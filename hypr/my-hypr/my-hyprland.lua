-- Migrated from my-hyprland.conf to the Hyprland 0.55+ Lua config format.
-- ========Context========
-- INPUT CONFIG / MONITOR CONFIG / WINDOW CONFIG / USER DECORATION CONFIG
-- EXPERIMENTAL CONFIG / SYSTEM CONFIG / KEYBINDS CONFIG

local mainMod    = "SUPER"
local home       = os.getenv("HOME") or "/home/alamin"
local scriptsDir = home .. "/.config/hypr/my-hypr/scripts"

-- ==================
-- STARTUP (exec-once)
-- ==================
hl.on("hyprland.start", function()
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    -- DMS provides the session's Polkit agent.
    hl.exec_cmd("gnome-keyring-daemon --start --components=secrets")
end)

-- ==================
-- INPUT CONFIG
-- ==================
hl.config({
    input = {
        kb_layout                 = "us",
        kb_variant                = "",
        kb_model                  = "",
        kb_options                = "ctrl:swapcaps", -- caps_lock and ctrl swap
        kb_rules                  = "",
        repeat_rate               = 50,
        repeat_delay              = 300,
        sensitivity               = 0, -- mouse sensitivity
        numlock_by_default        = true,
        left_handed               = false,
        follow_mouse              = 1,
        float_switch_override_focus = false,
        touchpad = {
            disable_while_typing   = false,
            natural_scroll         = true,
            clickfinger_behavior   = false,
            middle_button_emulation = false,
            tap_to_click           = true,
            drag_lock              = false,
        },
        touchdevice = {
            enabled = true,
        },
        tablet = {
            transform   = 0,
            left_handed = false,
        },
    },
})

-- ==================
-- WINDOW RULES
-- ==================
-- dropdown terminal
hl.window_rule({ match = { class = "^(com[.]alamin[.]dropdown-terminal)$" }, workspace = "special:dropdown silent" })
hl.window_rule({ match = { class = "^(com[.]alamin[.]dropdown-terminal)$" }, float = true })
hl.window_rule({ match = { class = "^(com[.]alamin[.]dropdown-terminal)$" }, size = { "monitor_w * 0.65", "monitor_h * 0.65" } })
hl.window_rule({ match = { class = "^(com[.]alamin[.]dropdown-terminal)$" }, move = { "monitor_w * 0.175", "monitor_h * 0.175" } })

-- browser tags
hl.window_rule({ match = { class = "^([Ff]irefox|org.mozilla.firefox|[Ff]irefox-esr|[Ff]irefox-bin)$" }, tag = "+browser" })
hl.window_rule({ match = { class = "^([Gg]oogle-chrome(-beta|-dev|-unstable)?)$" }, tag = "+browser" })
hl.window_rule({ match = { class = "^(chrome-.+-Default)$" }, tag = "+browser" })
hl.window_rule({ match = { class = "^([Cc]hromium)$" }, tag = "+browser" })
hl.window_rule({ match = { class = "^([Mm]icrosoft-edge(-stable|-beta|-dev|-unstable))$" }, tag = "+browser" })
hl.window_rule({ match = { class = "^(Brave-browser(-beta|-dev|-unstable)?)$" }, tag = "+browser" })
hl.window_rule({ match = { class = "^([Tt]horium-browser|[Cc]achy-browser)$" }, tag = "+browser" })
hl.window_rule({ match = { class = "^(zen-alpha|zen)$" }, tag = "+browser" })

-- Thorium reuses its running process and can ignore --class.
-- App-mode windows have an origin-like initial title ending in "_/".
hl.window_rule({
    name = "tile-thorium-webapps",
    match = {
        initial_class = "^([Tt]horium-browser|alamin-webapp)$",
        initial_title = "^.+_/$",
    },
    tile = true,
})

hl.window_rule({ match = { class = "^(swaync-control-center|swaync-notification-window|swaync-client|class)$" }, tag = "+notif" })

-- KooL settings tag
hl.window_rule({ match = { title = "^(KooL Quick Cheat Sheet)$" }, tag = "+KooL_Cheat" })
hl.window_rule({ match = { title = "^(KooL Hyprland Settings)$" }, tag = "+KooL_Settings" })
hl.window_rule({ match = { class = "^(nwg-displays|nwg-look)$" }, tag = "+KooL-Settings" })

