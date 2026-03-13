# Task Classification Quick Reference

Use this table to route tasks with minimal context reads.

| User intent | Load first | Load second | Why |
| --- | --- | --- | --- |
| 项目介绍 / 架构说明 | `.github/skills/memory-project-context/SKILL.md` | `docs/core-idea.md` | Fast semantic overview |
| 注入策略 / instructions 改造 | `.github/skills/memory-router/SKILL.md` | `ai-memory` inject branch | Route before editing |
| learn 更新行为 / 记忆写入 | `.github/skills/memory-router/SKILL.md` | `lib/learn.sh` | Avoid unrelated files |
| token 成本 / 上下文优化 | `.github/skills/memory-token-audit/SKILL.md` | `.github/copilot-instructions.md` | Keep main instructions lean |
| 项目事实查询 | `ai-memory project <name>` | `~/.memory/projects/<name>.md` | Runtime source of truth |

## Minimal Retrieval Ladder
1. `ai-memory capability`
2. `ai-memory context`
3. `ai-memory project <name>` only when task is project-specific
4. Open exact code/doc sections only when implementing changes
