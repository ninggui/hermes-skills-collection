# Guining Hermes Skills

由日常 AI 协作中沉淀的可复用技能库（Skills）。每个 skill 包含触发条件、执行步骤、避坑清单，可直接用于 Hermes / Claude / 通用 AI Agent。

## 技能清单

| Skill | 用途 | 核心内容 |
|-------|------|---------|
| [research-first-protocol](skills/research-first-protocol/) | 研究前置协议 | 触发词驱动的"先研究后行动"流程：行业扫描→知识点→方法论→沉淀 |
| [job-hunting-framework](skills/job-hunting-framework/) | 求职定位与面试框架 | 主机厂 JD 拆解、STAR 应答方法论、简历优化清单 |
| [ev-after-sales-km](skills/ev-after-sales-km/) | 新能源售后知识管理 | 三电维修市场数据、培训体系搭建、知识库运营 SOP |
| [ev-news-briefing](skills/ev-news-briefing/) | 新能源行业早报 | 定时推送、行业新闻摘要、信源过滤 |
| [n8n-dify-deepseek-workflow](skills/n8n-dify-deepseek-workflow/) | AI 工作流搭建 | n8n + Dify + DeepSeek 最小闭环、MCP 集成、记忆系统 |
| [cron-timezone-pitfall](skills/cron-timezone-pitfall/) | Cron 时区陷阱 | 调度器 UTC 导致北京时错位 8 小时的排查与修复 |
| [docker-container-ops](skills/docker-container-ops/) | Docker 容器运维 | exec/cp/restart、只读挂载修改、config 热更新 |
| [autonomous-problem-solving](skills/autonomous-problem-solving/) | 自主问题解决 | 先搜索再执行、失败分析、SkillHub 国内 skill 商店 |
| [humanizer-zh](skills/humanizer-zh/) | 中文文本去 AI 味 | 去除 AI 生成痕迹，让文本更自然 |

## 使用方式

将任意 skill 目录放入你的 Agent 技能目录（如 Hermes 的 `skills/`、Claude 的 `~/.claude/skills/`），Agent 会在匹配触发条件时自动加载。

## 原则

- 每个 skill 都是真实场景沉淀，含避坑清单与验证步骤
- 不含任何个人隐私信息
- 定期更新，欢迎 PR
