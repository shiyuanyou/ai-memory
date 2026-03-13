#!/usr/bin/env bash

run_learn() {
  local dry_run=0
  local input_arg="$1"
  local input current system_prompt user_prompt response n i file action content target
  local config_file auto_inject

  if ! require_command curl; then
    echo "Error: curl is required for 'ai-memory learn'." >&2
    return 1
  fi
  if ! require_command jq; then
    echo "Error: jq is required for 'ai-memory learn'." >&2
    return 1
  fi

  if [[ "$1" == "--dry-run" ]]; then
    dry_run=1
    input_arg="$2"
  fi

  if [[ -n "$input_arg" && "$input_arg" != "-" ]]; then
    if [[ ! -f "$input_arg" ]]; then
      echo "Error: file not found: $input_arg" >&2
      return 1
    fi
    input="$(cat "$input_arg")"
  else
    input="$(cat)"
  fi

  current="$(render_context)"

  system_prompt='You are a developer memory manager. Extract facts worth remembering from the new information provided.
Output ONLY valid JSON (no markdown fences, no explanation):
{
  "updates": [
    {"file": "profile.md", "action": "append", "content": "..."}
  ]
}
Supported files: profile.md, preferences.md, infra.md, projects/<name>.md
Actions: "append" adds text to end of file. "replace" rewrites the full file.
Rules:
- Project-specific facts, project status, project capabilities, and project roadmaps must only go to projects/<name>.md.
- Do not store project lists or project summaries in profile.md, preferences.md, or infra.md.
- profile.md is for developer identity and technical background only.
- preferences.md is for coding preferences and constraints only.
- infra.md is for infrastructure, domains, services, and environments only.
Skip trivial or already-known facts. Be concise. If nothing is worth remembering, return {"updates":[]}'

  user_prompt="Current memory:
${current}

New information to learn:
${input}"

  echo "Analyzing..." >&2
  response="$(_llm_call "$system_prompt" "$user_prompt")" || return 1

  # Strip markdown code fences if model wraps response.
  response="$(printf '%s' "$response" | sed '/^```[A-Za-z0-9_-]*$/d')"

  if ! jq -e . >/dev/null 2>&1 <<< "$response"; then
    echo "Error: LLM response is not valid JSON." >&2
    echo "First response lines:" >&2
    printf '%s\n' "$response" | head -n 20 >&2
    return 1
  fi

  n="$(jq -r 'if (.updates | type) == "array" then (.updates | length) else "invalid" end' <<< "$response")"
  if [[ "$n" == "invalid" ]]; then
    echo "Error: LLM response JSON must include an array field: updates" >&2
    return 1
  fi
  if [[ "$n" == "0" ]]; then
    echo "Nothing new to remember."
    return 0
  fi

  if [[ "$dry_run" -eq 1 ]]; then
    echo "Dry run mode: no files will be modified."
  fi

  for i in $(seq 0 $((n - 1))); do
    file="$(jq -r ".updates[$i].file" <<< "$response")"
    action="$(jq -r ".updates[$i].action" <<< "$response")"
    content="$(jq -r ".updates[$i].content" <<< "$response")"

    if ! is_allowed_update_file "$file"; then
      echo "  invalid target '$file' - skipped"
      continue
    fi

    case "$action" in
      append|replace)
        ;;
      *)
        echo "  unknown action '$action' for $file - skipped"
        continue
        ;;
    esac

    if ! is_project_update_file "$file" && grep -Eiq '(^# )|(^Description:)|(^GitHub:)|(^Directory:)|(^## )' <<< "$content"; then
      echo "  project-like content targeted $file - skipped"
      continue
    fi

    target="$ROOT/$file"

    if [[ "$dry_run" -eq 1 ]]; then
      echo "  [dry-run] $action -> $file"
      continue
    fi

    mkdir -p "$(dirname "$target")"
    case "$action" in
      append)
        printf '\n%s\n' "$content" >> "$target"
        echo "  appended -> $file"
        ;;
      replace)
        printf '%s\n' "$content" > "$target"
        echo "  replaced -> $file"
        ;;
    esac
  done

  echo "Memory updated."

  config_file="$ROOT/.llm-config"
  auto_inject=""
  if [[ -f "$config_file" ]]; then
    auto_inject="$(grep -m1 '^AUTO_INJECT_VSCODE=' "$config_file" 2>/dev/null | sed 's/^AUTO_INJECT_VSCODE=//')"
  fi

  if [[ "$auto_inject" =~ ^(1|true|TRUE|yes|YES)$ ]]; then
    echo "AUTO_INJECT_VSCODE enabled: refreshing Copilot instructions (hybrid mode)..."
    if "$0" inject vs-code --scope hybrid >/dev/null 2>&1; then
      echo "Copilot instructions refreshed."
    else
      echo "Warning: auto refresh failed. Run: ai-memory inject vs-code --scope hybrid" >&2
    fi
  else
    echo "Tip: run 'ai-memory inject vs-code --scope hybrid' in your workspace to refresh Copilot context."
  fi

  return 0
}
