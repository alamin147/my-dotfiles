#!/usr/bin/env bash
# Game Mode - toggle Hyprland performance optimizations

set -euo pipefail

animations_enabled=$(hyprctl -j getoption animations:enabled | jq -r '.bool')

if [[ "$animations_enabled" == "true" ]]; then
    hyprctl eval 'hl.config({
        animations = { enabled = false },
        decoration = {
            shadow = { enabled = false },
            blur = { enabled = false },
            rounding = 0,
        },
        general = {
            gaps_in = 0,
            gaps_out = 0,
            border_size = 1,
        },
    })' >/dev/null
    dms notify "Gamemode" "Enabled"
else
    hyprctl reload
    dms notify "Gamemode" "Disabled"
fi
