-- ============================================================================
-- THEME CONFIGURATION - Centralized colorscheme management
-- ============================================================================
--
-- 🎨 FEATURES:
-- • Press <leader>th to open interactive theme picker with live preview
-- • Navigate themes with j/k or arrow keys - changes apply instantly
-- • Press Enter to save, Esc to cancel and restore original theme
-- • Automatically starts on your current theme
-- • Supports themes with multiple variants (e.g., Monokai Pro has 6 styles)
-- • ⚡ OPTIMIZED: Only active theme loads at startup (fast!)
-- • Other themes lazy-load when you open the picker (first time ~1s delay)
--
-- 📦 HOW TO ADD A NEW THEME (3 simple steps):
--
-- 1. Add config settings (optional):
--    config = {
--      my_new_theme = { setting1 = "value", setting2 = true }
--    }
--
-- 2. Add to theme_registry (~line 85):
--    ["my-theme"] = {
--      variants = { "dark", "light" },  -- Optional: only if theme has variants
--      variant_key = "style",            -- Optional: the config key name
--      apply = function(variant)
--        vim.cmd.colorscheme("my-theme")
--      end,
--    }
--
-- 3. Add to theme_plugins (~line 300):
--    ["my-theme"] = { "author/my-theme.nvim" }
--
-- That's it! The theme automatically appears in picker with live preview.
--
-- ============================================================================

