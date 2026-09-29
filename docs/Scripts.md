# Scripts de Utilidad y Automatización

El directorio `~/.config/scripts/` agrupa los scripts auxiliares encargados de la automatización del entorno en [[Hypr|Hyprland]] y [[200 - Dotfiles/Readme|Omarchy]].

## Funciones Principales

- **Control Multimedia**: Gestión de volumen (`player-volume.sh`) y reproductores multimedia.
- **Gestión de Fondos**: Selector personalizado de fondos de pantalla (`omarchy-background-selector`) con integración opcional para Wallpaper Engine.
- **Validación del Sistema**: Scripts de verificación de estado y sintaxis.

## Validación y Pruebas

Para garantizar que los scripts no contengan errores de sintaxis antes de recargar el entorno, se emplea el siguiente bucle de validación (soportando Bash y Python según corresponda):

```bash
for f in install.sh uninstall.sh scripts/*; do
  [[ "$f" == scripts/player-volume.sh ]] && { python3 -c "import ast,sys;ast.parse(open(sys.argv[1]).read())" "$f"; continue; }
  bash -n "$f" || echo "FALLA: $f"
done
```

Estos scripts calculan sus rutas de forma relativa a su ubicación, por lo que no dependen de rutas absolutas del usuario como `/home/villacus`.
