# Configuración de Dotfiles (Omarchy)

Esta es la configuración personal de escritorio Linux basada en **Omarchy** sobre **Hyprland** (Wayland) en [CachyOS](https://cachyos.org/). El objetivo es mantener un entorno modular, minimalista y altamente reproducible.

## Arquitectura del Repositorio

El repositorio tiene como raíz el propio `~/.config`. A diferencia de otros enfoques, solo los archivos y carpetas permitidos explícitamente en el `.gitignore` son versionados; el resto de `~/.config` permanece local y no se incorpora al repositorio para evitar fugas de datos sensibles o configuraciones específicas de una aplicación.

### Estructura de Gestión

| Ruta | Componente | Descripción |
|---|---|---|
| `hypr/` | Hyprland | Configuración modular en Lua y overrides locales ignorados. |
| `omarchy/` | Quickshell | Barra de estado y extensiones del menú. |
| `scripts/` | Utilitarios | Scripts de música, fondos y gestión de Wallpaper Engine. |
| `alacritty/`, `btop/`, `fastfetch/` | Herramientas | Configuración de terminal, monitorización y system info. |
| `starship.toml` | Prompt | Configuración del shell prompt. |
| `home/` | Enlaces Externos | Archivos que deben enlazarse fuera de `~/.config` (ej. `.bashrc`). |

## Instalación y Migración

Para desplegar esta configuración en un nuevo sistema o migrar una instalación existente:

```bash
# Clonar directamente en ~/.config
git clone <tu-repo-url> ~/.config
cd ~/.config

# Ejecutar el instalador para crear enlaces simbólicos fuera de ~/.config
./install.sh
```

El instalador no utiliza GNU Stow. En su lugar, crea backups fechados antes de reemplazar archivos críticos como `~/.bashrc`, `~/.gitconfig` o `~/.opencode`.

Para revertir los cambios y retirar los enlaces externos, se puede ejecutar `./uninstall.sh`.

## Personalización por Equipo

Dado que se utilizan múltiples máquinas, se implementa un sistema de **overrides locales**. Los archivos `.local.lua` son ignorados por Git y permiten definir configuraciones específicas de hardware sin ensuciar el repositorio común.

**Pasos para configurar un nuevo equipo:**
1. Copiar los ejemplos de configuración local:
   ```bash
   cp hypr/monitors.local.lua.example hypr/monitors.local.lua
   cp hypr/bindings.local.lua.example hypr/bindings.local.lua
   cp hypr/autostart.local.lua.example hypr/autostart.lua
   ```
2. Definir los monitores utilizando la salida de `hyprctl monitors all`.

## Wallpapers y Personalización Visual

Se utiliza un selector personalizado ubicado en `scripts/omarchy-background-selector`. El estado dinámico se almacena en `~/.local/state/omarchy/current/`. 

**Wallpaper Engine** es opcional y requiere la configuración de la variable `WALLPAPER_ENGINE_STEAM_LIBRARY` (por defecto `/mnt/Games/SteamLibrary`). Solo debe activarse el autostart local después de verificar que `linux-wallpaperengine`, `hyprctl`, `jq` y los assets estén disponibles.

## Validación y Mantenimiento

Para asegurar que los cambios no rompan el sistema, se recomienda ejecutar el siguiente flujo de validación:

```bash
# 1. Validación de sintaxis de scripts (Bash y Python)
for f in install.sh uninstall.sh scripts/*; do
  [[ "$f" == scripts/player-volume.sh ]] && { python3 -c "import ast,sys;ast.parse(open(sys.argv[1]).read())" "$f"; continue; }
  bash -n "$f"
done

# 2. Comprobación de Hyprland y Omarchy
hyprctl configerrors
hyprctl reload
omarchy restart shell
```

## Seguridad y Exclusiones

No se versionan claves privadas, `known_hosts`, secretos, archivos `docker-compose.yml` locales, perfiles de navegador ni datos bajo `~/.local/state`.

## Conexión con Homelab

Este entorno de escritorio está optimizado para interactuar con la infraestructura del servidor doméstico. El flujo de despliegue de servicios y la conectividad segura se detallan en [[Homelab/Despliegue|Despliegue de Servicios]].
