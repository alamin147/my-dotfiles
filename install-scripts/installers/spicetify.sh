#!/usr/bin/env bash

# =============================================================================
# Spicetify + Marketplace installer for Flatpak Spotify on Fedora / Linux
# Run as regular user (uses sudo only where needed)
# Last tested patterns 2025–2026
# =============================================================================

set -euo pipefail

USERNAME=$(whoami)
FLATPAK_APP="com.spotify.Client"
SPOTIFY_FLATPAK_PATH_BASE="/var/lib/flatpak/app/$FLATPAK_APP"
POSSIBLE_SPOTIFY_PATHS=(
    "$SPOTIFY_FLATPAK_PATH_BASE/x86_64/stable/active/files/extra/share/spotify"
    "$SPOTIFY_FLATPAK_PATH_BASE/current/active/files/extra/share/spotify"   # some variants use "current"
    "$SPOTIFY_FLATPAK_PATH_BASE/x86_64/master/active/files/extra/share/spotify"
)

PREFS_PATH="/home/$USERNAME/.var/app/$FLATPAK_APP/config/spotify/prefs"

echo "=== Spicetify + Marketplace Setup for Flatpak Spotify ==="
echo "User: $USERNAME"
echo "Date: $(date '+%Y-%m-%d')"
echo ""

# ──────────────────────────────────────────────────────────────────────────────
# 1. Prerequisites
# ──────────────────────────────────────────────────────────────────────────────
echo "→ Checking / installing prerequisites..."

if ! command -v flatpak &> /dev/null; then
    echo "Flatpak not found → installing..."
    sudo dnf install -y flatpak
fi

if ! flatpak remote-ls flathub | grep -q com.spotify.Client; then
    echo "Adding Flathub..."
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
fi

# ──────────────────────────────────────────────────────────────────────────────
# 2. Install Spotify (Flatpak) if missing
# ──────────────────────────────────────────────────────────────────────────────
if ! flatpak list | grep -q "$FLATPAK_APP"; then
    echo "→ Spotify Flatpak not found → installing..."
    flatpak install -y flathub "$FLATPAK_APP"
    echo ""
    echo "→ Launching Spotify once (log in if needed, then close it)..."
    flatpak run "$FLATPAK_APP" &>/dev/null &
    sleep 8
    pkill -f spotify || true
    echo "→ Spotify first-run done."
else
    echo "→ Spotify Flatpak already installed."
fi

# ──────────────────────────────────────────────────────────────────────────────
# 3. Install Spicetify CLI (official script)
# ──────────────────────────────────────────────────────────────────────────────
if ! command -v spicetify &> /dev/null; then
    echo "→ Installing Spicetify CLI..."
    curl -fsSL https://raw.githubusercontent.com/spicetify/cli/main/install.sh | sh
    # Make sure it's in PATH for this session
    export PATH="$HOME/.spicetify:$PATH"
else
    echo "→ Spicetify already installed → updating..."
    spicetify update
fi

# ──────────────────────────────────────────────────────────────────────────────
# 4. Detect & set spotify_path
# ──────────────────────────────────────────────────────────────────────────────
echo "→ Detecting Flatpak Spotify path..."

SPOTIFY_PATH=""
for path in "${POSSIBLE_SPOTIFY_PATHS[@]}"; do
    if [[ -d "$path" ]]; then
        SPOTIFY_PATH="$path"
        break
    fi
done

if [[ -z "$SPOTIFY_PATH" ]]; then
    echo "ERROR: Could not find Spotify installation in common Flatpak locations."
    echo "Please check: ls -l /var/lib/flatpak/app/com.spotify.Client/"
    echo "Then edit ~/.config/spicetify/config-xpui.ini manually."
    exit 1
fi

echo "→ Found spotify_path = $SPOTIFY_PATH"

# Set paths
spicetify config spotify_path "$SPOTIFY_PATH"
spicetify config prefs_path   "$PREFS_PATH"

# Enable needed features
spicetify config inject_css 1
spicetify config replace_colors 1

# ──────────────────────────────────────────────────────────────────────────────
# 5. Permissions (critical for patching to work)
# ──────────────────────────────────────────────────────────────────────────────
echo "→ Applying write permissions (sudo required)..."

sudo chmod a+wr "$SPOTIFY_PATH" -R
# Especially important for Apps folder (custom apps / patches go here)
if [[ -d "$SPOTIFY_PATH/Apps" ]]; then
    sudo chmod a+wr "$SPOTIFY_PATH/Apps" -R
fi

# ──────────────────────────────────────────────────────────────────────────────
# 6. Flatpak filesystem overrides (for CustomApps / Extensions symlinks)
# ──────────────────────────────────────────────────────────────────────────────
echo "→ Adding Flatpak overrides for CustomApps & Extensions..."

SPICETIFY_CONFIG_DIR="$(dirname "$(spicetify -c)")"

sudo flatpak override --filesystem="$SPICETIFY_CONFIG_DIR/CustomApps/:ro" "$FLATPAK_APP"
sudo flatpak override --filesystem="$SPICETIFY_CONFIG_DIR/Extensions/:ro" "$FLATPAK_APP"
# Sometimes needed for the binary dir too
sudo flatpak override --filesystem="$HOME/.spicetify/CustomApps/:ro" "$FLATPAK_APP" 2>/dev/null || true

# ──────────────────────────────────────────────────────────────────────────────
# 7. Install Marketplace (most popular extension)
# ──────────────────────────────────────────────────────────────────────────────
echo "→ Installing Spicetify Marketplace..."
curl -fsSL https://raw.githubusercontent.com/spicetify/marketplace/main/resources/install.sh | sh || {
    echo "→ Marketplace install failed once → retrying with backup apply first..."
    spicetify backup apply
    curl -fsSL https://raw.githubusercontent.com/spicetify/marketplace/main/resources/install.sh | sh
}

# ──────────────────────────────────────────────────────────────────────────────
# 8. Final apply
# ──────────────────────────────────────────────────────────────────────────────
echo "→ Creating backup & applying changes..."
spicetify apply
spicetify backup apply
echo ""
echo "=== Setup complete! ==="
echo ""
echo "Launch Spotify:"
echo "    flatpak run com.spotify.Client"
echo ""
echo "→ You should see the green Marketplace icon in the left sidebar."
echo "→ If changes don't appear: close Spotify fully → run 'spicetify apply' → restart."
echo "→ To install themes/extensions: use the Marketplace tab or 'spicetify config'."
echo ""
echo "Enjoy your customized Spotify! 🎶"
echo "If issues → run: spicetify -c   (shows config) and share output."
