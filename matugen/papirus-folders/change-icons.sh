#!/usr/bin/env bash

set -euo pipefail

# Resolve papirus-folders explicitly because graphical post-hooks may not have
# the same PATH as an interactive shell.
if [[ -z "${PAPIRUS_FOLDERS:-}" ]]; then
  if command -v papirus-folders >/dev/null 2>&1; then
    PAPIRUS_FOLDERS="$(command -v papirus-folders)"
  elif [[ -x "$HOME/.local/bin/papirus-folders" ]]; then
    PAPIRUS_FOLDERS="$HOME/.local/bin/papirus-folders"
  elif [[ -x /usr/bin/papirus-folders ]]; then
    PAPIRUS_FOLDERS="/usr/bin/papirus-folders"
  else
    echo "papirus-folders is not installed." >&2
    exit 1
  fi
fi
PAPIRUS_THEME="${PAPIRUS_THEME:-Papirus-Dark}"
SYSTEM_ICON_DIR="/usr/share/icons"
LOCAL_ICON_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/icons"
COLOR_FILE="${PAPIRUS_COLOR_FILE:-$HOME/.config/matugen/papirus-folders/folder-color.txt}"

copy_icon_theme_if_needed() {
  local theme="$1"
  local src="$SYSTEM_ICON_DIR/$theme"
  local dst="$LOCAL_ICON_DIR/$theme"

  if [[ -f "$dst/index.theme" && -e "$dst/48x48/places/folder.svg" ]]; then
    return 0
  fi

  if [[ -L "$dst" ]]; then
    echo "Local icon theme '$dst' is a symlink; leaving it untouched." >&2
    return 1
  fi

  if [[ ! -d "$src" ]]; then
    echo "System icon theme '$src' was not found." >&2
    return 1
  fi

  mkdir -p "$dst"
  echo "Preparing writable local icon theme: $dst"
  cp -a "$src/." "$dst/"
}

ensure_local_papirus_theme() {
  mkdir -p "$LOCAL_ICON_DIR"

  # Papirus-Dark links its folder icons back to the base Papirus theme, so both
  # need local writable copies before papirus-folders can run without sudo.
  copy_icon_theme_if_needed "Papirus"
  copy_icon_theme_if_needed "$PAPIRUS_THEME"

  if [[ ! -w "$LOCAL_ICON_DIR/Papirus/48x48/places/folder.svg" ]]; then
    echo "Local Papirus folder icons are still not writable." >&2
    return 1
  fi
}

PREVIEW_MODE=0
PREVIEW_HEX=""

if [[ "${1:-}" == "--preview" ]]; then
  PREVIEW_MODE=1
  PREVIEW_HEX="${2:-}"
  shift 2 || true
fi

if [[ "$#" -gt 0 ]]; then
  echo "Usage: $0 [--preview HEX]" >&2
  exit 2
fi

declare -A matugen_colors=()
declare -A role_weights=(
  ["source"]=52
  ["primary"]=38
  ["secondary"]=6
  ["tertiary"]=4
)

add_matugen_color() {
  local role="$1"
  local value="$2"

  role="${role//-/_}"
  role="${role,,}"
  value="${value//[[:space:]]/}"
  value="${value#\#}"
  value="${value,,}"

  [[ "$role" == "source_color" ]] && role="source"

  if [[ "$value" =~ ^[0-9a-f]{6}$ ]]; then
    matugen_colors["$role"]="$value"
  fi
}

