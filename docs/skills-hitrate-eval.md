# Skills Hitrate and Token Evaluation

## Purpose
Evaluate whether Hybrid plus Skills improves:
- first-turn project understanding
- subagent routing accuracy
- total context token efficiency

## Test Setup
- Workspace: memory repository
- Instruction mode: run ai-memory inject vs-code --scope global
- Skills expected:
  - .github/skills/memory-router/SKILL.md
  - .github/skills/memory-token-audit/SKILL.md

## Prompt Set (New Window)
1. Explain this project's architecture in 5 lines.
2. Compare inject global and hybrid for token cost.
3. Where should project-specific facts be stored?
4. How does learn update memory files?
5. Why should copilot-instructions stay lightweight?

## Prompt Set (Subagent)
1. Find where vs-code inject template is generated.
2. Find all token-related optimization mechanisms.
3. Locate learn and describe post-update refresh flow.
4. Identify files that define project principles.
5. Propose minimal edits to reduce instruction bloat.

## Scoring
For each prompt, mark:
- route_correct: did the assistant choose the right source first?
- answer_correct: is the first answer materially correct?
- extra_context: did it load unnecessary large files?
- token_behavior: low, medium, high

## Pass Criteria
- New window route_correct >= 80%
- Subagent route_correct >= 85%
- answer_correct >= 85% for both sets
- No high token_behavior in more than 20% of prompts

## Baseline Comparison
Run the same prompts in two modes:
- Mode A: before skills (old instructions)
- Mode B: after skills (current instructions)

Compare:
- average route_correct
- average answer_correct
- average token_behavior grade
- number of follow-up clarification turns
