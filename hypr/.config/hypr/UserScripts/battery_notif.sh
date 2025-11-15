#!/bin/bash

# Correct battery path
BAT_PATH="/sys/class/power_supply/BAT1"

BATTERY=$(cat "$BAT_PATH/capacity")
STATUS=$(cat "$BAT_PATH/status")

SOUND_DISCHARGE="/home/alamin/.config/hypr/audio/low_battery-329310.mp3"
# SOUND_CHARGING="/home/alamin/.config/hypr/audio/charging.mp3"

SOUND_CHARGING="/home/alamin/.config/hypr/audio/audio/cute-cat-meow.mp3"

if [[ "$STATUS" == "Discharging" ]]; then
    if [[ "$BATTERY" -le 20 && "$BATTERY" -gt 10 ]]; then
        pw-play "$SOUND_CHARGING" &
        notify-send -u normal -t 10000 -i battery-low "LOW POWER!" \
            "Battery: ${BATTERY}%\nPlug in soon meow! 😼"
    elif [[ "$BATTERY" -le 10 && "$BATTERY" -gt 5 ]]; then
    pw-play "$SOUND_CHARGING" &
        notify-send -u critical -t 12000 -i battery-caution "😿 CRITICAL BATTERY!" \
            "Battery: ${BATTERY}%\nFeed me power or I faint!"
    elif [[ "$BATTERY" -le 5 ]]; then
    pw-play "$SOUND_CHARGING" &
        notify-send -u critical -t 15000 -i battery-empty "💀 BATTERY DEAD SOON!" \
            "Battery: ${BATTERY}%\nSay your goodbyes"
    fi
elif [[ "$STATUS" == "Charging" ]]; then
    if [[ "$BATTERY" -ge 78 ]]; then
        pw-play "$SOUND_CHARGING" &
        notify-send -u normal -t 10000 "😼 FULLY CHARGED!" \
            "Battery: ${BATTERY}%\nYou can unplug me meow!"
    fi
fi
