# AI Memory 项目进展

## 项目概述

**项目名称**: ai-memory (开发者记忆层)  
**目标**: 为AI编码工具提供跨项目、跨工具、跨编码会话的持久上下文

## 核心功能

- **context**: 返回开发者 profile + preferences + infra + 项目摘要
- **projects**: 从 `~/.memory/projects/` 列出项目摘要（项目单一真相源）
- **project <name>**: 显示项目详情
- **search <keyword>**: 搜索记忆库
- **inject <tool>**: 注入完整聚合上下文到各类AI工具 (claude/opencode/codex)
- **learn**: 让LLM自动学习新信息并更新记忆
- **config**: 配置LLM后端

## 技术实现

- 纯Shell脚本，无依赖
- 数据存储于 `~/.memory/` 目录
- 项目信息统一存放于 `~/.memory/projects/*.md`
- 支持多种LLM后端配置

## 当前进度

- [x] 核心CLI工具实现
- [x] 支持多种AI工具上下文注入
- [x] LLM自动学习功能
- [x] 文档 (docs/core-idea.md)
- [x] 稳定性修复（project/inject 错误码与错误信息一致）
- [x] 配置写入安全加固（config set 参数校验 + 安全写回）
- [x] VS Code 动态注入支持（`ai-memory inject vs-code` 生成 `.github/copilot-instructions.md`）
- [x] learn 模块化重构（主脚本分发，`lib/llm.sh` + `lib/learn.sh`）
- [x] projects 摘要解析可维护化（`project_description` 线性化简化）
- [x] VS Code 注入分层改造（`inject vs-code --scope global|project|hybrid`）
- [x] 项目摘要文件输出（`.github/copilot-project-summary.md`，按需生成）
- [x] 注入产物体积与 token 估算输出（便于持续优化）
- [x] learn 后可选自动刷新注入（`AUTO_INJECT_VSCODE=1`）
- [x] Skills 按需加载入口（project-context/router/token-audit 三层）
- [x] 主指令改为项目语义索引 + 路由流（避免大快照）
- [x] Memory skills 按需加载层（routing + token audit）
- [x] VS Code 主指令增加结构化路由流（task classify -> minimal fetch -> execute）
- [x] 命中率验证清单文档（新窗口 + sub agent + token 评分）

## 下一步

- 补齐旧项目文件的头部元数据 (`Description` / `GitHub` / `Directory`)
- 增加可重复的 smoke 测试脚本（语法 + 命令回归 + 错误路径）
- 优化 learn 的 dry-run 预览展示（当前仅动作级提示，可增强为内容 diff）
- 增加注入模式 A/B 评估（首轮理解率 vs token 成本）
- 在新窗口和 sub agent 场景跑命中率评估并固化阈值
- 增加新窗口与 sub agent 命中率基线测试集（用于验证 skills 触发效果）
