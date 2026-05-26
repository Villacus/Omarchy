#!/bin/bash
RAW=$(busctl --user get-property org.mpris.MediaPlayer2.cliamp /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player PlaybackStatus 2>/dev/null)
if [ -z "$RAW" ]; then
  echo '{"text": "", "class": "stopped", "alt": "stopped"}'
elif echo "$RAW" | grep -q "Playing"; then
  echo '{"text": "⏸", "class": "playing", "alt": "playing"}'
else
  echo '{"text": "▶", "class": "paused", "alt": "paused"}'
fi
