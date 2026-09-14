# Neovim configuration

This is a LazyVim-based editor with a VS Code-like file explorer and buffer
bar, while keeping normal Neovim workflows and the existing development tools.

## Layout

```text
init.lua                    bootstrap and logical working-directory handling
lua/config/                 editor options, keymaps, autocmds, appearance
lua/plugins/                one focused plugin or feature per file
lua/config/theme-selector.lua
                            live theme picker and saved selection
lua/nvconfig.lua            NvChad Base46 options
lua/config/theme-integrations/
                            shared-palette UI integrations
colors/nvchad.lua           Base46 colorscheme entry point
colors/dms.lua              generated DMS colorscheme
lua/lualine/themes/dms.lua  generated DMS statusline theme
```

The Neo-tree sidebar is configured in `lua/plugins/explorer.lua`. The top file
bar is configured in `lua/plugins/bufferline.lua`. DMS readability and
transparent UI are owned by `lua/config/appearance.lua`; NvChad themes retain
their own palettes and native Base46 integrations.

## Everyday navigation

- `<C-b>` toggles the Explorer; `<leader>f` reveals the current file.
- `<Tab>` and `<S-Tab>` move through open file buffers.
- `<A-1>` through `<A-9>` jump directly to a visible buffer.
- `<leader>bd` closes the current buffer; `<leader>bo` closes the others.
- `:EditorTransparencyToggle` switches between transparent and opaque UI.
  Selected rows and the active buffer remain filled in transparent mode.

The complete custom mapping reference is in `keybinds.md`.

## Themes

Press `<leader>th` to preview and select DMS or any bundled NvChad theme.
Enter saves your selection; Escape restores the previous theme. Use `:Theme dms`
to follow DMS/Matugen again. See `THEME_GUIDE.md` for integration details.
