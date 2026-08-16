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

validate_link() {
    local target="$1"
    local source="$2"
    local target_path
    local source_path

    if [[ ! -L "$target" ]]; then
        echo -e "${RED}Error: $target no es un symlink${NC}"
        return 1
    fi

    if ! target_path="$(readlink -f -- "$target")"; then
        echo -e "${RED}Error: $target es un symlink roto${NC}"
        return 1
    fi

    if ! source_path="$(readlink -f -- "$source")"; then
        echo -e "${RED}Error: no se puede resolver el origen esperado $source${NC}"
        return 1
    fi

    if [[ "$target_path" != "$source_path" ]]; then
        echo -e "${RED}Error: $target apunta a $target_path, se esperaba $source_path${NC}"
        return 1
    fi
}

EDITOR_COMMAND=()

select_editor() {
    local configured_editor
    local fallback_editor

    for configured_editor in "$VISUAL" "$EDITOR"; do
        if [[ -n "$configured_editor" ]]; then
            read -r -a EDITOR_COMMAND <<< "$configured_editor"
            if command -v "${EDITOR_COMMAND[0]}" &> /dev/null; then
                return 0
            fi
        fi
    done

    for fallback_editor in nvim vim nano; do
        if command -v "$fallback_editor" &> /dev/null; then
            EDITOR_COMMAND=("$fallback_editor")
            return 0
        fi
    done

    echo -e "${RED}Error: no se encontró un editor. Configura VISUAL o EDITOR.${NC}"
    return 1
}

# Paquetes a instalar con stow
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

# Configuraciones que pueden necesitar backup
CONFIGS_TO_BACKUP=(
    "$HOME/.bashrc"
    "$HOME/.gitconfig"
    "$HOME/.config/hypr"
    "$HOME/.config/scripts"
    "$HOME/.config/omarchy/shell.json"
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

# Instalar cada paquete
for package in "${PACKAGES[@]}"; do
    if [[ ! -d "$DOTFILES_DIR/$package" ]]; then
        echo -e "${RED}Error: Paquete no encontrado: $package${NC}"
        exit 1
    fi

    echo -e "  ${GREEN}✓${NC} Instalando $package"
    stow -d "$DOTFILES_DIR" -t "$HOME" "$package"
done

echo -e "\n${GREEN}Validando symlinks de stow...${NC}"
VALIDATION_LINKS=(
    "$HOME/.bashrc:$DOTFILES_DIR/bash/.bashrc"
    "$HOME/.gitconfig:$DOTFILES_DIR/git/.gitconfig"
    "$HOME/.opencode:$DOTFILES_DIR/opencode/.opencode"
    "$HOME/.config/hypr:$DOTFILES_DIR/hypr/.config/hypr"
    "$HOME/.config/scripts:$DOTFILES_DIR/scripts/.config/scripts"
    "$HOME/.config/omarchy/shell.json:$DOTFILES_DIR/omarchy/.config/omarchy/shell.json"
    "$HOME/.config/omarchy/extensions:$DOTFILES_DIR/omarchy-extensions/.config/omarchy/extensions"
    "$HOME/.config/alacritty:$DOTFILES_DIR/alacritty/.config/alacritty"
    "$HOME/.config/btop:$DOTFILES_DIR/btop/.config/btop"
    "$HOME/.config/fastfetch:$DOTFILES_DIR/fastfetch/.config/fastfetch"
    "$HOME/.config/starship.toml:$DOTFILES_DIR/starship/.config/starship.toml"
    "$HOME/.config/mimeapps.list:$DOTFILES_DIR/mimeapps/.config/mimeapps.list"
)

for link in "${VALIDATION_LINKS[@]}"; do
    target="${link%%:*}"
    source="${link#*:}"
    validate_link "$target" "$source"
done

if [[ -f "$DOTFILES_DIR/ssh/.ssh/id_ed25519.pub" ]]; then
    validate_link "$HOME/.ssh/id_ed25519.pub" "$DOTFILES_DIR/ssh/.ssh/id_ed25519.pub"
fi

# Eliminar solo el symlink roto que dejó una versión previa del paquete SSH.
if [[ -L "$HOME/.ssh/agent" ]] && [[ ! -e "$HOME/.ssh/agent" ]]; then
    echo -e "${YELLOW}  Eliminando symlink roto: ~/.ssh/agent${NC}"
    rm "$HOME/.ssh/agent"
fi

echo -e "${YELLOW}\nRevisa los monitores disponibles con: hyprctl monitors${NC}"
select_editor
"${EDITOR_COMMAND[@]}" \
    "$DOTFILES_DIR/hypr/.config/hypr/monitors.lua" \
    "$DOTFILES_DIR/omarchy/.config/omarchy/shell.json"

echo -e "\n${GREEN}=== Instalación completada ===${NC}"
echo -e "\nSymlinks creados y validados en:"
echo "  - ~/.bashrc"
echo "  - ~/.gitconfig"
echo "  - ~/.ssh/id_ed25519.pub (si existe en el paquete)"
echo "  - ~/.config/hypr/"
echo "  - ~/.config/scripts/"
echo "  - ~/.config/omarchy/shell.json"
echo "  - ~/.config/omarchy/extensions/"
echo "  - ~/.config/alacritty/"
echo "  - ~/.config/btop/"
echo "  - ~/.config/fastfetch/"
echo "  - ~/.config/starship.toml"
echo "  - ~/.config/mimeapps.list"

echo -e "\n${YELLOW}Nota importante para portátil:${NC}"
echo "  - Ajusta monitores.lua y shell.json en el editor que se abrió"
echo "  - Los paths de Wallpaper Engine están hardcoded para /mnt/Games/"
echo "  - Si no tienes Omarchy instalado, necesitarás instalarlo primero"
echo "  - La clave SSH privada se gestiona manualmente y no la toca este script"

echo -e "\n${GREEN}Para desinstalar:${NC}"
echo "  stow -D -d $DOTFILES_DIR -t \$HOME <paquete>"
echo "  o ejecuta: ./uninstall.sh"
