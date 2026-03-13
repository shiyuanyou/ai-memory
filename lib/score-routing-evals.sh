#!/usr/bin/env bash

set -euo pipefail

workspace="${1:-$(pwd)}"
suite_file="$workspace/evals/skills-routing-evals.json"
results_file="${2:-$workspace/evals/skills-routing-results.json}"

if [[ ! -f "$suite_file" ]]; then
  echo "Error: missing $suite_file"
  exit 1
fi

if [[ ! -f "$results_file" ]]; then
  if ! command -v jq >/dev/null 2>&1; then
    echo "Error: jq is required to generate result template."
    exit 1
  fi
  jq -n --slurpfile suite "$suite_file" '
    {
      results: [
        ($suite[0].evals[] | {id: .id, mode: "new_window", passed: false, notes: ""}),
        ($suite[0].evals[] | {id: .id, mode: "subagent", passed: false, notes: ""})
      ]
    }
  ' > "$results_file"
  echo "Created result template: $results_file"
  echo "Fill it with observed pass/fail values, then rerun this script."
  exit 0
fi

if ! command -v jq >/dev/null 2>&1; then
  echo "Error: jq is required."
  exit 1
fi

score_mode() {
  local mode="$1"
  local threshold
  local total passed rate

  threshold="$(jq -r --arg mode "$mode" '.thresholds[$mode]' "$suite_file")"
  total="$(jq -r --arg mode "$mode" '[.results[] | select(.mode == $mode)] | length' "$results_file")"
  passed="$(jq -r --arg mode "$mode" '[.results[] | select(.mode == $mode and .passed == true)] | length' "$results_file")"

  if [[ "$total" == "0" ]]; then
    echo "$mode: no results"
    return
  fi

  rate="$(awk -v p="$passed" -v t="$total" 'BEGIN { printf "%.2f", (t == 0 ? 0 : p / t) }')"
  printf '%-12s pass=%s/%s  rate=%s  threshold=%s\n' "$mode" "$passed" "$total" "$rate" "$threshold"
}

echo "Routing evaluation summary"
echo "Suite: $suite_file"
echo "Results: $results_file"
echo
score_mode "new_window"
score_mode "subagent"
echo

echo "Detailed failures:"
jq -r '.results[] | select(.passed != true) | "- [" + .mode + "] " + .id + (if .notes != "" then ": " + .notes else "" end)' "$results_file"
