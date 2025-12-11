#!/usr/bin/env bash

# Stow Manager - Interactive dotfiles stowing
# Manages symlink creation for dotfile configurations

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../utils/logging.sh"

# Get the dotfiles root directory (parent of install-scripts)
DOTFILES_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

# Get available stow packages
get_stow_packages() {
    local packages=()
    cd "$DOTFILES_ROOT"

    for dir in */; do
        # Skip install-scripts and screenshots directories
        if [[ "$dir" != "install-scripts/" && "$dir" != "screenshots/" && "$dir" != ".git/" ]]; then
            packages+=("${dir%/}")
        fi
    done

    echo "${packages[@]}"
}

# Stow a single package
stow_package() {
    local package="$1"

    log_info "Processing $package..."

    cd "$DOTFILES_ROOT"

    # First, do a dry run to find conflicts
    local conflicts
    conflicts=$(stow -n -v "$package" 2>&1 | grep "existing target" | awk '{print $NF}' | sed 's/:.*//')

    # Remove any conflicting files/directories
    if [ -n "$conflicts" ]; then
        while IFS= read -r conflict; do
            if [ -n "$conflict" ]; then
                local target="$HOME/$conflict"
                if [ -e "$target" ] || [ -L "$target" ]; then
                    log_warning "Removing existing: $target"
                    rm -rf "$target"
                fi
            fi
        done <<< "$conflicts"
    fi

    # Stow the package
    cd "$DOTFILES_ROOT"
    if stow -v "$package" 2>&1; then
        log_success "$package stowed successfully"
    else
        log_error "Failed to stow $package"
        # Restore backup if exists
        local backup=$(ls -t "$config_dir.backup."* 2>/dev/null | head -1)
        if [ -n "$backup" ]; then
            log_info "Restoring backup..."
            mv "$backup" "$config_dir"
        fi
    fi
}

# Interactive stow selection
interactive_stow() {
    log_section "Stow Manager - Interactive Mode"

    local packages=($(get_stow_packages))

    if [ ${#packages[@]} -eq 0 ]; then
        log_error "No stow packages found in $DOTFILES_ROOT"
        return 1
    fi

    log_info "Available packages in dotfiles:"
    echo ""

    # Display packages with numbers
    local i=1
    for package in "${packages[@]}"; do
        echo "  $i) $package"
        ((i++))
    done
    echo "  $i) Stow All"
    echo "  $((i+1))) Return to Main Menu"
    echo ""

    read -p "Select package to stow [1-$((i+1))]: " choice

    if [ "$choice" -eq "$i" ]; then
        # Stow all
        log_section "Stowing All Packages"
        for package in "${packages[@]}"; do
            stow_package "$package"
            echo ""
        done
    elif [ "$choice" -eq "$((i+1))" ]; then
        # Return to menu
        return 0
    elif [ "$choice" -ge 1 ] && [ "$choice" -lt "$i" ]; then
        # Stow selected package
        local selected="${packages[$((choice-1))]}"
        stow_package "$selected"
    else
        log_error "Invalid selection"
    fi
}

# Unstow a package
unstow_package() {
    local package="$1"

    log_info "Unstowing $package..."
    cd "$DOTFILES_ROOT"

    if stow -D -v "$package" 2>&1; then
        log_success "$package unstowed successfully"
    else
        log_error "Failed to unstow $package"
    fi
}

# Interactive unstow selection
interactive_unstow() {
    log_section "Unstow Manager - Interactive Mode"

    local packages=($(get_stow_packages))

    if [ ${#packages[@]} -eq 0 ]; then
        log_error "No stow packages found in $DOTFILES_ROOT"
        return 1
    fi

    log_info "Available packages to unstow:"
    echo ""

    # Display packages with numbers
    local i=1
    for package in "${packages[@]}"; do
        echo "  $i) $package"
        ((i++))
    done
    echo "  $i) Unstow All"
    echo "  $((i+1))) Return to Main Menu"
    echo ""

    read -p "Select package to unstow [1-$((i+1))]: " choice

    if [ "$choice" -eq "$i" ]; then
        # Unstow all
        log_section "Unstowing All Packages"
        for package in "${packages[@]}"; do
            unstow_package "$package"
        done
    elif [ "$choice" -eq "$((i+1))" ]; then
        # Return to menu
        return 0
    elif [ "$choice" -ge 1 ] && [ "$choice" -lt "$i" ]; then
        # Unstow selected package
        local selected="${packages[$((choice-1))]}"
        unstow_package "$selected"
    else
        log_error "Invalid selection"
    fi
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    interactive_stow
fi
