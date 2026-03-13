# ai-memory

Developer memory layer CLI for persistent context across projects and AI tools.

## What it is

ai-memory solves one practical problem:

- your AI tools only know the current repo and short chat history
- they do not know your long-term preferences, infra, or existing projects
- so you keep repeating the same background information

ai-memory keeps that context in `~/.memory/` and injects the minimum useful context into your tools when needed.

## Quick start on a new machine

Run this in your target project directory:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/shiyuanyou/ai-memory/main/bootstrap.sh) --project <your-project-name> --tool all --scope hybrid
```

What it does:
- clones or updates this repository into `$HOME/.local/share/ai-memory`
- links `ai-memory` into `$HOME/.local/bin`
- auto-runs project init (mapping + skills + VS Code/OpenCode injection)

If `$HOME/.local/bin` is not in your `PATH`, add this to your shell config:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

## First-time setup for this repository

If you are working on the ai-memory repository itself:

```bash
ai-memory init --project ai-memory --tool all --scope hybrid
```

This writes:

- `.ai-memory-project`
- `.github/copilot-instructions.md`
- `.github/copilot-project-summary.md`
- `AGENTS.md`
- `.opencode/instructions.md`

## Daily use in any existing project

Go into any project repository and run:

```bash
ai-memory init --project <your-project-name> --tool all --scope hybrid
```

Recommended examples:

```bash
ai-memory init --project anti-fomo --tool all --scope hybrid
ai-memory init --project mind-flow --tool vs-code --scope hybrid
ai-memory init --project ai-balance --tool opencode --scope hybrid
```

What this does:

- binds the repo to a memory project using `.ai-memory-project`
- installs the default skills pack into `.github/skills`
- generates editor/agent instructions for the selected tool(s)

## Add a new project into memory

When a project is not yet tracked, do this once.

### 1. Create the project memory file

```bash
ai-memory new-project <project-name>
```

Example:

```bash
ai-memory new-project personal-wiki
```

This creates:

- `~/.memory/projects/personal-wiki.md`

### 2. Fill in the project metadata

Edit the generated file and update at least these fields:

- `Description`
- `GitHub`
- `Directory`
- `## Purpose`
- `## Key Capabilities`

Minimal example:

```markdown
# personal-wiki

Description: Personal knowledge base with FastAPI backend and Vue frontend.
GitHub: https://github.com/shiyuanyou/personal-wiki
Directory: ~/Projects/personal-wiki

## Purpose

Store, search, and organize personal notes.

## Key Capabilities

- Full-text note search
- Tag and graph navigation
```

### 3. Initialize that repository

Go to the project directory and run:

```bash
ai-memory init --project <project-name> --tool all --scope hybrid
```

After that, your AI tools can resolve the project through memory instead of only the local repo context.

## Core commands

```bash
ai-memory context
ai-memory capability
ai-memory projects
ai-memory project <name>
ai-memory search <keyword>
ai-memory new-project <name>
ai-memory init --project <name> --tool all --scope hybrid
```

## Tool outputs

- OpenCode output is written to both `AGENTS.md` and `.opencode/instructions.md`.
- VS Code output is written under `.github/`.

## Suggested workflow

1. Create or update project memory in `~/.memory/projects/`.
2. Run `ai-memory init` in the target repository.
3. Let the AI start with minimal context and only escalate when needed.

## Troubleshooting

### `ai-memory: command not found`

Add this to your shell config and restart the shell:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

### Project name resolves incorrectly

Check the mapping file in the repository:

```bash
cat .ai-memory-project
```

If needed, reset it explicitly:

```bash
ai-memory init --project <your-project-name> --tool all --scope hybrid
```

### Skills were not installed into the project

Run init again in the repository root:

```bash
ai-memory init --project <your-project-name> --tool all --scope hybrid
```

Then verify these paths exist:

- `.github/skills/`
- `.github/copilot-instructions.md`
- `AGENTS.md`

### OpenCode and VS Code files look different

This is expected.

- OpenCode uses `AGENTS.md` and `.opencode/instructions.md`
- VS Code uses `.github/copilot-instructions.md` and `.github/copilot-project-summary.md`

### I only want to set up one tool

Use `--tool`:

```bash
ai-memory init --project <your-project-name> --tool vs-code --scope hybrid
ai-memory init --project <your-project-name> --tool opencode --scope hybrid
```

## Repository

GitHub repository:

- https://github.com/shiyuanyou/ai-memory
