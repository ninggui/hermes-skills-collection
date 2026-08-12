# Docker 端口转发失效诊断流程

容器运行正常但宿主机端口不可用时的完整诊断流程。

## 背景

Docker 端口转发依赖两个机制：
1. **docker-proxy**（用户态代理）— 处理 localhost 访问
2. **iptables DNAT 规则** — 处理外部网络访问

在 NAS Docker 环境中，`iptables` 可能不可用（内核未编译或未安装），`docker-proxy` 也可能未启动，导致端口映射配置存在但实际转发不工作。

## 诊断三步法

### Step 1：容器内部验证（隔离问题）

```bash
# 服务是否在容器内部正常监听？
docker exec <container> curl -sv http://127.0.0.1:<port>/health
```

如果返回 200，说明**服务本身正常**，问题在 Docker 网络层。

### Step 2：宿主机端口监听检查（关键）

将端口号转换为 hex（如 18060 → 0x468C），检查 `/proc/net/tcp`：

```bash
# 端口转换：printf '%04X' 18060 → 468C
# 在 /proc/net/tcp 中搜索 LISTEN 状态（st=0A）的该端口
awk '$2 ~ /0000468C/ && $4 == "0A"' /proc/net/tcp
```

- **有结果** → 端口在宿主机上正常监听，问题在防火墙或其他层
- **无结果** → Docker 端口转发未生效，进入 Step 3

同时检查是否有连接到容器内部网络的 ESTABLISHED 连接（st=01），这能证明容器可被 Docker 内部网络访问：

```bash
awk '$3 ~ /030012AC:468C/' /proc/net/tcp
# 端口 468C（18060）连到容器 IP 如 172.18.0.3
```

### Step 3：Docker 转发机制检查

```bash
# 检查 docker-proxy 是否存在
ps aux | grep docker-proxy

# 检查 iptables NAT 规则（如果 iptables 可用）
iptables -t nat -L DOCKER -n | grep <port>

# 检查容器端口映射配置
docker port <container>
```

## 根因确认矩阵

| 容器内 curl | 宿主机 /proc/net/tcp | docker-proxy | 结论 |
|------------|---------------------|-------------|------|
| ✅ 200 | ❌ 无 LISTEN | ❌ 不存在 | Docker 端口转发层失效 |
| ✅ 200 | ✅ 有 LISTEN | ✅ 存在 | 问题在防火墙/安全组 |
| ❌ 失败 | — | — | 服务本身未启动/端口错误 |

## 修复建议

1. **首选**：重启容器触发 Docker 重建端口映射
   ```bash
   curl -s --unix-socket /var/run/docker.sock \
     -X POST "http://localhost/containers/<name>/restart"
   ```

2. **备选**：通过 Docker 内部网络 IP 直接访问（限同一 Docker 网络内）
   ```bash
   curl http://172.18.0.3:<port>/health  # 使用容器内网 IP
   ```

3. **检查 Docker daemon 配置**：确保 `"userland-proxy": true`
