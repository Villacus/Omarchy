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
export PATH="$HOME/.local/share/omarchy/bin-custom:$PATH"
alias omarchy-theme-bg-switcher='~/.local/share/omarchy/bin-custom/omarchy-theme-bg-switcher'