-- Configuration: Change these values to customize your theme
local config = {
  -- Active colorscheme: "sonokai", "gruvbox", "nord", "onedark", "cyberdream", "tokyonight", "monokai-pro"

  active_theme = "gruvbox", --Change to any available theme
  --  also change in lazy.lua:  colorscheme = "gruvbox",
  -- Theme-specific settings
  monokai_pro = {
    filter = "pro",
    -- transparent_background = false,
    -- terminal_colors = true,
    -- devicons = true,
    styles = {
      comment = { italic = true },
      keyword = { italic = true },
      type = { italic = true },
      storageclass = { italic = true },
      structure = { italic = true },
      parameter = { italic = true },
      annotation = { italic = true },
      tag_attribute = { italic = true },
      conditionals = { italic = true },
      loops = {},
      functions = {},
      strings = {},
      variables = {},
      numbers = {},
      booleans = {},
      properties = {},
      operators = {},
    },
    inc_search = "background", -- "underline" or "background"
  },
  sonokai = {
    style = "andromeda",
    enable_italic = true,
    transparent_background = false, -- Set to true for transparent background
    styles = {
      comments = { italic = true },
      keywords = { italic = true },
      conditionals = { italic = true },
      loops = {},
      functions = {},
      strings = {},
      variables = {},
      numbers = {},
      booleans = {},
      properties = {},
      types = { italic = true },
      operators = {},
    },
  },
  gruvbox = {
    terminal_colors = true, -- add neovim terminal colors
    undercurl = true,
    underline = true,
    bold = true,
    italic = {
      strings = true,
      emphasis = true,
      comments = true,
      operators = false,
      folds = true,
    },
    strikethrough = true,
    invert_selection = false,
    invert_signs = false,
    invert_tabline = false,
    inverse = true, -- invert background for search, diffs, statuslines and errors
    contrast = "", -- can be "hard", "soft" or empty string
    palette_overrides = {},
    overrides = {},
    dim_inactive = false,
    transparent_mode = false,
  },
  nord = {
    contrast = false,
    italic = true,
    styles = {
      comments = { italic = true },
      keywords = { italic = true },
      conditionals = { italic = true },
      loops = {},
      functions = {},
      strings = {},
      variables = {},
      numbers = {},
      booleans = {},
      properties = {},
      types = { italic = true },
      operators = {},
    },
  },
  onedark = {
    styles = {
      comments = "italic",
      keywords = "italic",
      conditionals = "italic",
      loops = "NONE",
      functions = "NONE",
      strings = "NONE",
      variables = "NONE",
      numbers = "NONE",
      booleans = "NONE",
      properties = "NONE",
      types = "italic",
      operators = "NONE",
    },
  },
  cyberdream = {
    italic_comments = true,
    styles = {
      comments = { italic = true },
      keywords = { italic = true },
      conditionals = { italic = true },
      loops = {},
      functions = {},
      strings = {},
      variables = {},
      numbers = {},
      booleans = {},
      properties = {},
      types = { italic = true },
      operators = {},
    },
  },
  tokyonight = {
    style = "night",
    styles = {
      comments = { italic = true },
      keywords = { italic = true },
      conditionals = { italic = true },
      loops = {},
      functions = {},
      strings = {},
      variables = {},
      numbers = {},
      booleans = {},
      properties = {},
      types = { italic = true },
      operators = {},
    },
  },
  solarized_osaka = {
    styles = {
      comments = { italic = true },
      keywords = { italic = true },
      conditionals = { italic = true },
      loops = {},
      functions = {},
      strings = {},
      variables = {},
      numbers = {},
      booleans = {},
      properties = {},
      types = { italic = true },
      operators = {},
    },
  },
  kanagawa = {
    commentStyle = { italic = true },
    keywordStyle = { italic = true },
    statementStyle = { bold = true },
    styles = {
      conditionals = { italic = true },
      loops = {},
      functions = {},
      strings = {},
      variables = {},
      numbers = {},
      booleans = {},
      properties = {},
      types = { italic = true },
      operators = {},
    },
  },
  catppuccin = {
    flavour = "mocha",
    transparent_background = false,
    styles = {
      comments = { "italic" },
      conditionals = { "italic" },
      loops = {},
      functions = {},
      keywords = { "italic", "bold" },
      strings = {},
      variables = {},
      numbers = {},
      booleans = {},
      properties = {},
      types = {},
      operators = {},
    },
    integrations = {
      cmp = true,
      gitsigns = true,
      nvimtree = true,
      treesitter = true,
      telescope = true,
    },
  },
  rose_pine = {
    variant = "main", -- main, moon, dawn
    dark_variant = "main", -- main or moon
    styles = {
      bold = true,
      italic = true,
      transparency = false,
      comments = { italic = true },
      keywords = { italic = true },
      conditionals = { italic = true },
      loops = {},
      functions = {},
      strings = {},
      variables = {},
      numbers = {},
      booleans = {},
      properties = {},
      types = { italic = true },
      operators = {},
    },
  },
  vscode = {
    style = "light",
    transparent = false,
    italic_comments = true,
    styles = {
      comments = { italic = true },
      keywords = { italic = true },
      conditionals = { italic = true },
      loops = {},
      functions = {},
      strings = {},
      variables = {},
      numbers = {},
      booleans = {},
      properties = {},
      types = { italic = true },
      operators = {},
    },
  },
  dracula = {
    variant = "default",
    italic_comment = true,
    styles = {
      comments = { italic = true },
      keywords = { italic = true },
      conditionals = { italic = true },
      loops = {},
      functions = {},
      strings = {},
      variables = {},
      numbers = {},
      booleans = {},
      properties = {},
      types = { italic = true },
      operators = {},
    },
  },
  everforest = {
    background = "medium", -- hard, medium, soft
    enable_italic = true,
    transparent_background = false,
    styles = {
      comments = { italic = true },
      keywords = { italic = true },
      conditionals = { italic = true },
      loops = {},
      functions = {},
      strings = {},
      variables = {},
      numbers = {},
      booleans = {},
      properties = {},
      types = { italic = true },
      operators = {},
    },
  },
  miasma = {
    -- Miasma is a simple theme with minimal config options
    styles = {
      comments = { italic = true },
      keywords = { italic = true },
      conditionals = { italic = true },
      loops = {},
      functions = {},
      strings = {},
      variables = {},
      numbers = {},
      booleans = {},
      properties = {},
      types = { italic = true },
      operators = {},
    },
  },
  poimandres = {
    -- Poimandres configuration
    disable_background = false,
    disable_float_background = false,
    disable_italics = false,
    styles = {
      comments = { italic = true },
      keywords = { italic = true },
      conditionals = { italic = true },
      loops = {},
      functions = {},
      strings = {},
      variables = {},
      numbers = {},
      booleans = {},
      properties = {},
      types = { italic = true },
      operators = {},
    },
  },
  ayu = {
    mirage = true, -- set false for dark
    overrides = {},
    styles = {
      comments = { italic = true },
      keywords = { italic = true },
      conditionals = { italic = true },
      loops = {},
      functions = {},
      strings = {},
      variables = {},
      numbers = {},
      booleans = {},
      properties = {},
      types = { italic = true },
      operators = {},
    },
  },
}

