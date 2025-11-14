# Theme Configuration Guide

All theme-related settings are now centrally managed in `lua/plugins/theme.lua`.

## Quick Start

Edit `lua/plugins/theme.lua` and modify the `config` table at the top:

```lua
local config = {
  active_theme = "sonokai",  -- Change this to switch themes
  transparency = {
    enabled = true,           -- Toggle transparency on/off
  },
  -- ... theme-specific settings below
}
```

## Available Themes

- `sonokai` - Modern, vibrant colorscheme (default)
- `gruvbox-material` - Warm, retro-inspired theme
- `nord` - Arctic, north-bluish color palette
- `onedark` - Atom's iconic One Dark theme
- `cyberdream` - Futuristic cyberpunk theme

## How to Switch Themes

1. Open `lua/plugins/theme.lua`
2. Change `active_theme = "sonokai"` to your desired theme
3. Restart Neovim or run `:Lazy sync`

## Transparency Settings

### Enable/Disable Transparency
```lua
transparency = {
  enabled = true,  -- Set to false to disable
}
```

### Sonokai Background Transparency
```lua
transparency = {
  background = "0",  -- "0" = opaque, "1" = partial, "2" = full
}
```

## Theme-Specific Settings

### Sonokai
```lua
sonokai = {
  style = "andromeda",      -- default, atlantis, andromeda, shusia, maia, espresso
  enable_italic = true,
}
```

### Gruvbox Material
```lua
gruvbox_material = {
  enable_italic = true,
  background = "medium",    -- soft, medium, hard
}
```

### Nord
```lua
nord = {
  contrast = false,
  italic = true,
}
```

## What Was Changed?

- **Consolidated**: All theme settings from `colorscheme.lua` and `transparency.lua` are now in `theme.lua`
- **Organized**: Easy-to-find configuration section at the top
- **Efficient**: Only the active theme is loaded (using `enabled` flag)
- **Automatic**: Transparency applies automatically after theme loads

## File Organization

- ✅ `lua/plugins/theme.lua` - **USE THIS** for all theme settings
- ❌ `lua/plugins/colorscheme.lua` - Deprecated, kept for compatibility
- ❌ `lua/plugins/transparency.lua` - Deleted (merged into theme.lua)

## Tips

1. **Change theme quickly**: Just change `active_theme` value
2. **Toggle transparency**: Set `transparency.enabled` to `true`/`false`
3. **Customize per theme**: Each theme has its own settings section
4. **Add new themes**: Follow the pattern in theme.lua's plugin list

Enjoy your organized theme configuration! 🎨
