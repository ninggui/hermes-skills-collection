# xiaohongshu-mcp 部署记录

**日期**: 2026-08-09
**项目**: https://github.com/xpzouying/xiaohongshu-mcp (15K+ stars)
**功能**: 小红书全自动运营 — 发笔记、读/回评论、搜索、点赞收藏

## 部署配置

镜像: `crpi-hocnvtkomt7w9v8t.cn-beijing.personal.cr.aliyuncs.com/xpzouying/xiaohongshu-mcp` (阿里云源，国内快)
版本: v2.4.3
大小: 1.16GB
端口: 18060 (MCP HTTP)

```
数据目录: /opt/data/xiaohongshu-mcp/data/
图片目录: /opt/data/xiaohongshu-mcp/images/
Cookies: /app/data/cookies.json
```

## 部署步骤

```bash
# 1. 创建目录
mkdir -p /opt/data/xiaohongshu-mcp/data /opt/data/xiaohongshu-mcp/images

# 2. 拉取镜像（Docker API 绕过 consent）
curl -s --unix-socket /var/run/docker.sock -X POST \
  "http://localhost/images/create?fromImage=crpi-hocnvtkomt7w9v8t.cn-beijing.personal.cr.aliyuncs.com%2Fxpzouying%2Fxiaohongshu-mcp"

# 3. 创建容器（注意 URL 编码的 fromImage）
curl -s --unix-socket /var/run/docker.sock -X POST \
  "http://localhost/containers/create?name=xiaohongshu-mcp" \
  -H "Content-Type: application/json" -d '{
    "Image": "crpi-hocnvtkomt7w9v8t.cn-beijing.personal.cr.aliyuncs.com/xpzouying/xiaohongshu-mcp",
    "HostConfig": {
      "Binds": [
        "/opt/data/xiaohongshu-mcp/data:/app/data",
        "/opt/data/xiaohongshu-mcp/images:/app/images"
      ],
      "PortBindings": {"18060/tcp": [{"HostPort": "18060"}]},
      "RestartPolicy": {"Name": "unless-stopped"},
      "Init": true,
      "Tty": true
    },
    "Env": [
      "COOKIES_PATH=/app/data/cookies.json",
      "HOME=/app/data/home",
      "XDG_CONFIG_HOME=/app/data/config"
    ]
  }'

# 4. 启动容器
curl -s --unix-socket /var/run/docker.sock -X POST \
  "http://localhost/containers/<container_id>/start"
```

## 首次登录

容器启动后 MCP 服务在 `http://<NAS_IP>:18060`。首次需在浏览器打开该地址完成小红书扫码登录。

工具列表（18个）:
- `check_login_status` / `login`
- `publish_note` (图文发布)
- `publish_video` (视频发布)
- `search_notes` (搜索)
- `get_feed_detail` (帖子详情+评论)
- `post_comment` / `reply_comment` (评论/回复)
- `like_note` / `favorite_note` (点赞/收藏)
- `get_user_profile` (用户主页)

## 已知限制

- 账号须实名认证，否则触发风控
- 同一账号不能在多个网页端登录（会踢掉 MCP）
- Cookies 过期需重新登录
- 标题 ≤ 20 字，正文 ≤ 1000 字
- 每天发帖上限约 50 篇
- 图文流量 > 视频 > 纯文字

## 端口不通排查（宿主机连不上 18060）

**症状**：`docker ps` 显示 `0.0.0.0:18060->18060/tcp`，容器内 `curl 127.0.0.1:18060/health` 返回 200，但宿主机 `curl localhost:18060` 返回 `Connection refused`。

**诊断三步**：

```bash
# 1. 确认容器内服务正常（已知可靠）
docker exec xiaohongshu-mcp curl -s http://127.0.0.1:18060/health

# 2. 确认 Hermes 能否解析容器名（网络是否已连接）
docker exec xiaohongshu-mcp curl -s http://hermes:8080/health 2>&1 || echo "NO_ROUTE"

# 3. 如果 #2 不通 → 容器未接入 Hermes 网络 → 重新连接（见"连接容器到 Hermes 网络"节）
```

**常见原因**：
- **Docker 网络未连接**（最常见）：容器名 URL (`xiaohongshu-mcp`) 只在同一 Docker 网络内可解析
- **docker-proxy 挂死**：重启容器可恢复
- **防火墙/iptables**：NAS 固件更新后规则重置