-- ============================================================================
-- THEME REGISTRY - Add new themes here
-- ============================================================================
-- EXAMPLE: Adding a new theme with variants
-- ["catppuccin"] = {
--   variants = { "latte", "frappe", "macchiato", "mocha" },
--   variant_key = "flavour",
--   apply = function(variant)
--     require("catppuccin").setup({ flavour = variant })
--     vim.cmd.colorscheme("catppuccin")
--   end,
-- },
--
-- EXAMPLE: Adding a simple theme (no variants)
-- ["rose-pine"] = {
--   apply = function()
--     vim.cmd.colorscheme("rose-pine")
--   end,
-- },
-- ============================================================================
local theme_registry = {
  ["monokai-pro"] = {
    variants = { "pro", "octagon", "machine", "ristretto", "spectrum", "classic" },
    variant_key = "filter",
    apply = function(variant)
      require("monokai-pro").setup({ filter = variant })
      vim.cmd.colorscheme("monokai-pro")
    end,
  },
  ["sonokai"] = {
    variants = { "default", "atlantis", "andromeda", "shusia", "maia", "espresso" },
    variant_key = "style",
    apply = function(variant)
      vim.g.sonokai_style = variant
      vim.cmd.colorscheme("sonokai")
    end,
  },
  ["gruvbox"] = {
    variants = { "hard", "soft", "default" },
    variant_key = "contrast",
    apply = function(variant)
      require("gruvbox").setup({
        terminal_colors = config.gruvbox.terminal_colors,
        undercurl = config.gruvbox.undercurl,
        underline = config.gruvbox.underline,
        bold = config.gruvbox.bold,
        italic = config.gruvbox.italic,
        strikethrough = config.gruvbox.strikethrough,
        invert_selection = config.gruvbox.invert_selection,
        invert_signs = config.gruvbox.invert_signs,
        invert_tabline = config.gruvbox.invert_tabline,
        inverse = config.gruvbox.inverse,
        contrast = variant == "default" and "" or variant,
        palette_overrides = config.gruvbox.palette_overrides,
        overrides = config.gruvbox.overrides,
        dim_inactive = config.gruvbox.dim_inactive,
        transparent_mode = config.gruvbox.transparent_mode,
      })
      vim.cmd.colorscheme("gruvbox")
    end,
  },
  ["nord"] = {
    apply = function()
      vim.g.nord_contrast = config.nord.contrast
      vim.g.nord_italic = config.nord.italic
      vim.cmd.colorscheme("nord")
    end,
  },
  ["onedark"] = {
    apply = function()
      require("onedarkpro").setup({
        styles = config.onedark.styles,
      })
      vim.cmd.colorscheme("onedark")
    end,
  },
  ["cyberdream"] = {
    apply = function()
      require("cyberdream").setup({
        italic_comments = config.cyberdream.italic_comments,
      })
      vim.cmd.colorscheme("cyberdream")
    end,
  },
  ["tokyonight"] = {
    variants = { "night", "moon", "storm", "day" },
    variant_key = "style",
    apply = function(variant)
      local style = variant or config.tokyonight.style
      require("tokyonight").setup({
        style = style,
        styles = config.tokyonight.styles,
      })
      vim.cmd.colorscheme("tokyonight")
    end,
  },
  ["solarized-osaka"] = {
    apply = function()
      require("solarized-osaka").setup({
        styles = config.solarized_osaka.styles,
      })
      vim.cmd.colorscheme("solarized-osaka")
    end,
  },
  ["kanagawa"] = {
    apply = function()
      require("kanagawa").setup({
        commentStyle = config.kanagawa.commentStyle,
        keywordStyle = config.kanagawa.keywordStyle,
        statementStyle = config.kanagawa.statementStyle,
      })
      vim.cmd.colorscheme("kanagawa")
    end,
  },
  ["catppuccin"] = {
    variants = { "latte", "frappe", "macchiato", "mocha" },
    variant_key = "flavour",
    apply = function(variant)
      require("catppuccin").setup({
        flavour = variant,
        transparent_background = config.catppuccin.transparent_background,
        styles = config.catppuccin.styles,
        integrations = config.catppuccin.integrations,
      })
      vim.cmd.colorscheme("catppuccin")
    end,
  },
  ["rose-pine"] = {
    variants = { "main", "moon", "dawn" },
    variant_key = "variant",
    apply = function(variant)
      require("rose-pine").setup({
        variant = variant,
        dark_variant = config.rose_pine.dark_variant,
        bold_vert_split = false,
        dim_nc_background = false,
        disable_background = not config.rose_pine.styles.transparency,
        disable_float_background = false,
        disable_italics = not config.rose_pine.styles.italic,
        styles = {
          bold = config.rose_pine.styles.bold,
          italic = config.rose_pine.styles.italic,
          transparency = config.rose_pine.styles.transparency,
        },
      })
      -- Rose Pine uses variant-specific colorscheme names
      if variant == "main" then
        vim.cmd.colorscheme("rose-pine")
      elseif variant == "moon" then
        vim.cmd.colorscheme("rose-pine-moon")
      elseif variant == "dawn" then
        vim.cmd.colorscheme("rose-pine-dawn")
      end
    end,
  },
  ["vscode"] = {
    variants = { "dark", "light" },
    variant_key = "style",
    apply = function(variant)
      require("vscode").setup({
        style = variant,
        transparent = config.vscode.transparent,
        italic_comments = config.vscode.italic_comments,
      })
      if variant == "dark" then
        vim.cmd.colorscheme("vscode")
      else
        vim.o.background = "light"
        vim.cmd.colorscheme("vscode")
      end
    end,
  },
  ["dracula"] = {
    variants = { "default", "soft" },
    variant_key = "variant",
    apply = function(variant)
      if variant == "soft" then
        vim.cmd.colorscheme("dracula-soft")
      else
        vim.cmd.colorscheme("dracula")
      end
    end,
  },
  ["everforest"] = {
    variants = { "hard", "medium", "soft" },
    variant_key = "background",
    apply = function(variant)
      vim.g.everforest_background = variant
      vim.g.everforest_enable_italic = config.everforest.enable_italic and 1 or 0
      vim.g.everforest_transparent_background = config.everforest.transparent_background and 1 or 0
      vim.cmd.colorscheme("everforest")
    end,
  },
  ["miasma"] = {
    apply = function()
      vim.cmd.colorscheme("miasma")
    end,
  },
  ["poimandres"] = {
    apply = function()
      require("poimandres").setup({
        disable_background = config.poimandres.disable_background,
        disable_float_background = config.poimandres.disable_float_background,
        disable_italics = config.poimandres.disable_italics,
      })
      vim.cmd.colorscheme("poimandres")
    end,
  },
  ["ayu"] = {
    variants = { "dark", "mirage", "light" },
    variant_key = "variant",
    apply = function(variant)
      require("ayu").setup({
        mirage = variant == "mirage",
        overrides = config.ayu.overrides,
      })
      -- Ayu uses different colorscheme names for variants
      if variant == "dark" then
        vim.cmd.colorscheme("ayu-dark")
      elseif variant == "mirage" then
        vim.cmd.colorscheme("ayu-mirage")
      elseif variant == "light" then
        vim.cmd.colorscheme("ayu-light")
      end
    end,
  },
}

