# AI Memory System – Copilot Instructions

## Project Overview

This repo implements a **minimal developer memory layer** — a lightweight CLI tool that gives AI coding assistants persistent, cross-session context about the developer's environment, preferences, and projects.

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
3. **Cross-tool compatible** — works with any AI tool that can run a shell command
4. **Low friction** — usable via a single shell command or prompt injection

## Conventions

- All memory data files are plain Markdown (`.md`)
- The CLI script (`ai-memory`) has no dependencies beyond `bash`, `cat`, `grep`, `ls`
- Data lives in `~/.memory/` at runtime; this repo only contains the CLI and docs
- Keep the script under 500 lines; avoid adding dependencies
- New commands follow the `case "$cmd" in` pattern in `ai-memory`

## Optimization Directions (active development goals)

1. **Capability awareness** — auto-summarize developer capabilities from project files
2. **Context compression** — return concise summaries to minimize prompt tokens
3. **Cross-tool interoperability** — universal CLI interface consumable by any AI tool
4. **Optional MCP interface** — expose commands via MCP tool protocol for auto AI access
5. **Zero-dependency** — remain `<500 lines`, text-based, and scriptable

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

## Key File

- [`ai-memory`](../ai-memory) — the entire CLI; start here for all changes
