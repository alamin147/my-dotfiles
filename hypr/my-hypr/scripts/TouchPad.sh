#!/usr/bin/env bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# For disabling touchpad.
# Edit the Touchpad_Device on ~/.config/hypr/UserConfigs/Laptops.conf according to your system
# use hyprctl devices to get your system touchpad device name
# source https://github.com/hyprwm/Hyprland/discussions/4283?sort=new#discussioncomment-8648109

set -euo pipefail

touchpad_device="${TOUCHPAD_DEVICE:-}"
if [[ -z "$touchpad_device" ]]; then
    touchpad_device="$(
        hyprctl -j devices \
            | jq -r '.mice[]? | select(.name | test("touchpad"; "i")) | .name' \
            | head -n 1
    )"
fi

if [[ -z "$touchpad_device" ]]; then
    dms notify "Touchpad" "No touchpad device was detected"
    exit 1
fi

status_file="${XDG_RUNTIME_DIR:-/tmp}/touchpad.status"

set_touchpad() {
    local enabled="$1"
    hyprctl eval "hl.device({ name = \"$touchpad_device\", enabled = $enabled })" >/dev/null
}

enable_touchpad() {
    printf "true" >"$status_file"
    set_touchpad true
    dms notify "Touchpad" "Enabled"
}

disable_touchpad() {
    printf "false" >"$status_file"
    set_touchpad false
    dms notify "Touchpad" "Disabled"
}

current_state="false"
if [[ -f "$status_file" ]]; then
    current_state="$(<"$status_file")"
fi

if [[ "$current_state" == "true" ]]; then
    disable_touchpad
else
    enable_touchpad
fi
