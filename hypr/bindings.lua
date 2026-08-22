-- Shared bindings for applications available on both machines.
-- Remove only conflicting Omarchy defaults before rebinding a key.
hl.unbind("SUPER + SHIFT + N")
hl.unbind("SUPER + SHIFT + S")
hl.unbind("SUPER + TAB") -- Default: next workspace, replaced by the mirador overview
hl.unbind("SUPER + SHIFT + M")
hl.unbind("SUPER + SHIFT + G")
hl.unbind("SUPER + SHIFT + P")

o.bind("SUPER + ALT + RETURN", "Tmux", { omarchy = "terminal-tmux" })
o.bind("SUPER + ALT + SHIFT + F", "File manager (cwd)", { omarchy = "nautilus-cwd" })
o.bind("SUPER + SHIFT + N", "Editor", { omarchy = "editor" })

o.bind("SUPER + SHIFT + C", "Calendar", { webapp = "https://calendar.google.com/" })
o.bind("SUPER + SHIFT + E", "Email", { webapp = "https://mail.google.com/mail/u/0/" })
o.bind("SUPER + SHIFT + Y", "YouTube", { webapp = "https://youtube.com/" })
o.bind("SUPER + SHIFT + U", "WhatsApp", { webapp = "https://web.whatsapp.com/", focus = true })
o.bind("SUPER + SHIFT + G", "Github", { webapp = "https://github.com/Villacus/" })
o.bind("SUPER + SHIFT + P", "Homelab", { webapp = "https://homepage.tailf45616.ts.net" })
o.bind("SUPER + SHIFT + M", "Navidrome", { webapp = "https://navidrome.tailf45616.ts.net" })

o.bind("SUPER + SHIFT + S", "Screenshot area to clipboard", "omarchy-capture-screenshot region copy")
o.bind("SUPER + ALT + A", "Switch audio output", "omarchy-audio-output-switch")
o.bind("SUPER + mouse:275", "Mute microphone", "omarchy audio input mute")

-- Workspace overview from the mirador shell plugin. The plugin is not versioned
-- (omarchy/plugins/ stays local), so on a machine without it the shell simply
-- ignores the toggle and the key does nothing.
o.bind("SUPER + TAB", "Workspace overview", "omarchy-shell shell toggle mirador '{}'")
