---
name: cron-timezone-pitfall
description: Cron时区陷阱：调度器用UTC导致北京时错位8小时。
---

# Cron时区陷阱

## 症状
Cron Job的`next_run_at`显示`+00:00`（UTC），导致执行时间比预期晚8小时。例如`0 18 * * *`在北京时间凌晨2点执行。

## 验证
```bash
# 检查Job的时区
cronjob action=list
# 看 next_run_at 后缀：+00:00=UTC(错误) / +08:00=北京(正确)
```

## 修复
1. 确保容器环境变量 `TZ=Asia/Shanghai`
2. 重新`cronjob action=update`相同schedule触发时区重算
3. 验证`next_run_at`变为`+08:00`

## 预防
- 创建Cron Job后立即检查next_run_at时区
- docker-compose中确保 `- TZ=Asia/Shanghai`

## 相邻陷阱：分钟间隔表达式（容易误写）
创建"每N分钟"任务时，`0 */30 * * *` 的**小时字段** `*/30` 只匹配 0 点（每天一次），不是每30分钟！
- 每30分钟的正确写法：`*/30 * * * *`（分钟字段）
- 每2小时：`0 */2 * * *`（小时字段，正确——因为 0,2,4...24 都有意义）
- 创建后立刻看 `next_run_at` 是否符合预期（如 `*/30` 应看到下一个半点/整点）

## 相邻陷阱：新建 job 未固定模型
cronjob 工具创建的 job 默认 model/provider 为 null（unpinned）。全局模型一漂移，job 会跳过执行报 error（`Skipped to prevent unintended spend ... unpinned`）。创建后立即：
```bash
hermes cron edit <JOB_ID> --model <model> --provider <provider>
```
⚠️ **`cronjob action=update` 传 model/provider 参数无效（2026-08-12 实测）**：update 返回的 job 里 model 仍是 null——update 只接受 schedule/prompt/deliver/skills 等，模型固定**必须用 CLI `hermes cron edit --model --provider`**。CLI 路径：`export PATH="/opt/hermes/.venv/bin:$PATH"`（`hermes` 不在默认 PATH）。改完用 `cronjob action=list` 验证 model/provider 字段非 null。

## 相邻陷阱：整点并发 → HTTP 504（2026-08-11 实测）
多个 cron job 在同一分钟触发（如 10:00 的 morning-brief + 10:00 的 xhs-comment）会撞 TokenRhythm 网关并发限制，报 `HTTP 504 Gateway Time-out`。单个 job 手动触发也偶发 504 → 网关本身间歇性抖动。
**修复：错峰调度**——把次要 job 移到半点（`30 */2 * * *` 而非 `0 */2 * * *`），大 job 之间至少错开 30 分钟。
**2026-08-12 完整错峰案例**：ev-industry-watch 08:00→`30 */8 * * *`（08:30/16:30/00:30），system-health-watch 12:00→`15 */6 * * *`（00:15/06:15/12:15/18:15）。整点只剩必须每分钟/每10分钟的轻量任务（群消息、xhs-monitor），大任务全部错开。同时给失败任务 prompt 加"遇 504 等待 60 秒重试一次"，实现自愈。
**诊断顺序**：① `curl -o /dev/null -w "%{http_code}" https://tokenrhythm.studio/v1/models -H "Authorization: Bearer $(cat /opt/data/backup_api_key.txt)"` 测网关健康 → ② CLI 直连 `hermes chat -q "OK" --provider tokenrhythm` 测主会话 → ③ 看 errors.log 中 cron 会话的 provider/base_url → ④ 确认 fallback 链生效（`hermes fallback list`）。

## 相邻陷阱：504 未必是配置问题（2026-08-12 实测）
12:07-12:13 三个不同 job（xhs-monitor-v3、system-health-watch、群消息回复）**同时**报 504——非整点、非并发碰撞、纯网关间歇抖动。判定依据：①错误文本就是 `HTTP 504 Gateway Time-out` 无其他上下文 ②同批其他 job 正常 ③下个周期自动重跑成功。**处置：无需修复，等待下周期自愈**；不要因单次 504 就改配置或删 job。区分：若 504 反复出现在同一 job 且伴随其他错误（401/模型漂移），才需要查配置。

## 相邻陷阱：fallback_providers 存成字符串（2026-08-11 实测）
`hermes config set fallback_providers '["siliconflow", "tokenrhythm-backup"]'` 会把值**存成带引号的字符串**，`hermes fallback list` 显示 "No fallback providers configured"（未生效），而 `hermes config get` 会把字符串解析成列表显示（假象）。
**验证用 `hermes fallback list`，不要用 `hermes config get`**。未生效时用交互式 `hermes fallback add`（需 TTY，非交互环境用 delegate_task 跑）。

## 只读监控 cron 模板（QQ邮箱/告警类）
用户要求"有新内容才通知、绝不回复/绝不写"的监控任务，用此模板（deliver=origin，enabled_toolsets=["terminal"]）：
1. 读取最新条目（`himalaya envelope list --page-size 5`）
2. 对比已见文件（如 /opt/data/cache/qq_mail_seen.txt 存已处理 ID）
3. 有新内容→列出标题/发件人/时间，更新 seen 文件
4. 无新内容→回复 `[SILENT]` 抑制推送
关键：**只在 SKILL 层写"只读、绝不回复"约束到 prompt**，防止 cron agent 自作主张回复。