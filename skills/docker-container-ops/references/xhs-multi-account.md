# 小红书多账号部署

## 场景
用一个容器跑主账号，第二个容器跑辅账号（引流/评论/搜索），互不干扰。

## 部署第二个容器

```bash
curl -s --unix-socket /var/run/docker.sock \
  -X POST "http://localhost/containers/create?name=xiaohongshu-mcp-02" \
  -H "Content-Type: application/json" -d '{
    "Image": "crpi-hocnvtkomt7w9v8t.cn-beijing.personal.cr.aliyuncs.com/xpzouying/xiaohongshu-mcp",
    "HostConfig": {
      "Binds": ["/opt/data/xiaohongshu-mcp-02/data:/app/data",
                "/opt/data/xiaohongshu-mcp-02/images:/app/images"],
      "PortBindings": {"18060/tcp": [{"HostPort": "18061"}]},
      "RestartPolicy": {"Name": "unless-stopped"},
      "Init": true, "Tty": true
    },
    "Env": ["COOKIES_PATH=/app/data/cookies.json",
            "HOME=/app/data/home",
            "XDG_CONFIG_HOME=/app/data/config"]
  }'
```

## 账号隔离
- 容器1 (18060): xiaohongshu-mcp — 主账号
- 容器2 (18061): xiaohongshu-mcp-02 — 辅账号
- Cookie/登录态完全独立（不同 data 目录）

## 已知问题
- get_login_qrcode 首次调用可能超时（504），但日志显示实际已返回200。重试时二维码已过期需重新获取
- MCP publish_content 内部重试可能产生重复帖子（已知bug）
- 小红书图片CDN有防盗链（403），需用Unsplash等公开图源或本地图片
