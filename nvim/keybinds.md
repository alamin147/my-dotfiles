# Neovim Keybinds

Leader is `<Space>`. This is the audited mapping reference for the active
LazyVim setup. `:Keybinds` / `<leader>hk` is the complete runtime browser; it
shows the effective current-buffer mapping, not shadowed global or native
entries.

## Files and search

| Key | Mode | Action | Owner |
| --- | --- | --- | --- |
| `<leader><space>` | `n` | Find project files | LazyVim / Snacks |
| `<leader>ff` / `<leader>fF` | `n` | Find files from root / cwd | LazyVim / Snacks |
| `;f` | `n` | Telescope files at launch root, including hidden/ignored | custom |
| `;d` | `n` | Telescope files under the current file directory | custom |
| `<leader>e` | `n` | Toggle Neo-tree at the original launch root | custom |
| `<leader>E` | `n` | Toggle Neo-tree at cwd | LazyVim Neo-tree extra |
| `<leader>fe` / `<leader>fE` | `n` | Neo-tree at LazyVim root / cwd | LazyVim Neo-tree extra |
| `<leader>sb` | `n` | Search lines in the current buffer | LazyVim / Snacks |
| `;r` | `n` | Telescope live grep at the original launch root | custom |
| `;w` | `n` | Telescope grep word under cursor | custom |
| `;s` | `n` | Telescope Treesitter symbols | custom |
| `;;` | `n` | Resume Telescope | custom |

`<leader>/` and `<leader>sg` are intentionally disabled aliases; `;r` is the
single launch-root project-grep mapping. `<leader>f` remains a namespace, not a
single action.

## Diagnostics, TODO, and quickfix

| Key | Mode | Action | Owner |
| --- | --- | --- | --- |
| `[d` / `]d` | `n` | Previous / next diagnostic | LazyVim |
| `[e` / `]e` | `n` | Previous / next error | LazyVim |
| `[w` / `]w` | `n` | Previous / next warning | LazyVim |
| `<leader>cd` | `n` | Line diagnostic | LazyVim |
| `<leader>xx` / `<leader>xX` | `n` | Project / current-buffer Trouble diagnostics | LazyVim |
| `;e` | `n` | Telescope diagnostics | custom |
| `;q` | `n` | Put diagnostics in quickfix and open it | custom |
| `<leader>xq` | `n` | Toggle native quickfix | LazyVim |
| `<leader>xQ` | `n` | Trouble quickfix | LazyVim |
| `[q` / `]q` | `n` | Previous / next Trouble or quickfix item | LazyVim |
| `<leader>xt` | `n` | TODO list in Trouble | LazyVim todo-comments |
| `[t` / `]t` | `n` | Previous / next TODO | LazyVim todo-comments |

## LSP and completion

The LSP mappings below are buffer-local and appear when the attached server
supports the action.

| Key | Mode | Action | Owner |
| --- | --- | --- | --- |
| `gd` / `gD` | `n` | Definition / declaration | LazyVim LSP |
| `gr` / `gI` / `gy` | `n` | References / implementation / type definition | LazyVim LSP |
| `K` / `gK` | `n` | Hover / signature help | LazyVim LSP |
| `<C-k>` | `i` | Signature help | LazyVim LSP |
| `<leader>ca` | `n`, `x` | Code action | LazyVim LSP |
| `<leader>cr` | `n` | Rename symbol | LazyVim LSP |
| `<leader>co` | `n` | Organize imports when supported | LazyVim LSP |
| `<leader>cf` | `n`, `x` | Format | LazyVim |
| `<Tab>` / `<S-Tab>` | `i` | Super-Tab completion/snippet navigation | Blink |
| `<C-y>` | `i` | Select and accept completion | LazyVim / Blink |
| `<M-l>` / `<M-w>` | `i` | Accept full / next-word Copilot suggestion | Copilot |
| `<M-]>` / `<M-[>` | `i` | Next / previous Copilot suggestion | Copilot |
| `<C-]>` | `i` | Dismiss Copilot suggestion | Copilot |

Copilot no longer owns `<M-j>`; LazyVim keeps it for moving the insert-mode
line down.

## Buffers, windows, and tabs

