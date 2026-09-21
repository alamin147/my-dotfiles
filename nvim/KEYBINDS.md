# Neovim Core Keybinds

`Space` is the leader. Use `Space h k` or `:Keybinds` for the effective
current-buffer map browser; shadowed global and native mappings are hidden.

## Files and search

| Key | Action |
| --- | --- |
| `Space Space` | Find project files |
| `Space e` | Toggle Neo-tree at the original launch folder |
| `; f` | Find launch-root files, including hidden/ignored |
| `Space s b` | Search the current buffer |
| `; r` | Project live grep at the original launch folder |
| `; d` | Find files under the current file's directory |
| `; w` | Grep the word under the cursor |
| `; s` | Treesitter symbols |
| `; ;` | Resume Telescope |

## Diagnostics and quickfix

| Key | Action |
| --- | --- |
| `[ d` / `] d` | Previous / next diagnostic |
| `[ e` / `] e` | Previous / next error |
| `[ w` / `] w` | Previous / next warning |
| `Space x x` / `Space x X` | Project / current-buffer Trouble diagnostics |
| `; e` | Telescope diagnostics |
| `; q` | Send diagnostics to quickfix and open it |
| `Space x q` | Toggle native quickfix |
| `[ q` / `] q` | Previous / next Trouble or quickfix item |

## LSP

| Key | Action |
| --- | --- |
| `g d` | Definition |
| `g r` | References |
| `K` | Hover |
| `Ctrl-k` in insert mode | Signature help |
| `Space c a` | Code action |
| `Space c r` | Rename |
| `Space c o` | Organize imports when supported |
| `Space c f` | Format |

## Buffers, windows, and tabs

| Key | Action |
| --- | --- |
| `Tab` / `Shift-Tab` | Next / previous buffer |
| `Alt-1` … `Alt-9` | Select visible buffer by position |
| `Space b o` | Delete other buffers |
| `Ctrl-h/j/k/l` | Move between windows |
| `s s` / `s v` | Horizontal / vertical split |
| `s h/j/k/l` | Move between windows using the custom scheme |
| `Space Tab Tab` | New tab page |
| `Space Tab d` | Close tab page |
| `Space Tab [` / `Space Tab ]` | Previous / next tab page |

## Terminal

| Key | Action |
| --- | --- |
| `Ctrl-\` | Toggle the persistent editor-column bottom terminal |
| `Ctrl-q` in that terminal | Kill it |
| `Esc` / `j k` in a terminal | Leave terminal insert mode |

## Competitive programming and debugger

| Key | Action |
| --- | --- |
| `F5` | Compile and run C++ |
| `F6` / `F7` / `F8` | Input / output / output split |
| `Space r r` / `Space r c` | Run current file / close runner output |
| `Space d b` | Toggle breakpoint |
| `Space d c` | Run or continue debugging |
| `Space d i` / `Space d O` / `Space d o` | Step into / over / out |
| `Space d u` | Toggle debugger UI |

## Flash, themes, completion, and help

| Key | Action |
| --- | --- |
| `z k` / `Z k` | Flash / Flash Treesitter |
| `Space u C` | DMS / NvChad theme picker |
| `Ctrl-s` | Save in normal, insert, visual, or select mode |
| `Tab` / `Shift-Tab` in insert mode | Completion/snippet navigation |
| `Alt-l` / `Alt-w` | Accept full / next-word Copilot suggestion |
| `Space h k` | Search effective mappings and native defaults |
| `Space ?` | Buffer-local WhichKey mappings |

The longer audited reference is in `keybinds.md`.
