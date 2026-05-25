# AGENTS - Configuración de villacus

## Reglas generales

- **NO editar scripts en `/home/villacus/.local/share/omarchy/bin/`** — son parte de omarchy y se actualizan con el sistema.
- Los scripts personalizados van en `~/.config/scripts/`.
- No modificar archivos de sistema ni de omarchy directamente.
- Los wallpapers estáticos los gestiona omarchy (`omarchy-theme-bg-set`). Los animated (Wallpaper Engine) tienen su propio sistema.

## Sistema de wallpapers

### Archivos clave en `~/.config/scripts/`

| Script | Función |
|---|---|
| `restore-wallpapers` | Restaura todos los wallpapers al iniciar Hyprland. Se lanza desde `~/.config/hypr/autostart.lua` |
| `omarchy-background-selector` | Selector interactivo de wallpaper por monitor (estático o wallpaper engine) |
| `omarchy-theme-bg-switcher` | Symlink a `omarchy-background-selector` |
| `omarchy-wallpaper-engine` | Ejecuta `linux-wallpaperengine` para un wallpaper animado en un monitor |
| `set-wallpaper-engine` | Wrapper de `omarchy-wallpaper-engine` con logging |
| `setup-wallpaper-engine-previews.sh` | Genera screenshots 1920x1080 de todos los wallpapers del taller para el selector |

### Persistencia al encender

- `~/.config/omarchy/current/wallpapers.conf` guarda las asignaciones por monitor con formato `MONITOR:TIPO:VALOR`.
- `restore-wallpapers` lee ese archivo al arranque y restaura cada wallpaper en su monitor.
- `autostart.lua` ejecuta `restore-wallpapers` al inicio de Hyprland.

### Wallpaper Engine

- Workshop path: `/mnt/Games/SteamLibrary/steamapps/workshop/content/431960/`
- Assets dir: `/mnt/Games/SteamLibrary/steamapps/common/wallpaper_engine/assets/`
- Previews generados en: `~/.config/omarchy/themes/wallpaper-engine/backgrounds/` (todos a 1920x1080)
- Para regenerar previews: `bash ~/.config/scripts/setup-wallpaper-engine-previews.sh`
- El script captura cada wallpaper uno por uno con `--window` + `grim`, mostrando ventanas en pantalla. Los que crashean el engine usan fallback del preview del taller.
- Algunos wallpapers del taller tienen scripts rotos (ReferenceError, SyntaxError) y no se pueden capturar; usan la preview original como fallback.

### Monitor config

Monitores definidos en `~/.config/hypr/monitors.lua`:
- DP-3 (izquierda): 1600x900@60 en 0x180
- DP-2 (derecha): 1920x1080@180 en 1600x0 (monitor principal para capturas)

### Autostart

`~/.config/hypr/autostart.lua`:
- `hyprsunset` — filtro de luz azul
- `~/.config/scripts/restore-wallpapers` — restaura wallpapers al iniciar
