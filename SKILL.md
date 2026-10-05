---
name: hermes-skills-collection
description: Hermes Agent 实用技能合集（索引仓）——一条命令把 25 个实战验证的技能装到本地 skills 目录。触发：批量安装 Hermes 技能、找现成技能、clone 技能合集。
---

# Hermes 技能合集（索引仓）

本仓是**技能合集入口**：把分散在各处的可复用方法论（B站视频总结、KOL 内容提炼、规则审计、任务队列、cron 时区排查、售后知识管理、小红书运营……）汇总成一个入口，一条命令装齐。

## 它解决什么问题

技能分散在独立小仓或本地目录里，换环境要逐个 clone、逐个装，容易漏、容易版本漂移。本仓提供统一入口：一次 `git pull` 全部更新，按需装单个，别人搜 Hermes 技能时也能一眼看到全貌。

## ⚠️ 关于 `skills/` 目录只有 `.gitkeep`——这不是缺文件

**本仓是"技能内容不入库"的索引设计，技能实体不存放在 Git 里。**

- `.gitignore` 规则为 `skills/*` + `!.gitkeep`：`skills/` 下除占位文件外的全部内容**被有意排除在版本控制之外**；
- 安装脚本的工作方式是：把 **本仓 `skills/` 目录下已就位的技能目录**复制到目标 skills 目录；
- 因此克隆本仓后 `skills/` 是空的，**必须先让技能内容就位**（从各自的源仓 clone / 复制 / 软链进 `skills/`），再跑安装脚本。

换言之：**本仓负责"收集与安装"，不负责"托管内容"**。README 的技能清单是**索引**，每一项对应一个独立源仓或本地技能目录。

## 安装机制

| 脚本 | 作用 | 用法 |
|---|---|---|
| `install-all.sh` | 遍历 `skills/*/`，逐个复制到目标目录 | `bash install-all.sh [目标目录]` |
| `install-one.sh` | 只装单个技能 | `bash install-one.sh <技能名> [目标目录]` |

**默认目标目录**：`~/.hermes/skills`（Hermes 的技能目录；容器化部署下是该环境的 skills 根目录）。

```bash
git clone https://github.com/ninggui/hermes-skills-collection.git
cd hermes-skills-collection

# 1) 先让技能内容就位（示例：把源仓拷进 skills/，或软链）
mkdir -p skills && cp -r /path/to/some-skill skills/

# 2) 再安装
bash install-all.sh                        # 全部
bash install-one.sh <技能名>                # 单个
```

脚本行为说明：

- 目标目录已存在同名技能 → **跳过（不覆盖）**，不会破坏你已有的本地改动；
- `skills/` 下没有 `SKILL.md` 的目录 → 跳过并打印 `SKIP`（说明它不是一个可安装技能）；
- 安装完成后打印统计行：`完成: N 安装, N 跳过, N 失败`；
- 脚本对 `skills/` 内以符号链接形式存放的技能做了 `readlink -f` 解析，软链方式同样可用。

## 技能清单（25 项）

### 工具与流程

| 技能 | 说明 |
|------|------|
| `bilibili-watchlater-summarizer` | B站稍后再看视频总结 → 飞书文档 |
| `bilibili-api-patterns` | B站 API 调用模式与反 ban 策略 |
| `research-first-protocol` | 先研究后动手，禁止边做边试错 |
| `autonomous-problem-solving` | 自主问题排查与解决 |
| `rules-audit` | 规则审计与一致性检查 |
| `session-task-audit` | 会话任务审计 |
| `task-queue-protocol` | 任务队列协议 |
| `cron-timezone-pitfall` | 定时任务时区陷阱 |
| `docker-container-ops` | Docker 容器操作 |
| `hermes-config-workflow` | Hermes 配置修改正确姿势 |
| `external-skill-adoption` | 外部技能学习与吸收规范 |

### 内容生产

| 技能 | 说明 |
|------|------|
| `brand-style-research` | 品牌风格调研 |
| `kol-content-research` | KOL 内容调研 |
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
| `ima-knowledge-base` | IMA 知识库操作 |
| `n8n-dify-deepseek-workflow` | n8n + Dify + DeepSeek 工作流 |

## 维护约定

- **内容不入库**：技能实体留在各自源仓，本仓只维护索引（清单 + 安装脚本）；
- 新增技能 = 更新 README 清单 + 确保该技能能被放进 `skills/`；
- 安装脚本保持**幂等**：已存在的技能跳过，不覆盖本地改动。

## License

MIT
