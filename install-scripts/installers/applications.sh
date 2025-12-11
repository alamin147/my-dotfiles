#!/usr/bin/env bash

# Applications Installer
# Desktop applications: transmission, localsend, brave-browser, vlc, vscode

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../utils/logging.sh"

install_applications() {
    log_section "Installing Applications"

    # Transmission BitTorrent client
    if command -v transmission-gtk &> /dev/null || command -v transmission-qt &> /dev/null; then
        log_info "Transmission already installed, skipping"
    else
        log_info "Installing Transmission..."
        sudo dnf install -y transmission
        log_success "Transmission installed"
    fi

    # LocalSend - local file sharing
    if flatpak list | grep -q org.localsend.localsend_app; then
        log_info "LocalSend already installed, skipping"
    else
        log_info "Installing LocalSend via Flatpak..."
        flatpak install -y flathub org.localsend.localsend_app
        log_success "LocalSend installed"
    fi

    # Brave Browser
    if command -v brave-browser &> /dev/null; then
        log_info "Brave Browser already installed, skipping"
    else
        log_info "Installing Brave Browser..."
        sudo dnf install -y dnf-plugins-core

        # Add repo with overwrite flag if it already exists
        if [ ! -f /etc/yum.repos.d/brave-browser.repo ]; then
            sudo dnf config-manager addrepo --from-repofile=https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
        else
            log_info "Brave repo already configured"
        fi

        sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc 2>/dev/null || true
        sudo dnf install -y brave-browser
        log_success "Brave Browser installed"
    fi

    # Thorium Browser
    if command -v thorium-browser &> /dev/null; then
        log_info "Thorium Browser already installed, skipping"
    else
        log_info "Installing Thorium Browser..."
        TEMP_DIR=$(mktemp -d)
        cd "$TEMP_DIR"

        # Get latest Thorium release URL for RPM
        log_info "Fetching latest Thorium release..."
        THORIUM_URL=$(curl -s https://api.github.com/repos/Alex313031/thorium/releases/latest | grep "browser_download_url.*\.rpm" | grep -v "AVX" | grep "x86_64" | head -1 | cut -d '"' -f 4)

        if [ -z "$THORIUM_URL" ]; then
            log_warning "Could not find Thorium RPM. Trying direct URL..."
            THORIUM_URL="https://github.com/Alex313031/thorium/releases/download/M128.0.6613.189/thorium-browser-128.0.6613.189-1.x86_64.rpm"
        fi

        log_info "Downloading from: $THORIUM_URL"
        if curl -fsSL -o thorium.rpm "$THORIUM_URL" && [ -f thorium.rpm ]; then
            sudo dnf install -y ./thorium.rpm
            log_success "Thorium Browser installed"
        else
            log_warning "Failed to download Thorium, you may need to install it manually"
            log_info "Visit: https://github.com/Alex313031/thorium/releases"
        fi

        cd - > /dev/null
        rm -rf "$TEMP_DIR"
    fi

    # VLC Media Player (requires RPM Fusion)
    log_info "Setting up RPM Fusion repositories..."
    sudo dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
    sudo dnf install -y https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
    log_success "RPM Fusion repositories configured"

    if command -v vlc &> /dev/null; then
        log_info "VLC already installed, skipping"
    else
        log_info "Installing VLC..."
        sudo dnf install -y vlc
        log_success "VLC installed"
    fi

    # Visual Studio Code
    if command -v code &> /dev/null; then
        log_info "Visual Studio Code already installed, skipping"
    else
        log_info "Installing Visual Studio Code..."
        sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
        echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null
        sudo dnf check-update
        sudo dnf install -y code
        log_success "Visual Studio Code installed"
    fi

    log_section "Applications Installation Complete"
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_applications
fi