| Key | Mode | Action | Owner |
| --- | --- | --- | --- |
| `<Tab>` / `<S-Tab>` | `n` | Next / previous Bufferline buffer | custom |
| `<S-h>` / `<S-l>`, `[b` / `]b` | `n` | Previous / next buffer | LazyVim |
| `<A-1>` … `<A-9>` | `n` | Select visible buffer by position | custom |
| `<leader>bo` | `n` | Delete other buffers | LazyVim / Snacks |
| `<C-h/j/k/l>` | `n` | Move between windows | LazyVim |
| `<C-Arrow>` | `n` | Resize windows | LazyVim |
| `ss` / `sv` | `n` | Horizontal / vertical split | custom |
| `sh` / `sj` / `sk` / `sl` | `n` | Move between windows | custom |
| `<leader>-` / `<leader>\|` | `n` | Horizontal / vertical split | LazyVim |
| `<leader><tab><tab>` | `n` | New tab page | LazyVim |
| `<leader><tab>d` | `n` | Close tab page | LazyVim |
| `<leader><tab>[` / `<leader><tab>]` | `n` | Previous / next tab page | LazyVim |

Tab/Shift-Tab and the `s…` window family are intentional preferred-workflow
aliases. The removed `te` / `tw` mappings no longer shadow native `t{char}`
motions.

## Terminal

| Key | Context | Action |
| --- | --- | --- |
| `<C-\>` | normal / insert | Toggle the persistent editor-column bottom terminal |
| `<C-\>` | its terminal buffer | Hide the terminal without killing its shell |
| `<C-q>` | its terminal buffer | Kill the terminal |
| `<Esc>` / `jk` | terminal buffer | Leave terminal insert mode |
| `<C-h/j/k/l>` | terminal buffer | Move between windows |
| `<C-w>` | terminal buffer | Enter window-command prefix |

LazyVim's Snacks `<C-/>`, `<leader>ft`, and `<leader>fT` entry points and the
custom ToggleTerm leader aliases are disabled. `:ToggleTerm` and `:TermExec`
remain available explicitly; their terminal-local controls stay scoped to
ToggleTerm buffers.

## Flash and scoped plugin mappings

| Key | Context | Action |
| --- | --- | --- |
| `zk` | `n`, `x`, `o` | Flash jump |
| `Zk` | `n`, `x`, `o` | Flash Treesitter jump |
| `r` | operator-pending | Remote Flash |
| `R` | operator-pending / visual | Treesitter search |
| `<C-s>` | command-line | Toggle Flash search |
| `<C-space>` | normal / operator / visual | Flash Treesitter incremental selection |

Flash `s` and `S` are disabled so they cannot compete with `ss`, `sv`,
`sh`, `sj`, `sk`, and `sl`. Neo-tree and Telescope's internal buffer-local
mappings remain plugin-local and are not global duplicates.

## Competitive programming, runner, and debugger

| Key | Mode | Action |
| --- | --- | --- |
| `<F5>` | `n` | Compile and run C++ using `../io/input.txt` |
| `<F6>` / `<F7>` | `n` | Open CP input / output |
| `<F8>` | `n` | Open CP output in a vertical split |
| `<F9>` | `n` | Show CP input/output side by side |
| `<F10>` | `n` | Compile and run with terminal output |
| `<F11>` / `<F12>` | `n` | Verbose compile / CP path diagnostics |
| `<leader>ct` | `n` | Insert the small C++ starter template |
| `cpp` / `cph` | `n` | Insert full / minimal C++ templates |
| `<leader>rr` / `<leader>rc` | `n` | Run current file / close runner output |
| `<leader>db` / `<leader>dc` | `n` | Toggle breakpoint / run or continue |
| `<leader>di` / `<leader>dO` / `<leader>do` | `n` | Step into / over / out |
| `<leader>du` | `n` | Toggle debugger UI |

The CP `<leader>ci`, `<leader>co`, `<leader>cr`, and `<leader>gD` aliases were
removed. Function keys own CP I/O/run actions; LazyVim owns LSP organize-imports
and rename, and Snacks owns Git Diff at `<leader>gD`.

## Themes, help, and editing overrides

| Key | Mode | Action |
| --- | --- | --- |
| `<leader>uC` | `n` | Open the DMS / NvChad theme picker |
| `<leader>hk` | `n` | Open the effective keybinding browser |
| `<leader>?` | `n` | Show current-buffer WhichKey mappings |
| `<C-s>` | `n`, `i`, `x`, `s` | Save | LazyVim |
| `x` | `n` | Delete character without yanking | custom |
| `+` / `-` | `n` | Increment / decrement number | custom |
| `<C-a>` | `n` | Select all | custom |
| `J` / `K` | `x` | Move selected block down / up | custom |

`<leader>uC` is registered once as the custom theme picker. The old
`<leader>th` alias and stale Harpoon documentation are gone.
