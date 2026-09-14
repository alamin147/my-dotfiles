# Themes: DMS + NvChad Base46

Press **Space t h** (or **Space u C**) to open the searchable theme picker.
Moving through results previews the theme across the editor. Enter confirms and
saves it; Escape or closing the picker restores the previous theme.

You can also use `:Theme onedark`, `:Theme gruvbox_light`, or `:Theme dms`.
`:Theme` opens the picker and command completion lists installed Base46 themes.
DMS is the initial default. Choices are saved in
`stdpath("state")/dms-theme.json`, so switching does not rewrite tracked Lua files.

## How the integration works

NvChad's [Base46 engine](https://github.com/NvChad/base46) provides both
`base_16` syntax colors and `base_30` UI colors. Its integrations compile
highlights to Lua bytecode. This setup uses that engine directly, including
theme-specific polish, Treesitter, semantic tokens, diagnostics, Telescope,
Blink completion, Git, Which-key, Mason, Markdown, Trouble, and debugger groups.

The local `lua/nvconfig.lua` supplies Base46's configuration contract.
`lua/config/theme-integrations/desktop.lua` adds Neo-tree, Noice, Snacks,
Mini Icons, and buffer-bar details through Base46's same compilation pipeline.
Lualine's mode colors come from that same active palette while retaining your
clock and breadcrumbs. Your editor remains LazyVim with its existing plugins.

`colors/nvchad.lua` provides the standard ColorScheme lifecycle. Themes are
recompiled when switched; late-loaded plugins receive the compiled highlights
after setup. Embedded terminal ANSI colors are refreshed too (already-running
terminal jobs may retain colors cached when they were created).
Compiled caches are private to each editor process and removed on normal exit,
so previewing a theme cannot change another running editor's integrations.

Theme selection is intentionally editor-only. Neovim does not export its
palette to Ghostty or change tmux styling; both continue following DMS.

## DMS and transparency

The `dms` choice keeps your existing Matugen-generated colorscheme and live
watcher. Its Lualine palette is reloaded when the DMS colorscheme refreshes.
DMS contrast adjustments apply only to DMS, never to the Base46 themes.

DMS starts transparent; NvChad themes start opaque to preserve their authored
backgrounds, especially for light themes. `:EditorTransparencyToggle` remembers
your preference separately for each theme. Selected rows remain filled.

The generated DMS files still come from:

- `~/.config/matugen/templates/nvim-dms.lua` → `colors/dms.lua`
- `~/.config/matugen/templates/nvim-dms-lualine.lua` → `lua/lualine/themes/dms.lua`

Keep DMS's built-in Neovim template disabled while those standalone templates
own the same output paths. No Matugen or desktop settings were changed here.

## Maintenance

The independent colorscheme plugin collection and old `lua/colors/` themes
have been removed. Theme names now come from the installed Base46 catalog.
Base46 is pinned in `lazy-lock.json` along with your other dependencies.

To adjust a palette or an integration, use `base46.changed_themes`,
`hl_override`, or `hl_add` in `lua/nvconfig.lua`; use palette color names
instead of unrelated hardcoded colors. Local integration code belongs in
`lua/config/theme-integrations/`. After edits, reselect the theme to recompile.

This setup is active at `~/.config/nvim` and mirrored in
`/home/alamin/dms-dotfiles/nvim`. The exploratory NvChad configuration,
plugins, state, and cache were backed up before restoration to
`~/.local/share/nvim-backups/nvchad-20260913-224501/`.
