# Guía de Trabajo: Claude CLI en Omarchy

Esta guía detalla el modelo de trabajo para desarrollar y mantener los dotfiles de Omarchy sobre [CachyOS](https://cachyos.org/), utilizando herramientas de IA para la gestión del repositorio.

## Modelo del Repositorio

El repositorio tiene como raíz el propio `~/.config`. Solo las rutas permitidas en `.gitignore` se versionan. No se utiliza GNU Stow.

### Estructura de Componentes
```
~/.config/
├── alacritty/       Configuración de terminal
├── hypr/            Hyprland y overrides `*.local.lua` (ignorados)
├── omarchy/         Shell Quickshell y extensión del menú
├── scripts/         Helpers de música y wallpapers
├── starship.toml    Prompt
└── home/            Archivos enlazados fuera de ~/.config
```

`home/.bashrc`, `home/.gitconfig` y `home/.opencode/` se enlazan mediante `./install.sh`. Archivos como claves SSH, `known_hosts` y `~/.local/state/` nunca se versionan.

## Flujo de Trabajo Operativo

```bash
cd ~/.config
git status --short --branch
git pull --ff-only
./install.sh                 # Actualiza enlaces fuera de ~/.config
```

Para validar cambios antes de aplicar:

```bash
# Validación de scripts (Bash y Python)
for f in install.sh uninstall.sh scripts/*; do
  [[ "$f" == scripts/player-volume.sh ]] && { python3 -c "import ast,sys;ast.parse(open(sys.argv[1]).read())" "$f"; continue; }
  bash -n "$f" || echo "FALLA: $f"
done
```

## Hyprland y Omarchy

- **Hyprland**: La entrada es `hypr/hyprland.lua`. Carga el bootstrap, módulos comunes y finalmente los overrides locales (`monitors.local.lua`, `bindings.local.lua`, `autostart.local.lua`). 
  - Validaciones: `hyprctl monitors all`, `hyprctl configerrors`, `hyprctl reload`.
- **Omarchy**: Configura el shell en `omarchy/shell.json`. Reinicia con `omarchy restart shell`.
- **Wallpapers**: Estado en `~/.local/state/omarchy/current/`. Configurar `WALLPAPER_ENGINE_STEAM_LIBRARY` si es necesario.

## Reglas de Oro

1. No ejecutes `stow`.
2. No muevas el repositorio a `~/dotfiles`.
3. No copies todo el contenido de `~/.config` al repositorio.
4. Si migras, crea backups fechados antes de reemplazar configuraciones existentes.
5. Edita directamente los archivos gestionados.
