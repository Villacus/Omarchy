# AGENTS - Configuración de villacus

## Sistema

- **SO**: CachyOS (Arch Linux)
- **WM**: Hyprland (Wayland)
- **Shell**: bash
- **Repo**: `~/.config` es la raíz del repositorio de dotfiles (allowlist en `.gitignore`)
- **Omarchy**: framework de gestión de configuración de escritorio Linux
- **Monitores**: no se versionan; cada equipo los define en `~/.config/hypr/monitors.local.lua` (ver `hyprctl monitors all`)

## Reglas de edición

- **NO editar nada en `~/.local/share/omarchy/`** — es el código base de omarchy, se sobreescribe con cada actualización. Cualquier cambio ahí se pierde.
- **Omarchy lee de `~/.config/`** — las configs activas están en `~/.config/omarchy/`, `~/.config/hypr/`, etc. Ahí es donde se sobreescriben y personalizan las cosas.
- Los scripts personalizados viven en `~/.config/scripts/` y el repositorio tiene raíz en `~/.config`.
- Los comandos del sistema (`omarchy-*`) se ejecutan desde `~/.local/share/omarchy/bin/` — no tocarlos.
- Si hay que modificar el comportamiento de un comando omarchy, crear un wrapper en `~/.config/scripts/` o editar los archivos de configuración correspondientes en `~/.config/`.
- **En caso de duda, consultar el repo de omarchy (`https://github.com/basecamp/omarchy`) o su web `https://omarchy.org`** — no asumir rutas, flags o comportamientos.
- **Omarchy usa Lua en vez de conf para hyprland**: `hyprland.lua`, `looknfeel.lua`, etc. con `hl.config({...})` y `hl.env("VAR","value")`.
- **No borrar branches ni commits sin permiso del usuario**.

### Cómo extender omarchy sin tocar /bin

- `~/.config/omarchy/extensions/menu.sh` es **sourced por `omarchy-menu`** al final del script. Ahí se pueden redefinir funciones del menú (como `show_background_menu()`) para cambiar su comportamiento sin editar `/bin`.
- El menú usa `omarchy-theme-bg-switcher` para backgrounds. Se override `show_background_menu()` en `menu.sh` para llamar al selector propio, y `omarchy/extensions/omarchy-menu.jsonc` fija la misma ruta en el `action` de `style.background`. Ambos resuelven la ruta con `${XDG_CONFIG_HOME:-$HOME/.config}/scripts/omarchy-background-selector`; las acciones del menú se ejecutan con `bash -lc`, así que la expansión funciona.
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
| `~/.local/state/omarchy/current/` | Estado activo de Omarchy (symlinks y configs) |
| `~/.local/state/omarchy/current/wallpapers.conf` | Asignación de wallpapers por monitor para restaurar al encender |
| `~/.local/state/omarchy/current/background` | Symlink al wallpaper activo (usado por hyprlock) |
| `~/.config/omarchy/backgrounds/` | Fondos de usuario (theme-agnostic y por tema) |
| `~/.config/omarchy/extensions/menu.sh` | Sourced por omarchy-menu, permite override de funciones |
| `~/.local/state/omarchy/toggles/hyprlock.conf` | Toggles dinámicos de omarchy para hyprlock (CREA input-field duplicado) |
| `~/.config/scripts/` | Scripts personalizados del usuario |
| `~/.config/omarchy/shell.json` | Configuración de la barra Quickshell de Omarchy |
| `~/.config/walker/` | Lanzador de aplicaciones |
| `~/.local/share/icons/` | Iconos y cursores instalados manualmente |

## Sistema de wallpapers

### Gestión

- **Estáticos**: `omarchy-theme-bg-set <ruta>` — los renderiza el shell de Omarchy y guarda el symlink en `~/.local/state/omarchy/current/background`
- **Animados (Wallpaper Engine)**: `omarchy-wallpaper-engine <ID> [MONITOR]` — usa `linux-wallpaperengine`, guarda PID por monitor
- **Selector interactivo**: `omarchy-background-selector` — menú para elegir wallpaper y asignarlo a un monitor

### Archivos en `~/.config/scripts/`

