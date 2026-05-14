#!/usr/bin/env bash

# Applications Installer
# Desktop applications: transmission, localsend, brave-browser, vlc, vscode

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../utils/logging.sh"

install_applications() {
    log_section "Installing Applications"
    # GIMP
    # if flatpak info org.gimp.GIMP &>/dev/null; then
    #     log_info "GIMP already installed, skipping"
    # else
    #     log_info "Installing GIMP..."
    #     flatpak install -y flathub org.gimp.GIMP
    #     log_success "GIMP installed"
    # fi

    # Transmission BitTorrent client
    if command -v transmission-gtk &>/dev/null || command -v transmission-qt &>/dev/null; then
        log_info "Transmission already installed, skipping"
    else
        log_info "Installing Transmission..."
        sudo dnf install -y transmission
        log_success "Transmission installed"
    fi

    # nmtui (NetworkManager TUI)
    if command -v nmtui &>/dev/null; then
        log_info "nmtui already installed, skipping"
    else
        log_info "Installing nmtui (NetworkManager-tui)..."
        sudo dnf install -y NetworkManager-tui
        log_success "nmtui installed"
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
    if command -v brave-browser &>/dev/null; then
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
    if command -v thorium-browser &>/dev/null; then
        log_info "Thorium Browser already installed, skipping"
    else
        log_info "Installing Thorium Browser..."
        TEMP_DIR=$(mktemp -d)
        cd "$TEMP_DIR"

        THORIUM_URL="https://github.com/Alex313031/thorium/releases/download/M138.0.7204.300/thorium-browser_138.0.7204.300_AVX.rpm"
        log_info "Downloading Thorium from GitHub..."

        if curl -fsSL -o thorium.rpm "$THORIUM_URL" && [ -f thorium.rpm ]; then
            sudo dnf install -y ./thorium.rpm
            log_success "Thorium Browser installed"
            rm -f thorium.rpm
        else
            log_warning "Failed to download Thorium"
        fi

        cd - >/dev/null
        rm -rf "$TEMP_DIR"
    fi

    # VLC Media Player (requires RPM Fusion)
    log_info "Setting up RPM Fusion repositories..."
    sudo dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
    sudo dnf install -y https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
    log_success "RPM Fusion repositories configured"

    if command -v vlc &>/dev/null; then
        log_info "VLC already installed, skipping"
    else
        log_info "Installing VLC..."
        sudo dnf install -y vlc
        log_success "VLC installed"
    fi

    # Visual Studio Code
    if command -v code &>/dev/null; then
        log_info "Visual Studio Code already installed, skipping"
    else
        log_info "Installing Visual Studio Code..."
        sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc &&
            echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo >/dev/null
        sudo dnf install -y code
        log_success "Visual Studio Code installed"
    fi

    # OBS Studio
    if flatpak info com.obsproject.Studio &>/dev/null; then
        log_info "OBS Studio already installed, skipping"
    else
        log_info "Installing OBS Studio..."
        flatpak install -y flathub com.obsproject.Studio
        log_success "OBS Studio installed"
    fi

    # Obsidian
    if flatpak info md.obsidian.Obsidian &>/dev/null; then
        log_info "Obsidian already installed, skipping"
    else
        log_info "Installing Obsidian..."
        flatpak install -y flathub md.obsidian.Obsidian
        log_success "Obsidian installed"
    fi
    # Discord
    if flatpak info com.discordapp.Discord &>/dev/null; then
        log_info "Discord already installed, skipping"
    else
        log_info "Installing Discord..."
        flatpak install -y flathub com.discordapp.Discord
        log_success "Discord installed"
    fi
    # bottles
    # if flatpak info com.usebottles.bottles &>/dev/null; then
    #     log_info "Bottles already installed, skipping"
    # else
    #     log_info "Installing Bottles..."
    #     flatpak install -y flathub com.usebottles.bottles
    #     log_success "Bottles installed"
    # fi
     # Evince
    if command -v evince &>/dev/null; then
        log_info "Document viewer (Evince) already installed, skipping"
    else
        log_info "Installing Document viewer (Evince)..."
    sudo dnf install -y evince
        log_success "Evince installed"
    fi
     # steam
     if command -v steam &>/dev/null; then
        log_info "Steam already installed, skipping"
    else
        log_info "Installing Steam..."
        sudo dnf install -y steam
        sudo dnf install mesa-vulkan-drivers mesa-vulkan-drivers.i686
        log_success "Steam installed"
    fi

    log_section "Applications Installation Complete"

    # Run javafortlauncher.sh for Java setup
    log_section "Running javafortlauncher.sh for Java setup"
    bash "${SCRIPT_DIR}/javafortlauncher.sh"
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_applications
fi
