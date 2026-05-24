#!/bin/bash

WALLPAPER_DIR="$HOME/.config/omarchy/themes/wallpaper-engine/backgrounds"
WALLPAPER_PATH="/mnt/Games/SteamLibrary/steamapps/workshop/content/431960"

declare -a IDS=()

mkdir -p "$WALLPAPER_DIR"

for carpeta in "$WALLPAPER_PATH"/*; do
  if [[ -d $carpeta ]]; then
    ID=$(basename "$carpeta")

      for ext in png jpg jpeg webp gif bmp; do
      if [[ -f "$carpeta/preview.$ext" ]]; then
        cp "$carpeta/preview.$ext" "$WALLPAPER_DIR/wallpaper_$ID.$ext"
        echo "✓ $ID ($ext)"
        break
      fi
    done
  fi
done


