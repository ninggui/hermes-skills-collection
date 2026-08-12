---
name: autonomous-problem-solving
description: 遭遇问题时先搜索再执行，失败后分析原因，只在确实需要用户介入时才回传。含SkillHub国内skill商店。
---

# 自主问题解决流程

## 触发条件

当以下任一情况发生时使用本 skill：
- 执行任务遇到报错、失败、阻塞
- 需要某个能力但当前工具/skill不具备
- 用户纠正了你的工作方式（"你应该先搜一下""不要直接问我"）
- 需要搜索或安装新的 skill 来增强能力

## 核心原则

**三层递进，不走到死胡同：**

```
搜索 → 执行 → 分析 → 回传（只在这层都失败时才找用户）
```

1. **先搜索**：遇到问题第一反应是联网搜索，不是直接告诉用户"做不到"
2. **再执行**：找到方案后立刻尝试，不要只描述不行动
3. **分析原因**：如果还是失败，自己分析根因（权限？网络？配置？）
4. **回传用户**：只有确认需要用户手动操作（如注册账号、授权、挂载文件）时才回传，且要告诉用户具体需要做什么

## SkillHub — 国内 Skill 商店

### 安装

```bash
curl -fsSL https://skillhub-1388575217.cos.ap-guangzhou.myqcloud.com/install/install.sh | bash
```

CLI 安装到 `~/.local/bin/skillhub`。

### 设为优先源

首次安装时询问用户是否设为优先源。设优先后，技能发现/安装/升级优先走 SkillHub（国内更快更合规），不可用/无匹配时回退。

### 搜索和安装

```bash
skillhub search <关键词>                    # 搜索
skillhub install <skill> --namespace <ns> --dir <skills目录>  # 安装到当前Agent的skills目录
```

Hermes 的 skills 目录通常为 `~/./skills/` 或 `/opt/data/skills/`。

### 已知优质 Skill

| Skill | 用途 | 安装命令 |
|-------|------|---------|
| `tencent-news` | 腾讯新闻搜索（国内可用，替代 Tavily） | `skillhub install tencent-news --namespace tencent-adm` |
| `brand-monitor` | 新能源汽车品牌舆情监控（需 SerpAPI Key） | `skillhub install brand-monitor --namespace wenxiaoyu` |
| `feishu-knowledge-manager` | 飞书知识管理 | `skillhub install feishu-knowledge-manager --namespace subwukong` |
| `clawfeed-push` | 全球新闻→AI摘要→飞书推送 | `skillhub install clawfeed-push --namespace goofyfht-blip` |
| `position-hunter` | 求职精准搜索 | `skillhub install position-hunter --namespace user_1002ca6a` |
| `feishu-enhanced` | 飞书增强套件 | `skillhub install feishu-enhanced --namespace lijie298` |
| `docker` | Docker 容器管理 | `skillhub install docker --namespace ivangdavila` |
| `ai-news-pusher` | AI 新闻推送 | `skillhub install ai-news-pusher --namespace kern1x` |
| `feishu-docs` | 飞书文档 API | `skillhub install feishu-docs --namespace stevenlikewatermelon` |
| `reflect-learn` | 自我反思学习 | `skillhub install reflect-learn --namespace stevengonsalvez` |

## 搜索能力降级策略

当 Tavily API 不可用时（401/403/网络不通），按以下优先级降级：

1. **SkillHub 腾讯新闻 skill** — 国内新闻搜索
2. **浏览器直接访问** — GitHub、文档站等直连站点
3. **curl 直接拉取** — .md/.json/.txt 等纯文本端点
4. **告知用户** — 说明搜索能力受限，请用户提供链接或开通 API

## 常见阻塞场景及处理

| 场景 | 不要直接说 | 应该做 |
|------|-----------|--------|
| 工具报错 | "这个做不到" | 搜索错误信息 → 找解决方案 → 尝试 |
| 缺少依赖 | "需要安装 X" | 自己尝试安装（uv/pip/apt）→ 失败再告诉用户 |
| 需要 API Key | "需要 Key" | 提供注册链接 + 注册步骤 → 让用户拿到 Key 给你 |
| Docker 不可用 | "需要挂载 socket" | 尝试所有连接方式（TCP/SSH/API）→ 确认都不行再回传 |
| 网络不通 | "访问不了" | 换协议（curl/浏览器）、换镜像源、换 CDN |

## 回传用户时的格式

当确实需要用户介入时，用这个格式：

```
**需要你做的：** [具体操作，一行一件]
**为什么：** [一句话原因]
**注册链接（如需要）：** [URL]
```

不要长篇解释，不要"我无法做到因为...需要你...建议你..."。直接给行动项。