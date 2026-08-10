-- Change the default Omarchy look'n'feel.

-- https://wiki.hypr.land/Configuring/Basics/Variables/#general
hl.config({
	general = {
		-- No gaps between windows or borders.
		gaps_in = 2,
		gaps_out = 5,
		border_size = 2,

		-- Change to niri-like side-scrolling layout.
		layout = "dwindle",
	},
})

-- https://wiki.hypr.land/Configuring/Basics/Variables/#decoration
hl.config({
	decoration = {
		-- Use round window corners.
		rounding = 12,

		-- Dim unfocused windows (0.0 = no dim, 1.0 = fully dimmed).
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

-- https://wiki.hypr.land/Configuring/Basics/Variables/#layout
-- hl.config({
--   layout = {
--     -- Avoid overly wide single-window layouts on wide screens.
--     single_window_aspect_ratio = { 1, 1 },
--   },
-- })

-- https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/
-- hl.config({
--   scrolling = {
--     -- See only one column per screen instead of two.
--     column_width = 0.97,
--   },
-- })

-- Sweet Nova cursor theme
hl.env("XCURSOR_THEME", "Sweet-cursors")
