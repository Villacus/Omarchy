-- Learn how to configure Hyprland: https://wiki.hypr.land/Configuring/Start/

-- Omarchy's bootstrap keeps path setup out of this user config.
dofile((os.getenv("OMARCHY_PATH") or "/usr/share/omarchy") .. "/default/hypr/bootstrap.lua")

-- Keep Omarchy's built-in bindings and add personal bindings below.
-- Disable only a conflicting binding in hypr/bindings.lua when needed.

-- Load Omarchy defaults.
require("default.hypr.omarchy")

-- Put your personal overrides in these files. They're loaded after Omarchy's
-- defaults so package updates can improve the defaults without rewriting your
-- ~/.config/hypr files.
require("hypr.monitors")
require("hypr.input")
require("hypr.bindings")
require("hypr.looknfeel")
require("hypr.autostart")

-- Machine-specific overrides are local and ignored by Git.
local function dofile_if_exists(filename)
	local config_home = os.getenv("XDG_CONFIG_HOME") or (os.getenv("HOME") .. "/.config")
	local path = config_home .. "/hypr/" .. filename
	local file = io.open(path, "r")
	if file then
		file:close()
		dofile(path)
	end
end

dofile_if_exists("monitors.local.lua")
dofile_if_exists("bindings.local.lua")
dofile_if_exists("autostart.local.lua")

-- Toggle config flags dynamically.
require("default.hypr.toggles")

-- Add any other personal Hyprland configuration below.
-- o.window("qemu", { workspace = "5" })
