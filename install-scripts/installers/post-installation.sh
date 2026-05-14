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
echo "[1/7] Configuring DNF..."

# Create config if missing
touch "$CONF"

# Set max_parallel_downloads=10
if grep -q "^max_parallel_downloads=" "$CONF"; then
    sed -i 's/^max_parallel_downloads=.*/max_parallel_downloads=10/' "$CONF"
else
    if grep -q "^\[main\]" "$CONF"; then
        sed -i '/^\[main\]/a max_parallel_downloads=10' "$CONF"
    else
        printf "[main]\nmax_parallel_downloads=10\n" >> "$CONF"
    fi
fi

echo ""
echo "[2/7] Installing RPM Fusion repositories..."

# Execute in bash explicitly
bash -c '
dnf install -y \
https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
'

echo ""
echo "[3/7] Updating appstream metadata..."

dnf groupupdate core -y

echo ""
echo "[4/7] Installing multimedia codecs..."

dnf swap -y ffmpeg-free ffmpeg --allowerasing

dnf group upgrade -y multimedia \
--exclude=PackageKit-gstreamer-plugin

dnf group upgrade -y sound-and-video

echo ""
echo "[5/7] Adding Flathub repository..."

flatpak remote-add --if-not-exists flathub \
https://dl.flathub.org/repo/flathub.flatpakrepo

echo ""
echo "[6/7] Checking firmware updates..."

fwupdmgr get-updates
fwupdmgr update -y

echo ""
echo "[7/7] Cleaning unused packages..."

dnf autoremove -y
dnf clean all

echo ""
echo "========================================"
echo " Setup Complete!"
echo "========================================"