| Script | Función |
|---|---|
| `restore-wallpapers` | Restaura todos los wallpapers al iniciar Hyprland (lee wallpapers.conf) |
| `omarchy-background-selector` | Selector interactivo de wallpaper por monitor. Busca en: current/theme/backgrounds, backgrounds/$theme_name, backgrounds/wallpaper-engine |
| `omarchy-wallpaper-engine` | Ejecuta `linux-wallpaperengine` para un wallpaper animado. También actualiza current/background → preview para lockscreen |
| `set-wallpaper-engine` | Wrapper con logging |
| `setup-wallpaper-engine-previews.sh` | Genera screenshots 1920x1080 de todos los wallpapers del taller usando `--screenshot` |

### Persistencia al encender

- Cada vez que se selecciona un wallpaper, se guarda en `wallpapers.conf` con formato `MONITOR:TIPO:VALOR`.
- La restauración al arrancar es opt-in: la configuración común no la lanza. Para activarla, copia el ejemplo a `~/.config/hypr/autostart.local.lua` (ignorado por Git) y descomenta la línea de `restore-wallpapers`, solo en el equipo que tenga `linux-wallpaperengine`, `hyprctl`, `jq` y los assets.
- `restore-wallpapers` lee `wallpapers.conf` y aplica cada entrada en su monitor; si un wallpaper no está disponible cae al fondo del tema.

### Wallpaper Engine

- **Workshop path**: `/mnt/Games/SteamLibrary/steamapps/workshop/content/431960/`
- **Assets dir**: `/mnt/Games/SteamLibrary/steamapps/common/wallpaper_engine/assets/`
- **Previews**: `~/.config/omarchy/backgrounds/wallpaper-engine/` (todos a 1920x1080)
- **Regenerar**: `bash ~/.config/scripts/setup-wallpaper-engine-previews.sh`
- Captura uno por uno con `--screenshot` (sin UI/waybar visible) + `magick -resize 1920x1080!` para forzar resolución exacta sin bordes negros.
- Los que crashean el engine (scripts rotos, errores JS/JSON) usan fallback del preview original del taller (`$carpeta/preview.png/jpg/jpeg/webp/gif`).
- El engine está compilado solo para Wayland (`-DENABLE_X11=OFF`). No se puede renderizar en Xvfb.
- El flag `--screenshot` tiene el bug de `Failed to initialize GLEW: No GLX display` pero igual genera el archivo (no bloqueante). Se resuelve con `-resize 1920x1080!`.
- **IMPORTANTE**: las previews se movieron de `themes/wallpaper-engine/backgrounds/` a `backgrounds/wallpaper-engine/` para que wallpaper-engine no aparezca como tema en omarchy.

### Lockscreen (hyprlock)

- Config en `~/.config/hypr/hyprlock.conf` (no tocar `~/.local/share/omarchy/config/hypr/hyprlock.conf`).
- Soursea colores del tema desde `~/.local/state/omarchy/current/theme/hyprlock.conf`.
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

## Aprendizajes técnicos (CLIAMP / WAYBAR / VOLUMEN)

### MPRIS Volume vs cliamp IPC
- cliamp mapea dB a MPRIS Volume mediante `dbToLinear`/`linearToDb`: -30dB → 0.0, +6dB → 1.0.
- **MPRIS Volume NO puede bajar de -30dB** — valores menores se clampa a 0.
- Para controlar el rango completo (-50dB a +6dB) usar `cliamp volume <dB>` (IPC por socket Unix).
- `cliamp status --json` devuelve `"volume": <dB>`, pero **omite el campo** cuando vale 0 dB.
- El IPC y MPRIS convergen al mismo estado interno: cambios por IPC actualizan MPRIS Volume y viceversa.
- `wpctl set-volume` controla el volumen del stream de PipeWire, NO el volumen interno de la app. Cambiar uno sin el otro desincroniza.

### Scroll en controles de la barra
- Los controles de Quickshell y los scripts asociados deben mantener pasos de volumen uniformes.
- Para pasos perceptualmente uniformes, usar factor multiplicativo: paso en dB = `20*log10(factor)`. Factor 1.10 → 0.83 dB/scroll.