-- terminal tags
hl.window_rule({ match = { class = "^(Ghostty|ghostty|Alacritty|kitty|kitty-dropterm)$" }, tag = "+terminal" })
-- Minecraft tags
hl.window_rule({ match = { class = "^(org-tlauncher-tlauncher-rmo-TLauncher)$" }, tag = "+minecraft" })
-- Localsend
hl.window_rule({ match = { class = "^(localsend)$" }, tag = "+localsend" })
-- email tags
hl.window_rule({ match = { class = "^([Tt]hunderbird|org.mozilla.Thunderbird)$" }, tag = "+email" })
hl.window_rule({ match = { class = "^(eu.betterbird.Betterbird)$" }, tag = "+email" })
hl.window_rule({ match = { class = "^(org.gnome.Evolution)$" }, tag = "+email" })
-- project tags
hl.window_rule({ match = { class = "^(codium|codium-url-handler|VSCodium)$" }, tag = "+projects" })
hl.window_rule({ match = { class = "^(VSCode|code|code-url-handler)$" }, tag = "+projects" })
hl.window_rule({ match = { class = "^(jetbrains-.+)$" }, tag = "+projects" })
hl.window_rule({ match = { class = "^(dev.zed.Zed|antigravity)$" }, tag = "+projects" })
-- screenshare tags
hl.window_rule({ match = { class = "^(com.obsproject.Studio)$" }, tag = "+screenshare" })
-- spotify tags
hl.window_rule({ match = { class = "^(Spotify)$" }, tag = "+spotify" })
hl.window_rule({ match = { class = "^(spotify)$" }, tag = "+spotify" })
hl.window_rule({ match = { class = "^(com.spotify.Client)$" }, tag = "+spotify" })
-- IM tags
hl.window_rule({ match = { class = "^([Dd]iscord|[Ww]ebCord|[Vv]esktop)$" }, tag = "+im" })
hl.window_rule({ match = { class = "^([Ff]erdium)$" }, tag = "+im" })
hl.window_rule({ match = { class = "^([Ww]hatsapp-for-linux)$" }, tag = "+im" })
hl.window_rule({ match = { class = "^(org.telegram.desktop|io.github.tdesktop_x64.TDesktop)$" }, tag = "+im" })
hl.window_rule({ match = { class = "^(teams-for-linux)$" }, tag = "+im" })
hl.window_rule({ match = { class = "^(im.riot.Riot|Element)$" }, tag = "+im" })
-- game tags
hl.window_rule({ match = { class = "^(gamescope)$" }, tag = "+games" })
hl.window_rule({ match = { class = "^(steam_app_\\\\d+)$" }, tag = "+games" })
-- gamestore tags
hl.window_rule({ match = { class = "^([Ss]team)$" }, tag = "+gamestore" })
hl.window_rule({ match = { title = "^([Ll]utris)$" }, tag = "+gamestore" })
hl.window_rule({ match = { class = "^(com.heroicgameslauncher.hgl)$" }, tag = "+gamestore" })
-- file-manager tags
hl.window_rule({ match = { class = "^([Tt]hunar|org.gnome.Nautilus|[Pp]cmanfm-qt)$" }, tag = "+file-manager" })
hl.window_rule({ match = { class = "^(app.drey.Warp)$" }, tag = "+file-manager" })
-- wallpaper tags
hl.window_rule({ match = { class = "^([Ww]aytrogen)$" }, tag = "+wallpaper" })
-- multimedia tags
hl.window_rule({ match = { class = "^([Aa]udacious)$" }, tag = "+multimedia" })
-- multimedia-video tags
hl.window_rule({ match = { class = "^([Mm]pv|vlc)$" }, tag = "+multimedia_video" })
-- settings tags
hl.window_rule({ match = { title = "^(ROG Control)$" }, tag = "+settings" })
hl.window_rule({ match = { class = "^(wihotspot(-gui)?)$" }, tag = "+settings" })
hl.window_rule({ match = { class = "^([Bb]aobab|org.gnome.[Bb]aobab)$" }, tag = "+settings" })
hl.window_rule({ match = { class = "^(gnome-disks|wihotspot(-gui)?)$" }, tag = "+settings" })
hl.window_rule({ match = { title = "(Kvantum Manager)" }, tag = "+settings" })
hl.window_rule({ match = { class = "^(file-roller|org.gnome.FileRoller)$" }, tag = "+settings" })
hl.window_rule({ match = { class = "^(nm-applet|nm-connection-editor|blueman-manager)$" }, tag = "+settings" })
hl.window_rule({ match = { class = "^(pavucontrol|org.pulseaudio.pavucontrol|com.saivert.pwvucontrol)$" }, tag = "+settings" })
hl.window_rule({ match = { class = "^(qt5ct|qt6ct)$" }, tag = "+settings" })
hl.window_rule({ match = { class = "(xdg-desktop-portal-gtk)" }, tag = "+settings" })
hl.window_rule({ match = { class = "^(org.kde.polkit-kde-authentication-agent-1)$" }, tag = "+settings" })
hl.window_rule({ match = { class = "^([Rr]ofi)$" }, tag = "+settings" })
hl.window_rule({ match = { class = "^(btrfs-assistant)$" }, tag = "+settings" })
hl.window_rule({ match = { class = "^(timeshift-gtk)$" }, tag = "+settings" })
-- viewer tags
hl.window_rule({ match = { class = "^(gnome-system-monitor|org.gnome.SystemMonitor|io.missioncenter.MissionCenter)$" }, tag = "+viewer" })
hl.window_rule({ match = { class = "^(evince)$" }, tag = "+viewer" })
hl.window_rule({ match = { class = "^(eog|org.gnome.Loupe)$" }, tag = "+viewer" })

