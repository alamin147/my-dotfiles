# Neovim configuration

This is a LazyVim-based editor with a VS Code-like file explorer and buffer
bar, while keeping normal Neovim workflows and the existing development tools.

## Layout

```text
init.lua                    bootstrap and logical working-directory handling
lua/config/                 editor options, keymaps, autocmds, appearance
lua/plugins/                one focused plugin or feature per file
lua/config/theme-selector.lua
                            active theme name
lua/colors/                 hand-written local themes
colors/dms.lua              generated DMS colorscheme
lua/lualine/themes/dms.lua  generated DMS statusline theme
```

The Neo-tree sidebar is configured in `lua/plugins/explorer.lua`. The top file
bar is configured in `lua/plugins/bufferline.lua`. Cross-theme readability and
transparent UI are owned by `lua/config/appearance.lua`.

## Everyday navigation

- `<C-b>` toggles the Explorer; `<leader>f` reveals the current file.
- `<Tab>` and `<S-Tab>` move through open file buffers.
- `<A-1>` through `<A-9>` jump directly to a visible buffer.
- `<leader>bd` closes the current buffer; `<leader>bo` closes the others.
- `:EditorTransparencyToggle` switches between transparent and opaque UI.
  Selected rows and the active buffer remain filled in transparent mode.

The complete custom mapping reference is in `keybinds.md`.

## Themes

Change `ACTIVE_THEME` in `lua/config/theme-selector.lua`, then restart Neovim.
Use `dms` to follow DMS/Matugen. See `THEME_GUIDE.md` for the data flow and how
to add local or plugin themes.
