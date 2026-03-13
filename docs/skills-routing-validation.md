# Skills Routing Validation

Use this checklist to validate first-turn understanding and token efficiency after Hybrid + Skills rollout.

## Preconditions
- Run `ai-memory inject vs-code --scope global`.
- Optional: initialize scoring files with `./lib/score-routing-evals.sh .`.
- If testing `--scope project|hybrid`, set a repo mapping file (`.ai-memory-project`) or pass `--project <name>`.
- Confirm these skills exist:
  - `.github/skills/memory-project-context/SKILL.md`
  - `.github/skills/memory-router/SKILL.md`
  - `.github/skills/memory-token-audit/SKILL.md`

## Test Set (New Window)
Run each prompt in a fresh session:
1. "简单介绍一下这个项目"
2. "为什么你们不用静态大快照写 copilot-instructions?"
3. "帮我改 inject 逻辑，支持更省 token 的模式"
4. "分析 learn 流程是否会导致上下文过期"
5. "评估这个仓库的 token 开销结构"

Pass criteria for each prompt:
- Mentions ai-memory project goal in first response.
- Picks a minimal read path instead of broad file dump.
- References runtime source of truth when discussing facts.

## Test Set (Subagent)
Use Explore-style read tasks with the same prompts.

Pass criteria:
- Reads project-context skill or equivalent narrow index first.
- Does not open unrelated files before classifying task type.
- Produces actionable answer with bounded file references.

## Metrics
- First-turn hit rate = successful prompts / total prompts.
- Context size proxy = generated instructions bytes and approximate tokens.
- Overread count = number of unrelated files opened before first useful answer.

## Files
- Prompt suite: `evals/skills-routing-evals.json`
- Example results: `evals/skills-routing-results.example.json`
- Score script: `lib/score-routing-evals.sh`

Notes:
- If no result file exists, the score script will generate a full template from the prompt suite.
- In hybrid mode, `.github/copilot-project-summary.md` should be a semantic index, not a long raw snapshot.

## Suggested Thresholds
- New window hit rate >= 0.80
- Subagent hit rate >= 0.85
- Context size should not exceed previous baseline by more than 15%.

## Regression Actions
If hit rate drops:
1. Expand skill descriptions with clearer trigger phrases.
2. Tighten task routing flow in `.github/copilot-instructions.md`.
3. Split overloaded skills into smaller intent-specific skills.

If token cost rises:
1. Trim repeated prose in main instructions.
2. Keep only entrypoints and routing steps in main file.
3. Move project details to skill files or project summary file.