-- Some special override rules
hl.window_rule({ match = { tag = "multimedia_video" }, no_blur = true })
hl.window_rule({ match = { tag = "multimedia_video" }, opacity = "1.0" })
hl.window_rule({ match = { tag = "multimedia" }, no_blur = true })
hl.window_rule({ match = { tag = "multimedia" }, opacity = "1.0" })

-- POSITION
hl.window_rule({ match = { tag = "KooL_Cheat" }, center = true })
hl.window_rule({ match = { tag = "KooL-Settings" }, center = true })
hl.window_rule({ match = { title = "^(ROG Control)$" }, center = true })
hl.window_rule({ match = { title = "^(Keybindings)$" }, center = true })
hl.window_rule({ match = { class = "^(pavucontrol|org.pulseaudio.pavucontrol|com.saivert.pwvucontrol)$" }, center = true })
hl.window_rule({ match = { class = "^([Ff]erdium)$" }, center = true })

-- avoid idle for fullscreen apps
hl.window_rule({ match = { fullscreen = true }, idle_inhibit = "fullscreen" })

-- FLOAT
hl.window_rule({ match = { tag = "minecraft" }, float = true, center = true })
hl.window_rule({ match = { tag = "localsend" }, float = true, size = { "monitor_w * 0.3", "monitor_h * 0.6" } })
hl.window_rule({ match = { tag = "KooL_Cheat" }, float = true })
hl.window_rule({ match = { tag = "wallpaper" }, float = true, center = true })
hl.window_rule({ match = { tag = "settings" }, float = true, center = true })
hl.window_rule({ match = { tag = "viewer" }, float = true, center = true })
hl.window_rule({ match = { tag = "KooL-Settings" }, float = true, center = true })
hl.window_rule({ match = { class = "([Zz]oom|onedriver|onedriver-launcher)" }, float = true })
hl.window_rule({ match = { class = "(org.gnome.Calculator|qalculate-gtk)" }, float = true })
hl.window_rule({ match = { class = "([Oo]bsidian)" }, float = true , center=true})
hl.window_rule({ match = { class = "^(mpv|com.github.rafostar.Clapper)$" }, float = true })
hl.window_rule({ match = { class = "^([Qq]alculate-gtk)$" }, float = true })
hl.window_rule({ match = { class = "^([Ff]erdium)$" }, float = true })

