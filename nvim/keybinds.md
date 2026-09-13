# Neovim Keybinds

Leader key: `<Space>`

Mode legend:

- `n`: normal
- `i`: insert
- `v`: visual
- `x`: visual/select
- `o`: operator-pending
- `c`: command-line
- `t`: terminal

This lists active custom mappings from this config. Commented-out saved mappings are listed separately at the end.

## General Editing

| Key | Mode | Action | Source |
| --- | --- | --- | --- |
| `x` | `n` | Delete character into the black-hole register | `lua/config/keymaps.lua` |
| `+` | `n` | Increment number | `lua/config/keymaps.lua` |
| `-` | `n` | Decrement number | `lua/config/keymaps.lua` |
| `<C-a>` | `n` | Select entire file | `lua/config/keymaps.lua` |
| `<C-s>` | `n` | Save file | `lua/config/keymaps.lua` |
| `<C-s>` | `i` | Save file and return to insert mode | `lua/config/keymaps.lua` |
| `<C-s>` | `v` | Save file and keep visual selection | `lua/config/keymaps.lua` |

## Files, Buffers, Tabs, And Windows

| Key | Mode | Action | Source |
| --- | --- | --- | --- |
| `<leader>w` | `n` | Save/update current file | `lua/config/keymaps.lua` |
| `<leader>q` | `n` | Quit current window | `lua/config/keymaps.lua` |
| `<leader>Q` | `n` | Quit all windows | `lua/config/keymaps.lua` |
| `<C-b>` | `n` | Toggle the Neo-tree Explorer | `lua/plugins/explorer.lua` |
| `<leader>f` | `n` | Reveal current file in Neo-tree | `lua/plugins/explorer.lua` |
| `<Tab>` | `n` | Go to next file buffer | `lua/plugins/bufferline.lua` |
| `<S-Tab>` | `n` | Go to previous file buffer | `lua/plugins/bufferline.lua` |
| `<A-1>` … `<A-9>` | `n` | Jump to visible buffer by position | `lua/config/keymaps.lua` |
| `<leader>bo` | `n` | Close all other buffers | `lua/plugins/bufferline.lua` |
| `te` | `n` | Open a new tab | `lua/config/keymaps.lua` |
| `tw` | `n` | Close current tab | `lua/config/keymaps.lua` |
| `ss` | `n` | Horizontal split | `lua/config/keymaps.lua` |
| `sv` | `n` | Vertical split | `lua/config/keymaps.lua` |
| `sh` | `n` | Move to left window | `lua/config/keymaps.lua` |
| `sk` | `n` | Move to upper window | `lua/config/keymaps.lua` |
| `sj` | `n` | Move to lower window | `lua/config/keymaps.lua` |
| `sl` | `n` | Move to right window | `lua/config/keymaps.lua` |
| `<C-h>` | `n` | Move to left window | `lua/config/keymaps.lua` |
| `<C-k>` | `n` | Move to upper window | `lua/config/keymaps.lua` |
| `<C-j>` | `n` | Move to lower window | `lua/config/keymaps.lua` |
| `<C-l>` | `n` | Move to right window | `lua/config/keymaps.lua` |
| `<C-S-h>` | `n` | Shrink window width | `lua/config/keymaps.lua` |
| `<C-S-l>` | `n` | Grow window width | `lua/config/keymaps.lua` |
| `<C-S-k>` | `n` | Grow window height | `lua/config/keymaps.lua` |
| `<C-S-j>` | `n` | Shrink window height | `lua/config/keymaps.lua` |

## Neo-tree Panel

These mappings apply inside the Neo-tree window.

| Key | Mode | Action | Source |
| --- | --- | --- | --- |
| `<CR>` | Neo-tree | Open item | `lua/plugins/explorer.lua` |
| `o` | Neo-tree | Open item | `lua/plugins/explorer.lua` |
| `l` | Neo-tree | Open item | `lua/plugins/explorer.lua` |
| `H` | Neo-tree | Toggle hidden files | `lua/plugins/explorer.lua` |

## Telescope And Search

| Key | Mode | Action | Source |
| --- | --- | --- | --- |
| `<leader>bs` | `n` | Fuzzy find inside current buffer | `lua/config/keymaps.lua` |
| `;fw` | `n` | Live grep open/current-file search workflow | `lua/config/keymaps.lua` |
| `<leader>/` | `n` | Live grep in current working directory | `lua/config/keymaps.lua` |
| `;f` | `n` | Find files, including hidden and ignored files | `lua/plugins/telescope.lua` |
| `;r` | `n` | Live grep in current working directory | `lua/plugins/telescope.lua` |
| `\\` | `n` | List open buffers | `lua/plugins/telescope.lua` |
| `;;` | `n` | Resume previous Telescope picker | `lua/plugins/telescope.lua` |
| `;e` | `n` | Show diagnostics picker | `lua/plugins/telescope.lua` |
| `;s` | `n` | Show Treesitter symbols picker | `lua/plugins/telescope.lua` |
| `;d` | `n` | Find files under current file directory | `lua/plugins/telescope.lua` |
| `;w` | `n` | Search word under cursor | `lua/plugins/telescope.lua` |
| `sf` | `n` | Open Telescope file browser at current buffer directory | `lua/plugins/telescope.lua` |