Los apuntes históricos de CLIAMP y Waybar se conservan solo como referencia; Waybar ya no es la barra activa.

### git history management
- Para limpiar commits de prueba/error: `git reset --soft <base-commit> && git commit -m "mensaje"` aplasta todo el working tree en un solo commit.
- Si `git rebase -i` se cuelga (SIGTERM del editor): `git rebase --abort` y usar reset --soft en su lugar.

### omarchy restart shell
- `omarchy restart shell`.

## Los dos equipos

| Equipo | Rol | Acceso |
|---|---|---|
| `Portilla` | Portátil | local |
| `Omyilla` | Sobremesa | `ssh villacus@Omyilla` |

Ambos usan la rama `main`. El sobremesa tiene mucho más instalado: `cliamp`,
`hyprsunset`, `linux-wallpaperengine`, `omarchy-we`, `code`, `steam`,
`discord`, `lazydocker`. En el portátil faltan y por eso las guardas de
binario (`o.cmd_present`, `command -v`) son obligatorias en todo lo versionado.

### Plugins del shell (solo en el sobremesa)

`~/.config/omarchy/plugins/` no se versiona (miles de archivos), pero
`omarchy/shell.json` **sí** los declara. Los 7 instalados en el sobremesa:

```
bobbynicholas.omaland                    io.github.ricky.whatsapp
io.github.dkgamer02ai.wallpaper-engine   io.github.sirjul1337.lock-explorer
io.github.dotnetemmanuel.vitals          mirador
wian47.removable-drives
```

- **Un `shell.json` compartido es seguro.** Si un id de plugin o de widget no
  está instalado, `Bar.qml` deja `registryComponent` en `null` y simplemente no
  dibuja nada; no hay error. Verificado en vivo en el portátil con 0 plugins.
- `plugins[].design = "island"` es la clave que activa
  `omarchy/lock-designs/Island.qml` mediante `lock-explorer`.
- `mirador` da la vista general de workspaces; se invoca desde `bindings.lua`
  con `omarchy-shell shell toggle mirador '{}'`.
- `omaland` inyecta un bloque gestionado con vallas (`omaland managed block`)
  dentro de `hypr/looknfeel.lua`. No editar dentro de las vallas.

### Trampa: plugins que escriben en archivos versionados

El plugin `omarchy-we` añade `o.launch_on_start("omarchy-we launch")` al
archivo **versionado** `hypr/autostart.lua`, sin guarda de binario. Eso rompe
el portátil y ensucia el árbol. Al detectarlo: `git checkout -- hypr/autostart.lua`
y dejar lo específico del equipo en `hypr/autostart.local.lua` (ignorado).
Lo mismo con `omarchy-menu.jsonc`, aunque ahí su entrada sí lleva `when`, así
que es inofensiva y se puede commitear.

**Un solo restaurador de wallpapers al arrancar.** `scripts/restore-wallpapers`
y `omarchy-we launch` hacen lo mismo y se pelean por los monitores. En el
sobremesa se conserva únicamente `restore-wallpapers` en `autostart.local.lua`.

### hyprctl por SSH

`hyprctl` no encuentra la sesión sin estas dos variables:

```bash
export XDG_RUNTIME_DIR="/run/user/$(id -u)"
export HYPRLAND_INSTANCE_SIGNATURE="$(ls -t "$XDG_RUNTIME_DIR/hypr" | head -1)"
```

`hyprctl binds -j` devuelve las teclas en mayúsculas (`TAB`, no `Tab`) y como
`dispatcher: "__lua"` con un índice en `arg` cuando el bind viene de `o.bind`,
así que no se puede buscar el comando por texto en la salida.

### Rama de rescate

En el sobremesa, `rescate/escritorio-20260820` (commit `7d18432`) guarda su
configuración anterior al reset que borró la de plugins. No borrarla sin
permiso.

## Regla final para agentes
- **Si aprendes algo nuevo sobre el sistema del usuario** (rutas, configs, bugs, workarounds, comportamiento de programas), **documéntalo aquí inmediatamente**. No esperes a que te lo pidan. Esto asegura que el conocimiento persista entre sesiones.
