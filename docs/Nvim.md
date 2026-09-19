# Configuración de Neovim

Esta configuración define mi entorno de trabajo en Neovim, basada en [LazyVim](https://www.lazyvim.org/), una distribución altamente extensible y modular, adaptada específicamente para las necesidades de mi sistema (Omarchy).

## Estructura
La configuración sigue una estructura modular para facilitar el mantenimiento y la extensibilidad:

- `init.lua`: Punto de entrada principal que carga el núcleo de LazyVim.
- `lua/config/`: Contiene la configuración base, incluyendo opciones (`options.lua`), mapas de teclado (`keymaps.lua`), comandos automáticos (`autocmds.lua`) y la integración del portapapeles remoto.
- `lua/plugins/`: Directorio donde se definen los plugins personalizados y la configuración de temas.

## Gestión de Plugins
Esta configuración utiliza `lazy.lua` para la gestión de plugins. Los *overrides* y temas se recargan automáticamente aprovechando los *hooks* personalizados de Omarchy, permitiendo una experiencia de desarrollo fluida.

## Recursos
- [Documentación oficial de LazyVim](https://www.lazyvim.org/)