-- ============================================================================
-- HELPER FUNCTIONS
-- ============================================================================
-- Get current variant for a theme
local function get_current_variant(theme_name)
  local theme_info = theme_registry[theme_name]
  if not theme_info or not theme_info.variants then
    return nil
  end

  local theme_key = theme_name:gsub("%-", "_")
  local variant_key = theme_info.variant_key
  return config[theme_key] and config[theme_key][variant_key]
end

-- Generate theme list from registry
local function generate_theme_list()
  local themes = {}
  for theme_name, theme_info in pairs(theme_registry) do
    if theme_info.variants then
      -- Add all variants
      for _, variant_value in ipairs(theme_info.variants) do
        local display_name = theme_name:gsub("^%l", string.upper):gsub("%-(%l)", function(c)
          return " " .. c:upper()
        end)
        local variant_display = variant_value:gsub("^%l", string.upper)
        table.insert(themes, {
          name = display_name .. " - " .. variant_display,
          value = theme_name,
          variant = theme_info.variant_key,
          variant_value = variant_value,
        })
      end
    else
      -- Simple theme without variants
      local display_name = theme_name:gsub("^%l", string.upper):gsub("%-(%l)", function(c)
        return " " .. c:upper()
      end)
      table.insert(themes, {
        name = display_name,
        value = theme_name,
      })
    end
  end
  return themes
