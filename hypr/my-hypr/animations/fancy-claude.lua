-- Migrated from fancy-claude.conf to the Hyprland 0.55+ Lua config format.

-- 1. BEZIER CURVES
-- "bounce" — slides in fast, overshoots slightly, settles back.
-- The y2 = 1.08 is what makes it hit the top and bounce back down.
hl.curve("bounce",   { type = "bezier", points = { { 0.18, 0.89 }, { 0.32, 1.08 } } })
-- "easeIn"/"dropSoft" for closing — no need for bounce on the way out.
hl.curve("easeIn",   { type = "bezier", points = { { 0.55, 0.0 },  { 1.0, 0.45 } } })
hl.curve("dropSoft", { type = "bezier", points = { { 0.05, 0.72 }, { 0.12, 1.0 } } })

hl.config({
    animations = {
        enabled = true,
    },
})

-- All windows: slide in with bounce, slide out quick
hl.animation({ leaf = "windowsIn",   enabled = true, speed = 6, bezier = "bounce", style = "slide" })
hl.animation({ leaf = "windowsOut",  enabled = true, speed = 4, bezier = "easeIn", style = "slide" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 5, bezier = "bounce" })

-- Fades
hl.animation({ leaf = "fadeIn",  enabled = true, speed = 5, bezier = "default" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 4, bezier = "default" })

-- Workspaces
hl.animation({ leaf = "workspaces", enabled = true, speed = 5, bezier = "bounce", style = "slidevert" })

-- Dropdown / special workspaces
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 3, bezier = "dropSoft", style = "slidevert" })
