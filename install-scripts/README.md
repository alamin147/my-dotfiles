# Installation Scripts

Modern, modular installation automation for Linux dotfiles setup.

## Structure

```
install-scripts/
├── install.sh              # Master installer (interactive & CLI)
├── installers/             # Individual installation modules
│   ├── core-tools.sh      # stow, alacritty, neovim
│   ├── shell-tools.sh     # starship, zoxide, tmux, yazi
│   ├── system-tools.sh    # wlsunset, auto-cpufreq
│   ├── dev-tools.sh       # yarn, lazygit
│   ├── applications.sh    # transmission, localsend, brave, thorium, vlc, vscode
│   └── stow-manager.sh    # Interactive dotfiles stowing/unstowing
└── utils/
    └── logging.sh         # Colored logging utilities
```

## Usage

### Interactive Mode

Run the master installer without arguments for an interactive menu:

```bash
./install.sh
```

You'll see a menu to select what to install:
- Individual categories (core, shell, system, dev, apps)
- Everything at once
- Stow/Unstow dotfiles interactively
- Exit

### Command Line Mode

**Complete setup (install + stow):**

```bash
# Install everything AND stow dotfiles interactively
./install.sh --all
```

**Or install specific categories:**

```bash
./install.sh --core      # Core tools only
./install.sh --shell     # Shell tools only
./install.sh --system    # System tools only
./install.sh --dev       # Dev tools only
./install.sh --apps      # Applications only
```

**Manage dotfiles separately:**

```bash
./install.sh --stow      # Stow dotfiles interactively
./install.sh --unstow    # Unstow dotfiles interactively
```

### Individual Scripts

You can also run individual installer scripts directly:

```bash
./installers/core-tools.sh
./installers/stow-manager.sh    # Interactive stow management
./installers/shell-tools.sh
./installers/system-tools.sh
./installers/dev-tools.sh
./installers/applications.sh
```

## What Gets Installed

### Core Tools
- **GNU Stow** - Dotfiles symlink manager
- **Alacritty** - GPU-accelerated terminal emulator
- **Neovim** - Hyperextensible Vim-based text editor

### Shell Tools
- **Starship** - Fast, customizable shell prompt
- **Zoxide** - Smarter cd command
- **Tmux** - Terminal multiplexer
- **Yazi** - Blazing fast terminal file manager

### System Tools
- **wlsunset** - Day/night gamma adjustments for Wayland
- **auto-cpufreq** - Automatic CPU speed & power optimizer

### Dev Tools
- **Yarn** - Fast, reliable package manager
- **Lazygit** - Terminal UI for git commands

### Applications
- **Transmission** - BitTorrent client
- **LocalSend** - Local file sharing (Flatpak)
- **Brave Browser** - Privacy-focused web browser
- **Thorium Browser** - Chromium-based browser optimized for speed
- **VLC** - Powerful media player
- **Visual Studio Code** - Modern code editor

## Stow Manager

The stow manager provides an interactive way to symlink your dotfiles to their proper locations.

### How It Works

1. **Lists Available Packages**: Shows all dotfile directories (alacritty, nvim, zsh, etc.)
2. **Backup Protection**: Automatically backs up existing configs before stowing
3. **Safe Operation**: Creates timestamped backups (e.g., `.config/alacritty.backup.20251211_143022`)
4. **Individual or Bulk**: Stow packages one at a time or all at once

### Usage

**Interactive Mode:**
```bash
./install.sh --stow     # From the menu, select option 7
```

**Direct Execution:**
```bash
./installers/stow-manager.sh
```

### Example Workflow

```bash
# 1. Select alacritty from the menu
# 2. Script checks if ~/.config/alacritty exists
# 3. If exists, asks to backup and replace
# 4. Creates backup: ~/.config/alacritty.backup.20251211_143022
# 5. Runs: stow alacritty
# 6. Your dotfiles are now symlinked!
```

### Unstowing

To remove symlinks and restore originals:
```bash
./install.sh --unstow    # From menu, select option 8
```

## Requirements

- **OS**: Fedora Linux (or compatible)
- **Permissions**: sudo access required
- **Network**: Internet connection for downloads

## Features

✨ **Modular Design** - Install only what you need
🎨 **Colored Output** - Easy-to-read installation progress
🔒 **Error Handling** - Stops on errors (set -e)
📝 **Logging** - Clear status messages and success indicators
🔄 **Reusable** - Run scripts multiple times safely
⚡ **Fast** - Parallel-ready architecture
🔗 **Stow Manager** - Interactive dotfiles symlinking with backup protection

## Tips

1. **First Time Setup**:
   - Run `./install.sh --all` (installs all packages, then shows stow menu)
   - Select which dotfiles to symlink from the interactive menu
2. **Selective Install**: Use individual scripts or menu options for specific tools
3. **Stow Management**: Use option 7 from menu or `./install.sh --stow` anytime
4. **Backup Safety**: Existing configs are automatically backed up with timestamps
5. **Shell Reload**: Run `exec zsh` or restart terminal after shell tools install

## Customization

Each installer script can be modified independently. The modular structure makes it easy to:
- Add new packages to existing categories
- Create new category scripts
- Modify installation methods
- Add pre/post-install hooks

## Troubleshooting

If an installation fails:
1. Check error messages (in red)
2. Ensure you have sudo privileges
3. Verify internet connection
4. Check Fedora version compatibility
5. Review script logs

## Contributing

When adding new tools:
1. Choose appropriate category or create new script
2. Follow existing error handling patterns
3. Use logging functions for output
4. Test both standalone and integrated modes
5. Update this README

## License

Part of your dotfiles setup - use freely!
