#!/usr/bin/env bash
set -euo pipefail

# Drain stdin from hook payload; we do not need event details for this check.
cat >/dev/null || true

if ! command -v git >/dev/null 2>&1; then
  exit 0
fi

# Look for newly added Gist script embed lines in unstaged and staged post diffs.
if {
  git --no-pager diff --unified=0 -- _posts
  git --no-pager diff --cached --unified=0 -- _posts
} | grep -E '^\+[^+].*<script[^>]*src="https://gist\.github\.com/[^"]+\.js"' >/dev/null 2>&1; then
  cat <<'JSON'
{
  "continue": true,
  "systemMessage": "Detected newly added GitHub Gist script embed(s) under _posts. Prefer static inlined code blocks: run skill /inline-gist-to-jekyll-highlight and replace <script ... .js> with {% highlight ... linenos %} blocks plus a gist source link."
}
JSON
fi
