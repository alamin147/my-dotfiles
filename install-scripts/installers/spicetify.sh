#!/usr/bin/env bash
# =============================================================================
# Spicetify + Marketplace Setup for Flatpak Spotify (Fedora / most Linux)
# Run as regular user (uses sudo only for chmod and flatpak override)
# Version: 2026-02-ready
# =============================================================================
set -euo pipefail

# ──────────────────────────────────────────────────────────────────────────────
# Variables & Detection
# ──────────────────────────────────────────────────────────────────────────────
USERNAME="$(whoami)"
FLATPAK_APP="com.spotify.Client"
SPOTIFY_BASE="/var/lib/flatpak/app/$FLATPAK_APP"

# Possible spotify install directories (Flatpak often changes between stable/current)
POSSIBLE_PATHS=(
    "$SPOTIFY_BASE/x86_64/stable/active/files/extra/share/spotify"
    "$SPOTIFY_BASE/current/active/files/extra/share/spotify"
    "$SPOTIFY_BASE/x86_64/master/active/files/extra/share/spotify"
    "$SPOTIFY_BASE/x86_64/current/active/files/extra/share/spotify"
)

PREFS_PATH="/home/$USERNAME/.var/app/$FLATPAK_APP/config/spotify/prefs"

echo "=== Spicetify + Marketplace Setup for Flatpak Spotify ==="
echo "User:       $USERNAME"
echo "Date:       $(date '+%Y-%m-%d %H:%M')"
echo "Spotify:    Flatpak ($FLATPAK_APP)"
echo ""

# ──────────────────────────────────────────────────────────────────────────────
# 1. Prerequisites
# ──────────────────────────────────────────────────────────────────────────────
echo "→ Checking / installing prerequisites..."

if ! command -v flatpak >/dev/null 2>&1; then
    echo "Flatpak not found → installing..."
    sudo dnf install -y flatpak || { echo "dnf failed – are you on Fedora?"; exit 1; }
fi

if ! flatpak remote-ls flathub 2>/dev/null | grep -q com.spotify.Client; then
    echo "Adding Flathub remote..."
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
fi

# ──────────────────────────────────────────────────────────────────────────────
# 2. Install / ensure Spotify Flatpak
# ──────────────────────────────────────────────────────────────────────────────
if ! flatpak list --app | grep -q "$FLATPAK_APP"; then
    echo "→ Installing Spotify (Flatpak)..."
    flatpak install -y flathub "$FLATPAK_APP"
else
    echo "→ Spotify Flatpak already installed."
fi

# Launch once to create prefs file (very important!)
echo "→ Launching Spotify briefly to ensure prefs file is created..."
flatpak run "$FLATPAK_APP" >/dev/null 2>&1 &
SPOTIFY_PID=$!
sleep 10
kill $SPOTIFY_PID 2>/dev/null || true
wait $SPOTIFY_PID 2>/dev/null || true

if [[ ! -f "$PREFS_PATH" ]]; then
    echo "→ WARNING: prefs file still missing after first launch."
    echo "   Please run 'flatpak run $FLATPAK_APP' yourself, log in, play something briefly, then close Spotify."
    echo "   Then re-run this script."
    exit 1
fi
echo "→ prefs file found at $PREFS_PATH"

# ──────────────────────────────────────────────────────────────────────────────
# 3. Install / update Spicetify CLI
# ──────────────────────────────────────────────────────────────────────────────
echo "→ Installing / updating Spicetify CLI..."
if ! command -v spicetify >/dev/null 2>&1; then
    curl -fsSL https://raw.githubusercontent.com/spicetify/cli/main/install.sh | sh
    export PATH="$HOME/.spicetify:$PATH"
else
    spicetify update || true
fi

# ──────────────────────────────────────────────────────────────────────────────
# 4. Detect & configure spotify_path
# ──────────────────────────────────────────────────────────────────────────────
echo "→ Detecting Spotify Flatpak installation path..."
SPOTIFY_PATH=""
for p in "${POSSIBLE_PATHS[@]}"; do
    if [[ -d "$p" && -f "$p/spotify" ]]; then
        SPOTIFY_PATH="$p"
        break
    fi
done

if [[ -z "$SPOTIFY_PATH" ]]; then
    echo "ERROR: Could not locate Spotify files."
    echo "Run:   ls -ld /var/lib/flatpak/app/com.spotify.Client/*/*/active/files/extra/share/spotify"
    echo "Then set spotify_path manually in ~/.config/spicetify/config-xpui.ini"
    exit 1
fi

echo "→ Found spotify_path = $SPOTIFY_PATH"

# Force-write config (bypasses detection issues)
spicetify config spotify_path "$SPOTIFY_PATH" || true
spicetify config prefs_path   "$PREFS_PATH"   || true
spicetify config inject_css    1              || true
spicetify config replace_colors 1             || true

# ──────────────────────────────────────────────────────────────────────────────
# 5. Permissions (required for patching)
# ──────────────────────────────────────────────────────────────────────────────
echo "→ Setting write permissions (sudo required)..."
sudo chmod -R a+wr "$SPOTIFY_PATH"
if [[ -d "$SPOTIFY_PATH/Apps" ]]; then
    sudo chmod -R a+wr "$SPOTIFY_PATH/Apps"
fi

# ──────────────────────────────────────────────────────────────────────────────
# 6. Flatpak filesystem overrides (for extensions & custom apps)
# ──────────────────────────────────────────────────────────────────────────────
echo "→ Adding Flatpak filesystem overrides..."
SPICETIFY_DIR="$(spicetify -c | xargs dirname)"

sudo flatpak override --filesystem="$SPICETIFY_DIR/Extensions/:ro"   "$FLATPAK_APP" || true
sudo flatpak override --filesystem="$SPICETIFY_DIR/CustomApps/:ro"   "$FLATPAK_APP" || true
sudo flatpak override --filesystem="$HOME/.spicetify/Extensions/:ro" "$FLATPAK_APP" || true
sudo flatpak override --filesystem="$HOME/.spicetify/CustomApps/:ro" "$FLATPAK_APP" || true

# ──────────────────────────────────────────────────────────────────────────────
# 7. Install Marketplace
# ──────────────────────────────────────────────────────────────────────────────
echo "→ Installing Spicetify Marketplace..."
curl -fsSL https://raw.githubusercontent.com/spicetify/marketplace/main/resources/install.sh | sh || {
    echo "→ Marketplace install failed – retrying after backup apply..."
    spicetify backup apply || true
    curl -fsSL https://raw.githubusercontent.com/spicetify/marketplace/main/resources/install.sh | sh
}

# ──────────────────────────────────────────────────────────────────────────────
# 8. Final apply & backup
# ──────────────────────────────────────────────────────────────────────────────
echo "→ Creating backup & applying patches..."
spicetify backup apply
spicetify apply

echo ""
echo "=== Setup finished successfully! ==="
echo ""
echo "Launch Spotify with:"
echo "    flatpak run com.spotify.Client"
echo ""
echo "You should now see the green Marketplace icon in the sidebar."
echo ""
echo "Troubleshooting tips:"
echo "  • No changes? → Close Spotify completely → 'spicetify apply' → restart"
echo "  • Still issues? → Run 'spicetify -c' and check paths"
echo "  • Config location: $(spicetify -c)"
echo ""
echo "Enjoy your themed Spotify! 🎧"

echo "Exising"
exit
