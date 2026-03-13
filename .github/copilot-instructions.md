# AI Memory System – Universal AI Editor Instructions

## Project Overview

This repo implements a **minimal developer memory layer** — a lightweight CLI tool that gives AI coding assistants persistent, cross-session context about the developer's environment, preferences, and projects.

**Primary goal:** enable any AI coding tool (VS Code Copilot, Claude Code, OpenCode, Codex CLI, etc.) to consume the same developer memory via a unified shell interface — no per-tool integration required.

**Current stage:** the project is no longer only a text dumper. `ai-memory` now has an LLM-backed path for learning and maintaining memory via an OpenAI-compatible API.

The system lives in `~/.memory/` and is exposed via the `ai-memory` CLI script.

## Architecture

```
ai-memory           # Main CLI script (bash)
docs/
  core-idea.md      # Design principles, goals, and optimization roadmap

~/.memory/          # Runtime data (NOT in this repo)
  profile.md        # Developer identity and technical environment
  preferences.md    # Coding habits, editor, architecture preferences
  infra.md          # Servers, domains, local/deployed services
  .llm-config       # LLM endpoint/model/env-var-name configuration
  projects/
    <name>.md       # Per-project description and capabilities
```

## Implementation Status

- `ai-memory` is a single Bash entrypoint with `case "$cmd" in` command dispatch
- Read-only memory access is still plain Markdown under `~/.memory/`
- Write/update flows can now be LLM-assisted through `ai-memory learn`
- LLM integration is **OpenAI-compatible HTTP API based**, not tied to one vendor
- API credentials are read indirectly from a shell environment variable named by `LLM_KEY_ENV`

## CLI Commands

| Command | Purpose |
|---|---|
| `ai-memory context` | Output profile + preferences + infra for AI prompt injection |
| `ai-memory infra` | Show infrastructure details |
| `ai-memory projects` | List known projects with `Description:` and optional `GitHub:` summary |
| `ai-memory project <name>` | Show a specific project's description and capabilities |
| `ai-memory new-project <name>` | Create a structured project memory template |
| `ai-memory search <keyword>` | Full-text search across all memory files |
| `ai-memory capability` | Describe the memory system + list existing projects |
| `ai-memory inject <tool>` | Generate tool-specific instruction files for `claude`, `opencode`, or `codex` |
| `ai-memory config show` | Show effective LLM config or defaults |
| `ai-memory config set ...` | Set OpenAI-compatible LLM URL, model, and key env var |
| `ai-memory learn [<file>|-]` | Learn from a file or stdin and update memory files via LLM |

## Design Principles (from `docs/core-idea.md`)

1. **Extremely simple** — shell script + plain Markdown files; no databases, no frameworks
2. **UNIX-style** — one responsibility, text-based output, pipeable
3. **Cross-tool compatible** — works with VS Code Copilot, Claude Code, OpenCode, Codex CLI, and any tool that can run a shell command
4. **Low friction** — usable via a single shell command or prompt injection
5. **Tool-agnostic** — the same `~/.memory/` data and `ai-memory` CLI serve all tools; no per-tool config needed

## Conventions

- All memory data files are plain Markdown (`.md`)
- The CLI script (`ai-memory`) is Bash-first, but current LLM features also require `curl` and `jq`
- Data lives in `~/.memory/` at runtime; this repo only contains the CLI and docs
- Keep the script under 500 lines; avoid adding dependencies
- New commands follow the `case "$cmd" in` pattern in `ai-memory`
- Project files under `~/.memory/projects/*.md` should start with `Description:`, `GitHub:`, and `Directory:` for best summaries
- LLM provider configuration lives in `~/.memory/.llm-config`, not in the repo
- Never store API keys in repo files; store only the environment variable name in `LLM_KEY_ENV`

## Project File Format

Each project memory file should use this minimal metadata so `ai-memory projects` can summarize it:

```md
# project-name

Description: one-line summary
GitHub: https://github.com/owner/repo
Directory: ~/path/to/project
```

Then include sections like `## Purpose`, `## How to Reference`, `## Key Capabilities`, `## Tech Stack`, and `## Notes`.

When an AI adds a new project, prefer `ai-memory new-project <name>` instead of inventing a new ad hoc format.

## Cross-Tool Injection Guide

Each AI tool has a preferred way to consume shell output as context:

| Tool | Injection Method |
|---|---|
| **VS Code Copilot** | `.github/copilot-instructions.md` (this file) or `#terminalSelection` |
| **Claude Code** | `CLAUDE.md` in repo root, or `--system-prompt $(ai-memory context)` |
| **OpenCode** | `.opencode/instructions.md`, or paste `ai-memory context` output into session |
| **Codex CLI** | `--instructions "$(ai-memory context)"` flag at invocation |
| **Any tool** | `ai-memory context` output piped or pasted as system/user prompt |

