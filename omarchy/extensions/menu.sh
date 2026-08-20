# Override del menú de backgrounds para soporte multi-monitor y Wallpaper Engine.
show_background_menu() {
  local config_home="${XDG_CONFIG_HOME:-$HOME/.config}"
  "$config_home/scripts/omarchy-background-selector"
}
