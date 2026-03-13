# AI Memory 项目进展

## 项目概述

**项目名称**: ai-memory (开发者记忆层)  
**目标**: 为AI编码工具提供跨项目、跨工具、跨编码会话的持久上下文

## 核心功能

- **context**: 返回开发者 profile + preferences + infra
- **projects**: 列出已有项目
- **project <name>**: 显示项目详情
- **search <keyword>**: 搜索记忆库
- **inject <tool>**: 注入上下文到各类AI工具 (claude/opencode/codex)
- **learn**: 让LLM自动学习新信息并更新记忆
- **config**: 配置LLM后端

## 技术实现

- 纯Shell脚本，无依赖
- 数据存储于 `~/.memory/` 目录
- 支持多种LLM后端配置

## 当前进度

- [x] 核心CLI工具实现
- [x] 支持多种AI工具上下文注入
- [x] LLM自动学习功能
- [x] 文档 (docs/core-idea.md)

## 下一步

- 完善 profile/preferences/infra 模板
- 增加更多项目示例
- 优化 learn 命令的准确率
