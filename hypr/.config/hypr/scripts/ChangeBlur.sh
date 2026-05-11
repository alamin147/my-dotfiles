#!/usr/bin/env bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Script for changing blurs on the fly
normal_passes=3 # lower passes means less blur, higher means more blur
normal_size=7
less_passes=1
less_size=2

notif="$HOME/.config/swaync/images"

STATE=$(hyprctl -j getoption decoration:blur:passes | jq ".int")

if [ "${STATE}" == $normal_passes ]; then
	hyprctl keyword decoration:blur:size $less_size
	hyprctl keyword decoration:blur:passes $less_passes
 	notify-send -e -u low -i "$notif/note.png" " Less Blur"
else
	hyprctl keyword decoration:blur:size $normal_size
	hyprctl keyword decoration:blur:passes $normal_passes
  	notify-send -e -u low -i "$notif/ja.png" " Normal Blur"
fi