end

-- Apply theme using registry
local function apply_theme(theme_name, variant)
  local theme_info = theme_registry[theme_name]
  if theme_info then
    pcall(function()
      theme_info.apply(variant)
    end)
  end
end

-- ============================================================================
-- THEME PICKER FUNCTION
-- ============================================================================
local function setup_theme_picker()
  vim.keymap.set("n", "<leader>th", function()
    -- Load all theme plugins on demand (lazy loaded ones will be loaded now)
    vim.notify("Loading theme picker...", vim.log.levels.INFO)

    -- Ensure all theme plugins are loaded
    for theme_name in pairs(theme_registry) do
      if theme_name ~= config.active_theme then
        -- Trigger lazy load by requiring the plugin
        pcall(function()
          require("lazy").load({ plugins = { theme_plugins[theme_name][1]:match("([^/]+)$") } })
        end)
      end
    end

    -- Store original theme to restore if needed
    local original_theme = config.active_theme
    local original_variant = get_current_variant(original_theme)

    -- Generate theme list from registry
    local themes = generate_theme_list()

    -- Find the index of the current theme to pre-select it
    local default_selection = 1
    for i, theme in ipairs(themes) do
      if theme.value == original_theme then
        if original_variant then
          -- Match variant too
          if theme.variant_value == original_variant then
            default_selection = i
            break
          end
        else
          -- No variant, just match theme name
          default_selection = i
          break
        end
      end
    end

    local pickers = require("telescope.pickers")
    local finders = require("telescope.finders")
    local conf = require("telescope.config").values
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")
    local previewers = require("telescope.previewers")
    local action_set = require("telescope.actions.set")

    pickers
      .new({}, {
        prompt_title = "Select Theme (Navigate to Preview)",
        finder = finders.new_table({
          results = themes,
          entry_maker = function(entry)
            return {
              value = entry,
              display = entry.name,
              ordinal = entry.name,
            }
          end,
        }),
        sorter = conf.generic_sorter({}),
        default_selection_index = default_selection,
        previewer = previewers.new_buffer_previewer({
          title = "Theme Preview",
          define_preview = function(self, entry)
            -- Apply theme preview on navigation
            apply_theme(entry.value.value, entry.value.variant_value)

            -- Sample code to display in preview
            local preview_lines = {
              "-- Theme: " .. entry.value.name,
              "",
              "-- Functions and Keywords",
              "local function greet(name)",
              '  if name == "World" then',
              '    print("Hello, " .. name .. "!")',
              "  else",
              '    return "Hi, " .. name',
              "  end",
              "end",
              "",
              "-- Variables and Types",
              "local number = 42",
              'local text = "string value"',
              "local boolean = true",
              "local table_data = { key = 'value', count = 100 }",
              "",
              "-- Comments",
              "-- This is a single line comment",
              "--[[ This is a",
              "     multi-line comment ]]",
              "",
              "-- Operators and Built-ins",
              "for i = 1, 10 do",
              "  local result = math.sqrt(i) * 2",
              "  if result > 5 then",
              "    break",
              "  end",
              "end",
              "",
              "-- Class/Module Pattern",
              "local MyClass = {}",
              "MyClass.__index = MyClass",
              "",
              "function MyClass:new()",
              "  local instance = setmetatable({}, self)",
              "  return instance",
              "end",
              "",
              "-- Error Handling",
              "local success, err = pcall(function()",
              "  error('Something went wrong')",
              "end)",
              "",
              "-- String interpolation",
              "local user = { name = 'Alice', age = 30 }",
              'vim.notify(string.format("User: %s (%d)", user.name, user.age))',
            }

            vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, preview_lines)
            vim.api.nvim_buf_set_option(self.state.bufnr, "filetype", "lua")
          end,
        }),
        attach_mappings = function(prompt_bufnr, map)
          -- On Enter: Save and apply the selected theme
          actions.select_default:replace(function()
            actions.close(prompt_bufnr)
            local selection = action_state.get_selected_entry()
            if selection then
              vim.notify("Switching to " .. selection.display .. " theme...", vim.log.levels.INFO)

              -- Update the theme.lua config
              local theme_file = vim.fn.stdpath("config") .. "/lua/plugins/theme.lua"
              local lines = vim.fn.readfile(theme_file)

              -- Update active_theme
              for i, line in ipairs(lines) do
                if line:match("active_theme%s*=%s*") then
                  lines[i] = '  active_theme = "' .. selection.value.value .. '", --Change to any available theme'
                  break
                end
              end

              -- Update variant if present
              if selection.value.variant then
                local theme_key = selection.value.value:gsub("%-", "_")
                local in_theme_block = false
                local variant_key = selection.value.variant
                local variant_val = selection.value.variant_value

                for i, line in ipairs(lines) do
                  -- Detect theme block start
                  if line:match(theme_key .. "%s*=%s*{") then
                    in_theme_block = true
                  end

                  -- Update variant within theme block
                  if in_theme_block and line:match(variant_key .. "%s*=%s*") then
                    local indent = line:match("^%s*")
                    lines[i] = indent .. variant_key .. ' = "' .. variant_val .. '",'
                    break
                  end

                  -- Exit theme block
                  if in_theme_block and line:match("^%s*},") then
                    in_theme_block = false
                  end
                end
              end

              vim.fn.writefile(lines, theme_file)

              -- Reload the config
              vim.notify("Theme saved! Reloading config...", vim.log.levels.INFO)
              vim.defer_fn(function()
                vim.cmd("source " .. theme_file)
                vim.cmd("Lazy reload " .. selection.value.value)
                vim.notify("Theme applied: " .. selection.display, vim.log.levels.INFO)
              end, 100)
            end
          end)

          -- On Escape: Restore original theme
          local function restore_theme()
            actions.close(prompt_bufnr)
            apply_theme(original_theme, original_variant)
            vim.notify("Theme picker closed - restored original theme", vim.log.levels.INFO)
          end

          map("i", "<Esc>", restore_theme)
          map("n", "<Esc>", restore_theme)

          return true
        end,
      })
      :find()
  end, { desc = "Theme Picker" })
