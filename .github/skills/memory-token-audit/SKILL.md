---
name: memory-token-audit
description: Audit and optimize token usage for ai-memory prompts and instruction files. Use when user asks to reduce context cost, compare inject modes, improve first-turn hit rate, or design skills-based on-demand memory loading.
---

# Memory Token Audit

## Scope
Optimize token efficiency across:
- .github/copilot-instructions.md
- .github/copilot-project-summary.md
- ai-memory inject output behavior

## Checklist
1. Measure file size and estimate tokens.
2. Verify instruction file only contains routing logic.
3. Verify project semantics are routed to skills or summary layer, not copied into main instructions.
4. Keep summary concise and bounded.
5. Validate that runtime source of truth remains ai-memory context and ai-memory project.
6. Validate skills are split by intent so only one relevant skill body is loaded.

## Metrics
- First-turn instruction size
- Number of follow-up reads needed
- Correct task routing rate

## Suggested Actions
- Prefer inject --scope global for generic sessions.
- Use inject --scope project or hybrid only when project tasks dominate.
- Trim repeated prose and long examples from instruction files.
- Keep project-intent guidance in a dedicated skill and reference it from main instructions.
