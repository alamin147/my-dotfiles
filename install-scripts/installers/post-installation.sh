#!/bin/bash

CONF="/etc/dnf/dnf.conf"

# Require root
if [[ $EUID -ne 0 ]]; then
    echo "Run with sudo:"
    echo "sudo $0"
    exit 1
fi

echo "========================================"
echo " Fedora Post Install Setup"
echo "========================================"
echo ""

# Step 1: Configure DNF
echo "[1/7] Configuring DNF..."
touch "$CONF" || true

if grep -q "^max_parallel_downloads=" "$CONF"; then
    sed -i 's/^max_parallel_downloads=.*/max_parallel_downloads=10/' "$CONF"
else
    if grep -q "^\[main\]" "$CONF"; then
        sed -i '/^\[main\]/a max_parallel_downloads=10' "$CONF"
    else
        printf "[main]\nmax_parallel_downloads=10\n" >> "$CONF"
    fi
fi && echo "[✓] DNF configured" || echo "[✗] Failed to configure DNF"

# Step 2: RPM Fusion
echo ""
echo "[2/7] Installing RPM Fusion repositories..."
if bash -c 'dnf install -y \
https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm' 2>/dev/null; then
    echo "[✓] RPM Fusion installed"
else
    echo "[✗] RPM Fusion installation had issues"
fi

# Step 3: Update metadata
echo ""
echo "[3/7] Updating appstream metadata..."
if dnf makecache 2>/dev/null; then
    echo "[✓] Metadata updated"
else
    echo "[✗] Metadata update failed"
fi

# Step 4: Multimedia codecs
echo ""
echo "[4/7] Installing multimedia codecs..."
dnf swap -y ffmpeg-free ffmpeg --allowerasing >/dev/null 2>&1 || true
if dnf group upgrade -y multimedia --exclude=PackageKit-gstreamer-plugin >/dev/null 2>&1; then
    echo "[✓] Codecs installed"
else
    echo "[✗] Codec installation failed"
fi

# Step 5: Flathub
echo ""
echo "[5/7] Adding Flathub repository..."
if flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo >/dev/null 2>&1; then
    echo "[✓] Flathub added"
else
    echo "[✗] Flathub add failed"
fi

# Step 6: Firmware
echo ""
echo "[6/7] Checking firmware updates..."
if command -v fwupdmgr >/dev/null 2>&1; then
    if fwupdmgr get-updates >/dev/null 2>&1 && fwupdmgr update -y >/dev/null 2>&1; then
        echo "[✓] Firmware updated"
    else
        echo "[!] Firmware updates skipped or failed"
    fi
else
    echo "[!] fwupdmgr not available"
fi

# Step 7: Cleanup
echo ""
echo "[7/7] Cleaning unused packages..."
dnf autoremove -y >/dev/null 2>&1 || true
if dnf clean all >/dev/null 2>&1; then
    echo "[✓] Cleanup complete"
else
    echo "[✗] Cleanup failed"
fi

echo ""
echo "========================================"
echo " Setup Complete!"
echo "========================================"
