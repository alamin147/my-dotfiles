#!/usr/bin/env bash

# Shell Tools Installer
# Shell enhancements: starship, zoxide, tmux, yazi

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../utils/logging.sh"

install_shell_tools() {
    log_section "Installing Shell Tools"

    # Starship prompt
    log_info "Installing Starship prompt..."
    if ! command -v starship &> /dev/null; then
        curl -sS https://starship.rs/install.sh | sh -s -- -y
        log_success "Starship installed"
    else
        log_info "Starship already installed"
    fi

    # Zoxide - smarter cd command
    log_info "Installing Zoxide..."
    sudo dnf install -y zoxide
    log_success "Zoxide installed"

    # Tmux terminal multiplexer
    log_info "Installing Tmux..."
    sudo dnf install -y tmux
    log_success "Tmux installed"

    # Yazi file manager
    log_info "Installing Yazi..."
    log_warning "Please follow the installation prompts for Yazi"
    # Note: User mentioned "install with suggestion" - may need cargo or other method
    if ! command -v yazi &> /dev/null; then
        log_info "Installing Yazi via cargo (if available)..."
        if command -v cargo &> /dev/null; then
            cargo install --locked yazi-fm yazi-cli
        else
            log_warning "Cargo not found. Please install Yazi manually or install Rust first"
        fi
    else
        log_info "Yazi already installed"
    fi

    log_section "Shell Tools Installation Complete"
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_shell_tools
fi
