-- Keep monitor outputs and workspace assignments in monitors.local.lua.
-- Omarchy handles preferred outputs when no machine-specific override exists.
local omarchy_gdk_scale = 1
hl.env("GDK_SCALE", tostring(omarchy_gdk_scale))
