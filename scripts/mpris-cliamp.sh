#!/bin/bash
BUS="org.mpris.MediaPlayer2.cliamp"
PATH_="/org/mpris/MediaPlayer2"

RAW=$(busctl --user get-property "$BUS" "$PATH_" org.mpris.MediaPlayer2.Player PlaybackStatus 2>/dev/null)
if [ -z "$RAW" ]; then
  echo '{"text": "", "class": "stopped", "alt": "stopped"}'
  exit 0
fi

STATUS=$(echo "$RAW" | grep -oP '(?<=s ").*(?=")' | tr '[:upper:]' '[:lower:]')

META=$(busctl --user get-property "$BUS" "$PATH_" org.mpris.MediaPlayer2.Player Metadata 2>/dev/null)

# Match "xesam:title" s "..."  - then the string value
TITLE=$(echo "$META" | grep -oP 'xesam:title" s "\K[^"]*')
# Match "xesam:artist" as 1 "..." - the first artist string
ARTIST=$(echo "$META" | grep -oP 'xesam:artist" as \d+ "\K[^"]*')

if [ "$STATUS" = "playing" ]; then
  TEXT="▶ ${ARTIST} — ${TITLE}"
elif [ "$STATUS" = "paused" ]; then
  TEXT="⏸ ${ARTIST} — ${TITLE}"
else
  TEXT=""
fi

echo "{\"text\": \"$TEXT\", \"class\": \"$STATUS\", \"alt\": \"$STATUS\"}"
