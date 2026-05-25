# AGENTS - Configuración de villacus

## Sistema

- **SO**: CachyOS (Arch Linux)
- **WM**: Hyprland (Wayland)
- **Shell**: bash
- **Repo**: home directory entera (`/home/villacus/`)
- **Omarchy**: framework de gestión de configuración de escritorio Linux
- **Monitor principal**: DP-2 (1920x1080@180 en 1600x0)
- **Monitor secundario**: DP-3 (1600x900@60 en 0x180)

## Reglas de edición

- **NO editar nada en `~/.local/share/omarchy/`** — es el código base de omarchy, se sobreescribe con cada actualización. Cualquier cambio ahí se pierde.
- **Omarchy lee de `~/.config/`** — las configs activas están en `~/.config/omarchy/`, `~/.config/hypr/`, etc. Ahí es donde se sobreescriben y personalizan las cosas.
- Los scripts personalizados van en `~/.config/scripts/`.
- Los comandos del sistema (`omarchy-*`) se ejecutan desde `~/.local/share/omarchy/bin/` — no tocarlos.
- Si hay que modificar el comportamiento de un comando omarchy, crear un wrapper en `~/.config/scripts/` o editar los archivos de configuración correspondientes en `~/.config/`.

## Archivos de configuración clave

| Ruta | Propósito |
|---|---|
| `~/.config/hypr/hyprland.lua` | Config principal de Hyprland |
| `~/.config/hypr/monitors.lua` | Monitores, resoluciones, posiciones |
| `~/.config/hypr/autostart.lua` | Programas que se lanzan al iniciar |
| `~/.config/hypr/bindings.lua` | Keybindings |
| `~/.config/hypr/looknfeel.lua` | Apariencia (gaps, bordes, etc.) |
| `~/.config/omarchy/current/` | Tema activo actual (symlinks y configs) |
| `~/.config/omarchy/current/wallpapers.conf` | Asignación de wallpapers por monitor para restaurar al encender |
| `~/.config/scripts/` | Scripts personalizados del usuario |
| `~/.config/waybar/` | Barra de estado |
| `~/.config/walker/` | Lanzador de aplicaciones |

## Sistema de wallpapers

### Gestión

- **Estáticos**: `omarchy-theme-bg-set <ruta> [MONITOR]` — usa `swaybg`, guarda symlink en `~/.config/omarchy/current/background`
- **Animados (Wallpaper Engine)**: `omarchy-wallpaper-engine <ID> [MONITOR]` — usa `linux-wallpaperengine`, guarda PID por monitor
- **Selector interactivo**: `omarchy-background-selector` — menú para elegir wallpaper y asignarlo a un monitor

### Archivos en `~/.config/scripts/`

| Script | Función |
|---|---|
| `restore-wallpapers` | Restaura todos los wallpapers al iniciar Hyprland (lee wallpapers.conf) |
| `omarchy-background-selector` | Selector interactivo de wallpaper por monitor |
| `omarchy-theme-bg-switcher` | Symlink a `omarchy-background-selector` |
| `omarchy-wallpaper-engine` | Ejecuta `linux-wallpaperengine` para un wallpaper animado |
| `set-wallpaper-engine` | Wrapper con logging |
| `setup-wallpaper-engine-previews.sh` | Genera screenshots 1920x1080 de todos los wallpapers del taller |

### Persistencia al encender

- Cada vez que se selecciona un wallpaper, se guarda en `wallpapers.conf` con formato `MONITOR:TIPO:VALOR`.
- Al arrancar, `autostart.lua` ejecuta `~/.config/scripts/restore-wallpapers`, que lee el archivo y aplica cada wallpaper en su monitor.

### Wallpaper Engine

- **Workshop path**: `/mnt/Games/SteamLibrary/steamapps/workshop/content/431960/`
- **Assets dir**: `/mnt/Games/SteamLibrary/steamapps/common/wallpaper_engine/assets/`
- **Previews**: `~/.config/omarchy/themes/wallpaper-engine/backgrounds/` (todos a 1920x1080)
- **Regenerar**: `bash ~/.config/scripts/setup-wallpaper-engine-previews.sh`
- Captura uno por uno con `--window` + `grim`. Los que crashean el engine (scripts rotos) usan fallback del preview original del taller.
