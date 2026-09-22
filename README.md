<div align="center">

# Hermes Skills Collection

**25 个实战验证的 Agent 技能，一键安装到 Hermes，开箱即用。**

<p>
  <a href="#"><img src="https://img.shields.io/badge/skills-25-blue" alt="25 Skills" /></a>
  <a href="#"><img src="https://img.shields.io/badge/install-one-command-green" alt="One Command Install" /></a>
</p>

</div>

## 为什么是合集不是 25 个独立 repo

- **一键安装**：`bash install-all.sh` 全部装好，不用逐个 clone
- **统一版本管理**：所有技能在同一个 repo 里，一次 pull 全部更新
- **单独引用不受影响**：`install-one.sh <name>` 按需安装单个
- **发现性**：合集页是统一入口，别人搜 Hermes skills 一次性看到全部

## 快速开始

```bash
git clone https://github.com/ninggui/hermes-skills-collection.git
cd hermes-skills-collection
bash install-all.sh                    # 全部安装到 ~/.hermes/skills
bash install-one.sh bilibili-api-patterns  # 只装单个
```

## 技能清单

### 工具与流程

| 技能 | 说明 |
|------|------|
| `bilibili-watchlater-summarizer` | B站稍后再看视频总结→飞书文档 |
| `bilibili-api-patterns` | B站API调用模式与反ban策略 |
| `research-first-protocol` | 先研究后动手，禁止边做边试错 |
| `autonomous-problem-solving` | 自主问题排查与解决 |
| `rules-audit` | 规则审计与一致性检查 |
| `session-task-audit` | 会话任务审计 |
| `task-queue-protocol` | 任务队列协议 |
| `cron-timezone-pitfall` | 定时任务时区陷阱 |
| `docker-container-ops` | Docker容器操作 |
| `hermes-config-workflow` | Hermes配置修改正确姿势 |
| `external-skill-adoption` | 外部技能学习与吸收规范 |

### 内容生产

| 技能 | 说明 |
|------|------|
| `brand-style-research` | 品牌风格调研 |
| `kol-content-research` | KOL内容调研 |
| `web-intelligence-reports` | 网络情报报告 |
| `xiaohongshu-account-operations` | 小红书账号运营 |
| `xiaohongshu-comment-leads` | 小红书评论线索挖掘 |
| `douyin-realestate-research` | 抖音房产内容调研 |
| `travel-deal-research` | 旅行优惠调研 |
| `movie-resource-automation` | 影视资源自动化 |
| `media-resource-automation` | 媒体资源自动化 |

### 垂直领域

| 技能 | 说明 |
|------|------|
| `ev-after-sales-knowledge-management` | 新能源售后知识管理 |
| `automotive-job-hunting-framework` | 汽车行业求职框架 |
| `psycho-career-coach-model` | 职业心理教练模型 |
| `document-content-search` | 文档内容检索 |
| `ima-knowledge-base` | IMA知识库操作 |
| `n8n-dify-deepseek-workflow` | n8n+Dify+DeepSeek工作流 |

## License

MIT
