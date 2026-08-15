-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- List current monitors and supported resolutions with: hyprctl monitors all

local omarchy_gdk_scale = 1
local omarchy_monitor_scale = "auto"

hl.env("GDK_SCALE", tostring(omarchy_gdk_scale))
-- hl.monitor({ output = "", mode = "preferred", position = "auto", scale = omarchy_monitor_scale })

-- Philips 200V4 (DP-3) - LEFT
hl.monitor({ output = "DP-3", mode = "1600x900@60", position = "0x180", scale = omarchy_monitor_scale })

-- ASUS VG249Q3R (DP-2) - RIGHT
hl.monitor({ output = "DP-2", mode = "1920x1080@180", position = "1600x100", scale = omarchy_monitor_scale })

hl.workspace_rule({ workspace = "1", monitor = "DP-2", persistent = true })
hl.workspace_rule({ workspace = "2", monitor = "DP-3", persistent = true })
hl.workspace_rule({ workspace = "3", monitor = "DP-2", persistent = true })
hl.workspace_rule({ workspace = "4", monitor = "DP-3", persistent = true })
hl.workspace_rule({ workspace = "5", monitor = "DP-2", persistent = true })

-- Portrait/rotated secondary monitor (transform: 1 = 90°, 3 = 270°).
-- hl.monitor({ output = "DP-2", mode = "preferred", position = "auto", scale = 1, transform = 1 })
