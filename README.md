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
| `easyeffects/` | Pipeline de audio profesional: presets de entrada (filtro de voz con RNNoise + DeepFilterNet) y salida (EQs, convolución con IRS) |
| `omarchy-extensions/` | Extensión del menú de Omarchy para selector de wallpapers multi-monitor |
| `opencode/` | Configuración de OpenCode AI (`AGENTS.md` con documentación del sistema) |

## Hardware

- **Monitor izquierdo**: Philips 200V4 — DP-3, 1600x900@60
- **Monitor derecho**: ASUS VG249Q3R — DP-2, 1920x1080@180
- **Auriculares**: G435 (entrada/salida)
- **Micrófono**: FIFINE (con cadena de reducción de ruido)

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

## Licencia

Configuración personal — uso bajo tu propio riesgo.
