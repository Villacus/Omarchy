-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- List current monitors and supported resolutions with: hyprctl monitors all

local omarchy_gdk_scale = 1

hl.env("GDK_SCALE", tostring(omarchy_gdk_scale))

-- Laptop panel: Sharp LQ133M1JW02, 1920x1080 at 59.93 Hz.
hl.monitor({ output = "eDP-1", mode = "1920x1080@59.93", position = "0x0", scale = 1.5 })

-- Workspace assignments from the desktop configuration are intentionally
-- omitted: this laptop has one active monitor.
o.window("discord", { workspace = 2 })
o.window("chrome-navidrome.tailf45616.ts.net__-Default", { workspace = "special:scratchpad" })
o.window("chrome-web.whatsapp.com__-Default", { workspace = "special:scratchpad" })
