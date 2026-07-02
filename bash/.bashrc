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

alias quest='cat ~/discord-quest.js | xclip -selection clipboard -loops 1 && echo "Script copiado. Pega en la consola de Discord (Ctrl+V)"'

alias p='ssh villacus@pilla'
alias i='ssh itziar@Cachyilla'
