#!/usr/bin/env bash

# System Tools Installer
# System utilities: wlsunset

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../utils/logging.sh"

install_system_tools() {
    log_section "Installing System Tools"

    # Wlsunset - day/night gamma adjustments for Wayland
    log_info "Installing wlsunset..."
    sudo dnf install -y wlsunset
    log_success "wlsunset installed"

    log_section "System Tools Installation Complete"
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_system_tools
fi
