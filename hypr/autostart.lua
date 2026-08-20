-- Shared autostart entries only.
-- Add optional, machine-specific services to autostart.local.lua.

-- Only start what this machine actually has installed, so the same main branch
-- works on hosts without the optional package.
if o.cmd_present("hyprsunset") then
	o.launch_on_start("hyprsunset")
end
