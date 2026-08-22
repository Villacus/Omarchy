-- Shared autostart entries only.
-- Add optional, machine-specific services to autostart.local.lua.

-- Only start what this machine actually has installed, so the same main branch
-- works on hosts without the optional package.
if o.cmd_present("hyprsunset") then
	o.launch_on_start("hyprsunset")
end

local config_home = os.getenv("XDG_CONFIG_HOME") or (os.getenv("HOME") .. "/.config")
local config_sync = config_home .. "/scripts/config-sync-pull"

if o.cmd_present("git") then
	o.launch_on_start(config_sync)
end
