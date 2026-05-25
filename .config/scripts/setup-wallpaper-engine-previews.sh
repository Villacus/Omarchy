#!/bin/bash

WALLPAPER_DIR="$HOME/.config/omarchy/themes/wallpaper-engine/backgrounds"
WALLPAPER_PATH="/mnt/Games/SteamLibrary/steamapps/workshop/content/431960"
ASSETS_DIR="/mnt/Games/SteamLibrary/steamapps/common/wallpaper_engine/assets"

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

# Obtener geometria del monitor principal para la ventana
MON_DATA=$(hyprctl monitors -j | jq '.[0]')
MONITOR=$(jq -r '.name' <<<"$MON_DATA")
X=$(jq -r '.x' <<<"$MON_DATA")
Y=$(jq -r '.y' <<<"$MON_DATA")
W=$(jq -r '.width' <<<"$MON_DATA")
H=$(jq -r '.height' <<<"$MON_DATA")
GEO="${X}x${Y}x${W}x${H}"
echo "Usando monitor: $MONITOR (${W}x${H} en ${X},${Y})"

count=0
total=$(ls -d "$WALLPAPER_PATH"/*/ 2>/dev/null | wc -l)

for carpeta in "$WALLPAPER_PATH"/*; do
  [[ -d $carpeta ]] || continue

  ID=$(basename "$carpeta")
  OUTPUT="$WALLPAPER_DIR/wallpaper_$ID.png"

  [[ -f "$OUTPUT" ]] && echo "✓ $ID (ya existe)" && continue

  count=$((count + 1))
  echo "[$count/$total] Capturando $ID..."

  linux-wallpaperengine \
    --assets-dir "$ASSETS_DIR" \
    --window "$GEO" \
    --silent --fps 60 --disable-particles --disable-mouse \
    "$carpeta" &>/dev/null &
  WPE_PID=$!

  # Esperar a que renderice y capturar
  sleep 5
  if kill -0 "$WPE_PID" 2>/dev/null; then
    grim -g "${X},${Y} ${W}x${H}" "$OUTPUT"
    if [[ -f "$OUTPUT" ]]; then
      echo "  ✓ $ID (1920x1080)"
      kill $WPE_PID 2>/dev/null
      wait $WPE_PID 2>/dev/null
      sleep 1
      continue
    fi
  fi

  # Fallback: preview del taller si el engine crashea
  kill $WPE_PID 2>/dev/null
  wait $WPE_PID 2>/dev/null

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

  if [[ -n "$src" ]]; then
    echo "  ↻ $ID (fallback preview)"
    magick "$src"[0] -resize 1920x1080\> -background black -gravity center -extent 1920x1080 "$OUTPUT"
  else
    echo "  ✗ $ID (sin preview disponible)"
  fi
  sleep 1
done

echo "--- Proceso completado ($count capturas) ---"
