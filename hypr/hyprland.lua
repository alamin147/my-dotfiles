-- Hyprland Configuration (Lua)
-- Migrated from hyprland.conf for the Hyprland 0.55+ Lua config format.
-- https://wiki.hypr.land/Configuring/

-- ==================
-- MONITOR CONFIG
-- ==================
-- hl.monitor({ output = "eDP-2", mode = "2560x1600@239.998993", position = "2560x0", scale = 1, vrr = 1 })
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "auto",
})

-- ==================
-- STARTUP APPS
-- ==================
hl.on("hyprland.start", function()
    hl.exec_cmd("dbus-update-activation-environment --systemd --all")
    hl.exec_cmd("systemctl --user start hyprland-session.target")
end)

-- ==================
-- INPUT CONFIG
-- ==================
hl.config({
    input = {
        kb_layout          = "us",
        numlock_by_default = true,
        touchpad = {
            natural_scroll = false,
            scroll_factor  = 1.0,
        },
    },
})

-- ==================
-- GENERAL LAYOUT
-- ==================
hl.config({
    general = {
        gaps_in     = 5,
        gaps_out    = 5,
        border_size = 2,
        layout      = "dwindle",
    },
})

-- ==================
-- DECORATION
-- ==================
hl.config({
    decoration = {
        rounding         = 12,
        active_opacity   = 1.0,
        inactive_opacity = 1.0,
        shadow = {
            enabled      = true,
            range        = 30,
            render_power = 5,
            offset       = { 0, 5 },
            color        = 0x70000000,
        },
    },
})

-- ==================
-- ANIMATIONS
-- ==================
hl.config({
    animations = {
        enabled = true,
    },
})
hl.animation({ leaf = "windowsIn",   enabled = true, speed = 3, bezier = "default" })
hl.animation({ leaf = "windowsOut",  enabled = true, speed = 3, bezier = "default" })
hl.animation({ leaf = "workspaces",  enabled = true, speed = 5, bezier = "default" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 4, bezier = "default" })
hl.animation({ leaf = "fade",        enabled = true, speed = 3, bezier = "default" })
hl.animation({ leaf = "border",      enabled = true, speed = 3, bezier = "default" })

-- ==================
-- LAYOUTS
-- ==================
hl.config({
    dwindle = {
        preserve_split = true,
    },
    master = {
        mfact = 0.5,
    },
})

-- ==================
-- MISC
-- ==================
hl.config({
    misc = {
        disable_hyprland_logo    = true,
        disable_splash_rendering = true,
    },
})

-- ==================
-- WINDOW RULES
-- ==================
hl.window_rule({ match = { class = "^(org\\.wezfurlong\\.wezterm)$" }, tile = true })

hl.window_rule({ match = { class = "^(org\\.gnome\\.)" }, rounding = 12 })

hl.window_rule({ match = { class = "^(gnome-control-center)$" }, tile = true })
hl.window_rule({ match = { class = "^(pavucontrol)$" }, tile = true })
hl.window_rule({ match = { class = "^(nm-connection-editor)$" }, tile = true })

hl.window_rule({ match = { class = "^(org\\.gnome\\.Calculator)$" }, float = true })
hl.window_rule({ match = { class = "^(gnome-calculator)$" }, float = true })
hl.window_rule({ match = { class = "^(galculator)$" }, float = true })
hl.window_rule({ match = { class = "^(blueman-manager)$" }, float = true })
-- hl.window_rule({ match = { class = "^(org\\.gnome\\.Nautilus)$" }, float = true })
hl.window_rule({ match = { class = "^(org\\.gnome\\.Loupe)$" }, float = true }) -- image viewer float on
hl.window_rule({ match = { class = "^(xdg-desktop-portal)$" }, float = true })

hl.window_rule({ match = { class = "^(steam)$", title = "^(notificationtoasts)" }, no_initial_focus = true })
hl.window_rule({ match = { class = "^(steam)$", title = "^(notificationtoasts)" }, pin = true })

hl.window_rule({ match = { class = "^(firefox)$", title = "^(Picture-in-Picture)$" }, float = true })
hl.window_rule({ match = { class = "^(zoom)$" }, float = true })

-- DMS windows floating by default
-- ! Hyprland doesn't size these windows correctly so disabling by default here
-- hl.window_rule({ match = { class = "^(org.quickshell)$" }, float = true })

hl.layer_rule({ match = { namespace = "^(quickshell)$" }, no_anim = true })
hl.layer_rule({ match = { namespace = "^dms:.*" }, no_anim = true })

-- ==================
-- DMS SOURCES (auto-generated)
-- ==================

require("dms.colors")
require("dms.outputs")
require("dms.layout")
require("dms.cursor")
require("dms.binds")
require("dms.windowrules")

-- my custom configs (loaded last so they override the above)
require("my-hypr.my-hyprland")
