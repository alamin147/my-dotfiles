#!/usr/bin/env bash

# Development Tools Installer
# Dev tools: npm, yarn, lazygit

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../utils/logging.sh"

install_dev_tools() {
    log_section "Installing Development Tools"

    # Yarn package manager
    log_info "Installing Yarn globally via npm..."
    if command -v npm &> /dev/null; then
        sudo npm install --global yarn
        log_success "Yarn installed"
    else
        log_error "npm not found. Please install Node.js first"
        log_info "You can install Node.js with: sudo dnf install nodejs"
        exit 1
    fi

    # Lazygit - terminal UI for git
    log_info "Installing Lazygit..."
    sudo dnf copr enable -y atim/lazygit
    sudo dnf install -y lazygit
    log_success "Lazygit installed"

    log_section "Development Tools Installation Complete"
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_dev_tools
fi
