#!/bin/bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Script for changing blurs on the fly

notif="$HOME/.config/swaync/images"

STATE=$(hyprctl -j getoption decoration:blur:passes | jq ".int")

if [ "${STATE}" == "3" ]; then
	hyprctl keyword decoration:blur:size 3
	hyprctl keyword decoration:blur:passes 1
 	notify-send -e -u low -i "$notif/note.png" " Less Blur"
else
	hyprctl keyword decoration:blur:size 7
	hyprctl keyword decoration:blur:passes 3
  	notify-send -e -u low -i "$notif/ja.png" " Normal Blur"
fi
