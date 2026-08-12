---
name: n8n-dify-deepseek-workflow
description: n8n + Dify + DeepSeek 最小闭环工作流搭建。含节点选择、MCP集成、记忆系统、实战链路。
---

# n8n-dify-deepseek-workflow

n8n + Dify + DeepSeek 最小闭环工作流搭建。轻量级部署方案、节点选择、MCP集成、记忆系统配置。

---

## 一、工具定位

| 工具 | 核心定位 | 适用场景 |
|------|---------|---------|
| **n8n** | 跨服务自动化编排 | 定时任务、消息推送、系统串联 |
| **Dify** | AI应用搭建（RAG Bot） | 知识库问答、对话机器人 |
| **DeepSeek** | 推理/生成模型 | 低成本LLM后端（<0.01元/次） |

**组合逻辑**：n8n做业务流程自动化 + Dify做AI应用 + DeepSeek做推理引擎

---

## 二、部署方案

### 轻量级（推荐个人/小团队）

- n8n + PostgreSQL：2个Docker容器
- 空载内存：300-500MB
- 最低要求：1GB内存（需加Swap）
- 推荐配置：2GB内存（$99.99/年套餐）

### Dify对接n8n

两者Webhook互联：
- n8n触发 → 调用Dify API（生成答案）
- Dify完成 → 回调n8n（执行后续流程）

---

## 三、DeepSeek接入n8n

### 最简接入方式

1. 在n8n中搜索 **ChatGPT 节点**
2. 创建 Credential
3. 填入：
   - API-Key：DeepSeek API Key
   - Base URL：`https://api.deepseek.com`
4. 完成——参数与ChatGPT API兼容，直接切换

### 模型选择

| 模型 | 适用场景 | 成本 |
|------|---------|------|
| `deepseek-chat` | 日常对话、知识库问答 | <0.01元/次 |
| `deepseek-reasoner` | 复杂推理、深度分析 | 略高 |

---

## 四、n8n Agent节点类型

| 节点类型 | Memory | 适用场景 |
|---------|--------|---------|
| **Conversational Agent** | ✅ 支持上下文记忆 | 培训助手、客服对话 |
| **Tools Agent** | ❌ 无记忆 | 单次任务执行 |
| **ReAct Agent** | ✅ 会检查结果并重试 | 复杂问题处理 |

**推荐**：培训助手场景用 `Conversational Agent`，接 `Postgres Memory` 或 `Redis Chat Memory`（开源、跨会话持久化）

---

## 五、MCP集成

### n8n-nodes-mcp

n8n官方MCP社区节点包：
- 工作流可通过MCP协议调用外部工具
- 腾讯云、阿里百炼等国内平台均已接入MCP

### 自定义工作流工具（国内平台痛点解法）

n8n原生不支持百度搜索、飞书推送等。通过 `Call n8n Workflow Tool`：
1. 建一个专门推送企微/飞书消息的工作流
2. 将其注册为工具供AI Agent调用
3. 实现积木式扩展

---

## 六、实战链路

### 链路1：竞品培训动态追踪

```
定时触发（n8n Cron）
  → RSS抓取（竞品官网/行业媒体）
  → AI Agent（DeepSeek提取关键内容）
  → 整理入库（飞书文档/多维表格）
  → 推送培训管理员（企微/飞书机器人）
```

**迁移到汽车培训场景**：
- 定时抓取竞品（理想/问界/蔚来）公开培训动态
- AI提取关键内容（新课程/新政策）
- 整理入库 → 推送培训管理员

### 链路2：培训咨询问答Bot

```
用户提问（Dify Web/企微）
  → RAG检索（课程资料向量库）
  → DeepSeek生成答案（Dify内置）
  → 返回答案
  → 用户满意？否 → 转人工
  → 转人工（n8n工单系统）
  → 人工处理 → 更新知识库
```

### 链路3：培训业务流程自动化

```
课程发布（管理员操作）
  → n8n Webhook触发
  → 自动发企微通知（学员）
  → 自动更新学员状态（多维表格）
  → 课程结束 → 自动发结课通知
  → 自动归档 → 更新培训记录
```

---

## 七、Skill相关引用

| 关联Skill | 关系 |
|-----------|------|
| `ev-after-sales-km` | 上游：知识库内容来源 |
| `ai-knowledge-base-playbook` | 平行：知识库搭建方法论 |

---

## 八、核心参考来源

- n8n + DeepSeek集成：bandwagonhost.net / 53ai.com
- Dify定位对比：n8n偏自动化，Dify偏AI应用
- MCP协议：n8n-nodes-mcp社区包，腾讯云/阿里百炼已接入