-- popups and dialogue
hl.window_rule({ match = { title = "^(Authentication Required)$" }, float = true, center = true })
-- NOTE: `negative:` (not-match) selectors below are preserved verbatim; verify behavior after switching to Lua.
hl.window_rule({ match = { class = "(codium|codium-url-handler|VSCodium)", title = "negative:(.*codium.*|.*VSCodium.*)" }, float = true })
hl.window_rule({ match = { class = "^(com.heroicgameslauncher.hgl)$", title = "negative:(Heroic Games Launcher)" }, float = true })
hl.window_rule({ match = { class = "^([Ss]team)$", title = "negative:^([Ss]team)$" }, float = true })
-- dms settings
hl.window_rule({ match = { class = "^com.danklinux.dms$" }, float = false })
-- Xdg-desktop-portal-gtk
hl.window_rule({ match = { class = "^(Xdg-desktop-portal-gtk)$" }, float = true, center = true })
hl.window_rule({ match = { title = "^(Add Folder to Workspace)$" }, float = true, size = { "monitor_w * 0.7", "monitor_h * 0.6" }, center = true })
hl.window_rule({ match = { title = "^(Save As)$" }, float = true, size = { "monitor_w * 0.7", "monitor_h * 0.6" }, center = true })
hl.window_rule({ match = { initial_title = "(Open Files)" }, float = true, size = { "monitor_w * 0.7", "monitor_h * 0.6" } })
hl.window_rule({ match = { title = "^(SDDM Background)$" }, float = true, center = true, size = { "monitor_w * 0.16", "monitor_h * 0.12" } })
hl.window_rule({ match = { class = "^(yad)$" }, float = true, center = true, size = { "monitor_w * 0.2", "monitor_h * 0.2" } })
hl.window_rule({ match = { class = "^(hyprland-donate-screen)$" }, float = true, center = true })

-- OPACITY/Transparent
hl.window_rule({ match = { tag = "browser" }, opacity = "1 1" })
hl.window_rule({ match = { tag = "projects" }, opacity = "0.92 0.9" })
hl.window_rule({ match = { tag = "im" }, opacity = "0.9 0.8" })
hl.window_rule({ match = { tag = "multimedia" }, opacity = "0.94 0.86" })
hl.window_rule({ match = { tag = "file-manager" }, opacity = "0.8 0.7" })
hl.window_rule({ match = { tag = "terminal" }, opacity = "0.9 0.7" })
hl.window_rule({ match = { tag = "settings" }, opacity = "0.8 0.7" })
hl.window_rule({ match = { tag = "viewer" }, opacity = "0.82 0.75" })
hl.window_rule({ match = { tag = "wallpaper" }, opacity = "0.9 0.7" })
hl.window_rule({ match = { tag = "spotify" }, opacity = "0.8 0.7" })
hl.window_rule({ match = { class = "^(gedit|org.gnome.TextEditor|mousepad)$" }, opacity = "0.8 0.7" })
hl.window_rule({ match = { class = "^(deluge)$" }, opacity = "0.9 0.8" })
hl.window_rule({ match = { class = "^(seahorse)$" }, opacity = "0.9 0.8" })
hl.window_rule({ match = { title = "^(Picture-in-Picture)$" }, opacity = "0.95 0.75" })
hl.window_rule({ match = { title = "^(Settings)$" }, opacity = "0.85 0.8" })

-- SIZE
hl.window_rule({ match = { tag = "KooL_Cheat" }, size = { "monitor_w * 0.65", "monitor_h * 0.9" } })
hl.window_rule({ match = { tag = "wallpaper" }, size = { "monitor_w * 0.7", "monitor_h * 0.7" } })
hl.window_rule({ match = { tag = "settings" }, size = { "monitor_w * 0.7", "monitor_h * 0.7" } })
hl.window_rule({ match = { class = "^([Ff]erdium)$" }, size = { "monitor_w * 0.6", "monitor_h * 0.7" } })

-- BLUR & FULLSCREEN
hl.window_rule({ match = { tag = "games" }, no_blur = true, fullscreen = false })
hl.window_rule({ match = { tag = "games" }, fullscreen = false })
hl.window_rule({ match = { class = "^(jetbrains-.+)" }, no_initial_focus = true })
hl.window_rule({ match = { title = "^(wind.*)$" }, no_initial_focus = true })

-- LAYER RULES
hl.layer_rule({ match = { namespace = "rofi" }, blur = true })
hl.layer_rule({ match = { namespace = "notifications" }, blur = true })
hl.layer_rule({ match = { namespace = "quickshell:overview" }, blur = true })
hl.layer_rule({ match = { namespace = "quickshell:overview" }, ignore_alpha = 0.5 })

