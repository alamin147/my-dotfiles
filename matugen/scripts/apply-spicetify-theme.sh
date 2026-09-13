#!/usr/bin/env bash
set -euo pipefail

theme_name="${SPICETIFY_THEME:-Matugen}"
scheme_name="${SPICETIFY_SCHEME:-Matugen}"
spicetify_bin="${SPICETIFY_BIN:-}"

if [[ -z "$spicetify_bin" ]]; then
  if command -v spicetify >/dev/null 2>&1; then
    spicetify_bin="$(command -v spicetify)"
  elif [[ -x "$HOME/.spicetify/spicetify" ]]; then
    spicetify_bin="$HOME/.spicetify/spicetify"
  else
    printf 'Spicetify binary was not found in PATH or %s/.spicetify/spicetify\n' "$HOME" >&2
    exit 127
  fi
fi

"$spicetify_bin" config current_theme "$theme_name" color_scheme "$scheme_name" inject_css 1 replace_colors 1 >/dev/null
"$spicetify_bin" apply
