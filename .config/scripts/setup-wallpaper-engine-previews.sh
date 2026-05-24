#!/bin/bash

WALLPAPER_DIR="$HOME/.config/omarchy/themes/wallpaper-engine/backgrounds"
WALLPAPER_PATH="/mnt/Games/SteamLibrary/steamapps/workshop/content/431960"
ASSETS_DIR="/mnt/Games/SteamLibrary/steamapps/common/wallpaper_engine/assets"

mkdir -p "$WALLPAPER_DIR"

# Limpiar previews de wallpapers que ya no existen en el taller
echo "Limpiando previews obsoletas..."
for preview in "$WALLPAPER_DIR"/wallpaper_*.png; do
  [[ -f "$preview" ]] || continue
  id=$(basename "$preview" | sed 's/^wallpaper_//;s/\.png$//')
  if [[ ! -d "$WALLPAPER_PATH/$id" ]]; then
    rm -f "$preview"
    echo "  ✀ eliminado wallpaper_$id.png (ya no existe en el taller)"
  fi
done

# Iniciar Xvfb compartido
XVFB_DISPLAY=":44"
Xvfb "$XVFB_DISPLAY" -screen 0 1920x1080x24 +extension GLX &>/dev/null &
XVFB_PID=$!
sleep 1

MAX_JOBS=2
count=0

for carpeta in "$WALLPAPER_PATH"/*; do
  if [[ ! -d $carpeta ]]; then
    continue
  fi

  ID=$(basename "$carpeta")
  OUTPUT="$WALLPAPER_DIR/wallpaper_$ID.png"

  [[ -f "$OUTPUT" ]] && echo "✓ $ID (ya existe)" && continue

  (
    echo "Capturando $ID..."

    DISPLAY="$XVFB_DISPLAY" linux-wallpaperengine \
      --assets-dir "$ASSETS_DIR" \
      --screenshot "$OUTPUT" \
      --screenshot-delay 20 \
      --silent \
      --fps 30 \
      --disable-particles \
      --disable-mouse \
      "$carpeta" &>/dev/null &
    WPE_PID=$!

    # Esperar a que aparezca el screenshot o timeout (45s)
    for i in $(seq 45); do
      if [[ -f "$OUTPUT" ]]; then
        break
      fi
      sleep 1
    done

    kill $WPE_PID 2>/dev/null
    wait $WPE_PID 2>/dev/null

    if [[ -f "$OUTPUT" ]]; then
      # Redimensionar a 640x360 manteniendo aspect ratio con relleno negro
      magick "$OUTPUT" -resize 640x360 -background black -gravity center -extent 640x360 "$OUTPUT"
      echo "  ✓ $ID"
    else
      echo "  ✗ $ID (error)"
    fi
  ) &

  count=$((count + 1))
  if [[ $count -ge $MAX_JOBS ]]; then
    wait -n
    count=$((count - 1))
  fi
done

wait
kill $XVFB_PID 2>/dev/null
wait $XVFB_PID 2>/dev/null
echo "--- Proceso completado ---"


