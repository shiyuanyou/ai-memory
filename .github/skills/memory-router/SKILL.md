---
name: memory-router
description: Route tasks in the ai-memory project and load only the minimum required memory context. Always use this skill when user asks about ai-memory architecture, inject modes, copilot-instructions redesign, project memory lookup, learn pipeline behavior, or when a subagent should avoid broad file reads.
metadata:
  keywords:
    - routing
    - minimal context
    - inject modes
    - copilot instructions
  triggers:
    - "how should we route this task"
    - "inject strategy"
    - "copilot instructions redesign"
    - "最小化读取路径"
---

# Memory Router

Use this skill to avoid overloading context while keeping project understanding accurate.

## Goal
- Identify task type quickly.
- Load minimum context first.
- Escalate to deeper files only when needed.

## Task Classification
- First-turn project understanding:
  - Read .github/skills/memory-project-context/SKILL.md first.
- Inject and instruction design:
  - Read ai-memory and .github/copilot-instructions.md first.
- Core architecture:
  - Read docs/core-idea.md first, then ai-memory.
- Learn pipeline:
  - Read lib/learn.sh and ai-memory config/inject branches.
- Project status:
  - Read note.md.

## Retrieval Ladder
1. ai-memory capability
2. .github/skills/memory-project-context/SKILL.md (project semantic index)
3. ai-memory context
4. ai-memory project <name> (only if project-specific)
5. Open exact file sections for implementation details

## Response Contract
- Start with direct answer in 1-3 lines.
- Then list only the files actually needed.
- For subagent tasks, state a concrete read plan before opening files.
- If proposing edits, keep diff surface small and mention validation steps.

## Token Discipline
- Do not paste large snapshots unless asked.
- Prefer summaries over full file dumps.
- For VS Code instructions, keep the main file lightweight and route to project summary/skills.
