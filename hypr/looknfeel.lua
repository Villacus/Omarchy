-- Change the default Omarchy look'n'feel.

-- https://wiki.hypr.land/Configuring/Basics/Variables/#general
hl.config({
	general = {
		gaps_in = 2,
		gaps_out = 5,
		border_size = 2,
		layout = "dwindle",
	},
})

-- https://wiki.hypr.land/Configuring/Basics/Variables/#decoration
hl.config({
	decoration = {
		rounding = 12,
		dim_inactive = true,
		dim_strength = 0.05,
	},
})

-- https://wiki.hypr.land/Configuring/Basics/Variables/#animations
hl.config({
	animations = {
		enabled = true,
	},
})

-- Animations imported from the Amekoji theme.
-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve("easeSoft", { type = "bezier", points = { { 0.22, 0.61 }, { 0.36, 1 } } })
hl.curve("easePop", { type = "bezier", points = { { 0.26, 0.70 }, { 0.48, 1 } } })
hl.curve("easeFade", { type = "bezier", points = { { 0.33, 0.00 }, { 0.20, 1 } } })

hl.animation({
	leaf = "windows",
	enabled = true,
	speed = 3.0,
	bezier = "easeSoft",
})
hl.animation({
	leaf = "windowsIn",
	enabled = true,
	speed = 2.8,
	bezier = "easeSoft",
})
hl.animation({
	leaf = "windowsOut",
	enabled = true,
	speed = 2.6,
	bezier = "easeFade",
})
hl.animation({
	leaf = "windowsMove",
	enabled = true,
	speed = 3.2,
	bezier = "easeSoft",
})
hl.animation({
	leaf = "fade",
	enabled = true,
	speed = 2.4,
	bezier = "easeFade",
})
hl.animation({
	leaf = "fadeIn",
	enabled = true,
	speed = 2.2,
	bezier = "easeSoft",
})
hl.animation({
	leaf = "fadeOut",
	enabled = true,
	speed = 2.0,
	bezier = "easeFade",
})
hl.animation({
	leaf = "fadeDim",
	enabled = true,
	speed = 2.0,
	bezier = "easeFade",
})
hl.animation({
	leaf = "layers",
	enabled = true,
	speed = 2.4,
	bezier = "easeSoft",
})
hl.animation({
	leaf = "layersIn",
	enabled = true,
	speed = 2.2,
	bezier = "easePop",
})
hl.animation({
	leaf = "layersOut",
	enabled = true,
	speed = 2.0,
	bezier = "easeFade",
})
hl.animation({
	leaf = "workspaces",
	enabled = true,
	speed = 2.6,
	bezier = "easeSoft",
})
hl.animation({
	leaf = "specialWorkspace",
	enabled = true,
	speed = 2.4,
	bezier = "easeSoft",
})
hl.animation({
	leaf = "border",
	enabled = true,
	speed = 3.4,
	bezier = "easeSoft",
})
hl.animation({
	leaf = "borderangle",
	enabled = true,
	speed = 3.8,
	bezier = "easeSoft",
})
hl.animation({
	leaf = "fadeSwitch",
	enabled = true,
	speed = 1.8,
	bezier = "easeFade",
})

-- Sweet Nova cursor theme
hl.env("XCURSOR_THEME", "Sweet-cursors")

-- >>> omaland managed block >>>
-- Written by Omaland. Safe to hand-edit: Omaland re-reads this block
-- every time it opens, and only ever rewrites what's between the fences.
hl.config({
  decoration = {
    active_opacity = 0.97,
    dim_inactive = true,
    inactive_opacity = 0.94,

    blur = {
      enabled = false,
    },

    glow = {
      enabled = false,
    },

    shadow = {
      enabled = false,
    },
  },

  general = {
    border_size = 2,
    float_gaps = 38,
    gaps_in = 1,
    gaps_out = 0,
    gaps_workspaces = 0,
  },
})
-- <<< omaland managed block <<<