read_matugen_colors() {
  local line

  if [[ "$PREVIEW_MODE" -eq 1 ]]; then
    add_matugen_color "source" "$PREVIEW_HEX"
    add_matugen_color "primary" "$PREVIEW_HEX"
    return 0
  fi

  while IFS= read -r line || [[ -n "$line" ]]; do
    line="${line//$'\r'/}"

    if [[ "$line" =~ ^[[:space:]]*([A-Za-z0-9_-]+)[[:space:]]*=[[:space:]]*#?([0-9A-Fa-f]{6})[[:space:]]*$ ]]; then
      add_matugen_color "${BASH_REMATCH[1]}" "${BASH_REMATCH[2]}"
    elif [[ "$line" =~ ^[[:space:]]*#?([0-9A-Fa-f]{6})[[:space:]]*$ ]]; then
      add_matugen_color "primary" "${BASH_REMATCH[1]}"
    fi
  done < "$COLOR_FILE"
}

read_matugen_colors

if [[ "${#matugen_colors[@]}" -eq 0 ]]; then
  echo "No valid matugen colors found in '$COLOR_FILE'." >&2
  exit 1
fi

palette_refs=(
  "adwaita:#3584e4" "adwaita:#1c71d8"
  "black:#1a1a1a" "black:#2b2b2b"
  "white:#f5f5f5" "white:#ffffff"
  "grey:#9e9e9e" "grey:#757575"
  "bluegrey:#78909c" "bluegrey:#607d8b"
  "red:#f44336" "red:#e53935" "red:#c62828" "red:#ff1744"
  "carmine:#a00000" "carmine:#b00020" "carmine:#8b1a1a"
  "deeporange:#ff5722" "deeporange:#f4511e" "deeporange:#bf360c" "deeporange:#ff6e40"
  "yaru:#e95420" "yaru:#dd4814"
  "orange:#ff9800" "orange:#fb8c00" "orange:#ef6c00" "orange:#ff6d00"
  "paleorange:#ffb74d" "paleorange:#ffa726" "paleorange:#ffcc02" "paleorange:#ffd54f"
  "yellow:#ffeb3b" "yellow:#fdd835" "yellow:#f9a825" "yellow:#ffee58"
  "green:#4caf50" "green:#43a047" "green:#2e7d32" "green:#00e676" "green:#1b5e20"
  "teal:#009688" "teal:#00897b" "teal:#004d40" "teal:#1de9b6"
  "darkcyan:#008b8b" "darkcyan:#006c6c"
  "cyan:#00bcd4" "cyan:#00acc1" "cyan:#006064" "cyan:#18ffff"
  "breeze:#4d8ecb" "breeze:#29b6f6" "breeze:#039be5" "breeze:#0288d1"
  "blue:#1a73e8" "blue:#1e88e5" "blue:#1565c0" "blue:#2979ff" "blue:#0d47a1"
  "nordic:#5e81ac" "nordic:#4c72a0" "nordic:#3b5998"
  "indigo:#3f51b5" "indigo:#3949ab" "indigo:#1a237e" "indigo:#536dfe"
  "violet:#9c27b0" "violet:#8e24aa" "violet:#4a148c" "violet:#aa00ff" "violet:#7b1fa2"
  "magenta:#e91e63" "magenta:#d81b60" "magenta:#880e4f" "magenta:#f50057"
  "pink:#f48fb1" "pink:#f06292" "pink:#ec407a" "pink:#e91e63"
  "brown:#795548" "brown:#6d4c41" "brown:#4e342e" "brown:#a1887f"
  "palebrown:#a1887f" "palebrown:#bcaaa4" "palebrown:#d7ccc8"
)

# Convert hex to RGB.
hex_to_rgb() {
  local h="${1#\#}"
  echo "$((16#${h:0:2})) $((16#${h:2:2})) $((16#${h:4:2}))"
}

weighted_color_score() {
  awk \
    -v r1="$1" -v g1="$2" -v b1="$3" \
    -v r2="$4" -v g2="$5" -v b2="$6" \
    -v weight="$7" '
    function abs(v) { return v < 0 ? -v : v }
    function max3(a, b, c) { return a > b ? (a > c ? a : c) : (b > c ? b : c) }
    function min3(a, b, c) { return a < b ? (a < c ? a : c) : (b < c ? b : c) }
    function hue(r, g, b, max, min, delta, h) {
      max = max3(r, g, b)
      min = min3(r, g, b)
      delta = max - min
      if (delta == 0) return 0
      if (max == r) h = 60 * ((g - b) / delta)
      else if (max == g) h = 60 * (((b - r) / delta) + 2)
      else h = 60 * (((r - g) / delta) + 4)
      return h < 0 ? h + 360 : h
    }
    BEGIN {
      r1 /= 255; g1 /= 255; b1 /= 255
      r2 /= 255; g2 /= 255; b2 /= 255

      max1 = max3(r1, g1, b1); min1 = min3(r1, g1, b1)
      max2 = max3(r2, g2, b2); min2 = min3(r2, g2, b2)
      sat1 = max1 == 0 ? 0 : (max1 - min1) / max1
      sat2 = max2 == 0 ? 0 : (max2 - min2) / max2

      rgb = ((r1 - r2) ^ 2 + (g1 - g2) ^ 2 + (b1 - b2) ^ 2) * 1000

      if (sat1 < 0.08) {
        score = rgb * 950 + sat2 * 850
        print int(score * weight)
        exit
      }

      h1 = hue(r1, g1, b1)
      h2 = hue(r2, g2, b2)
      dh = abs(h1 - h2)
      if (dh > 180) dh = 360 - dh

      score = (dh ^ 2) * 4 + ((sat1 - sat2) ^ 2) * 7000 + ((max1 - max2) ^ 2) * 900

      if (sat2 < 0.10) score += 3000
      if (sat1 > 0.20 && sat2 < 0.22) score += 1200

      print int(score * weight)
    }'
}

matugen_summary() {
  local parts=()
  local role

  for role in source primary secondary tertiary; do
    if [[ -n "${matugen_colors[$role]+set}" ]]; then
      parts+=("$role=#${matugen_colors[$role]}")
    fi
  done

  local IFS=", "
  echo "${parts[*]}"
}

choose_papirus_color() {
  local best_color=""
  local best_ref=""
  local best_score=999999999
  local ref_spec ref_color ref_hex total_score role target_hex role_score
  local tr tg tb rr rg rb

  for ref_spec in "${palette_refs[@]}"; do
    ref_color="${ref_spec%%:*}"
    ref_hex="${ref_spec#*:}"
    read rr rg rb <<< "$(hex_to_rgb "$ref_hex")"
    total_score=0

    for role in source primary secondary tertiary; do
      if [[ -z "${matugen_colors[$role]+set}" ]]; then
        continue
      fi

      target_hex="${matugen_colors[$role]}"
      read tr tg tb <<< "$(hex_to_rgb "$target_hex")"
      role_score="$(weighted_color_score "$tr" "$tg" "$tb" "$rr" "$rg" "$rb" "${role_weights[$role]}")"
      total_score=$((total_score + role_score))
    done

    if (( total_score < best_score )); then
      best_score="$total_score"
      best_color="$ref_color"
      best_ref="$ref_color:$ref_hex"
    fi
  done

  echo "$best_color|$best_ref|$best_score"
}

IFS="|" read -r closest_color matched_ref match_score <<< "$(choose_papirus_color)"

echo "Matugen colors: $(matugen_summary) -> matched $matched_ref -> papirus color: $closest_color"

if [[ "$PREVIEW_MODE" -eq 1 ]]; then
  exit 0
fi

# Apply.
ensure_local_papirus_theme
"$PAPIRUS_FOLDERS" -C "$closest_color" --theme "$PAPIRUS_THEME"

# Refresh icon cache.
gtk-update-icon-cache -qf "$LOCAL_ICON_DIR/Papirus" 2>/dev/null || true
gtk-update-icon-cache -qf "$LOCAL_ICON_DIR/$PAPIRUS_THEME" 2>/dev/null || true
