#!/bin/bash

# Correct battery path
BAT_PATH="/sys/class/power_supply/BAT1"

BATTERY=$(cat "$BAT_PATH/capacity")
STATUS=$(cat "$BAT_PATH/status")

if [[ "$STATUS" == "Discharging" ]]; then
    if [[ "$BATTERY" -le 20 && "$BATTERY" -gt 10 ]]; then
        notify-send -u normal -t 10000 -i battery-low "LOW POWER!" \
            "Battery: ${BATTERY}%\nPlug in soon meow! 😼"
    elif [[ "$BATTERY" -le 10 && "$BATTERY" -gt 5 ]]; then
        notify-send -u critical -t 12000 -i battery-caution "😿 CRITICAL BATTERY!" \
            "Battery: ${BATTERY}%\nFeed me power or I faint!"
    elif [[ "$BATTERY" -le 5 ]]; then
        notify-send -u critical -t 15000 -i battery-empty "💀 BATTERY DEAD SOON!" \
            "Battery: ${BATTERY}%\nSay your goodbyes"
    fi
elif [[ "$STATUS" == "Charging" ]]; then
    if [[ "$BATTERY" -ge 80 ]]; then
        notify-send -u normal -t 10000 -i battery-full-charged "😼 FULLY CHARGED!" \
            "Battery: ${BATTERY}%\nYou can unplug me meow!"
    fi
fi
