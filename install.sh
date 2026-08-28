#!/usr/bin/env bash
# Instala los enlaces fuera de ~/.config. El repositorio vive en ~/.config.

set -euo pipefail

ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
EXPECTED_ROOT="$HOME/.config"
FORCE=false

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

usage() {
  cat <<'EOF'
Uso: ./install.sh [--force] [--help]

Enlaza los archivos que viven fuera de ~/.config:
  ~/.bashrc              -> ~/.config/home/.bashrc
  ~/.zshrc               -> ~/.config/home/.zshrc
  (zsh se instala como shell predeterminada con: chsh -s /usr/bin/zsh)
  ~/.gitconfig           -> ~/.config/home/.gitconfig
  ~/.opencode            -> ~/.config/home/.opencode
  ~/.claude/settings.json -> ~/.config/home/.claude/settings.json

La API key de Claude va en ~/.config/home/.env (ignorado por git; se
carga en .bashrc). El settings.json se versionea sin secrets.

Los archivos de ~/.config son el repositorio: no se copian ni se enlazan.

  --force   No pedir confirmación.
  --help    Mostrar esta ayuda y salir.

Si alguno de los destinos ya existe se mueve a <destino>.backup-<fecha> antes
de crear el enlace. Para ~/.opencode eso mueve el directorio entero, con todo
su contenido, al backup.
EOF
}

if [[ "${1:-}" == "--force" ]]; then
  FORCE=true
elif [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
  usage
  exit 0
elif [[ -n "${1:-}" ]]; then
  printf '%b\n' "${RED}Uso: $0 [--force] [--help]${NC}" >&2
  exit 2
fi

if [[ "$ROOT" != "$EXPECTED_ROOT" ]]; then
  printf '%b\n' "${RED}Error: el repositorio debe estar en $EXPECTED_ROOT (actual: $ROOT)${NC}" >&2
  exit 1
fi

STAMP="$(date +%Y%m%d-%H%M%S)"

backup_target() {
  local target="$1"
  local backup="${target}.backup-${STAMP}"

  if [[ -e "$target" || -L "$target" ]]; then
    mv -- "$target" "$backup"
    printf '%b\n' "  ${YELLOW}Backup: $backup${NC}"
  fi
}

link_home_file() {
  local target="$1"
  local source="$2"
  local resolved

  if [[ -L "$target" ]]; then
    resolved="$(readlink -f -- "$target" 2>/dev/null || true)"
    if [[ "$resolved" == "$source" ]]; then
      printf '%b\n' "  ${GREEN}✓${NC} $target"
      return
    fi
    backup_target "$target"
  elif [[ -e "$target" ]]; then
    backup_target "$target"
  fi

  mkdir -p -- "$(dirname -- "$target")"
  ln -s -- "$source" "$target"
  printf '%b\n' "  ${GREEN}✓${NC} $target -> $source"
}

required=(
  alacritty/alacritty.toml
  btop/btop.conf
  fastfetch/config.jsonc
  home/.bashrc
  home/.zshrc
  home/.gitconfig
  home/.opencode/AGENTS.md
  home/.claude/settings.json
  hypr/hyprland.lua
  hypr/monitors.lua
  omarchy/shell.json
  scripts/omarchy-background-selector
  starship.toml
)

for path in "${required[@]}"; do
  # -e sigue los enlaces, asi que un symlink roto se detecta aparte para
  # distinguirlo de un archivo que simplemente no esta en el repositorio.
  if [[ -L "$ROOT/$path" && ! -e "$ROOT/$path" ]]; then
    printf '%b\n' "${RED}Error: $ROOT/$path es un enlace roto${NC}" >&2
    exit 1
  fi
  if [[ ! -e "$ROOT/$path" ]]; then
    printf '%b\n' "${RED}Error: falta $ROOT/$path${NC}" >&2
    exit 1
  fi
done

link_targets=(
  "$HOME/.bashrc:$ROOT/home/.bashrc"
  "$HOME/.zshrc:$ROOT/home/.zshrc"
  "$HOME/.gitconfig:$ROOT/home/.gitconfig"
  "$HOME/.opencode:$ROOT/home/.opencode"
  "$HOME/.claude/settings.json:$ROOT/home/.claude/settings.json"
)

if [[ "$FORCE" != true ]]; then
  for target_spec in "${link_targets[@]}"; do
    target="${target_spec%%:*}"
    if [[ -e "$target" || -L "$target" ]]; then
      if [[ -d "$target" && ! -L "$target" ]]; then
        printf '%b\n' "${YELLOW}Existe $target y es un directorio real; se moverá completo (con su contenido) al backup antes de enlazarlo.${NC}"
      else
        printf '%b\n' "${YELLOW}Existe $target; se creará un backup antes de enlazarlo.${NC}"
      fi
    fi
  done
  read -r -p "¿Continuar? (s/n) " answer
  [[ "$answer" =~ ^[SsYy]$ ]] || { echo "Instalación cancelada"; exit 1; }
fi

printf '%b\n' "${GREEN}=== Instalando enlaces de ~/.config ===${NC}"
link_home_file "$HOME/.bashrc" "$ROOT/home/.bashrc"
link_home_file "$HOME/.zshrc" "$ROOT/home/.zshrc"
link_home_file "$HOME/.gitconfig" "$ROOT/home/.gitconfig"
link_home_file "$HOME/.opencode" "$ROOT/home/.opencode"
link_home_file "$HOME/.claude/settings.json" "$ROOT/home/.claude/settings.json"

printf '%b\n' "${GREEN}=== Instalación completada ===${NC}"
printf '%b\n' "${YELLOW}Los archivos de ~/.config son el repositorio; no se copian ni se enlazan.${NC}"
printf '%b\n' "${YELLOW}Para adaptar hardware, copia hypr/monitors.local.lua.example a hypr/monitors.local.lua.${NC}"
exit 0

# Keep the script intentionally short: all sources are preflighted above and
# only the four external links are managed here.
