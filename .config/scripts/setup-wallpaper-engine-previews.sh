#!/bin/bash

WALLPAPER_DIR="$HOME/.config/omarchy/themes/wallpaper-engine/backgrounds"
WALLPAPER_PATH="/mnt/Games/SteamLibrary/steamapps/workshop/content/431960"

mkdir -p "$WALLPAPER_DIR"

# Limpiar previews de wallpapers que ya no existen en el taller
echo "Limpiando previews obsoletas..."
for preview in "$WALLPAPER_DIR"/wallpaper_*.*; do
  [[ -f "$preview" ]] || continue
  id=$(basename "$preview" | sed 's/^wallpaper_//;s/\.[^.]*$//')
  if [[ ! -d "$WALLPAPER_PATH/$id" ]]; then
    rm -f "$preview"
    echo "  ✀ eliminado wallpaper_$id (ya no existe en el taller)"
  fi
done

for carpeta in "$WALLPAPER_PATH"/*; do
  [[ -d $carpeta ]] || continue

  ID=$(basename "$carpeta")
  OUTPUT="$WALLPAPER_DIR/wallpaper_$ID.png"

  [[ -f "$OUTPUT" ]] && echo "✓ $ID (ya existe)" && continue

  src=""
  for ext in png jpg jpeg; do
    if [[ -f "$carpeta/preview.$ext" ]]; then
      src="$carpeta/preview.$ext"
      break
    fi
  done

  if [[ -z "$src" && -f "$carpeta/preview.gif" ]]; then
    src="$carpeta/preview.gif"
  fi

  if [[ -z "$src" ]]; then
    echo "  ✗ $ID (sin preview)"
    continue
  fi

  echo "Procesando $ID..."
  magick "$src"[0] -resize 640x360\> -background black -gravity center -extent 640x360 "$OUTPUT"
  echo "  ✓ $ID"
done

echo "--- Proceso completado ---"
