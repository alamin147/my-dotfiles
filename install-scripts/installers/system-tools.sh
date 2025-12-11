#!/usr/bin/env bash

# System Tools Installer
# System utilities: wlsunset, auto-cpufreq

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../utils/logging.sh"

install_system_tools() {
    log_section "Installing System Tools"

    # Wlsunset - day/night gamma adjustments for Wayland
    log_info "Installing wlsunset..."
    sudo dnf install -y wlsunset
    log_success "wlsunset installed"

    # Auto CPU Freq - automatic CPU speed and power optimizer
    log_info "Installing auto-cpufreq..."
    TEMP_DIR=$(mktemp -d)
    cd "$TEMP_DIR"

    if [ -d "$HOME/auto-cpufreq" ]; then
        log_info "auto-cpufreq directory already exists, using existing..."
        cd "$HOME/auto-cpufreq"
        git pull
    else
        git clone https://github.com/AdnanHodzic/auto-cpufreq.git "$HOME/auto-cpufreq"
        cd "$HOME/auto-cpufreq"
    fi

    sudo ./auto-cpufreq-installer
    sudo auto-cpufreq --install
    log_success "auto-cpufreq installed and configured"
    log_info "To remove later, run: sudo auto-cpufreq --remove"

    cd - > /dev/null

    log_section "System Tools Installation Complete"
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_system_tools
fi
