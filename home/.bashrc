# If not running interactively, don't do anything (leave this at the top of this file)
[[ $- != *i* ]] && return

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
# /etc/omarchy.conf is written by omarchy-dev-link. When absent, force the
# package default instead of preserving a stale inherited dev-link value before
# we decide which rc file to source.
if [[ -f /etc/omarchy.conf ]]; then
  source /etc/omarchy.conf
  export OMARCHY_PATH="${OMARCHY_PATH:-/usr/share/omarchy}"
else
  export OMARCHY_PATH=/usr/share/omarchy
fi
source "$OMARCHY_PATH/default/bash/rc"

# Secrets: cargar .env local (no commiteado) si existe
[[ -f "${HOME}/.config/home/.env" ]] && set -a && source "${HOME}/.config/home/.env" && set +a

# Add your own exports, aliases, and functions here.
#
# Make an alias for invoking commands you use constantly
# alias p='python'
fastfetch
alias clear='clear && fastfetch'

alias killmc='kill $(pgrep -f theseus.jar) 2>/dev/null; sleep 1; kill -9 $(pgrep -f theseus.jar) 2>/dev/null; echo "Minecraft cerrado"'

alias quest='cat ~/.config/discord-quest.js | wl-copy && echo "Script copiado. Pega en la consola de Discord (Ctrl+V)"'

alias p='ssh villacus@pilla'
alias i='ssh itziar@Cachyilla'

alias claudio=claude
alias claud=claude
alias c=claude
