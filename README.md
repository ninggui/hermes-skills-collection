<div align="center">

# hermes-skills-collection

**Hermes Agent 实用技能库：AI 协作与自动化运维实战沉淀的可复用方法论合集。**

[SkillHub 在线安装](https://skillhub.cn/skills/hermes-skills-collection) · [子项目索引](#子项目索引) · [使用方式](#使用方式) · [使用边界](#使用边界)

</div>

---

这里是作者在真实业务场景中沉淀的可复用 AI Agent 技能（Skill）合集，来自 Hermes Agent 实战运维，含完整执行流程、避坑清单与验证步骤。**每个技能都是独立子项目**，可单独浏览、下载、复用。

## 子项目索引

| Skill | 仓库 | 功能 |
|-------|------|------|
| AI 研究前置协议 | [research-first-protocol](https://github.com/ninggui/research-first-protocol) | 触发词驱动的"先研究后行动"方法论 |
| 新能源汽车求职框架 | [automotive-job-hunting-framework](https://github.com/ninggui/automotive-job-hunting-framework) | JD拆解 / STAR应答 / 简历优化 |
| 新能源售后知识管理 | [ev-after-sales-knowledge-management](https://github.com/ninggui/ev-after-sales-knowledge-management) | 三电维修市场 / 培训体系 / 知识库SOP |
| 新能源行业早报 | [ev-news-briefing](https://github.com/ninggui/ev-news-briefing) | 每日定时早报自动化 |
| n8n+Dify+DeepSeek 工作流 | [n8n-dify-deepseek-workflow](https://github.com/ninggui/n8n-dify-deepseek-workflow) | AI 工作流搭建 / MCP 集成 |
| Cron 时区陷阱 | [cron-timezone-pitfall](https://github.com/ninggui/cron-timezone-pitfall) | UTC 时区错位排查修复 |
| Docker 容器运维 | [docker-container-ops](https://github.com/ninggui/docker-container-ops) | 容器操作 / 只读挂载 / config热更新 |
| 自主问题解决 | [autonomous-problem-solving](https://github.com/ninggui/autonomous-problem-solving) | 先搜索再执行 / 失败分析 |
| 中文去 AI 味 | [humanizer-zh](https://github.com/ninggui/humanizer-zh) | 去除 AI 生成痕迹 |
| 品牌风格研究规范 | [brand-style-research](https://github.com/ninggui/brand-style-research) | 以品牌为主体的全景研究流程（6阶段） |
| 小红书风格模仿 | [xhs-style-imitation](https://github.com/ninggui/xhs-style-imitation) | 分析博主风格指纹→按指纹写新文 |
| KOL 深度内容研究 | [kol-content-research](https://github.com/ninggui/kol-content-research) | 定位账号→全量拉取→内涵提炼 |
| Web 情报报告 | [web-intelligence-reports](https://github.com/ninggui/web-intelligence-reports) | 搜索→验证→结构化报告→发布 |
| B站 API 模式 | [bilibili-api-patterns](https://github.com/ninggui/bilibili-api-patterns) | feed聚合 / cookie陷阱 / 防412 |
| 影视资源自动化 | [media-resource-automation](https://github.com/ninggui/media-resource-automation) | 资源站搜片→磁力→网盘离线→观看 |
| 电影资源站自动化 | [movie-resource-automation](https://github.com/ninggui/movie-resource-automation) | 登录→筛选→API提取磁力→缓存 |
| Hermes 配置工作流 | [hermes-config-workflow](https://github.com/ninggui/hermes-config-workflow) | config.yaml / API key / fallback链 / web后端 |
| 抖音房产推广接入评估 | [douyin-realestate-research](https://github.com/ninggui/douyin-realestate-research) | 平台能力盘点 / 候选工具 / 推荐路径 |
| 规则审计 | [rules-audit](https://github.com/ninggui/rules-audit) | 用户规则固化检查/自动补 |
| 待办队列协议 | [task-queue-protocol](https://github.com/ninggui/task-queue-protocol) | 高峰入队闲时执行 |
| 任务盘点 | [session-task-audit](https://github.com/ninggui/session-task-audit) | 未完成任务盘点 |
| 外部技能评估 | [external-skill-adoption](https://github.com/ninggui/external-skill-adoption) | 插件/技能比选采纳 |
| 出行比价盯价 | [travel-deal-research](https://github.com/ninggui/travel-deal-research) | 机票/酒店/火车比价 |
| 文档检索找回 | [document-content-search](https://github.com/ninggui/document-content-search) | 按内容片段找回文档 |
| ima知识库操作 | [ima-knowledge-base](https://github.com/ninggui/ima-knowledge-base) | 腾讯ima API 检索/读取 |
| 心理咨询师与职业发展规划师评估模型 | [psycho-career-coach-model](https://github.com/ninggui/psycho-career-coach-model) | 全量语音记录→双角色评估→报告链 |
| 小红书账号运营 | [xiaohongshu-account-operations](https://github.com/ninggui/xiaohongshu-account-operations) | 评论系统/人设/频率/反馈闭环（脱敏方法论） |
| 小红书评论引流 | [xiaohongshu-comment-leads](https://github.com/ninggui/xiaohongshu-comment-leads) | 关键词策略/边界红线/风控处置（脱敏方法论） |
| 通话录音批量处理系统 | [call-recording-analysis-system](https://github.com/ninggui/call-recording-analysis-system) | 批量转写→按人合并→五层深度分析→飞书知识库沉淀（8000+条实测） |

## 使用方式

每个子仓库都是独立可用的 Skill（SKILL.md + 可选 references/），放入你的 Agent 技能目录即可自动加载：

- **Hermes**: 放入 `skills/` 目录
- **Claude Code**: 放入 `~/.claude/skills/`
- **Cursor**: 放入 `.cursor/skills/`
- **SkillHub**: 一键安装（见上方徽章链接）

## 使用边界

- 全部技能来自个人实践沉淀，按需取用，不承诺适用于所有场景
- **零隐私**：全部内容经自动扫描，不含任何个人身份信息（真实姓名、联系方式、内网地址、密钥一律不入库）
- 命令与脚本如与实际环境不符，以当前环境为准

## License

MIT
