#!/usr/bin/env bash

set -euo pipefail

REPO_URL="${AI_MEMORY_REPO_URL:-https://github.com/shiyuanyou/ai-memory.git}"
REPO_REF="${AI_MEMORY_REPO_REF:-main}"
INSTALL_DIR="${AI_MEMORY_INSTALL_DIR:-$HOME/.local/share/ai-memory}"
BIN_DIR="${AI_MEMORY_BIN_DIR:-$HOME/.local/bin}"
SCOPE="${AI_MEMORY_INIT_SCOPE:-hybrid}"
TOOL="${AI_MEMORY_INIT_TOOL:-all}"
PROJECT_NAME="${AI_MEMORY_PROJECT:-}"
PROJECT_DIR="$(pwd -P)"
DO_INIT=1

print_help() {
  cat <<'EOF'
Usage: bootstrap.sh [options]

Options:
  --project <name>     Set project mapping explicitly for init
  --project-dir <dir>  Directory to run init in (default: current directory)
  --scope <mode>       Init scope: global|project|hybrid (default: hybrid)
  --tool <name>        Init tool: vs-code|copilot|opencode|claude|codex|all (default: all)
  --skip-init          Install ai-memory only, do not run init
  --repo <url>         Override repository URL
  --ref <git-ref>      Install a specific branch or tag (default: main)
  -h, --help           Show this help
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
  --project)
    PROJECT_NAME="${2:-}"
    [[ -n "$PROJECT_NAME" ]] || { echo "Error: --project requires a value" >&2; exit 1; }
    shift 2
    ;;
  --project-dir)
    PROJECT_DIR="${2:-}"
    [[ -n "$PROJECT_DIR" ]] || { echo "Error: --project-dir requires a value" >&2; exit 1; }
    shift 2
    ;;
  --scope)
    SCOPE="${2:-}"
    [[ -n "$SCOPE" ]] || { echo "Error: --scope requires a value" >&2; exit 1; }
    shift 2
    ;;
  --tool)
    TOOL="${2:-}"
    [[ -n "$TOOL" ]] || { echo "Error: --tool requires a value" >&2; exit 1; }
    shift 2
    ;;
  --skip-init)
    DO_INIT=0
    shift
    ;;
  --repo)
    REPO_URL="${2:-}"
    [[ -n "$REPO_URL" ]] || { echo "Error: --repo requires a value" >&2; exit 1; }
    shift 2
    ;;
  --ref)
    REPO_REF="${2:-}"
    [[ -n "$REPO_REF" ]] || { echo "Error: --ref requires a value" >&2; exit 1; }
    shift 2
    ;;
  -h|--help)
    print_help
    exit 0
    ;;
  *)
    echo "Error: unknown option: $1" >&2
    print_help
    exit 1
    ;;
  esac
done

case "$SCOPE" in
  global|project|hybrid) ;;
  *) echo "Error: invalid --scope value: $SCOPE" >&2; exit 1 ;;
esac

case "$TOOL" in
  vs-code|copilot|opencode|claude|codex|all) ;;
  *) echo "Error: invalid --tool value: $TOOL" >&2; exit 1 ;;
esac

mkdir -p "$BIN_DIR"
if [[ -d "$INSTALL_DIR/.git" ]]; then
  git -C "$INSTALL_DIR" fetch --tags origin
  git -C "$INSTALL_DIR" checkout "$REPO_REF"
  git -C "$INSTALL_DIR" pull --ff-only origin "$REPO_REF" || true
else
  rm -rf "$INSTALL_DIR"
  git clone "$REPO_URL" "$INSTALL_DIR"
  git -C "$INSTALL_DIR" checkout "$REPO_REF"
fi

chmod +x "$INSTALL_DIR/ai-memory"
if [[ -f "$INSTALL_DIR/bootstrap.sh" ]]; then
  chmod +x "$INSTALL_DIR/bootstrap.sh"
fi
ln -sf "$INSTALL_DIR/ai-memory" "$BIN_DIR/ai-memory"

if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
  echo "Warning: $BIN_DIR is not in PATH. Add this line to your shell config:" >&2
  echo "  export PATH=\"$BIN_DIR:\$PATH\"" >&2
fi

mkdir -p "$HOME/.memory/projects"

if (( DO_INIT == 1 )); then
  if [[ -d "$PROJECT_DIR/.git" ]]; then
    pushd "$PROJECT_DIR" >/dev/null
    if [[ -n "$PROJECT_NAME" ]]; then
      "$BIN_DIR/ai-memory" init --project "$PROJECT_NAME" --tool "$TOOL" --scope "$SCOPE"
    else
      "$BIN_DIR/ai-memory" init --tool "$TOOL" --scope "$SCOPE"
    fi
    popd >/dev/null
  else
    echo "Skip init: $PROJECT_DIR is not a git repository." >&2
    echo "Run this later in your project directory:" >&2
    echo "  ai-memory init --tool $TOOL --scope $SCOPE" >&2
  fi
fi

echo "ai-memory is ready."
echo "Check version/help: ai-memory"
