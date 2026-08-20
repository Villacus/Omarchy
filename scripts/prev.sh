#!/bin/bash
if busctl --user get-property org.mpris.MediaPlayer2.cliamp /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player PlaybackStatus &>/dev/null; then
  echo '{"text": "⏮", "class": "active", "alt": "prev"}'
else
  echo '{"text": ""}'
fi