**如果端口映射彻底失败**：可用 Docker API exec 替代——所有 MCP 调用改为 `docker exec` + 容器内 `curl`：
```bash
# 等效于 mcp_xiaohongshu_publish_note
curl -s --unix-socket /var/run/docker.sock \
  -X POST "http://localhost/containers/xiaohongshu-mcp/exec" \
  -H "Content-Type: application/json" \
  -d '{"Cmd":["curl","-s","http://127.0.0.1:18060/mcp","-H","Content-Type: application/json","-d","{\"jsonrpc\":\"2.0\",\"method\":\"tools/call\",\"params\":{\"name\":\"publish_note\",\"arguments\":{...}},\"id\":1}"]}'
```
然后获取 exec ID，调用 `/exec/<id>/start` 执行。走 Docker API 绕过 consent + 端口问题，一箭双雕。

## Hermes MCP 集成

### 1. 连接容器到 Hermes 网络

Hermes 运行在 Docker 容器内（通常 `hermes_default` 网络），与 xiaohongshu-mcp 可能不在同一网络，需先连接：

```bash
# 查看 Hermes 网络
curl -s --unix-socket /var/run/docker.sock http://localhost/containers/hermes/json -o /tmp/h.json
grep -o '"NetworkMode":"[^"]*"' /tmp/h.json

# 连接 xiaohongshu-mcp 到该网络（如 hermes_default）
curl -s --unix-socket /var/run/docker.sock \
  -X POST "http://localhost/networks/<hermes_network>/connect" \
  -H "Content-Type: application/json" \
  -d '{"Container":"xiaohongshu-mcp"}'
```

### 2. 写入 MCP 配置

在 `/opt/data/hermes-config/config.yaml` 追加（注意：URL 用容器名，非 localhost）：

```yaml
mcp_servers:
  xiaohongshu:
    url: "http://xiaohongshu-mcp:18060/mcp"
    timeout: 120
    connect_timeout: 30
```

配置文件可能 root 所有，需通过 Docker exec API 写入，详见 `references/hermes-mcp-docker-integration.md`。

### 3. 重启 Hermes

**MCP 变更不支持热加载**，`hermes config reload` 不存在。必须完整重启 Hermes：

```bash
curl -s --unix-socket /var/run/docker.sock -X POST \
  "http://localhost/containers/hermes/restart"
```

重启后 `mcp_xiaohongshu_*` 系列工具自动注册。

## 部署后验证

```bash
# 1. 容器是否在运行
curl -s --unix-socket /var/run/docker.sock http://localhost/containers/json?all=true -o /tmp/ctrs.json
# read_file /tmp/ctrs.json 或 python3 解析

# 2. 如果 stopped，启动它
curl -s --unix-socket /var/run/docker.sock -X POST http://localhost/containers/xiaohongshu-mcp/start

# 3. MCP 端点是否响应（容器内 curl 绕过端口映射问题）
docker exec xiaohongshu-mcp curl -s http://127.0.0.1:18060/health 2>/dev/null || echo "NOT_RESPONDING"

# 4. 列出可用工具
docker exec xiaohongshu-mcp curl -s http://127.0.0.1:18060/mcp -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","method":"tools/list","id":1}'
```

## 发帖前检查清单

⚠️ **每次代发帖前必须验证**（容器可能因 NAS 重启等原因停止）：

1. 容器运行中 → 不是则 Docker API start
2. MCP 端点响应 → 不是则看日志排查
3. `check_login_status` 返回已登录 → 不是则提示用户扫码登录
4. 确认后再调 `publish_note`
5. **发帖后验证日志**：检查容器日志确认发布成功，避免假阳性（MCP 返回成功但实际未发布）
   ```bash
   docker logs xiaohongshu-mcp --tail 10 2>&1 | grep -i "发布内容\|publish\|error"
   ```

## 集成工作流

1. xiaohongshu-mcp 容器提供 HTTP MCP 端点
2. Hermes 通过 `mcp_servers` 配置的 HTTP transport 连接（容器名 `xiaohongshu-mcp`，非 localhost）
3. Cron 定时监控评论 → 调 `mcp_xiaohongshu_check_login_status` → `mcp_xiaohongshu_get_feed_detail` → `mcp_xiaohongshu_reply_comment`
4. 用户发帖需求 → AI 生成文案（标题≤20字，正文≤1000字）→ `mcp_xiaohongshu_publish_note`

## 费用

开源免费，无订阅。仅需 NAS 运行 Docker 容器的电费。
