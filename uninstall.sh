#!/usr/bin/env bash
# Retira los enlaces que install.sh crea fuera de ~/.config.

set -euo pipefail

ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
EXPECTED_ROOT="$HOME/.config"
FORCE=false

usage() {
  cat <<'EOF'
Uso: ./uninstall.sh [--force] [--help]

Elimina los enlaces que install.sh crea fuera de ~/.config, y solo si apuntan
al repositorio:
  ~/.bashrc
  ~/.gitconfig
  ~/.opencode

No se modifica ~/.config ni se eliminan los backups .backup-<fecha>.

  --force   No pedir confirmación.
  --help    Mostrar esta ayuda y salir.
EOF
}

if [[ "${1:-}" == "--force" ]]; then
  FORCE=true
elif [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
  usage
  exit 0
elif [[ -n "${1:-}" ]]; then
  printf 'Uso: %s [--force] [--help]\n' "$0" >&2
  exit 2
fi

if [[ "$ROOT" != "$EXPECTED_ROOT" ]]; then
  printf 'Error: el repositorio debe estar en %s (actual: %s)\n' "$EXPECTED_ROOT" "$ROOT" >&2
  exit 1
fi

if [[ "$FORCE" != true ]]; then
  printf 'Se eliminarán solo estos enlaces, si apuntan al repositorio:\n'
  printf '  ~/.bashrc\n  ~/.gitconfig\n  ~/.opencode\n'
  read -r -p '¿Continuar? (s/n) ' answer
  [[ "$answer" =~ ^[SsYy]$ ]] || { echo 'Desinstalación cancelada'; exit 1; }
fi

remove_link() {
  local target="$1"
  local source="$2"
  local resolved

  if [[ ! -L "$target" ]]; then
    printf '  - %s: no es un enlace gestionado\n' "$target"
    return
  fi

  # readlink -f resuelve la ruta completa, pero devuelve vacio si el enlace esta
  # colgado; en ese caso se compara el destino literal para poder retirar un
  # enlace gestionado que apunte a un archivo ya inexistente del repositorio.
  resolved="$(readlink -f -- "$target" 2>/dev/null || true)"
  if [[ -z "$resolved" ]]; then
    resolved="$(readlink -- "$target" 2>/dev/null || true)"
  fi

  if [[ "$resolved" != "$source" ]]; then
    printf '  - %s: se conserva (apunta a %s)\n' "$target" "${resolved:-destino desconocido}"
    return
  fi

  rm -- "$target"
  printf '  ✓ %s\n' "$target"
}

remove_link "$HOME/.bashrc" "$ROOT/home/.bashrc"
remove_link "$HOME/.gitconfig" "$ROOT/home/.gitconfig"
remove_link "$HOME/.opencode" "$ROOT/home/.opencode"
printf '\nDesinstalación completada; no se modificó ~/.config ni se eliminaron backups.\n'
