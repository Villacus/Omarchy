-- Unbind Omarchy defaults that conflict with custom bindings.
-- Quattro now includes default bindings for common apps that overlap with personal configs.
hl.unbind("SUPER + SHIFT + RETURN")  -- Default: Browser → rebinding below
hl.unbind("SUPER + SHIFT + B")       -- Default: Browser → rebinding below
hl.unbind("SUPER + SHIFT + F")       -- Default: File manager → rebinding below
hl.unbind("SUPER + SHIFT + N")       -- Default: Notes → using for Editor
hl.unbind("SUPER + SHIFT + D")       -- Default: Discord → using for Docker
hl.unbind("SUPER + SHIFT + V")       -- Default: VSCode → rebinding below
hl.unbind("SUPER + SHIFT + H")       -- Default: Steam → rebinding below
hl.unbind("SUPER + SHIFT + I")       -- Default: Spotify → using for Discord
hl.unbind("SUPER + SHIFT + O")       -- Default: Obsidian → rebinding below
hl.unbind("SUPER + SHIFT + C")       -- Default: Calendar → rebinding below
hl.unbind("SUPER + SHIFT + E")       -- Default: Email → rebinding below
hl.unbind("SUPER + SHIFT + G")       -- Default: Signal → using for Github/Github webapp
hl.unbind("SUPER + SHIFT + Y")       -- Default: YouTube Music → using for YouTube webapp
hl.unbind("SUPER + SHIFT + U")       -- Default: (none) → using for WhatsApp
hl.unbind("SUPER + SHIFT + P")       -- Default: (none) → using for Homelab
hl.unbind("SUPER + SHIFT + M")       -- Default: Music → using for Navidrome
hl.unbind("SUPER + SHIFT + S")       -- Default: Screenshot → rebinding with specific args

-- Application bindings.
o.bind("SUPER + RETURN", "Terminal", { omarchy = "terminal" })
o.bind("SUPER + ALT + RETURN", "Tmux", { omarchy = "terminal-tmux" })
o.bind("SUPER + SHIFT + RETURN", "Browser", { omarchy = "browser" })
o.bind("SUPER + SHIFT + F", "File manager", { omarchy = "nautilus" })
o.bind("SUPER + ALT + SHIFT + F", "File manager (cwd)", { omarchy = "nautilus-cwd" })
o.bind("SUPER + SHIFT + B", "Browser", { omarchy = "browser" })
o.bind("SUPER + SHIFT + ALT + B", "Browser (private)", { omarchy = "browser --private" })
o.bind("SUPER + SHIFT + N", "Editor", { omarchy = "editor" })
o.bind("SUPER + SHIFT + D", "Docker", { tui = "lazydocker" })
o.bind("SUPER + SHIFT + O", "Obsidian", { launch = "obsidian", focus = "^obsidian$" })
o.bind("SUPER + SHIFT + V", "VSCode", { launch = "code", focus = "^code$" })
o.bind("SUPER + SHIFT + H", "Steam", { launch = "steam", focus = "^steam$" })
o.bind("SUPER + SHIFT + I", "Discord", { launch = "discord", focus = "^discord$" })

-- Web app bindings.
o.bind("SUPER + SHIFT + C", "Calendar", { webapp = "https://calendar.google.com/" })
o.bind("SUPER + SHIFT + E", "Email", { webapp = "https://mail.google.com/mail/u/0/" })
o.bind("SUPER + SHIFT + Y", "YouTube", { webapp = "https://youtube.com/" })
o.bind("SUPER + SHIFT + U", "WhatsApp", { webapp = "https://web.whatsapp.com/", focus = true })
o.bind("SUPER + SHIFT + G", "Github", { webapp = "https://github.com/Villacus/" })
o.bind("SUPER + SHIFT + P", "Homelab", { webapp = "https://homepage.tailf45616.ts.net" })
o.bind("SUPER + SHIFT + M", "Navidrome", { webapp = "https://navidrome.tailf45616.ts.net" })

-- Screenshot
o.bind("SUPER + SHIFT + S", "Screenshot area to clipboard", "omarchy-capture-screenshot region copy")

-- Audio output switcher
o.bind("SUPER + ALT + A", "Switch audio output", "omarchy-audio-output-switch")

-- Mic mute toggle with Super + mouse side button (back/lower).
o.bind("SUPER + mouse:275", "Mute microphone", "omarchy audio input mute")