For tools that support `AGENTS.md` or equivalent, copy relevant sections from `ai-memory context` output into that file.

Generated files today:

- `ai-memory inject claude` → `CLAUDE.md`
- `ai-memory inject opencode` → `.opencode/instructions.md`
- `ai-memory inject codex` → `.codex-instructions.md`

These generated files are refreshable artifacts. Re-run the command instead of hand-maintaining duplicated context.

## LLM Configuration

`ai-memory` expects an OpenAI-compatible chat completions endpoint.

Example:

```bash
ai-memory config set \
  LLM_KEY_ENV=DEEPSEEK_API_KEY \
  LLM_URL=https://api.deepseek.com/v1/chat/completions \
  LLM_MODEL=deepseek-chat
```

Interpretation:

- `LLM_URL` is the full chat completions endpoint
- `LLM_MODEL` is the provider-specific model name
- `LLM_KEY_ENV=DEEPSEEK_API_KEY` means `ai-memory` reads the real secret from `$DEEPSEEK_API_KEY`

Default fallback values:

- `LLM_URL=https://api.openai.com/v1/chat/completions`
- `LLM_MODEL=gpt-4o-mini`
- `LLM_KEY_ENV=OPENAI_API_KEY`

## Learn Workflow

`ai-memory learn` is a core workflow. It allows any external AI environment to push durable memory updates back into `~/.memory/`.

Behavior:

1. Read current memory context from `profile.md`, `preferences.md`, and `infra.md`
2. Read new information from a file or stdin
3. Ask the configured LLM to emit JSON updates
4. Apply `append` or `replace` updates to memory files under `~/.memory/`

Examples:

```bash
ai-memory learn meeting-notes.md
echo "I now use bun instead of npm for side projects" | ai-memory learn
```

AI agents should prefer concise, durable facts over transient notes. Do not write chat transcripts verbatim into memory.

## Validation And Pitfalls

- Run `bash -n ai-memory` after modifying the script; there is no formal test suite yet
- `learn` assumes the configured endpoint follows the OpenAI chat completions response shape
- `learn` currently applies LLM output directly after JSON parsing; agents should keep prompts conservative and file targets constrained
- `projects)` currently loops over `~/.memory/projects/*.md`; be careful about the empty-glob case if extending this logic
- Avoid suggestions that require moving runtime memory into the repo; the design intentionally keeps runtime state in `~/.memory/`

## Optimization Directions (active development goals)

1. **Capability awareness** — auto-summarize developer capabilities from project files
2. **Context compression** — return concise summaries to minimize prompt tokens
3. **Cross-tool interoperability** — universal CLI interface consumable by all AI editors
4. **Optional MCP interface** — expose commands via MCP tool protocol for automatic AI access
5. **Per-tool bootstrap scripts** — `ai-memory inject <tool>` generates the correct file for each tool
6. **Safer learn pipeline** — add preview/diff/approval before applying LLM-proposed updates
7. **Zero-dependency bias** — stay lightweight where possible, even though current LLM mode requires `curl` and `jq`

## How AI Should Use This System

Before planning architecture or proposing solutions, always read developer memory:

```bash
ai-memory context     # who the developer is + environment
ai-memory projects    # what tools already exist (avoid reinventing)
```

Use project information to:
- Reuse existing capabilities instead of suggesting new infrastructure
- Respect stated editor/architecture preferences
- Avoid assuming the developer lacks existing tools or servers
- Do not suggest adding a new AI tool if one already exists in `ai-memory projects`

When the task is about updating memory itself:

- Prefer changing `ai-memory` over adding separate helper scripts unless the complexity clearly justifies it
- Preserve the runtime boundary: repo code here, mutable memory in `~/.memory/`
- If introducing more LLM behavior, keep the provider interface OpenAI-compatible and configurable
- Treat `ai-memory learn` as the primary write path for cross-tool memory updates

## Adding a New AI Tool to the Ecosystem

When the developer adopts a new AI coding tool, the workflow is:
1. Run `ai-memory context` and paste output into the new tool's system prompt or config file
2. Optionally add a dedicated config file (e.g. `CLAUDE.md`, `.opencode/instructions.md`) that calls `ai-memory context`
3. Do **not** duplicate memory data — always source from `~/.memory/`

## Key File

- [`ai-memory`](../ai-memory) — the entire CLI; start here for all changes
