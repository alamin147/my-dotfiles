#!/usr/bin/env bash

# Development Tools Installer
# Dev tools: npm, yarn, lazygit

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../utils/logging.sh"

install_dev_tools() {
    log_section "Installing Development Tools"

    # Yarn package manager
    if command -v yarn &> /dev/null; then
        log_info "Yarn already installed, skipping"
    else
        log_info "Installing Yarn globally via npm..."
        if command -v npm &> /dev/null; then
            sudo npm install --global yarn
            log_success "Yarn installed"
        else
            log_error "npm not found. Please install Node.js first"
            log_info "You can install Node.js with: sudo dnf install nodejs"
        fi
    fi

    # Lazygit - terminal UI for git
    if command -v lazygit &> /dev/null; then
        log_info "Lazygit already installed, skipping"
    else
        log_info "Installing Lazygit..."
        sudo dnf copr enable -y atim/lazygit
        sudo dnf install -y lazygit
        log_success "Lazygit installed"
    fi

    log_section "Development Tools Installation Complete"
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_dev_tools
fi
