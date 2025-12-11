#!/usr/bin/env bash

# Applications Installer
# Desktop applications: transmission, localsend, brave-browser, vlc, vscode

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../utils/logging.sh"

install_applications() {
    log_section "Installing Applications"

    # Transmission BitTorrent client
    log_info "Installing Transmission..."
    sudo dnf install -y transmission
    log_success "Transmission installed"

    # LocalSend - local file sharing
    log_info "Installing LocalSend via Flatpak..."
    flatpak install -y flathub org.localsend.localsend_app
    log_success "LocalSend installed"

    # Brave Browser
    log_info "Installing Brave Browser..."
    sudo dnf install -y dnf-plugins-core
    sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
    sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
    sudo dnf install -y brave-browser
    log_success "Brave Browser installed"

    # Thorium Browser
    log_info "Installing Thorium Browser..."
    TEMP_DIR=$(mktemp -d)
    cd "$TEMP_DIR"

    # Download latest Thorium release for Fedora
    THORIUM_URL="https://github.com/Alex313031/thorium/releases/latest/download/thorium-browser-latest.x86_64.rpm"
    log_info "Downloading Thorium from GitHub releases..."

    if curl -sL -o thorium.rpm "$THORIUM_URL"; then
        sudo dnf install -y ./thorium.rpm
        log_success "Thorium Browser installed"
    else
        log_warning "Failed to download Thorium, you may need to install it manually"
        log_info "Visit: https://github.com/Alex313031/thorium/releases"
    fi

    cd - > /dev/null
    rm -rf "$TEMP_DIR"

    # VLC Media Player (requires RPM Fusion)
    log_info "Setting up RPM Fusion repositories..."
    sudo dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
    sudo dnf install -y https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
    log_success "RPM Fusion repositories configured"

    log_info "Installing VLC..."
    sudo dnf install -y vlc
    log_success "VLC installed"

    # Visual Studio Code
    log_info "Installing Visual Studio Code..."
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null
    sudo dnf check-update
    sudo dnf install -y code
    log_success "Visual Studio Code installed"

    log_section "Applications Installation Complete"
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_applications
fi
