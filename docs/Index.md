# Índice de Documentación de Dotfiles

Este directorio contiene la documentación técnica de la configuración personal de escritorio basada en **Omarchy** sobre **Hyprland** (Wayland) en [CachyOS](https://cachyos.org/), diseñada para ofrecer un entorno de desarrollo rápido, modular y conectado directamente con la gestión de infraestructura del homelab.

## Documentación General y Guías
- [[Claude|Claude.md]] — Guía operativa y modelo de trabajo con asistentes de inteligencia artificial en el repositorio.
- [[Readme|Readme.md]] — Resumen general de la arquitectura, estructura de archivos y flujo de instalación.

## Componentes de Entorno y Ventanas
- [[Nvim|Neovim (nvim)]] — Configuración avanzada basada en [LazyVim](https://www.lazyvim.org/).
- [[Hypr|Hyprland]] — Gestor de ventanas Wayland y su configuración modular en Lua ([Hyprland](https://hyprland.org/)).
- [[Tmux|Tmux]] — Multiplexor de terminal para sesiones persistentes y despliegues remotos ([Tmux](https://github.com/tmux/tmux)).
- [[Terminales|Terminales]] — Emuladores de terminal soportados (Alacritty, Kitty, Foot, Ghostty).
- [[Starship|Starship Prompt]] — Prompt rápido y minimalista ([Starship](https://starship.rs/)).

## Automatización y Utilidades
- [[Scripts|Scripts de utilidad]] — Conjunto de scripts en Bash y Python para control multimedia, fondos y validaciones.

## Conexión con Homelab
La configuración de los dotfiles está diseñada para operar de forma fluida con el entorno de servidor doméstico:
- [[Homelab/Despliegue|Despliegue de Servicios]] — Flujo de trabajo para contenedores Docker, túneles seguros mediante [Tailscale](https://tailscale.com/) y monitorización en la Raspberry Pi.
