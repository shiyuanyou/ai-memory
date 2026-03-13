# v0.2.1

## Highlights

- Added one-command install entry via `install.sh`
- Unified scoped inject support for VS Code, OpenCode, Claude, and Codex
- `ai-memory init --tool all` now initializes all major supported tools
- Bootstrap can install from a stable tag or branch via `--ref`

## Recommended install command

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/shiyuanyou/ai-memory/v0.2.1/install.sh) --project <your-project-name>
```

## Notes

- Stable installs should prefer `install.sh`
- Advanced/custom installs can still use `bootstrap.sh`
- GitHub Release page can use this file as release notes
