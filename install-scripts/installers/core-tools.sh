#!/usr/bin/env bash

# Core Tools Installer
# Essential tools: stow, alacritty, neovim, ghostty

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../utils/logging.sh"

install_core_tools() {
    log_section "Installing Core Tools"

    # GNU Stow for dotfiles management
    log_info "Installing GNU Stow..."
    sudo dnf install -y stow
    log_success "GNU Stow installed"

    # Alacritty terminal emulator
    log_info "Installing Alacritty..."
    sudo dnf install -y alacritty
    log_success "Alacritty installed"

    # Neovim text editor
    log_info "Installing Neovim..."
    sudo dnf install -y neovim
    log_success "Neovim installed"

    # ghostty terminal emulator
    log_info "Installing Ghostty..."
    sudo dnf copr enable scottames/ghostty -y
    sudo dnf install -y ghostty
    log_success "Ghostty installed"

    log_section "Core Tools Installation Complete"
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_core_tools
fi
