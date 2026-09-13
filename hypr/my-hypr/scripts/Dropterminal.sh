#!/usr/bin/env bash

set -euo pipefail

DROPDOWN_CLASS="com.alamin.dropdown-terminal"
SPECIAL_NAME="dropdown"
SPECIAL_WORKSPACE="special:${SPECIAL_NAME}"

if [[ $# -eq 0 ]]; then
	TERMINAL_CMD=(ghostty --class="$DROPDOWN_CLASS")
elif [[ "$1" == "ghostty" ]]; then
	shift
	TERMINAL_CMD=(ghostty --class="$DROPDOWN_CLASS" "$@")
else
	TERMINAL_CMD=("$@")
fi

terminal_command_string() {
	printf "%q " "${TERMINAL_CMD[@]}"
}

dropdown_exists() {
	hyprctl clients -j 2>/dev/null \
		| jq -e --arg class "$DROPDOWN_CLASS" 'any(.[]; .class == $class)' >/dev/null
}

wait_for_dropdown() {
	for _ in {1..100}; do
		if dropdown_exists; then
			return 0
		fi
		sleep 0.05
	done

	return 1
}

toggle_dropdown() {
	hyprctl eval "hl.dispatch(hl.dsp.workspace.toggle_special(\"$SPECIAL_NAME\"))" >/dev/null
}

if dropdown_exists; then
	toggle_dropdown
	exit 0
fi

# The class-based rule in my-hyprland.lua starts this window hidden on the
# special workspace. The old `hyprctl dispatch exec "[workspace ...]"` form is
# hyprlang syntax and is rejected by Hyprland's Lua provider (0.55+).
"${TERMINAL_CMD[@]}" >/dev/null 2>&1 &
if wait_for_dropdown; then
	toggle_dropdown
	exit 0
fi

printf 'Dropdown terminal did not create a window within 5 seconds: %s\n' \
	"$(terminal_command_string)" >&2
exit 1