-- Named rules for special cases
hl.window_rule({
    name  = "Whatsapp-zapzap",
    match = { class = "^([Ww]hatsapp-for-linux|ZapZap|com.rtosta.zapzap)$" },
    size   = { "monitor_w * 0.6", "monitor_h * 0.7" },
    center = true,
})
hl.window_rule({
    name  = "Picture-in-Picture",
    match = { title = "^(Picture-in-Picture)$" },
    float             = true,
    move              = { "monitor_w * 0.72", "monitor_h * 0.07" },
    opacity           = "0.95 0.75",
    pin               = true,
    keep_aspect_ratio = true,
    size              = { "monitor_w * 0.3", "monitor_h * 0.3" },
})
-- Thunar copy progress dialog
hl.window_rule({
    name  = "Thunar-Progress-bar",
    match = { class = "^(thunar)$", title = "^(File Operation Progress)$" },
    float  = true,
    center = true,
    size   = { "monitor_w * 0.26", "monitor_h * 0.18" },
})

-- ==================
-- USER DECORATION CONFIG
-- ==================
hl.config({
    general = {
        border_size      = 0,
        gaps_in          = 6,
        gaps_out         = 10,
        resize_on_border = true,
    },
    decoration = {
        rounding = 20,
        -- Keep the current workspace visually unchanged behind dropdowns.
        dim_special = 0.0,
        blur = {
            enabled          = true,
            size             = 7,
            passes           = 3,
            new_optimizations = true,
            xray             = true,
            ignore_opacity   = true,
            special          = false,
            popups           = true,
        },
    },
})

-- Custom animations (loaded from the animations library)
require("my-hypr.animations.fancy-claude")

-- ==================
-- EXPERIMENTAL CONFIG
-- ==================
hl.device({
    name    = "pnp0c50:01-0911:5288-touchpad",
    enabled = true,
})

-- Toolkit Backend Variables
hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("CLUTTER_BACKEND", "wayland")
-- XDG Specifications
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")

hl.config({
    misc = {
        disable_hyprland_logo     = true,
        disable_splash_rendering  = true,
        vrr                       = 2,
        mouse_move_enables_dpms   = true,
        enable_swallow            = false,
        swallow_regex             = "^(kitty)$",
        focus_on_activate         = false,
        initial_workspace_tracking = 0,
        middle_click_paste        = false,
        enable_anr_dialog         = true, -- Application not Responding (ANR)
        anr_missed_pings          = 15,   -- ANR threshold (default 1 is too low)
        allow_session_lock_restore = true, -- prevent lockscreen crash on resume from suspend
        on_focus_under_fullscreen = 1,     -- 1: new focused window takes over fullscreen
    },
    binds = {
        workspace_back_and_forth = true,
        allow_workspace_cycles   = true,
        pass_mouse_when_bound    = false,
    },
    render = {
        direct_scanout = 0,
    },
    cursor = {
        sync_gsettings_theme     = true,
        no_hardware_cursors      = 1, -- change to 1 to disable hardware cursors
        enable_hyprcursor        = true,
        warp_on_change_workspace = 2,
        no_warps                 = true,
    },
})

-- ==================
-- SYSTEM CONFIG (gestures)
-- ==================
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
-- Zoom in / out (4-finger up / down)
hl.gesture({ fingers = 4, direction = "up", action = function()
    hl.exec_cmd(scriptsDir .. "/ChangeZoom.sh 1.5")
end })
hl.gesture({ fingers = 4, direction = "down", action = function()
    hl.exec_cmd(scriptsDir .. "/ChangeZoom.sh 0.6666667")
end })
-- NOTE: the legacy `gestures { workspace_swipe_* }` tuning options (distance=500, invert=true,
-- min_speed_to_force=30, cancel_ratio=0.5, create_new=true, forever=true) were removed with the
-- old gesture system. Re-tune with the new trackpad gesture API if the swipe feel differs.

-- ==================
-- KEYBINDS CONFIG
-- ==================
hl.bind(mainMod .. " + SHIFT + Return", hl.dsp.exec_cmd(scriptsDir .. "/Dropterminal.sh ghostty"))

hl.bind(mainMod .. " + ALT + slash", hl.dsp.exec_cmd("dms ipc call audio micmute")) -- toggle mic mute
hl.bind(mainMod .. " + ALT + O", hl.dsp.exec_cmd(scriptsDir .. "/ChangeBlur.sh"), { description = "toggle blur" })
hl.bind(mainMod .. " + SPACE", hl.dsp.window.float({ action = "toggle" }), { description = "Float current window" })

