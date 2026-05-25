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
- **En caso de duda, consultar el repo de omarchy (`https://github.com/basecamp/omarchy`) o su web `https://omarchy.org`** — no asumir rutas, flags o comportamientos.
- **Omarchy usa Lua en vez de conf para hyprland**: `hyprland.lua`, `looknfeel.lua`, etc. con `hl.config({...})` y `hl.env("VAR","value")`.
- **No borrar branches ni commits sin permiso del usuario**.

### Cómo extender omarchy sin tocar /bin

- `~/.config/omarchy/extensions/menu.sh` es **sourced por `omarchy-menu`** al final del script. Ahí se pueden redefinir funciones del menú (como `show_background_menu()`) para cambiar su comportamiento sin editar `/bin`.
- El menú usa `omarchy-theme-bg-switcher` para backgrounds. Se overrideo `show_background_menu()` para llamar a `~/.config/scripts/omarchy-background-selector` en vez del original.
- El PATH de omarchy se define en `~/.config/uwsm/env`: `export PATH=$OMARCHY_PATH/bin:$PATH:$HOME/.local/bin`. Para que scripts de `~/.config/scripts/` tengan prioridad, habría que ponerlos antes que omarchy/bin en el PATH.
- Los comandos `omarchy-*` se resuelven desde `~/.local/share/omarchy/bin/` primero por el PATH. Para reemplazar uno, crear wrapper con el mismo nombre en `~/.config/scripts/` y poner ese directorio antes en el PATH.

## Archivos de configuración clave

| Ruta | Propósito |
|---|---|
| `~/.config/hypr/hyprland.lua` | Config principal de Hyprland |
| `~/.config/hypr/monitors.lua` | Monitores, resoluciones, posiciones |
| `~/.config/hypr/autostart.lua` | Programas que se lanzan al iniciar |
| `~/.config/hypr/bindings.lua` | Keybindings |
| `~/.config/hypr/looknfeel.lua` | Apariencia (gaps, bordes, env vars) |
| `~/.config/hypr/hyprlock.conf` | Pantalla de bloqueo (input field, blur, fondo) |
| `~/.config/hypr/hypridle.conf` | Tiempos de inactividad (screensaver, lock, apagado pantalla) |
| `~/.config/omarchy/current/` | Tema activo actual (symlinks y configs) |
| `~/.config/omarchy/current/wallpapers.conf` | Asignación de wallpapers por monitor para restaurar al encender |
| `~/.config/omarchy/current/background` | Symlink al wallpaper activo (usado por hyprlock) |
| `~/.config/omarchy/backgrounds/` | Fondos de usuario (theme-agnostic y por tema) |
| `~/.config/omarchy/extensions/menu.sh` | Sourced por omarchy-menu, permite override de funciones |
| `~/.local/state/omarchy/toggles/hyprlock.conf` | Toggles dinámicos de omarchy para hyprlock (CREA input-field duplicado) |
| `~/.config/scripts/` | Scripts personalizados del usuario |
| `~/.config/waybar/` | Barra de estado |
| `~/.config/walker/` | Lanzador de aplicaciones |
| `~/.local/share/icons/` | Iconos y cursores instalados manualmente |

## Sistema de wallpapers

### Gestión

- **Estáticos**: `omarchy-theme-bg-set <ruta> [MONITOR]` — usa `swaybg`, guarda symlink en `~/.config/omarchy/current/background`
- **Animados (Wallpaper Engine)**: `omarchy-wallpaper-engine <ID> [MONITOR]` — usa `linux-wallpaperengine`, guarda PID por monitor
- **Selector interactivo**: `omarchy-background-selector` — menú para elegir wallpaper y asignarlo a un monitor

### Archivos en `~/.config/scripts/`

| Script | Función |
|---|---|
| `restore-wallpapers` | Restaura todos los wallpapers al iniciar Hyprland (lee wallpapers.conf) |
| `omarchy-background-selector` | Selector interactivo de wallpaper por monitor. Busca en: current/theme/backgrounds, backgrounds/$theme_name, backgrounds/wallpaper-engine |
| `omarchy-theme-bg-switcher` | Symlink a `omarchy-background-selector` |
| `omarchy-wallpaper-engine` | Ejecuta `linux-wallpaperengine` para un wallpaper animado. También actualiza current/background → preview para lockscreen |
| `set-wallpaper-engine` | Wrapper con logging |
| `setup-wallpaper-engine-previews.sh` | Genera screenshots 1920x1080 de todos los wallpapers del taller usando `--screenshot` |