## Telescope File Browser

These mappings apply inside the Telescope file browser in normal mode.

| Key | Mode | Action | Source |
| --- | --- | --- | --- |
| `N` | Telescope file browser | Create file or directory | `lua/plugins/telescope.lua` |
| `h` | Telescope file browser | Go to parent directory | `lua/plugins/telescope.lua` |
| `<C-u>` | Telescope file browser | Move selection up by 10 | `lua/plugins/telescope.lua` |
| `<C-d>` | Telescope file browser | Move selection down by 10 | `lua/plugins/telescope.lua` |

## Diagnostics, LSP, And Code Actions

| Key | Mode | Action | Source |
| --- | --- | --- | --- |
| `]d` | `n` | Go to next diagnostic | `lua/config/keymaps.lua` |
| `[d` | `n` | Go to previous diagnostic | `lua/config/keymaps.lua` |
| `<C-k>` | `i` | Show LSP signature help | `lua/config/keymaps.lua` |
| `<leader>ca` | `n` | Code actions | `lua/config/keymaps.lua` |
| `<leader>ca` | `v` | Code actions for visual selection | `lua/config/keymaps.lua` |
| `<leader>rn` | `n` | Incremental rename for word under cursor | `lua/plugins/plugs.lua` |
| `<leader>r` | `v` | Select refactor action | `lua/plugins/plugs.lua` |

## Completion And Snippets

| Key | Mode | Action | Source |
| --- | --- | --- | --- |
| `<C-space>` | Blink completion | Show completion and documentation, or hide documentation | `lua/plugins/completion.lua` |
| `<C-e>` | Blink completion | Hide completion menu | `lua/plugins/completion.lua` |
| `<C-y>` | Blink completion | Select and accept item | `lua/plugins/completion.lua` |
| `<C-p>` | Blink completion | Select previous item, then fallback | `lua/plugins/completion.lua` |
| `<C-n>` | Blink completion | Select next item, then fallback | `lua/plugins/completion.lua` |
| `<C-b>` | Blink completion | Scroll documentation up, then fallback | `lua/plugins/completion.lua` |
| `<C-f>` | Blink completion | Scroll documentation down, then fallback | `lua/plugins/completion.lua` |
| `<Tab>` | Blink completion | Accept completion or move forward in a snippet | `lua/plugins/completion.lua` |
| `<S-Tab>` | Blink completion | Jump backward in snippet, then fallback | `lua/plugins/completion.lua` |
| `<C-k>` | Blink completion | Show or hide function signature help | `lua/plugins/completion.lua` |
| `<M-l>` | Copilot suggestion | Accept the full inline suggestion | `lua/plugins/ai.lua` |
| `<M-w>` | Copilot suggestion | Accept the next suggested word | `lua/plugins/ai.lua` |
| `<M-j>` | Copilot suggestion | Accept the next suggested line | `lua/plugins/ai.lua` |
| `<M-]>` | Copilot suggestion | Show the next suggestion | `lua/plugins/ai.lua` |
| `<M-[>` | Copilot suggestion | Show the previous suggestion | `lua/plugins/ai.lua` |
| `<C-]>` | Copilot suggestion | Dismiss the inline suggestion | `lua/plugins/ai.lua` |

## Terminal

| Key | Mode | Action | Source |
| --- | --- | --- | --- |
| `<leader>ttt` | `n` | Toggle floating terminal | `lua/config/keymaps.lua` |
| `<leader>tth` | `n` | Open horizontal terminal split | `lua/config/keymaps.lua` |
| `<leader>ttv` | `n` | Toggle vertical terminal | `lua/config/keymaps.lua` |
| `<leader>rt` | `n` | Toggle most recently used terminal or open one | `lua/config/keymaps.lua` |
| `<Esc>` | `t` | Leave terminal insert mode | `lua/plugins/toggleterm.lua` |
| `jk` | `t` | Leave terminal insert mode | `lua/plugins/toggleterm.lua` |
| `<C-q>` | `t` | Kill terminal buffer | `lua/plugins/toggleterm.lua` |
| `<C-x>` | `t` | Kill terminal buffer | `lua/plugins/toggleterm.lua` |
| `<C-h>` | `t` | Move to left window | `lua/plugins/toggleterm.lua` |
| `<C-j>` | `t` | Move to lower window | `lua/plugins/toggleterm.lua` |
| `<C-k>` | `t` | Move to upper window | `lua/plugins/toggleterm.lua` |
| `<C-l>` | `t` | Move to right window | `lua/plugins/toggleterm.lua` |
| `<C-w>` | `t` | Enter window command prefix from terminal mode | `lua/plugins/toggleterm.lua` |

