# AI Memory System – Universal AI Editor Instructions

## Project Overview

This repo implements a **minimal developer memory layer** — a lightweight CLI tool that gives AI coding assistants persistent, cross-session context about the developer's environment, preferences, and projects.

**Primary goal:** enable any AI coding tool (VS Code Copilot, Claude Code, OpenCode, Codex CLI, etc.) to consume the same developer memory via a unified shell interface — no per-tool integration required.

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
  projects/
    <name>.md       # Per-project description and capabilities
```

## CLI Commands

| Command | Purpose |
|---|---|
| `ai-memory context` | Output profile + preferences + infra for AI prompt injection |
| `ai-memory infra` | Show infrastructure details |
| `ai-memory projects` | List all known projects |
| `ai-memory project <name>` | Show a specific project's description and capabilities |
| `ai-memory search <keyword>` | Full-text search across all memory files |
| `ai-memory capability` | Describe the memory system + list existing projects |

## Design Principles (from `docs/core-idea.md`)

1. **Extremely simple** — shell script + plain Markdown files; no databases, no frameworks
2. **UNIX-style** — one responsibility, text-based output, pipeable
3. **Cross-tool compatible** — works with VS Code Copilot, Claude Code, OpenCode, Codex CLI, and any tool that can run a shell command
4. **Low friction** — usable via a single shell command or prompt injection
5. **Tool-agnostic** — the same `~/.memory/` data and `ai-memory` CLI serve all tools; no per-tool config needed

## Conventions

- All memory data files are plain Markdown (`.md`)
- The CLI script (`ai-memory`) has no dependencies beyond `bash`, `cat`, `grep`, `ls`
- Data lives in `~/.memory/` at runtime; this repo only contains the CLI and docs
- Keep the script under 500 lines; avoid adding dependencies
- New commands follow the `case "$cmd" in` pattern in `ai-memory`

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

## Optimization Directions (active development goals)

1. **Capability awareness** — auto-summarize developer capabilities from project files
2. **Context compression** — return concise summaries to minimize prompt tokens
3. **Cross-tool interoperability** — universal CLI interface consumable by all AI editors
4. **Optional MCP interface** — expose commands via MCP tool protocol for automatic AI access
5. **Per-tool bootstrap scripts** — `ai-memory inject <tool>` generates the correct file for each tool
6. **Zero-dependency** — remain `<500 lines`, text-based, and scriptable

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

## Adding a New AI Tool to the Ecosystem

When the developer adopts a new AI coding tool, the workflow is:
1. Run `ai-memory context` and paste output into the new tool's system prompt or config file
2. Optionally add a dedicated config file (e.g. `CLAUDE.md`, `.opencode/instructions.md`) that calls `ai-memory context`
3. Do **not** duplicate memory data — always source from `~/.memory/`

## Key File

- [`ai-memory`](../ai-memory) — the entire CLI; start here for all changes
