# ai-memory

Description: Lightweight developer-memory layer for AI coding workflows.

## Purpose

Provide a minimal, cross-tool memory layer so AI agents can retrieve persistent developer context without relying on large static instruction snapshots.

## Architecture

- `ai-memory` is the CLI entrypoint.
- `~/.memory/` stores runtime memory facts.
- `.github/copilot-instructions.md` is a routed instruction layer for Copilot.
- `.github/skills/` holds task-specific routing and token-efficiency skills.

## Key Capabilities

- Render dynamic developer context via `ai-memory context`.
- Read project-specific memory via `ai-memory project <name>`.
- Inject lightweight or layered instructions for AI tools.
- Learn and persist new facts through the `learn` pipeline.

## Notes

- Prefer runtime memory over this file when both are available.
- This file exists as a repo-local fallback for project and hybrid inject modes.
