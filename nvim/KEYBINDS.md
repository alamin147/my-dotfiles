# Neovim Core Keybinds

`Space` is the leader key. Press `Space` and wait briefly to see the available
groups. Use `Space+h+k` or `:Keybinds` for a searchable list of every active
mapping; the list updates automatically when the configuration changes.

## Files and explorer

| Key | Action |
|---|---|
| `Space Space` | Find files from the project launch folder |
| `Space e` | Toggle Neo-tree at the project launch folder |
| `Ctrl-b` | Toggle Neo-tree at the project launch folder |
| `Space f` | Reveal the current file in Neo-tree |

## Text search

| Key | Action |
|---|---|
| `Space s f` | Search text in the current file |
| `Space s g` | Search text in all files from the project launch folder |
| `Space s k` | Search all active keymaps (LazyVim alias) |
| `Space h k` | Search all active keymaps (help alias) |

## Buffers, tabs, and windows

| Key | Action |
|---|---|
| `Tab` / `Shift-Tab` | Next / previous buffer |
| `Alt-1` ... `Alt-9` | Select a visible buffer |
| `t e` | Create a tab page |
| `t w` | Close the current tab page |
| `s s` | Horizontal split |
| `s v` | Vertical split |
| `Ctrl-h/j/k/l` | Move between editor windows |

## Editing and diagnostics

| Key | Action |
|---|---|
| `Space w` | Save the current file |
| `Space q` | Close the current window |
| `Space Q` | Quit Neovim |
| `Space c f` | Format the current file (or visual selection) |
| `Space c d` | Show the diagnostic under the cursor |
| `Space x X` | Show all errors/warnings for the current file |
| `Space x x` | Show all project diagnostics |
| `; e` | Open the diagnostics picker |
| `[ d` / `] d` | Previous / next diagnostic |
| `[ e` / `] e` | Previous / next error |
| `[ w` / `] w` | Previous / next warning |

## Completion and AI suggestions

| Key | Action |
|---|---|
| `Tab` / `Shift-Tab` | Accept or move through completion/snippet choices |
| `Ctrl-Space` | Open completion manually |
| `Ctrl-k` | Show or hide function signature help |
| `Alt-l` | Accept the full Copilot inline suggestion |
| `Alt-w` | Accept the next Copilot word |
| `Alt-j` | Accept the next Copilot line |
| `Alt-]` / `Alt-[` | Next / previous Copilot suggestion |
| `Ctrl-]` | Dismiss the Copilot suggestion |

Copilot is optional. Run `:Copilot auth` once to sign in; ordinary completion
works without a Copilot account.

## Terminal

| Key | Action |
|---|---|
| `Ctrl-\\` | Toggle the persistent editor-width bottom terminal |
| `Ctrl-q` | Kill the focused terminal |

## Competitive programming

| Key | Action |
|---|---|
| `F5` | Compile and run C++ |
| `F6` | Open the input file |
| `F7` | Open the output file |
| `F8` | Open output in a vertical split |

## Commands

| Command | Action |
|---|---|
| `:Keybinds` | Open the searchable active-keymap picker |
| `:EditorTransparencyToggle` | Toggle transparent/opaque editor UI |
