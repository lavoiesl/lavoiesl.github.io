#!/usr/bin/env bash
# Usage: download-image.sh <url> <destination-path>
#
# Downloads a remote image to the given destination path.
# Creates the parent directory if it does not already exist.
# Exits non-zero on failure.
set -euo pipefail

URL="${1:?Usage: $0 <url> <destination-path>}"
DEST="${2:?Usage: $0 <url> <destination-path>}"

mkdir -p "$(dirname "$DEST")"

curl \
  --fail \
  --silent \
  --show-error \
  --location \
  --max-redirs 5 \
  --max-time 30 \
  --output "$DEST" \
  -- "$URL"

echo "Saved: $DEST"