### Persistencia al encender

- Cada vez que se selecciona un wallpaper, se guarda en `wallpapers.conf` con formato `MONITOR:TIPO:VALOR`.
- Al arrancar, `autostart.lua` ejecuta `~/.config/scripts/restore-wallpapers`, que lee el archivo y aplica cada wallpaper en su monitor.

### Wallpaper Engine

- **Workshop path**: `/mnt/Games/SteamLibrary/steamapps/workshop/content/431960/`
- **Assets dir**: `/mnt/Games/SteamLibrary/steamapps/common/wallpaper_engine/assets/`
- **Previews**: `~/.config/omarchy/backgrounds/wallpaper-engine/` (todos a 1920x000)
- **Regenerar**: `bash ~/.config/scripts/setup-wallpaper-engine-previews.sh`
- Captura uno por uno con `--screenshot` (sin UI/waybar visible) + `magick -resize 1920x1080!` para forzar resolución exacta sin bordes negros.
- Los que crashean el engine (scripts rotos, errores JS/JSON) usan fallback del preview original del taller (`$carpeta/preview.png/jpg/gif`).
- El engine está compilado solo para Wayland (`-DENABLE_X11=OFF`). No se puede renderizar en Xvfb.
- El flag `--screenshot` tiene el bug de `Failed to initialize GLEW: No GLX display` pero igual genera el archivo (no bloqueante). Se resuelve con `-resize 1920x1080!`.
- **IMPORTANTE**: las previews se movieron de `themes/wallpaper-engine/backgrounds/` a `backgrounds/wallpaper-engine/` para que wallpaper-engine no aparezca como tema en omarchy.

### Lockscreen (hyprlock)

- Config en `~/.config/hypr/hyprlock.conf` (no tocar `~/.local/share/omarchy/config/hypr/hyprlock.conf`).
- Soursea colores del tema desde `~/.config/omarchy/current/theme/hyprlock.conf`.
- **NO sourcear `~/.local/state/omarchy/toggles/hyprlock.conf`** porque crea un SEGUNDO bloque `input-field` con valores default (centro, 650x100, sin fade) que se superpone al personalizado.
- El toggle `omarchy-style-corners-hyprlock` escribe rounding en el toggles file, pero al no sourcearlo se pierde esa funcionalidad — poner `rounding = N` directamente en hyprlock.conf.
- `blur_passes` controla el desenfoque del fondo: 0 = sin blur, 3 = default omarchy.
- `fade_on_empty = true` oculta el input hasta escribir (puede no funcionar bien en v0.9.5).
- `valign = bottom` + `position = 0, -N` mueve el input hacia abajo.
- Para que al iniciar sesión pida contraseña: `o.launch_on_start("hyprlock")` en `autostart.lua`.

### Cursor theme

- Sweet Nova cursors instalados en `~/.local/share/icons/Sweet-cursors/` desde `https://github.com/EliverLara/Sweet/tree/nova/kde/cursors/Sweet-cursors`.
- Para activar: `hl.env("XCURSOR_THEME", "Sweet-cursors")` en `looknfeel.lua` y `gtk-cursor-theme-name=Sweet-cursors` en `gtk-3.0/settings.ini` y `gtk-4.0/settings.ini`.
- También `hyprctl setcursor Sweet-cursors 24` para aplicar al instante sin reiniciar.

### Persistencia del wallpaper en lockscreen

- `current/background` es un symlink que usa hyprlock para mostrar el fondo en pantalla de bloqueo.
- `omarchy-theme-bg-set` lo actualiza para wallpapers estáticos.
- `omarchy-wallpaper-engine` lo actualiza al preview correspondiente cuando se selecciona un wallpaper animado.
- `restore-wallpapers` también lo actualiza al restaurar (tanto estáticos como animados).
