-- Extra autostart processes.
-- o.launch_on_start("my-service")
o.launch_on_start("hyprsunset")

-- Wallpaper restoration is opt-in on this laptop. The Wallpaper Engine
-- dependencies are not installed, and Omarchy already manages the current
-- static background.
-- o.launch_on_start("~/.config/scripts/restore-wallpapers")

-- Wallpaper Engine can be enabled later after its dependencies and state are
-- verified; it is intentionally not started during this migration.
-- o.launch_on_start("~/.config/scripts/omarchy-wallpaper-engine")
