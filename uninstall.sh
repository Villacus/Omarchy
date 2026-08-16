#!/usr/bin/env bash
# Script de desinstalación de dotfiles
# Elimina todos los symlinks creados por stow

set -e

DOTFILES_DIR="$HOME/dotfiles"

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}=== Desinstalación de Dotfiles ===${NC}\n"

# Verificar directorio
if [[ ! -d "$DOTFILES_DIR" ]]; then
    echo -e "${RED}Error: Directorio $DOTFILES_DIR no encontrado${NC}"
    exit 1
fi

# Paquetes a desinstalar
PACKAGES=(
    "bash"
    "git"
    "ssh"
    "opencode"
    "hypr"
    "scripts"
    "omarchy"
    "omarchy-extensions"
    "alacritty"
    "btop"
    "fastfetch"
    "starship"
    "mimeapps"
)

echo -e "${YELLOW}Esto eliminará todos los symlinks creados por stow${NC}"
read -p "¿Continuar? (s/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[SsYy]$ ]]; then
    echo -e "${RED}Desinstalación cancelada${NC}"
    exit 1
fi

cd "$HOME"

# Desinstalar cada paquete
for package in "${PACKAGES[@]}"; do
    if [[ ! -d "$DOTFILES_DIR/$package" ]]; then
        echo -e "${RED}Error: Paquete no encontrado: $package${NC}"
        exit 1
    fi

    echo -e "  ${GREEN}✓${NC} Desinstalando $package"
    stow -D -d "$DOTFILES_DIR" -t "$HOME" "$package"
done

echo -e "\n${GREEN}=== Desinstalación completada ===${NC}"
echo -e "\n${YELLOW}Los archivos de backup (.backup-*) no fueron eliminados${NC}"
echo "Revísalos manualmente en ~/.config/ y ~/"