end

-- Call setup after plugins are loaded
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = setup_theme_picker,
})

-- ============================================================================
-- THEME PLUGINS - Add new theme plugins here
-- ============================================================================
-- Plugin definitions: Map theme names to their plugin specs
local theme_plugins = {
  ["monokai-pro"] = {
    "loctvl842/monokai-pro.nvim",
    config = function()
      require("monokai-pro").setup({
        transparent_background = config.monokai_pro.transparent_background,
        terminal_colors = config.monokai_pro.terminal_colors,
        devicons = config.monokai_pro.devicons,
        styles = config.monokai_pro.styles,
        filter = config.monokai_pro.filter,
        inc_search = config.monokai_pro.inc_search,
        background_clear = { "toggleterm", "telescope", "renamer", "notify" },
        plugins = {
          bufferline = { underline_selected = false, underline_visible = false },
          indent_blankline = { context_highlight = "default", context_start_underline = false },
        },
      })
      if config.active_theme == "monokai-pro" then
        vim.cmd.colorscheme("monokai-pro")
      end
    end,
  },
  ["sonokai"] = {
    "sainnhe/sonokai",
    config = function()
      if config.active_theme == "sonokai" then
        vim.g.sonokai_transparent_background = config.sonokai.transparent_background and "1" or "0"
        vim.g.sonokai_enable_italic = config.sonokai.enable_italic and "1" or "0"
        vim.g.sonokai_style = config.sonokai.style
        vim.cmd.colorscheme("sonokai")
      end
    end,
  },
  ["gruvbox"] = {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = function()
      if config.active_theme == "gruvbox" then
        require("gruvbox").setup({
          terminal_colors = config.gruvbox.terminal_colors,
          undercurl = config.gruvbox.undercurl,
          underline = config.gruvbox.underline,
          bold = config.gruvbox.bold,
          italic = config.gruvbox.italic,
          strikethrough = config.gruvbox.strikethrough,
          invert_selection = config.gruvbox.invert_selection,
          invert_signs = config.gruvbox.invert_signs,
          invert_tabline = config.gruvbox.invert_tabline,
          inverse = config.gruvbox.inverse,
          contrast = config.gruvbox.contrast,
          palette_overrides = config.gruvbox.palette_overrides,
          overrides = config.gruvbox.overrides,
          dim_inactive = config.gruvbox.dim_inactive,
          transparent_mode = config.gruvbox.transparent_mode,
        })
        vim.cmd.colorscheme("gruvbox")
      end
    end,
  },
  ["nord"] = {
    "shaunsingh/nord.nvim",
    config = function()
      if config.active_theme == "nord" then
        vim.g.nord_contrast = config.nord.contrast
        vim.g.nord_italic = config.nord.italic
        vim.cmd.colorscheme("nord")
      end
    end,
  },
  ["onedark"] = {
    "olimorris/onedarkpro.nvim",
    config = function()
      if config.active_theme == "onedark" then
        require("onedarkpro").setup({
          styles = config.onedark.styles,
        })
        vim.cmd.colorscheme("onedark")
      end
    end,
  },
  ["cyberdream"] = {
    "scottmckendry/cyberdream.nvim",
    config = function()
      if config.active_theme == "cyberdream" then
        require("cyberdream").setup({
          italic_comments = config.cyberdream.italic_comments,
        })
        vim.cmd.colorscheme("cyberdream")
      end
    end,
  },
  ["tokyonight"] = {
    "folke/tokyonight.nvim",
    config = function()
      if config.active_theme == "tokyonight" then
        require("tokyonight").setup({
          style = config.tokyonight.style,
          styles = config.tokyonight.styles,
        })
        vim.cmd.colorscheme("tokyonight")
      end
    end,
  },
  ["solarized-osaka"] = {
    "craftzdog/solarized-osaka.nvim",
    config = function()
      if config.active_theme == "solarized-osaka" then
        require("solarized-osaka").setup({
          styles = config.solarized_osaka.styles,
        })
        vim.cmd.colorscheme("solarized-osaka")
      end
    end,
  },
  ["kanagawa"] = {
    "rebelot/kanagawa.nvim",
    config = function()
      if config.active_theme == "kanagawa" then
        require("kanagawa").setup({
          commentStyle = config.kanagawa.commentStyle,
          keywordStyle = config.kanagawa.keywordStyle,
          statementStyle = config.kanagawa.statementStyle,
        })
        vim.cmd.colorscheme("kanagawa")
      end
    end,
  },
  ["catppuccin"] = {
    "catppuccin/nvim",
    name = "catppuccin",
    config = function()
      if config.active_theme == "catppuccin" then
        require("catppuccin").setup({
          flavour = config.catppuccin.flavour,
          transparent_background = config.catppuccin.transparent_background,
          styles = config.catppuccin.styles,
          integrations = config.catppuccin.integrations,
        })
        vim.cmd.colorscheme("catppuccin")
      end
    end,
  },
  ["rose-pine"] = {
    "rose-pine/neovim",
    name = "rose-pine",
    config = function()
      if config.active_theme == "rose-pine" then
        require("rose-pine").setup({
          variant = config.rose_pine.variant,
          dark_variant = config.rose_pine.dark_variant,
          bold_vert_split = false,
          dim_nc_background = false,
          disable_background = not config.rose_pine.styles.transparency,
          disable_float_background = false,
          disable_italics = not config.rose_pine.styles.italic,
          styles = config.rose_pine.styles,
        })
        -- Apply the correct variant
        if config.rose_pine.variant == "main" then
          vim.cmd.colorscheme("rose-pine")
        elseif config.rose_pine.variant == "moon" then
          vim.cmd.colorscheme("rose-pine-moon")
        elseif config.rose_pine.variant == "dawn" then
          vim.cmd.colorscheme("rose-pine-dawn")
        end
      end
    end,
  },
  ["vscode"] = {
    "Mofiqul/vscode.nvim",
    config = function()
      if config.active_theme == "vscode" then
        require("vscode").setup({
          style = config.vscode.style,
          transparent = config.vscode.transparent,
          italic_comments = config.vscode.italic_comments,
        })
        if config.vscode.style == "dark" then
          vim.cmd.colorscheme("vscode")
        else
          vim.o.background = "light"
          vim.cmd.colorscheme("vscode")
        end
      end
    end,
  },
  ["dracula"] = {
    "Mofiqul/dracula.nvim",
    config = function()
      if config.active_theme == "dracula" then
        if config.dracula.variant == "soft" then
          vim.cmd.colorscheme("dracula-soft")
        else
          vim.cmd.colorscheme("dracula")
        end
      end
    end,
  },
  ["everforest"] = {
    "sainnhe/everforest",
    config = function()
      if config.active_theme == "everforest" then
        vim.g.everforest_background = config.everforest.background
        vim.g.everforest_enable_italic = config.everforest.enable_italic and 1 or 0
        vim.g.everforest_transparent_background = config.everforest.transparent_background and 1 or 0
        vim.cmd.colorscheme("everforest")
      end
    end,
  },
  ["miasma"] = {
    "xero/miasma.nvim",
    config = function()
      if config.active_theme == "miasma" then
        vim.cmd.colorscheme("miasma")
      end
    end,
  },
  ["poimandres"] = {
    "olivercederborg/poimandres.nvim",
    config = function()
      if config.active_theme == "poimandres" then
        require("poimandres").setup({
          disable_background = config.poimandres.disable_background,
          disable_float_background = config.poimandres.disable_float_background,
          disable_italics = config.poimandres.disable_italics,
        })
        vim.cmd.colorscheme("poimandres")
      end
    end,
  },
  ["ayu"] = {
    "Shatur/neovim-ayu",
    config = function()
      if config.active_theme == "ayu" then
        require("ayu").setup({
          mirage = config.ayu.mirage,
          overrides = config.ayu.overrides,
        })
        -- Apply the correct variant based on config
        if config.ayu.mirage then
          vim.cmd.colorscheme("ayu-mirage")
        else
          vim.cmd.colorscheme("ayu-dark")
        end
      end
    end,
  },
}

-- Build plugin list with lazy loading optimization
local plugins = {}
for theme_name, plugin_spec in pairs(theme_plugins) do
  local is_active = config.active_theme == theme_name

  local plugin = {
    plugin_spec[1], -- Plugin URL
    lazy = not is_active, -- Only load active theme at startup
    priority = is_active and 1000 or 100,
    config = plugin_spec.config or function()
      if config.active_theme == theme_name then
        vim.cmd.colorscheme(theme_name)
      end
    end,
  }
  table.insert(plugins, plugin)
end

return plugins
