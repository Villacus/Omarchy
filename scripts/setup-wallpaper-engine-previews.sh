#!/bin/bash

WALLPAPER_DIR="$HOME/.config/omarchy/backgrounds/wallpaper-engine"
STEAM_LIBRARY="${WALLPAPER_ENGINE_STEAM_LIBRARY:-/mnt/Games/SteamLibrary}"
WALLPAPER_PATH="$STEAM_LIBRARY/steamapps/workshop/content/431960"
ASSETS_DIR="$STEAM_LIBRARY/steamapps/common/wallpaper_engine/assets"

# Guardas de dependencias
for dep in linux-wallpaperengine magick awk; do
  if ! command -v "$dep" >/dev/null 2>&1; then
    echo "❌ $dep no está instalado; no se pueden generar previews"
    exit 1
  fi
done

mkdir -p "$WALLPAPER_DIR"

# Trap para no dejar el engine corriendo si se interrumpe el proceso
cleanup() {
  local pids
  pids=$(jobs -p)
  if [[ -n "$pids" ]]; then
    # shellcheck disable=SC2086  # se requiere word splitting para varios PIDs
    kill $pids 2>/dev/null
  fi
  return 0
}
trap cleanup EXIT INT TERM

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

# Conteo robusto mediante globbing
shopt -s nullglob
wallpapers=("$WALLPAPER_PATH"/*)
total=${#wallpapers[@]}
count=0
BLACK_THRESHOLD=5000

for carpeta in "${wallpapers[@]}"; do
  [[ -d "$carpeta" ]] || continue

  ID=$(basename "$carpeta")
  OUTPUT="$WALLPAPER_DIR/wallpaper_$ID.png"

  [[ -f "$OUTPUT" ]] && echo "✓ $ID (ya existe)" && continue

  count=$((count + 1))
  echo "[$count/$total] Capturando $ID..."

  linux-wallpaperengine \
    --assets-dir "$ASSETS_DIR" \
    --screenshot "$OUTPUT" \
    --silent --fps 30 --disable-particles --disable-mouse \
    "$carpeta" &>/dev/null &
  WPE_PID=$!

  for i in $(seq 15); do
    if [[ -f "$OUTPUT" ]] && [[ -s "$OUTPUT" ]]; then
      break
    fi
    sleep 1
  done

  if [[ -f "$OUTPUT" ]] && [[ -s "$OUTPUT" ]]; then
    magick "$OUTPUT" -resize 1920x1080! "$OUTPUT"
    mean=$(magick identify -format '%[mean]' "$OUTPUT" 2>/dev/null || echo 0)
    if awk -v mean="$mean" -v threshold="$BLACK_THRESHOLD" 'BEGIN { exit !(mean >= threshold) }'; then
      echo "  ✓ $ID (1920x1080)"
      kill $WPE_PID 2>/dev/null
      wait $WPE_PID 2>/dev/null
      sleep 1
      continue
    fi
    rm -f "$OUTPUT"
  fi

  # Fallback: preview del taller si el engine crashea
  kill $WPE_PID 2>/dev/null
  wait $WPE_PID 2>/dev/null

  src=""
  # Se añade webp a las extensiones de reserva
  for ext in png jpg jpeg webp; do
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
    if [[ $src == *.gif ]]; then
      frame=$(magick "$src" -coalesce -format '%[mean] %p\n' info: | sort -nr | head -1 | awk '{print $2}')
      [[ -n "$frame" ]] || frame=0
      magick "$src[$frame]" -resize 1920x1080! "$OUTPUT"
    else
      magick "$src" -resize 1920x1080! "$OUTPUT"
    fi
  else
    echo "  ✗ $ID (sin preview disponible)"
  fi
  sleep 1
done

echo "--- Proceso completado ($count capturas) ---"
