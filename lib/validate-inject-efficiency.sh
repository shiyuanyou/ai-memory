#!/usr/bin/env bash

set -euo pipefail

workspace="${1:-$(pwd)}"
main_file="$workspace/.github/copilot-instructions.md"
summary_file="$workspace/.github/copilot-project-summary.md"
quick_ref="$workspace/docs/task-classification-quick-ref.md"

if [[ ! -f "$main_file" ]]; then
  echo "Error: missing $main_file"
  echo "Run: ai-memory inject vs-code --scope global"
  exit 1
fi

report_file_stat() {
  local file="$1"
  local name bytes lines tokens

  [[ -f "$file" ]] || return 0

  name="$(basename "$file")"
  bytes="$(wc -c < "$file" | tr -d ' ')"
  lines="$(wc -l < "$file" | tr -d ' ')"
  tokens=$(( (bytes + 3) / 4 ))

  printf '%-30s %6s bytes  %4s lines  ~%5s tokens\n' "$name" "$bytes" "$lines" "$tokens"
}

echo "Inject efficiency report"
echo "Workspace: $workspace"
echo
report_file_stat "$main_file"
report_file_stat "$summary_file"
report_file_stat "$quick_ref"
echo

main_lines="$(wc -l < "$main_file" | tr -d ' ')"
if (( main_lines > 80 )); then
  echo "WARN: copilot-instructions.md has $main_lines lines (target <= 80)."
else
  echo "OK: copilot-instructions.md line count target met ($main_lines <= 80)."
fi

if grep -q "Quick classification reference" "$main_file"; then
  echo "OK: quick-ref hook found in main instructions."
else
  echo "WARN: quick-ref hook missing in main instructions."
fi

if grep -q "Skill-first routing" "$main_file"; then
  echo "OK: skill routing hook found in main instructions."
else
  echo "WARN: skill routing hook missing in main instructions."
fi
