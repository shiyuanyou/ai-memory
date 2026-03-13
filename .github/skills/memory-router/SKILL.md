---
name: memory-router
description: Route tasks in the ai-memory project and load only the minimum required memory context. Use whenever user asks about ai-memory architecture, inject modes, copilot instructions, project memory lookup, or learn pipeline behavior.
---

# Memory Router

Use this skill to avoid overloading context while keeping project understanding accurate.

## Goal
- Identify task type quickly.
- Load minimum context first.
- Escalate to deeper files only when needed.

## Task Classification
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
2. ai-memory context
3. ai-memory project <name> (only if project-specific)
4. Open exact file sections for implementation details

## Response Contract
- Start with direct answer in 1-3 lines.
- Then list only the files actually needed.
- If proposing edits, keep diff surface small and mention validation steps.

## Token Discipline
- Do not paste large snapshots unless asked.
- Prefer summaries over full file dumps.
- For VS Code instructions, keep the main file lightweight and route to project summary/skills.
