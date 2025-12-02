# 🎨 Neovim Theme System Guide

## Quick Start: Changing Themes

1. Open `lua/config/theme-selector.lua`
2. Edit **line 5** only:
   ```lua
   local ACTIVE_THEME = "your-theme-name"
   ```
3. Save and run `:Lazy sync` or restart Neovim

---

## Adding New Themes

### Option 1: Simple Plugin Theme (Most Common)

Use this for themes that just need to be installed and activated.

**Steps:**

1. **Add to `lua/config/theme-selector.lua`** - Add to the comments list:
   ```lua
   -- "theme-name"        -- Theme description
   ```

2. **Add to `lua/plugins/theme.lua`** - Add to the `theme_plugins` table:
   ```lua
   local theme_plugins = {
     -- ... existing themes
     ["theme-name"] = "github-user/repo-name.nvim",
   }
   ```

**Example:** Adding "tokyodark" theme:

```lua
-- In theme-selector.lua:
-- "tokyodark"          -- Tokyo Dark theme

-- In theme.lua (add to theme_plugins):
["tokyodark"] = "tiagovla/tokyodark.nvim",
```

Then use it:
```lua
local ACTIVE_THEME = "tokyodark"
```

---

### Option 2: Plugin Theme with Custom Config

Use this when the theme requires special setup or configuration.

**Steps:**

1. **Add to `lua/config/theme-selector.lua`** - Add under "Plugin themes with custom config" section:
   ```lua
   -- "theme-name"        -- Theme description
   ```

2. **Add to `lua/plugins/theme.lua`** - Add a new `elseif` block **before** the `carbonfox` section:

   ```lua
   elseif active_theme == "theme-name" then
     -- Your Theme Name
     return {
       {
         "github-user/repo-name.nvim",
         lazy = false,
         priority = 1000,
         config = function()
           require("theme-name").setup({
             -- Your custom options here
             option1 = true,
             colors = {
               -- Custom colors if needed
             },
           })
           vim.cmd("colorscheme theme-name")
         end,
       },
     }
   ```

**Example:** The existing "onedark" theme:

```lua
elseif active_theme == "onedark" then
  return {
    {
      "olimorris/onedarkpro.nvim",
      priority = 1000,
      config = function()
        require("onedarkpro").setup({
          theme = "onedark",
          highlights = {
            LineNr = { fg = "#5c6370", bg = "bg" },
            TabLineFill = { bg = "bg" },
            TabLine = { bg = "bg" },
            TabLineSel = { bg = "#282c34" },
          },
        })
        vim.cmd("colorscheme onedark")
      end,
    },
  }
```

---

### Option 3: Custom Inline Theme

Use this to create your own theme from scratch without installing a plugin.

**Steps:**

1. **Create theme file:** `lua/colors/your-theme-name.lua`

   ```lua
   -- Your Custom Theme
   local M = {}

   function M.setup()
     -- Reset highlighting
     vim.cmd("highlight clear")
     if vim.fn.exists('syntax_on') then
       vim.cmd("syntax reset")
     end

     vim.o.termguicolors = true
     vim.o.background = 'dark'
     vim.g.colors_name = 'your-theme-name'

     local colors = {
       bg = "#000000",
       fg = "#ffffff",
       red = "#ff0000",
       green = "#00ff00",
       blue = "#0000ff",
       -- Add more colors...
     }

     -- Set highlights
     vim.api.nvim_set_hl(0, "Normal", { fg = colors.fg, bg = colors.bg })
     vim.api.nvim_set_hl(0, "Comment", { fg = colors.green, italic = true })
     vim.api.nvim_set_hl(0, "Keyword", { fg = colors.red, bold = true })
     vim.api.nvim_set_hl(0, "String", { fg = colors.green })
     vim.api.nvim_set_hl(0, "Function", { fg = colors.blue, bold = true })
     -- Add more highlight groups...
   end

   return M
   ```

2. **Add to `lua/plugins/theme.lua`** - Add to the `custom_themes` table:

   ```lua
   local custom_themes = {
     "aetheria",
     "arc-blueberry",
     "azure-glow",
     "abhijeet-custom",
     "neovoid",
     "your-theme-name",  -- Add this line
   }
   ```

3. **Add to `lua/config/theme-selector.lua`** - Add under "Custom inline themes" section:

   ```lua
   -- "your-theme-name"   -- Your theme description
   ```

**Example:** Look at existing custom themes like `lua/colors/aetheria.lua` or `lua/colors/neovoid.lua`

---

## File Structure Overview

```
~/.config/nvim/
├── lua/
│   ├── config/
│   │   └── theme-selector.lua    # Change line 5 to switch themes
│   ├── plugins/
│   │   └── theme.lua             # Theme loading logic
│   └── colors/                   # Custom inline themes
│       ├── aetheria.lua
│       ├── arc-blueberry.lua
│       ├── azure-glow.lua
│       ├── abhijeet-custom.lua
│       └── neovoid.lua
```

---

## Common Highlight Groups Reference

When creating custom themes, here are the essential highlight groups:

### Editor
- `Normal` - Default text and background
- `Comment` - Comments
- `CursorLine` - Current line background
- `CursorLineNr` - Current line number
- `LineNr` - Line numbers
- `Visual` - Visual selection
- `Search` - Search highlights
- `IncSearch` - Incremental search

### Syntax
- `Keyword` - Keywords (if, else, function, etc.)
- `Function` - Function names
- `String` - String literals
- `Number` - Numbers
- `Boolean` - true/false
- `Operator` - Operators (+, -, *, etc.)
- `Type` - Type definitions
- `Constant` - Constants
- `Special` - Special characters

### UI
- `StatusLine` - Status line
- `Pmenu` - Popup menu
- `PmenuSel` - Popup menu selection
- `TabLine` - Tab line
- `FloatBorder` - Floating window borders

---

## Tips

1. **Test themes quickly:** After editing theme-selector.lua, just run `:Lazy reload` instead of restarting Neovim

2. **Hot reload for custom themes:** The `omarchy-theme-hotreload.lua` plugin automatically reloads theme changes

3. **Check current theme:** Run `:echo g:colors_name` in Neovim

4. **List all available themes:** Look at the comments in `theme-selector.lua`

5. **Copy existing themes:** The easiest way to create a custom theme is to copy an existing one from `lua/colors/` and modify the colors

---

## Currently Available Themes (52 total)

### Plugin-based themes (37)
bamboo, ash, aether, ethereal, hackerman, catppuccin (+ variants), everforest, flexoki (+ variants), gruvbox, everviolet, dracula, kanagawa (+ variants), matteblack, monokai-pro (+ variants), nord, rose-pine (+ variants), tokyonight (+ variants), gruvbox-material

### Custom inline themes (5)
aetheria, arc-blueberry, azure-glow, abhijeet-custom, neovoid

### Plugin themes with custom config (7)
onedark, pixel, poimandres, aether-custom, vesper, vhs80, carbonfox

---

## Troubleshooting

**Theme not loading?**
- Run `:Lazy sync` to install the plugin
- Check for typos in theme name
- Restart Neovim

**Colors look wrong?**
- Ensure `termguicolors` is enabled: `:set termguicolors`
- Check your terminal supports true colors

**Want to modify a plugin theme?**
- Convert it to a custom config theme (Option 2)
- Override specific highlights in the config function

---

**Last Updated:** December 2, 2025
