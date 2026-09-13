#!/usr/bin/env bash

set -euo pipefail

scale="${1:-}"
if [[ ! "$scale" =~ ^[0-9]+([.][0-9]+)?$ ]] || ! awk -v n="$scale" 'BEGIN { exit !(n > 0) }'; then
    printf 'Usage: %s SCALE (SCALE must be greater than zero)\n' "$0" >&2
    exit 2
fi

current=$(hyprctl -j getoption cursor:zoom_factor | jq -er '.float')
next=$(
    awk -v current="$current" -v scale="$scale" 'BEGIN {
        value = current * scale
        if (value < 1) value = 1
        if (value > 10) value = 10
        printf "%.6f", value
    }'
)

hyprctl eval "hl.config({ cursor = { zoom_factor = $next } })" >/dev/null
