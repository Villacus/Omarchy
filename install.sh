#!/usr/bin/env bash
# Script de instalación de dotfiles con stow
# Uso: ./install.sh [--force]

set -e

DOTFILES_DIR="$HOME/dotfiles"
FORCE=false

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Parsear argumentos
if [[ "$1" == "--force" ]]; then
    FORCE=true
fi

echo -e "${GREEN}=== Instalación de Dotfiles ===${NC}\n"

# Verificar que estamos en el directorio correcto
if [[ ! -f "$DOTFILES_DIR/install.sh" ]]; then
    echo -e "${RED}Error: Este script debe ejecutarse desde $DOTFILES_DIR${NC}"
    exit 1
fi

# Verificar que stow está instalado
if ! command -v stow &> /dev/null; then
    echo -e "${RED}Error: GNU Stow no está instalado${NC}"
    echo "Instálalo con: sudo pacman -S stow"
    exit 1
fi

# Función para crear backup
backup_config() {
    local config_path="$1"
    if [[ -e "$config_path" ]] && [[ ! -L "$config_path" ]]; then
        local backup_name="$(basename "$config_path").backup-$(date +%Y%m%d-%H%M%S)"
        local backup_dir="$(dirname "$config_path")"
        echo -e "${YELLOW}  Creando backup: $backup_name${NC}"
        mv "$config_path" "$backup_dir/$backup_name"
        return 0
    fi
    return 1
}

# Paquetes a instalar con stow
PACKAGES=(
    "bash"
    "git"
    "ssh"
    "opencode"
    "hypr"
    "waybar"
    "scripts"
    "omarchy-extensions"
    "alacritty"
    "btop"
    "fastfetch"
    "starship"
    "mimeapps"
)

# Configuraciones que pueden necesitar backup
CONFIGS_TO_BACKUP=(
    "$HOME/.bashrc"
    "$HOME/.gitconfig"
    "$HOME/.config/hypr"
    "$HOME/.config/waybar"
    "$HOME/.config/scripts"
    "$HOME/.config/omarchy/extensions"
    "$HOME/.config/alacritty"
    "$HOME/.config/btop"
    "$HOME/.config/fastfetch"
    "$HOME/.config/starship.toml"
    "$HOME/.config/mimeapps.list"
)

# Crear backups si es necesario
if [[ "$FORCE" == false ]]; then
    echo -e "${YELLOW}Verificando archivos existentes...${NC}"
    NEEDS_BACKUP=false
    for config in "${CONFIGS_TO_BACKUP[@]}"; do
        if [[ -e "$config" ]] && [[ ! -L "$config" ]]; then
            NEEDS_BACKUP=true
            break
        fi
    done

    if [[ "$NEEDS_BACKUP" == true ]]; then
        echo -e "${YELLOW}Se encontraron configuraciones existentes.${NC}"
        echo "Se crearán backups con el sufijo .backup-TIMESTAMP"
        read -p "¿Continuar? (s/n) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[SsYy]$ ]]; then
            echo -e "${RED}Instalación cancelada${NC}"
            exit 1
        fi

        for config in "${CONFIGS_TO_BACKUP[@]}"; do
            backup_config "$config" || true
        done
    fi
fi

# Crear directorio .config si no existe
mkdir -p "$HOME/.config"

# Crear directorio omarchy si no existe (para extensions)
mkdir -p "$HOME/.config/omarchy"

echo -e "\n${GREEN}Instalando paquetes con stow...${NC}"

cd "$HOME"

# Instalar cada paquete
for package in "${PACKAGES[@]}"; do
    if [[ -d "$DOTFILES_DIR/$package" ]]; then
        echo -e "  ${GREEN}✓${NC} Instalando $package"
        stow -d dotfiles -t "$HOME" "$package" 2>&1 | grep -v "^BUG in find_stowed_path" || true
    else
        echo -e "  ${YELLOW}⚠${NC} Paquete no encontrado: $package"
    fi
done

echo -e "\n${GREEN}=== Instalación completada ===${NC}"
echo -e "\nSymlinks creados en:"
echo "  - ~/.bashrc"
echo "  - ~/.gitconfig"
echo "  - ~/.ssh/ (keys, no known_hosts)"
echo "  - ~/.config/hypr/"
echo "  - ~/.config/waybar/"
echo "  - ~/.config/scripts/"
echo "  - ~/.config/omarchy/extensions/"
echo "  - ~/.config/alacritty/"
echo "  - ~/.config/btop/"
echo "  - ~/.config/fastfetch/"
echo "  - ~/.config/starship.toml"
echo "  - ~/.config/mimeapps.list"

echo -e "\n${YELLOW}Nota importante para portátil:${NC}"
echo "  - Revisa hypr/.config/hypr/monitors.lua y adapta a tu hardware"
echo "  - Los paths de Wallpaper Engine están hardcoded para /mnt/Games/"
echo "  - Si no tienes Omarchy instalado, necesitarás instalarlo primero"

echo -e "\n${GREEN}Para desinstalar:${NC}"
echo "  cd ~ && stow -D -d dotfiles <paquete>"
echo "  o ejecuta: ./uninstall.sh"
