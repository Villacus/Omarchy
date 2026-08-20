# CLAUDE.md

Guía para trabajar en este repositorio de dotfiles de Omarchy sobre CachyOS.

## Modelo del repositorio

El repositorio tiene como raíz el propio `~/.config`. Solo las rutas permitidas en `.gitignore` se versionan; el resto de `~/.config` pertenece a la máquina y permanece local. No se usa GNU Stow.

```
~/.config/
├── alacritty/       configuración de terminal
├── btop/            monitor de sistema
├── fastfetch/       información del sistema
├── hypr/            Hyprland y overrides `*.local.lua` ignorados
├── omarchy/         shell Quickshell y extensión del menú
├── scripts/         helpers de música y wallpapers
├── starship.toml    prompt
└── home/            archivos enlazados fuera de ~/.config
```

`home/.bashrc`, `home/.gitconfig` y `home/.opencode/` se enlazan con `install.sh`. La clave SSH privada, `known_hosts`, `mimeapps.list`, secretos, perfiles de navegador, backups y `~/.local/state/` nunca se gestionan aquí.

## Hyprland

La entrada es `hypr/hyprland.lua`. Carga el bootstrap y los módulos comunes de Omarchy, después los módulos de `hypr/`, y finalmente estos overrides locales si existen:

- `hypr/monitors.local.lua` — salidas, resolución y workspaces de cada equipo.
- `hypr/bindings.local.lua` — programas instalados solo en una máquina.
- `hypr/autostart.local.lua` — servicios opcionales.

Copia los ejemplos cuando sea necesario. Ambos equipos usan `main`; no uses `git update-index --skip-worktree` para ocultar hardware local.

Comprobaciones de Hyprland:

```bash
hyprctl monitors all
hyprctl configerrors
hyprctl reload
```

La configuración común no fija nombres de monitores. Los defaults de Omarchy siguen habilitados; `hypr/bindings.lua` deshace únicamente los bindings que realmente se rebindean.

## Omarchy y scripts

`omarchy/shell.json` configura el shell Quickshell y `omarchy/extensions/` contiene la extensión del menú. Reinicia el shell con `omarchy restart shell`.

Los scripts están en `scripts/`, que corresponde directamente a `~/.config/scripts/`. Sus rutas se calculan desde el propio script; no deben contener `/home/villacus` ni asumir que el repositorio vive en `~/dotfiles`.

Wallpaper Engine es opcional. Su estado permanece en `~/.local/state/omarchy/current/` y su biblioteca se configura con `WALLPAPER_ENGINE_STEAM_LIBRARY` (por defecto `/mnt/Games/SteamLibrary`). Solo activa `restore-wallpapers` desde un `autostart.local.lua` después de verificar `linux-wallpaperengine`, `hyprctl`, `jq` y los assets.

## Flujo de trabajo

```bash
cd ~/.config
git status --short --branch
git pull --ff-only
./install.sh                 # solo repara enlaces fuera de ~/.config
```

Edita directamente los archivos gestionados. Valida scripts antes de recargar. `bash -n a.sh b.sh` solo analiza el primer archivo, así que hay que recorrerlos uno a uno y tratar aparte el script de Python:

```bash
for f in install.sh uninstall.sh scripts/*; do
  [[ "$f" == scripts/player-volume.sh ]] && { python3 -c "import ast,sys;ast.parse(open(sys.argv[1]).read())" "$f"; continue; }
  bash -n "$f" || echo "FALLA: $f"
done
```

No ejecutes `stow`, no muevas el repositorio a `~/dotfiles` y no copies todo el contenido de `~/.config` al repositorio. Si se necesita una migración desde una instalación anterior, crea primero un backup fechado y conserva la copia de rollback hasta completar las comprobaciones.
