# ai-memory

Developer memory layer CLI for persistent context across projects and AI tools.

## One-click bootstrap on a new machine

Run this in your target project directory:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/shiyuanyou/ai-memory/main/bootstrap.sh) --project ai-memory --tool all --scope hybrid
```

What it does:
- clones or updates this repository into `$HOME/.local/share/ai-memory`
- links `ai-memory` into `$HOME/.local/bin`
- auto-runs project init (mapping + skills + VS Code/OpenCode injection)

## Daily use in any project

```bash
ai-memory init --project <your-project-name> --tool all --scope hybrid
```

## Notes

- OpenCode output is written to both `AGENTS.md` and `.opencode/instructions.md`.
- VS Code output is written under `.github/`.
