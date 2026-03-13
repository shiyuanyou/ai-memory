#!/usr/bin/env bash

_llm_call() {
  local system="$1" prompt="$2"
  local config="$ROOT/.llm-config"
  local url model key_env api_key payload response

  url="$(grep '^LLM_URL=' "$config" 2>/dev/null | cut -d= -f2-)"
  model="$(grep '^LLM_MODEL=' "$config" 2>/dev/null | cut -d= -f2-)"
  key_env="$(grep '^LLM_KEY_ENV=' "$config" 2>/dev/null | cut -d= -f2-)"

  url="${url:-https://api.openai.com/v1/chat/completions}"
  model="${model:-gpt-4o-mini}"
  key_env="${key_env:-OPENAI_API_KEY}"
  api_key="${!key_env}"

  if [[ -z "$api_key" ]]; then
    echo "Error: \$$key_env is not set." >&2
    echo "  Run: ai-memory config set LLM_KEY_ENV=YOUR_KEY_VAR_NAME" >&2
    return 1
  fi

  payload="$(jq -n --arg m "$model" --arg s "$system" --arg u "$prompt" \
    '{model:$m,messages:[{role:"system",content:$s},{role:"user",content:$u}]}')"

  response="$(curl -sf "$url" \
    -H "Authorization: Bearer $api_key" \
    -H "Content-Type: application/json" \
    -d "$payload")" || {
    echo "Error: failed to call LLM endpoint: $url" >&2
    return 1
  }

  jq -er '.choices[0].message.content // empty' <<< "$response" || {
    echo "Error: invalid LLM response shape (missing choices[0].message.content)." >&2
    return 1
  }
}