Note: ToggleTerm has no default `open_mapping` active; use the leader terminal mappings above.

## Competitive Programming And C++

| Key | Mode | Action | Source |
| --- | --- | --- | --- |
| `<F5>` | `n` | Save, compile C++ file, run with `../io/input.txt`, write `../io/output.txt` | `lua/config/keymaps.lua` |
| `<F6>` | `n` | Open `../io/input.txt` | `lua/config/keymaps.lua` |
| `<F7>` | `n` | Open `../io/output.txt` | `lua/config/keymaps.lua` |
| `<F8>` | `n` | Open `../io/output.txt` in a vertical split | `lua/config/keymaps.lua` |
| `<leader>ci` | `n` | Open `../io/input.txt` | `lua/config/keymaps.lua` |
| `<leader>co` | `n` | Open `../io/output.txt` | `lua/config/keymaps.lua` |
| `<leader>cr` | `n` | Save, compile, and run current C++ file | `lua/config/keymaps.lua` |
| `<leader>ct` | `n` | Insert small C++ starter template | `lua/config/keymaps.lua` |
| `<F9>` | `n` | Show input and output side by side | `lua/config/keymaps.lua` |
| `<F10>` | `n` | Compile and run with terminal output | `lua/config/keymaps.lua` |
| `cpp` | `n` | Insert full C++ competitive-programming template | `lua/config/keymaps.lua` |
| `cph` | `n` | Insert minimal C++ header template | `lua/config/keymaps.lua` |
| `<F11>` | `n` | Compile with verbose debug output | `lua/config/keymaps.lua` |
| `<F12>` | `n` | Print current directory and CP path status | `lua/config/keymaps.lua` |
| `<leader>gD` | `n` | Compile current file with `g++ --debug` into CP outputs directory | `lua/config/keymaps.lua` |

## Code Runner, TODO, And Utilities

| Key | Mode | Action | Source |
| --- | --- | --- | --- |
| `<leader>rr` | `n` | Run current file with Code Runner | `lua/config/keymaps.lua` |
| `<leader>rrc` | `n` | Close Code Runner output | `lua/config/keymaps.lua` |
| `<leader>xt` | `n` | Open TODO quickfix list | `lua/config/keymaps.lua` |
| `<leader>?` | `n` | Show buffer-local keymaps with WhichKey | `lua/plugins/plugs.lua` |

## Harpoon

| Key | Mode | Action | Source |
| --- | --- | --- | --- |
| `<leader>ha` | `n` | Add current file to Harpoon | `lua/plugins/plugs.lua` |
| `<leader>hh` | `n` | Toggle Harpoon quick menu | `lua/plugins/plugs.lua` |
| `<leader>hn` | `n` | Go to next Harpoon file | `lua/plugins/plugs.lua` |
| `<leader>hp` | `n` | Go to previous Harpoon file | `lua/plugins/plugs.lua` |

## Flash

| Key | Mode | Action | Source |
| --- | --- | --- | --- |
| `zk` | `n`, `x`, `o` | Flash jump | `lua/plugins/flash.lua` |
| `Zk` | `n`, `x`, `o` | Flash Treesitter jump | `lua/plugins/flash.lua` |
| `r` | `o` | Remote Flash | `lua/plugins/flash.lua` |
| `R` | `o`, `x` | Flash Treesitter search | `lua/plugins/flash.lua` |
| `<C-s>` | `c` | Toggle Flash search | `lua/plugins/flash.lua` |

## Plugin Commands Without Direct Keybinds

| Command | Action | Source |
| --- | --- | --- |
| `:Tetris` | Open Tetris | `lua/plugins/plugs.lua` |
| `:Rain` | Run `CellularAutomaton make_it_rain` | `lua/plugins/plugs.lua` |
| `:CellularAutomaton` | Run cellular automaton animations | `lua/plugins/plugs.lua` |
| `:ToggleTerm` | Open ToggleTerm manually | `lua/plugins/toggleterm.lua` |
| `:TermExec` | Execute command in ToggleTerm | `lua/plugins/toggleterm.lua` |
| `:EditorTransparencyToggle` | Toggle the transparent editor canvas | `lua/config/appearance.lua` |

## Inactive Or Saved Commented Mappings

These were found in comments or disabled example specs, so they are not active right now.

| Key | Intended Action | Source |
| --- | --- | --- |
| `<leader>th` | Telescope theme switcher | `lua/config/keymaps.lua` |
| `<leader>fp` | Find Lazy plugin files | `lua/plugins/example.lua` |
| `<leader>cR` | Typescript rename file | `lua/plugins/example.lua` |

Note: `lua/plugins/example.lua` returns an empty spec immediately, so its later example mappings are documentation only.
