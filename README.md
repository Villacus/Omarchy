# ~/.config — Villacus

Configuración personal de escritorio Linux con **Omarchy** sobre **Hyprland** (Wayland) en **CachyOS**.

El repositorio tiene como raíz el propio `~/.config`. Solo los archivos descritos abajo están versionados; el resto de `~/.config` permanece local y no se incorpora al repositorio.

## Instalación o migración

```bash
# Clonar directamente en ~/.config (si ~/.config aún no es el repositorio)
git clone <tu-repo-url> ~/.config
cd ~/.config

# Enlazar únicamente los archivos que viven fuera de ~/.config
./install.sh
```

El instalador no usa GNU Stow y crea backups fechados antes de reemplazar `~/.bashrc`, `~/.gitconfig` o `~/.opencode`. Los archivos dentro de `~/.config` se editan directamente en el repositorio.

Para retirar los enlaces externos sin tocar configuraciones locales, ejecuta `./uninstall.sh` y confirma la operación.

## Estructura gestionada

| Ruta | Contenido |
|---|---|
| `hypr/` | Configuración común de Hyprland en Lua y overrides locales ignorados |
| `omarchy/` | Barra Quickshell y extensión del menú |
| `scripts/` | Scripts de música, fondos y Wallpaper Engine |
| `alacritty/`, `btop/`, `fastfetch/` | Configuración de terminal, monitor y system info |
| `starship.toml` | Prompt |
| `home/` | Archivos que deben enlazarse fuera de `~/.config` |

Las carpetas no incluidas en el allowlist de `.gitignore` (navegadores, GTK, Fish, KDE, dconf, estado de Omarchy, backups, etc.) permanecen sin seguimiento.

## Diferencias entre máquinas

Ambos equipos usan la rama `main`. No se versionan salidas de monitor ni bindings de programas opcionales.

En cada equipo, crea los overrides locales a partir de los ejemplos:

```bash
cp hypr/monitors.local.lua.example hypr/monitors.local.lua
cp hypr/bindings.local.lua.example hypr/bindings.local.lua
cp hypr/autostart.local.lua.example hypr/autostart.local.lua
```

Edita `monitors.local.lua` con los nombres que muestre `hyprctl monitors all`. Estos archivos están ignorados por Git y se cargan después de la configuración común. Si no necesitas un override, no lo crees.

## Wallpapers

El selector personalizado está en `scripts/omarchy-background-selector`. El estado dinámico se guarda fuera del repositorio, en `~/.local/state/omarchy/current/`. Wallpaper Engine es opcional y no se inicia desde la configuración común.

Para usarlo, configura la biblioteca mediante `WALLPAPER_ENGINE_STEAM_LIBRARY` si no está en `/mnt/Games/SteamLibrary`, y activa explícitamente el autostart local solo después de comprobar que `linux-wallpaperengine`, `hyprctl`, `jq` y los assets están disponibles.

## Validación y mantenimiento

```bash
# Sintaxis de scripts
for f in install.sh uninstall.sh scripts/*; do
  [[ "$f" == scripts/player-volume.sh ]] && { python3 -c "import ast,sys;ast.parse(open(sys.argv[1]).read())" "$f"; continue; }
  bash -n "$f"
done

# Estado de Git y entorno
git status --short --branch
hyprctl configerrors
hyprctl reload
omarchy restart shell
```

No se versionan claves privadas, `known_hosts`, secretos, `docker-compose.yml` local, perfiles de navegador ni archivos bajo `~/.local/state`.
