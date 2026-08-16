#!/usr/bin/env bash
# Comandos útiles de stow para dotfiles

# === INSTALACIÓN ===

# Instalar un paquete
cd ~ && stow -d dotfiles -t ~ hypr

# Instalar varios paquetes
cd ~ && stow -d dotfiles -t ~ hypr scripts omarchy omarchy-extensions
# Waybar fue retirado tras la migración a Quattro.

# Ver qué haría sin hacer cambios (simulación)
cd ~ && stow -n -v -d dotfiles -t ~ hypr

# === DESINSTALACIÓN ===

# Desinstalar un paquete (elimina symlinks)
cd ~ && stow -D -d dotfiles -t ~ hypr

# Desinstalar todos
cd ~ && stow -D -d dotfiles -t ~ hypr scripts omarchy omarchy-extensions alacritty btop fastfetch starship mimeapps bash git ssh opencode

# === ACTUALIZACIÓN ===

# Re-stowear (útil si cambiaste estructura de directorios)
cd ~ && stow -R -d dotfiles -t ~ hypr

# === VERIFICACIÓN ===

# Ver si algo es symlink
ls -la ~/.config/hypr

# Ver a dónde apunta un symlink
readlink -f ~/.config/hypr

# Verificar todos los symlinks de dotfiles
find ~ -maxdepth 3 -type l -ls | grep dotfiles

# === TROUBLESHOOTING ===

# Si dice "conflicts", usa --adopt para resolver
# ⚠️ Cuidado: esto sobrescribe en dotfiles con lo que hay en ~
cd ~ && stow --adopt -d dotfiles -t ~ hypr

# Si tienes archivos duplicados, haz backup primero
mv ~/.config/hypr ~/.config/hypr.backup
cd ~ && stow -d dotfiles -t ~ hypr

# === ESTRUCTURA REQUERIDA ===

# Stow necesita esta estructura:
# dotfiles/
#   └── hypr/              ← nombre del paquete
#       └── .config/       ← estructura que se replicará en ~
#           └── hypr/
#               └── *.lua

# Resultado:
# ~/.config/hypr/ → symlink a ~/dotfiles/hypr/.config/hypr/
