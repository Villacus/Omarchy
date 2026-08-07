# ~/dotfiles — Villacus

Configuración personal de escritorio Linux con **Omarchy** sobre **Hyprland** (Wayland) en **CachyOS** (Arch Linux).

## Estructura

| Directorio | Contenido |
|---|---|
| `bash/` | `.bashrc` — alias, PATH, fastfetch |
| `git/` | `.gitconfig` — user, alias `tree`, LFS |
| `hypr/` | Configuración de Hyprland en Lua (monitores, bindings, input, looknfeel, autostart, hyprlock, hypridle, hyprsunset) |
| `waybar/` | Barra de estado modular con tema Material You (13 módulos, 6 archivos CSS de tokens) |
| `scripts/` | Scripts personalizados: gestor de wallpapers, control de música (CLIAMP/MPRIS), wallpaper-engine |
| `omarchy-extensions/` | Extensión del menú de Omarchy para selector de wallpapers multi-monitor |
| `opencode/` | Configuración de OpenCode AI (`AGENTS.md` con documentación del sistema) |

## Hardware

- **Monitor izquierdo**: Philips 200V4 — DP-3, 1600x900@60
- **Monitor derecho**: ASUS VG249Q3R — DP-2, 1920x1080@180
- **Auriculares**: G435

## Atajos destacados

| Tecla | Acción |
|---|---|
| `Super + Return` | Terminal |
| `Super + Shift + B` | Navegador |
| `Super + Shift + O` | Obsidian |
| `Super + Shift + V` | VSCode |
| `Super + Shift + H` | Steam |
| `Super + Shift + I` | Discord |
| `Super + Shift + S` | Captura de pantalla |
| `Super + Alt + A` | Cambiar salida de audio |

## Wallpapers

Soporta fondos estáticos (`swaybg`) y animados (Wallpaper Engine vía `linux-wallpaperengine`) con persistencia por monitor. El selector interactivo se lanza desde el menú de Omarchy.

### Arquitectura

```
~/dotfiles/scripts/.config/scripts/   (symlinkeado en ~/.config/scripts/)
├── restore-wallpapers                 # Se ejecuta al boot (autostart.lua): restaura wallpapers.conf por monitor
├── set-wallpaper-engine               # Wrapper: loguea en we-debug.log y delega en omarchy-wallpaper-engine
├── omarchy-wallpaper-engine           # Script principal: lanza linux-wallpaperengine y guarda estado
├── omarchy-background-selector        # Selector interactivo: elige preview → elige monitor
└── setup-wallpaper-engine-previews.sh # Genera thumbnails wallpaper_<ID>.png desde el workshop
```

### Flujo

1. **Boot**: `~/.config/hypr/autostart.lua` lanza `~/.config/scripts/restore-wallpapers`.
2. `restore-wallpapers` lee `~/.config/omarchy/current/wallpapers.conf` (`<monitor>:<tipo>:<valor>`):
   - `static:` → `swaybg` con la imagen.
   - `wallpaper-engine:` → `set-wallpaper-engine <ID> <monitor>`.
3. `set-wallpaper-engine` loguea en `we-debug.log` y llama a `omarchy-wallpaper-engine`, que:
   - Lanza `linux-wallpaperengine` desde `/mnt/Games/SteamLibrary/steamapps/workshop/content/431960/<ID>`.
   - Guarda el PID por monitor en `current/wallpaper-engine-pids/<MONITOR>.pid`.
   - Actualiza `wallpapers.conf` y el symlink de lockscreen `current/background`.
4. El selector (`omarchy-background-selector`) permite asignar un fondo estático o de Wallpaper Engine a un monitor concreto.

### Estado persistente (en `~/.config/omarchy/current/`)

| Archivo | Contenido |
|---|---|
| `wallpapers.conf` | Asignación por monitor: `DP-2:static:.../Trio.jpg`, `DP-3:wallpaper-engine:1613667090` |
| `wallpaper-engine-pids/<MONITOR>.pid` | PID del engine por monitor |
| `wallpaper-engine.pid` | PID legacy (primer monitor) |
| `background` | Symlink usado por el lockscreen |
| `we-debug.log`, `restore-wallpapers.log` | Logs del engine y de la restauración |

Los previews de los wallpapers del workshop viven en `~/.config/omarchy/backgrounds/wallpaper-engine/wallpaper_<ID>.png`.

### Uso

```bash
# Poner un wallpaper animado del workshop en un monitor
~/.config/scripts/set-wallpaper-engine <ID> <MONITOR>

# Regenerar los previews de todos los wallpapers del workshop
~/.config/scripts/setup-wallpaper-engine-previews.sh
```

### Ojo al cambiar de tema

`omarchy theme set` solo regenera `current/theme/` y `current/theme.name`; **no toca** `wallpapers.conf`, los PIDs, los scripts ni `backgrounds/wallpaper-engine/`. Por eso la configuración de Wallpaper Engine sobrevive al cambio de tema.

Matiz: las entradas `static:` de `wallpapers.conf` apuntan a `current/theme/backgrounds/<archivo>`, así que si el nuevo tema no tiene ese archivo, `restore-wallpapers` lo saltará con un error en el log. Las entradas `wallpaper-engine:` apuntan al workshop (`/mnt/Games/...`), así que siempre se restauran.

## Licencia

Configuración personal — uso bajo tu propio riesgo.
