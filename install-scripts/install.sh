#!/usr/bin/env bash

# Master Installer Script for Dotfiles Setup
# This script orchestrates the installation of all tools and applications

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/utils/logging.sh"

# Import installer functions
source "${SCRIPT_DIR}/installers/core-tools.sh"
source "${SCRIPT_DIR}/installers/shell-tools.sh"
source "${SCRIPT_DIR}/installers/system-tools.sh"
source "${SCRIPT_DIR}/installers/dev-tools.sh"
source "${SCRIPT_DIR}/installers/applications.sh"
source "${SCRIPT_DIR}/installers/stow-manager.sh"

show_menu() {
    echo ""
    log_section "Dotfiles Setup - Installation Menu"
    echo "1) Install Core Tools (stow, alacritty, neovim)"
    echo "2) Install Shell Tools (starship, zoxide, tmux, yazi)"
    echo "3) Install System Tools (wlsunset, auto-cpufreq)"
    echo "4) Install Dev Tools (yarn, lazygit)"
    echo "5) Install Applications (transmission, localsend, brave, thorium, vlc, vscode)"
    echo "6) Install Everything"
    echo "7) Stow Dotfiles (Interactive)"
    echo "8) Unstow Dotfiles (Interactive)"
    echo "9) Exit"
    echo ""
}

install_all() {
    log_section "Installing All Components"

    install_core_tools
    echo ""

    install_shell_tools
    echo ""

    install_system_tools
    echo ""

    install_dev_tools
    echo ""

    install_applications
    echo ""

    log_section "All Installations Complete!"
    log_success "Your system is now set up with all the dotfile tools"
    echo ""
    log_info "Now let's stow your dotfiles..."
    echo ""
    sleep 1

    # Launch interactive stow manager
    interactive_stow

    echo ""
    log_section "Setup Complete!"
    log_info "Final steps:"
    log_step "1. Restart your shell or run 'exec zsh' to apply changes"
    log_step "2. Configure applications as needed"
}

main() {
    # Check if running on Fedora
    if ! grep -qi fedora /etc/os-release; then
        log_warning "This script is designed for Fedora Linux"
        read -p "Continue anyway? (y/N) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi

    log_section "Dotfiles Setup Installer"
    log_info "This script will help you install tools for your dotfiles setup"

    # Interactive mode if no arguments
    if [ $# -eq 0 ]; then
        while true; do
            show_menu
            read -p "Select an option [1-9]: " choice

            case $choice in
                1) install_core_tools ;;
                2) install_shell_tools ;;
                3) install_system_tools ;;
                4) install_dev_tools ;;
                5) install_applications ;;
                6) install_all ;;
                7) interactive_stow ;;
                8) interactive_unstow ;;
                9)
                    log_info "Exiting..."
                    exit 0
                    ;;
                *)
                    log_error "Invalid option. Please try again."
                    ;;
            esac

            echo ""
            read -p "Press Enter to continue..."
        done
    else
        # Non-interactive mode with arguments
        case "$1" in
            --core) install_core_tools ;;
            --shell) install_shell_tools ;;
            --system) install_system_tools ;;
            --dev) install_dev_tools ;;
            --apps) install_applications ;;
            --all) install_all ;;
            --stow) interactive_stow ;;
            --unstow) interactive_unstow ;;
            --help)
                echo "Usage: $0 [OPTION]"
                echo "Options:"
                echo "  --core      Install core tools"
                echo "  --shell     Install shell tools"
                echo "  --system    Install system tools"
                echo "  --dev       Install development tools"
                echo "  --apps      Install applications"
                echo "  --all       Install everything"
                echo "  --stow      Stow dotfiles (interactive)"
                echo "  --unstow    Unstow dotfiles (interactive)"
                echo "  --help      Show this help message"
                echo ""
                echo "Without options, runs in interactive mode."
                ;;
            *)
                log_error "Unknown option: $1"
                log_info "Use --help for usage information"
                exit 1
                ;;
        esac
    fi
}

# Run main function
main "$@"
