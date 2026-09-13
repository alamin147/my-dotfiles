#!/usr/bin/env bash

# Script for changing blurs on the fly
normal_passes=3 # lower passes means less blur, higher means more blur
normal_size=7
normal_active_opacity=1.0
normal_inactive_opacity=0.9

less_size=1
less_passes=1
less_active_opacity=0.82
less_inactive_opacity=0.68



STATE=$(
	hyprctl -j getoption decoration:blur:passes 2>/dev/null \
		| sed -n 's/.*"int":[[:space:]]*\([0-9-]\+\).*/\1/p'
)

if [[ -z "$STATE" ]]; then
	exit 1
fi

if [[ "$STATE" -eq "$normal_passes" ]]; then
	hyprctl eval "hl.config({ decoration = { blur = { size = $less_size, passes = $less_passes }, active_opacity = $less_active_opacity, inactive_opacity = $less_inactive_opacity } })"
 	# notify-send -e -u low -i "$notif/note.png" " Less Blur"
else
	hyprctl eval "hl.config({ decoration = { blur = { size = $normal_size, passes = $normal_passes }, active_opacity = $normal_active_opacity, inactive_opacity = $normal_inactive_opacity } })"
  	# notify-send -e -u low -i "$notif/ja.png" " Normal Blur"
fi
