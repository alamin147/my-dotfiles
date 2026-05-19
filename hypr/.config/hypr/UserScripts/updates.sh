#!/usr/bin/env bash

STATE_FILE="/tmp/waybar-updating"

get_updates() {
    dnf check-upgrade 2>/dev/null | \
    grep -E '^[a-zA-Z0-9]' | \
    wc -l
}

refresh_waybar() {
    pkill -RTMIN+8 waybar
}

module_output() {
    if [[ -f "$STATE_FILE" ]]; then
        printf '{"text":"󰏖","class":"updating"}\n'
        exit
    fi

    updates=$(get_updates)

    if [[ "$updates" -eq 0 ]]; then
        printf '{"text":"󰄬","class":"updated"}\n'
    else
        printf '{"text":"󰚰 %s","class":"pending"}\n' "$updates"
    fi
}

run_update() {
    touch "$STATE_FILE"
    refresh_waybar

    ghostty -e bash -c '
        sudo dnf upgrade --refresh
        echo
        read -p "Press Enter to close..."
    '

    rm -f "$STATE_FILE"
    refresh_waybar
}

show_updates() {
    updates=$(get_updates)

    if [[ "$updates" -eq 0 ]]; then
        notify-send "System Update" "System is fully updated"
    else
        notify-send "System Update" "Update available: $updates"
    fi
}

case "$1" in
    update)
        run_update
        ;;
    check)
        show_updates
        ;;
    *)
        module_output
        ;;
esac
