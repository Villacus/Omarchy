#!/bin/bash
# Detects if a Steam game is running via /proc/*/environ.
# Emits JSON: {"game": true/false}
set -uo pipefail

if grep -qz '^SteamAppId=' /proc/[0-9]*/environ 2>/dev/null; then
  echo '{"game": true}'
else
  echo '{"game": false}'
fi
