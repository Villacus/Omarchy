# Hyprland en Omarchy

Gestor de ventanas basado en [Hyprland](https://hyprland.org/), configurado de forma modular mediante Lua en un entorno [CachyOS](https://cachyos.org/).

## Arquitectura de la Configuración

La configuración se basa en un núcleo común que se extiende mediante módulos y configuraciones locales específicas para cada máquina, evitando así la necesidad de ramas diferentes.

- `hypr/hyprland.lua` — Archivo raíz: carga el bootstrap y los módulos comunes.
- `hypr/monitors.lua` — Gestión de salidas y resoluciones.
- `hypr/bindings.lua` — Definición de atajos de teclado.
- `hypr/autostart.lua` — Servicios y aplicaciones de inicio.

### Overrides Locales (Ignorados por Git)
Para soportar distintas configuraciones de hardware sin conflictos en el repositorio, se utilizan archivos `.local.lua` que se cargan al final de la configuración común:
- `hypr/monitors.local.lua` — Salidas, resoluciones y workspaces específicos por equipo.
- `hypr/bindings.local.lua` — Programas instalados o atajos específicos por máquina.
- `hypr/autostart.local.lua` — Servicios locales opcionales.

## Comprobaciones y Mantenimiento

Para verificar la integridad de la configuración y aplicar cambios:

```bash
# Listar monitores detectados
hyprctl monitors all

# Validar errores en la configuración
hyprctl configerrors

# Recargar configuración en caliente
hyprctl reload
```

## Relaciones
Esta configuración interactúa con [[Terminales|Terminales]], [[Scripts|Scripts de utilidad]] y el entorno [[Claude|Claude.md]] para la automatización de la configuración.
