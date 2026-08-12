# TokenRhythm 配置（ai-morning 当前提供商）

## 生效日期
2026-08-09：ai-morning 已从硅基流动切换到 TokenRhythm。

## 当前配置

```json
{
  "ai": {
    "api_key": "sk_tr_j6XU0-DjFBHp8lFcytqjXOhJzWEUZl4u0a8ndLCUzz8",
    "base_url": "https://tokenrhythm.studio/v1",
    "model": "deepseek-v4-flash"
  }
}
```

## Provider 对比

| 字段 | 硅基流动（旧） | TokenRhythm（当前） |
|------|--------------|-------------------|
| base_url | https://api.siliconflow.cn/v1 | https://tokenrhythm.studio/v1 |
| model | deepseek-ai/DeepSeek-V3 | deepseek-v4-flash |
| api_key | sk-ewo...yfkw | sk_tr_j6XU...Uzz8 |

## 切换回顾

1. 备份 → 修改 config.json 的 ai 三个字段 → 验证
2. 用临时容器法（ref `references/readonly-bindmount-temp-container.md`）写入 NAS 路径
3. pkill -f "app_main_fixed.py" 重启进程

## Rollback（回退到硅基流动）

```bash
# 临时容器法恢复备份
docker run -d --name tmp-rollback -v /volume1/docker/user/ai-morning:/work:rw alpine sleep 300
docker exec tmp-rollback cp /work/config.json.sf_backup /work/config.json
docker exec tmp-rollback cat /work/config.json  # 验证
docker exec ai-morning pkill -f "app_main_fixed.py"
```
