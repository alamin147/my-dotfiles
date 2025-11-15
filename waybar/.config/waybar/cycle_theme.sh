#!/usr/bin/env bash

CONFIG_DIR="$HOME/.config/waybar"
STYLE_DIR="$CONFIG_DIR/style"
MAIN_CSS="$CONFIG_DIR/style.css"
INDEX_FILE="$CONFIG_DIR/current_theme_index.txt"

# List all main CSS files
CSS_FILES=(
"[Dark] Golden Eclipse.css"

"[0 VERTICAL] Golden Noir.css"
"[0 VERTICAL] Oglo Chicklets.css"
"[0 VERTICAL] [Catpuccin] Mocha.css"
"[Black & White] Monochrome.css"
"[Catppuccin] Frappe.css"
"[Catppuccin] Latte.css"
"[Catppuccin] Mocha.css"
"[Colored] Chroma Glowv2.css"
"[Colored] Translucent.css"
"[Colorful] Aurora Blossom.css"
"[Colorful] Aurora.css"
"[Colorful] Oglo Chicklets.css"
"[Colorful] Rainbow Spectrum.css"
"[Dark] Golden Noir.css"
"[Dark] Half-Moon.css"
"[Dark] Latte-Wallust combined v2.css"
"[Dark] Latte-Wallust combined.css"
"[Dark] Purpl.css"
"[Dark] Wallust Obsidian Edge.css"
"[Extra] Arrow.css"
"[Extra] Crimson.css"
"[Extra] EverForest.css"
"[Extra] ML4W starter.css"
"[Extra] Mauve.css"
"[windows] s.css"
"[Extra] Modern-Combined - Transparent.css"
"[Extra] Modern-Combined.css"
"[Extra] Neon Circuit.css"
"[Extra] Prismatic Glow.css"
"[Extra] Rose Pine2.css"
"[Extra] Simple Pink.css"
"[Light] Monochrome Contrast.css"
"[Light] Obsidian Glow.css"
"[Rainbow] RGB Bordered.css"
"[Retro] Simple Style.css"
"[Transparent] Crystal Clear.css"
"[VERTICAL] [Catpuccin] Mocha.css"
# "[WALLUST] ML4W-modern-mixed.css"
"[WALLUST] ML4W-modern.css"
"[Wallust Bordered] Chroma Fusion Edge.css"
"[Wallust Bordered] Chroma Simple.css"
# "[Wallust Transparent] Crystal Clear.css"
"[Wallust] Box type.css"
"[Wallust] Chroma Edge.css"
"[Wallust] Chroma Fusion.css"
"[Wallust] Chroma Tally V2.css"
"[Wallust] Chroma Tally.css"
"[Wallust] Colored.css"
"[Wallust] Simple.css"
)

# Read last index
if [ -f "$INDEX_FILE" ]; then
    last_index=$(cat "$INDEX_FILE")
else
    last_index=-1
fi

# Compute next index
next_index=$(( (last_index + 1) % ${#CSS_FILES[@]} ))

# Write new style.css with correct relative paths
{
    echo "/* Base file */"
    echo "@import 'global.css';"
    echo "/* Main file */"
    echo "@import 'style/${CSS_FILES[$next_index]}';"
} > "$MAIN_CSS"

# Save current index
echo "$next_index" > "$INDEX_FILE"

# Restart Waybar
pkill waybar
waybar &

echo "Switched to theme: ${CSS_FILES[$next_index]}"
