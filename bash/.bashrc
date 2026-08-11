# If not running interactively, don't do anything (leave this at the top of this file)
[[ $- != *i* ]] && return

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
source ~/.local/share/omarchy/default/bash/rc

# Add your own exports, aliases, and functions here.
#
# Make an alias for invoking commands you use constantly
# alias p='python'
fastfetch
alias clear='clear && fastfetch'
export PATH="$HOME/.cargo/bin:$PATH"

alias killmc='kill $(pgrep -f theseus.jar) 2>/dev/null; sleep 1; kill -9 $(pgrep -f theseus.jar) 2>/dev/null; echo "Minecraft cerrado"'

alias quest='cat ~/discord-quest.js | wl-copy && echo "Script copiado. Pega en la consola de Discord (Ctrl+V)"'

alias p='ssh villacus@pilla'
alias i='ssh itziar@Cachyilla'

# OmniRoute gateway: apunta Claude Code al router local (Claude gratis + fallback)
export DATA_DIR=/home/villacus/.config/omniroute
export ANTHROPIC_BASE_URL=http://localhost:20128
export ANTHROPIC_AUTH_TOKEN=sk-dde3dd83caf8fafc-7a27e8-c4636fbc
# Modelos: Claude Sonnet como principal (Kiro/Amazon), Haiku para tareas rápidas (combo claude-principal)
export ANTHROPIC_MODEL=claude-sonnet-4-6
export ANTHROPIC_SMALL_FAST_MODEL=kr/claude-haiku-4.5
