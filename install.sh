#!/usr/bin/env bash

set -euo pipefail

VERSION="v0.2.1"
RAW_BASE="https://raw.githubusercontent.com/shiyuanyou/ai-memory/${VERSION}"
TMP_BOOTSTRAP="$(mktemp)"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

cleanup() {
  rm -f "$TMP_BOOTSTRAP"
}
trap cleanup EXIT

if [[ -f "$SCRIPT_DIR/bootstrap.sh" ]]; then
  cp "$SCRIPT_DIR/bootstrap.sh" "$TMP_BOOTSTRAP"
else
  curl -fsSL "$RAW_BASE/bootstrap.sh" -o "$TMP_BOOTSTRAP"
fi
chmod +x "$TMP_BOOTSTRAP"
exec "$TMP_BOOTSTRAP" --tool all --scope hybrid --ref "$VERSION" "$@"
