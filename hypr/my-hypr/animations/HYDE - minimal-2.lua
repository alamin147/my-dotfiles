-- Migrated from HYDE - minimal-2.conf to the Hyprland 0.55+ Lua config format.
-- Name: Minimal-2
-- Credit: https://github.com/prasanthrangan/hyprdots

hl.curve("quart", { type = "bezier", points = { { 0.25, 1 }, { 0.5, 1 } } })

hl.config({
    animations = {
        enabled = true,
    },
})

hl.animation({ leaf = "windows", enabled = true, speed = 6, bezier = "quart", style = "slide" })
hl.animation({ leaf = "border", enabled = true, speed = 6, bezier = "quart" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 6, bezier = "quart" })
hl.animation({ leaf = "fade", enabled = true, speed = 6, bezier = "quart" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 6, bezier = "quart" })
