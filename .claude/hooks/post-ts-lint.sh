#!/usr/bin/env bash
set -euo pipefail

input="$(cat)"
file="$(jq -r '.tool_input.file_path // .tool_input.path // empty' <<< "$input")"

# Only process TS/JS files
case "$file" in
  *.ts|*.tsx|*.js|*.jsx) ;;
  *) exit 0 ;;
esac

# Skip if file doesn't exist (deleted)
[ -f "$file" ] || exit 0

# Auto-fix first (silent)
npx biome format --write "$file" >/dev/null 2>&1 || true
npx oxlint --fix "$file" >/dev/null 2>&1 || true

# Report remaining violations (filter out summary-only output)
diag="$(npx oxlint "$file" 2>&1 || true)"
errors="$(echo "$diag" | grep -c ' error\|⚠' || true)"

if [ "$errors" -gt 0 ]; then
  trimmed="$(echo "$diag" | head -30)"
  jq -Rn --arg msg "$trimmed" '{
    hookSpecificOutput: {
      hookEventName: "PostToolUse",
      additionalContext: $msg
    }
  }'
fi