-- Desktop zooming / magnifier
hl.bind(mainMod .. " + ALT + mouse_down", hl.dsp.exec_cmd(scriptsDir .. "/ChangeZoom.sh 2"), { description = "zoom in" })
hl.bind(mainMod .. " + ALT + mouse_up", hl.dsp.exec_cmd(scriptsDir .. "/ChangeZoom.sh 0.5"), { description = "zoom out" })

-- Move active window silently to workspace (SUPER + CTRL + [1-0])
for i = 1, 10 do
    local key = i == 10 and "0" or tostring(i)
    hl.bind(mainMod .. " + CTRL + " .. key, hl.dsp.window.move({ workspace = tostring(i), follow = false }),
        { description = "move silently to workspace " .. i })
end

-- media controls
hl.bind(mainMod .. " + ALT + backslash",    hl.dsp.exec_cmd("dms ipc call mpris playPause")) -- media play pause
hl.bind(mainMod .. " + ALT + bracketleft",  hl.dsp.exec_cmd("dms ipc call mpris previous"))  -- media previous
hl.bind(mainMod .. " + ALT + bracketright", hl.dsp.exec_cmd("dms ipc call mpris next"))      -- media next

-- SUPER + SHIFT + p = pin window (float + pin)
hl.bind(mainMod .. " + SHIFT + P", function()
    hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
    hl.dispatch(hl.dsp.window.pin())
end, { description = "pin app" })

-- Power
hl.bind(mainMod .. " + SHIFT + ALT + S", hl.dsp.exec_cmd("systemctl poweroff"))

-- Screen recording
hl.bind("ALT + " .. mainMod .. " + semicolon", hl.dsp.exec_cmd(scriptsDir .. "/ScreenRecord.sh full")) -- screen record fullscreen
hl.bind(mainMod .. " + ALT + apostrophe",      hl.dsp.exec_cmd(scriptsDir .. "/ScreenRecord.sh area")) -- screen record area

-- -------------------------------------------------
-- VS Code project launcher submap
-- Press: SUPER + SHIFT + C, then g/l/m/d/h
-- -------------------------------------------------
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.submap("code_projects"))

local working  = "/home/alamin/All/working/HTML/stn/portfolio-projects"
local research = "/home/alamin/Research"

hl.define_submap("code_projects", function()
    local function openAndReset(path)
        return function()
            hl.exec_cmd('code --new-window "' .. path .. '"')
            hl.dispatch(hl.dsp.submap("reset"))
        end
    end

    hl.bind("g", openAndReset(working .. "/game_online"))
    hl.bind("l", openAndReset(research .. "/lego-build-LLM"))
    hl.bind("m", openAndReset(research .. "/multimodal"))
    hl.bind("d", openAndReset("/home/alamin/dms-dotfiles"))
    hl.bind("h", openAndReset("/home/alamin/.config/hypr"))

    -- Cancel / exit submap
    hl.bind("ESCAPE",    hl.dsp.submap("reset"))
    hl.bind("Q",         hl.dsp.submap("reset"))
    hl.bind("BACKSPACE", hl.dsp.submap("reset"))
end)

-- DMS
hl.bind("ALT + SPACE", hl.dsp.exec_cmd("dms ipc call spotlight-bar toggle"))
hl.bind(mainMod .. " + CTRL + W", hl.dsp.exec_cmd("dms ipc call wallpaperSearch open")) -- wallpaper search window
hl.bind(mainMod .. " + SHIFT + CTRL + A",
    hl.dsp.exec_cmd(home .. "/.local/bin/dms-agent window"),
    { description = "Choose and launch AI agent" })

-- Correct user bindings after the auto-generated DMS bind file is loaded.
-- Keeping these overrides here prevents a future DMS regeneration from
-- restoring paths that belonged to the previous installation.
hl.unbind(mainMod .. " + W")
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("dms ipc call wallpaperCarousel toggle"))

hl.unbind(mainMod .. " + apostrophe")
hl.bind(mainMod .. " + apostrophe", hl.dsp.exec_cmd(scriptsDir .. "/ScreenRecord.sh area"))

hl.unbind(mainMod .. " + semicolon")
hl.bind(mainMod .. " + semicolon", hl.dsp.exec_cmd(scriptsDir .. "/ScreenRecord.sh full"))

hl.unbind(mainMod .. " + ALT + M")
hl.bind(mainMod .. " + ALT + M", hl.dsp.exec_cmd("java -jar " .. home .. "/TLauncher.jar"))
