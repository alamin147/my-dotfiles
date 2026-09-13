#!/usr/bin/env bash
set -euo pipefail

# This follows Omarchy's Chromium theming setup. Matugen writes the current
# theme's background as R,G,B; Chromium consumes the same color through its
# managed BrowserThemeColor policy.
theme_file="${CHROMIUM_THEME_FILE:-${THORIUM_THEME_FILE:-$HOME/.config/chromium-theme/chromium.theme}}"
policy_file="${CHROMIUM_POLICY_FILE:-${THORIUM_POLICY_FILE:-}}"
policy_changed=0

log() {
  printf 'Chromium theme: %s\n' "$*"
}

if [[ ! -f "$theme_file" ]]; then
  log "theme color file is missing: $theme_file"
  exit 0
fi

theme_color="$(tr -d '[:space:]' < "$theme_file")"
theme_rgb="$theme_color"
if [[ "$theme_color" =~ ^rgb\(([0-9]{1,3}),([0-9]{1,3}),([0-9]{1,3})\)$ ]]; then
  theme_rgb="${BASH_REMATCH[1]},${BASH_REMATCH[2]},${BASH_REMATCH[3]}"
elif [[ "$theme_color" =~ ^#([0-9A-Fa-f]{6})$ ]]; then
  theme_hex_digits="${BASH_REMATCH[1]}"
  theme_rgb="$(printf '%d,%d,%d' \
    "0x${theme_hex_digits:0:2}" \
    "0x${theme_hex_digits:2:2}" \
    "0x${theme_hex_digits:4:2}")"
fi

if [[ "$theme_rgb" != "$theme_color" ]]; then
  temporary_theme="$(mktemp "${theme_file}.XXXXXX")"
  printf '%s\n' "$theme_rgb" > "$temporary_theme"
  mv -f "$temporary_theme" "$theme_file"
fi

if [[ ! "$theme_rgb" =~ ^([0-9]{1,3}),([0-9]{1,3}),([0-9]{1,3})$ ]] ||
  (( BASH_REMATCH[1] > 255 || BASH_REMATCH[2] > 255 || BASH_REMATCH[3] > 255 )); then
  log "invalid RGB theme color: $theme_rgb"
  exit 1
fi

theme_hex="$(printf '#%02x%02x%02x' "${BASH_REMATCH[1]}" "${BASH_REMATCH[2]}" "${BASH_REMATCH[3]}")"

write_policy() {
  local policy_dir="$1"
  local target="$policy_dir/color.json"
  local temporary

  [[ -d "$policy_dir" && -w "$policy_dir" ]] || return 0
  temporary="$(mktemp "$policy_dir/.color.json.XXXXXX")"
  printf '{"BrowserThemeColor":"%s","BrowserColorScheme":"device"}\n' "$theme_hex" > "$temporary"

  if [[ -f "$target" ]] && cmp -s "$temporary" "$target"; then
    rm -f "$temporary"
    return 0
  fi

  mv -f "$temporary" "$target"
  policy_changed=1
  log "applied $theme_hex to $target"
}

if [[ -n "$policy_file" ]]; then
  write_policy "$policy_file"
else
  # Thorium builds have used both names for the Chromium policy root.
  write_policy /etc/chromium/policies/managed
  write_policy /etc/thorium/policies/managed
fi

browser_running=0
for process_name in thorium thorium-browser chromium chrome; do
  if pgrep -u "$(id -u)" -x "$process_name" >/dev/null 2>&1; then
    browser_running=1
    break
  fi
done

if (( policy_changed == 1 && browser_running == 1 )); then
  # Policy is already durable at this point; do not make Matugen wait for
  # Thorium's refresh process to finish.
  /usr/bin/thorium-browser --refresh-platform-policy --no-startup-window >/dev/null 2>&1 &
fi
