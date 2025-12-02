-- ═══════════════════════════════════════════════════════════════════════════
-- Simple theme loader - reads from theme-selector.lua
-- ═══════════════════════════════════════════════════════════════════════════

local active_theme = require("config.theme-selector")

-- Custom themes that are defined in lua/colors/
local custom_themes = {
  "aetheria",
  "arc-blueberry",
  "azure-glow",
  "abhijeet-custom",
  "neovoid",
}

-- Check if theme is custom
local function is_custom_theme(theme)
  for _, custom in ipairs(custom_themes) do
    if theme == custom then
      return true
    end
  end
  return false
end

-- Theme plugin mapping: maps colorscheme names to their plugin specs
local theme_plugins = {
  ["bamboo"] = "ribru17/bamboo.nvim",
  ["ash"] = "bjarneo/ash.nvim",
  ["aether"] = "bjarneo/aether.nvim",
  ["ethereal"] = "bjarneo/ethereal.nvim",
  ["hackerman"] = "bjarneo/hackerman.nvim",
  ["catppuccin"] = "catppuccin/nvim",
  ["catppuccin-latte"] = "catppuccin/nvim",
  ["catppuccin-frappe"] = "catppuccin/nvim",
  ["catppuccin-macchiato"] = "catppuccin/nvim",
  ["catppuccin-mocha"] = "catppuccin/nvim",
  ["everforest"] = "sainnhe/everforest",
  ["flexoki"] = "kepano/flexoki-neovim",
  ["flexoki-dark"] = "kepano/flexoki-neovim",
  ["flexoki-light"] = "kepano/flexoki-neovim",
  ["gruvbox"] = "ellisonleao/gruvbox.nvim",
  ["everviolet"] = "everviolet/nvim",
  ["dracula"] = "Mofiqul/dracula.nvim",
  ["kanagawa"] = "rebelot/kanagawa.nvim",
  ["kanagawa-wave"] = "rebelot/kanagawa.nvim",
  ["kanagawa-dragon"] = "rebelot/kanagawa.nvim",
  ["kanagawa-lotus"] = "rebelot/kanagawa.nvim",
  ["matteblack"] = "tahayvr/matteblack.nvim",
  ["monokai-pro"] = "loctvl842/monokai-pro.nvim",
  ["monokai-pro-classic"] = "loctvl842/monokai-pro.nvim",
  ["monokai-pro-machine"] = "loctvl842/monokai-pro.nvim",
  ["monokai-pro-octagon"] = "loctvl842/monokai-pro.nvim",
  ["monokai-pro-ristretto"] = "loctvl842/monokai-pro.nvim",
  ["monokai-pro-spectrum"] = "loctvl842/monokai-pro.nvim",
  ["nord"] = "shaunsingh/nord.nvim",
  ["rose-pine"] = "rose-pine/neovim",
  ["rose-pine-main"] = "rose-pine/neovim",
  ["rose-pine-moon"] = "rose-pine/neovim",
  ["rose-pine-dawn"] = "rose-pine/neovim",
  ["tokyonight"] = "folke/tokyonight.nvim",
  ["tokyonight-night"] = "folke/tokyonight.nvim",
  ["tokyonight-storm"] = "folke/tokyonight.nvim",
  ["tokyonight-day"] = "folke/tokyonight.nvim",
  ["tokyonight-moon"] = "folke/tokyonight.nvim",
  ["gruvbox-material"] = "sainnhe/gruvbox-material",
  ["sonokai"] = "sainnhe/sonokai",
  ["sonokai-default"] = "sainnhe/sonokai",
  ["sonokai-atlantis"] = "sainnhe/sonokai",
  ["sonokai-andromeda"] = "sainnhe/sonokai",
  ["sonokai-shusia"] = "sainnhe/sonokai",
  ["sonokai-maia"] = "sainnhe/sonokai",
  ["sonokai-espresso"] = "sainnhe/sonokai",
  ["vscode"] = "Mofiqul/vscode.nvim",
  ["vscode-dark"] = "Mofiqul/vscode.nvim",
  ["vscode-light"] = "Mofiqul/vscode.nvim",
}

-- Handle different theme types
if is_custom_theme(active_theme) then
  -- Custom theme: load it directly via colorscheme function
  return {
    {
      "LazyVim/LazyVim",
      opts = {
        colorscheme = function()
          require("colors." .. active_theme).setup()
        end,
      },
    },
  }
elseif active_theme == "onedark" then
  -- OneDark Pro with custom config
  return {
    {
      "olimorris/onedarkpro.nvim",
      priority = 1000,
      config = function()
        require("onedarkpro").setup({
          theme = "onedark",
          highlights = {
            -- Match gutter background to main background
            LineNr = { fg = "#5c6370", bg = "bg" },
            TabLineFill = { bg = "bg" },
            TabLine = { bg = "bg" },
            TabLineSel = { bg = "#282c34" }, -- active tab
          },
        })
        vim.cmd("colorscheme onedark")
      end,
    },
  }
elseif active_theme == "pixel" then
  -- Pixel theme
  return {
    {
      "bjarneo/pixel.nvim",
      name = "pixel",
    },
    {
      "LazyVim/LazyVim",
      opts = {
        colorscheme = "pixel",
      },
    },
  }
elseif active_theme == "sonokai" or active_theme == "sonokai-default" or active_theme == "sonokai-atlantis"
       or active_theme == "sonokai-andromeda" or active_theme == "sonokai-shusia"
       or active_theme == "sonokai-maia" or active_theme == "sonokai-espresso" then
  -- Sonokai theme with variants
  return {
    {
      "sainnhe/sonokai",
      lazy = false,
      priority = 1000,
      config = function()
        -- Set style variant
        if active_theme == "sonokai-atlantis" then
          vim.g.sonokai_style = "atlantis"
        elseif active_theme == "sonokai-andromeda" then
          vim.g.sonokai_style = "andromeda"
        elseif active_theme == "sonokai-shusia" then
          vim.g.sonokai_style = "shusia"
        elseif active_theme == "sonokai-maia" then
          vim.g.sonokai_style = "maia"
        elseif active_theme == "sonokai-espresso" then
          vim.g.sonokai_style = "espresso"
        else
          vim.g.sonokai_style = "default"
        end

        vim.g.sonokai_enable_italic = 1
        vim.g.sonokai_better_performance = 1
        vim.cmd("colorscheme sonokai")
      end,
    },
  }
elseif active_theme == "vscode" or active_theme == "vscode-dark" or active_theme == "vscode-light" then
  -- VSCode theme
  return {
    {
      "Mofiqul/vscode.nvim",
      lazy = false,
      priority = 1000,
      config = function()
        require('vscode').setup({
          style = active_theme == "vscode-light" and "light" or "dark",
          transparent = false,
          italic_comments = true,
          disable_nvimtree_bg = true,
        })
        require('vscode').load()
      end,
    },
  }
elseif active_theme == "poimandres" then
  -- Poimandres theme
  return {
    { "olivercederborg/poimandres.nvim", lazy = false, priority = 1000 },
    {
      "LazyVim/LazyVim",
      opts = {
        colorscheme = "poimandres",
      },
    },
  }
elseif active_theme == "aether-custom" then
  -- Aether with custom colors
  return {
    {
      "bjarneo/aether.nvim",
      name = "aether",
      priority = 1000,
      opts = {
        disable_italics = false,
        colors = {
          base00 = "#dedbc8", -- Default background
          base01 = "#8b4b3e", -- Lighter background (status bars)
          base02 = "#dedbc8", -- Selection background
          base03 = "#8b4b3e", -- Comments, invisibles
          base04 = "#444479", -- Dark foreground
          base05 = "#2c2c2c", -- Default foreground
          base06 = "#4b0304", -- Light foreground
          base07 = "#444479", -- Light background
          -- Accent colors (base08-base0F)
          base08 = "#a51d2d", -- Variables, errors, red
          base09 = "#e01b24", -- Integers, constants, orange
          base0A = "#005c32", -- Classes, types, yellow
          base0B = "#2c2c2c", -- Strings, green
          base0C = "#06498a", -- Support, regex, cyan
          base0D = "#695815", -- Functions, keywords, blue
          base0E = "#3d3a2c", -- Keywords, storage, magenta
          base0F = "#7a5e1e", -- Deprecated, brown/yellow
        },
      },
      config = function(_, opts)
        require("aether").setup(opts)
        vim.cmd.colorscheme("aether")
        -- Enable hot reload
        require("aether.hotreload").setup()
      end,
    },
    {
      "LazyVim/LazyVim",
      opts = {
        colorscheme = "aether",
      },
    },
  }
elseif active_theme == "vesper" then
  -- Vesper theme
  return {
    {
      "datsfilipe/vesper.nvim"
    },
    {
      "LazyVim/LazyVim",
      opts = {
        colorscheme = "vesper"
      },
    },
  }
elseif active_theme == "vhs80" then
  -- VHS80 theme by tahayvr
  return {
    { "tahayvr/vhs80.nvim", lazy = false, priority = 1000 },
    {
      "LazyVim/LazyVim",
      opts = {
        colorscheme = "vhs80",
      },
    },
  }
elseif active_theme == "carbonfox" then
  -- Nightfox RetroPC custom theme
  return {
    {
      "EdenEast/nightfox.nvim",
      lazy = false,
      priority = 1000,
      dependencies = {
        "folke/snacks.nvim",
        "nvim-tree/nvim-web-devicons",
        "nvim-lualine/lualine.nvim",
      },
      config = function()
        local nightfox = require('nightfox')
        local Shade = require('nightfox.lib.shade')
        local c = require('nightfox.lib.color')

        local retropc_palette = {
          bg0 = "#0A0A08", bg1 = "#0A0A08", bg2 = "#1A1612", bg3 = "#2A1F00", bg4 = "#2A1F00",
          fg0 = "#FFCC00", fg1 = "#FFB000", fg2 = "#CC9900", fg3 = "#996600",
          sel0 = "#2A1F00",
          sel1 = c.from_hex("#2A1F00"):blend(c.from_hex("#FFCC00"), 0.2):to_css(),
          comment = "#805500",
          red = Shade.new("#FF8800", c.from_hex("#FF8800"):lighten(8):to_css(), "#FF6600"),
          orange = Shade.new("#FFBB00", "#FFCC00", c.from_hex("#FFBB00"):lighten(-8):to_css()),
          yellow = Shade.new("#FFCC00", c.from_hex("#FFCC00"):lighten(10):to_css(), "#FFB000"),
          white = Shade.new("#FFB000", "#FFCC00", "#CC9900"),
          black = Shade.new("#2A1F00", "#805500", "#1A1612"),
          green = Shade.new("#CC9900", "#D4AA00", "#996600"),
          cyan = Shade.new("#FFAA00", "#FFBB00", "#CC8800"),
          blue = Shade.new("#CC9900", "#D4AA00", "#996600"),
          magenta = Shade.new("#FF9900", "#FFAA00", "#CC7700"),
          pink = Shade.new("#FFAA00", "#FFBB00", "#CC8800"),
          lualine_normal_bg = "#FFBB00",
          lualine_insert_bg = "#FF8800",
          lualine_visual_bg = "#FF9900",
          lualine_command_bg = "#FFBB00",
          lualine_inactive_bg = c.from_hex("#0A0A08"):lighten(5):to_css(),
          ts_parameter = "#FFAA00",
          ts_property = "#FFB000",
        }

        local final_palettes = {
          carbonfox = require('nightfox.lib.collect').deep_extend(
            require('nightfox.palette').load('carbonfox'),
            retropc_palette
          )
        }

        local specs = {
          carbonfox = {
            syntax = {
              keyword = "red",
              conditional = "red",
              statement = "red",
              func = "orange",
              string = "orange.dim",
              number = "orange",
              operator = "yellow",
              variable = "white",
              ident = "white.dim",
              const = "white",
              type = "white",
              field = "white.dim",
              comment = "comment",
            },
            diag = {
                error = "red",
                warn = "red",
                info = "cyan",
                hint = "magenta",
            }
          }
        }

        local groups = {
          all = {
            Whitespace = { fg = "palette.black.bright" },
            NonText = { fg = "palette.black.bright" },
            IncSearch = { bg = "palette.sel1" },
            CursorLine = { bg = "palette.bg2" },
            Normal = { fg = "palette.fg1" },
            NoiceCmdlinePopupBorder = { fg = "palette.fg3" },
            NoiceCmdlinePopupTitle = { fg = "palette.fg3", style = "bold" },
            NoiceCmdlinePopupBorderSearch = { fg = "palette.fg3" },
            NoiceCmdlinePopupTitleSearch = { fg = "palette.fg3", style = "bold" },
            NoiceCmdLineIcon = { fg = "palette.red" },
            NeoTreeNormal = { bg = "palette.bg0" },
            NeoTreeNormalNC = { link = "NeoTreeNormal" },
            NeoTreeDirectoryName = { fg = "palette.fg3" },
            NeoTreeDirectoryIcon = { fg = "palette.fg3" },
            NeoTreeRootName = { fg = "palette.orange", style = "bold" },
            NeoTreeGitAdded = { fg = "palette.green" },
            NeoTreeGitModified = { fg = "palette.yellow" },
            NeoTreeGitDeleted = { fg = "palette.red" },
            NeoTreeGitIgnored = { fg = "palette.comment" },
            NeoTreeC = { fg = "palette.orange", bg = "palette.sel0" },
            SnacksDashboardHeader = { fg = "palette.fg3" },
            SnacksDashboardIcon = { fg = "palette.fg1" },
            SnacksDashboardDir = { fg = "palette.orange" },
            SnacksDashboardFile = { fg = "palette.fg3" },
            SnacksDashboardFooter = { fg = "palette.fg3" },
            SnacksDashboardKey = { fg = "palette.orange" },
            SnacksDashboardDesc = { fg = "palette.fg1" },
            SnacksDashboardSpecial = { fg = "palette.fg1" },
            ["@comment"] = { fg = "palette.comment", style = "italic" },
            ["@keyword"] = { fg = "palette.red", style = "bold" },
            ["@keyword.function"] = { fg = "palette.red", style = "bold" },
            ["@keyword.operator"] = { fg = "palette.red", style = "bold" },
            ["@function"] = { fg = "palette.orange", style = "bold" },
            ["@function.builtin"] = { fg = "palette.orange", style = "bold" },
            ["@function.call"] = { fg = "palette.orange" },
            ["@string"] = { fg = "palette.orange" },
            ["@number"] = { fg = "palette.orange" },
            ["@operator"] = { fg = "palette.yellow" },
            ["@variable"] = { fg = "palette.white" },
            ["@constant"] = { fg = "palette.white" },
            ["@type"] = { fg = "palette.white.dim" },
            ["@variable.parameter"] = { fg = "palette.ts_parameter", style = "italic" },
            ["@property"] = { fg = "palette.ts_property" },
            ["@field"] = { fg = "palette.ts_property" },
          }
        }

        nightfox.setup({
          options = {
            style = "carbonfox",
            terminal_colors = true,
            dim_inactive = true,
            styles = { comments = "italic", functions = "bold", keywords = "bold" },
            modules = {
              neotree = true,
              treesitter = true,
            },
          },
          palettes = final_palettes,
          specs = specs,
          groups = groups
        })

        vim.cmd("colorscheme carbonfox")

        local lualine_theme = {
          normal = {
            a = { fg = retropc_palette.bg0, bg = retropc_palette.lualine_normal_bg, gui = "bold" },
            b = { fg = retropc_palette.fg1, bg = retropc_palette.lualine_inactive_bg },
            c = { fg = retropc_palette.fg2, bg = retropc_palette.lualine_inactive_bg },
          },
          insert = {
            a = { fg = retropc_palette.bg0, bg = retropc_palette.lualine_insert_bg, gui = "bold" },
            b = { fg = retropc_palette.fg1, bg = retropc_palette.lualine_inactive_bg },
            c = { fg = retropc_palette.fg2, bg = retropc_palette.lualine_inactive_bg },
          },
          visual = {
            a = { fg = retropc_palette.bg0, bg = retropc_palette.lualine_visual_bg, gui = "bold" },
            b = { fg = retropc_palette.fg1, bg = retropc_palette.lualine_inactive_bg },
            c = { fg = retropc_palette.fg2, bg = retropc_palette.lualine_inactive_bg },
          },
          command = {
            a = { fg = retropc_palette.bg0, bg = retropc_palette.lualine_command_bg, gui = "bold" },
            b = { fg = retropc_palette.fg1, bg = retropc_palette.lualine_inactive_bg },
            c = { fg = retropc_palette.fg2, bg = retropc_palette.lualine_inactive_bg },
          },
          inactive = {
            a = { fg = retropc_palette.fg3, bg = retropc_palette.lualine_inactive_bg },
            b = { fg = retropc_palette.fg3, bg = retropc_palette.lualine_inactive_bg },
            c = { fg = retropc_palette.comment, bg = retropc_palette.lualine_inactive_bg },
          },
        }

       require('lualine').setup({
          options = {
            theme = lualine_theme,
          },
        })
      end,
    },
  }
else
  local plugin_name = theme_plugins[active_theme] or "sainnhe/gruvbox-material"
  return {
    { plugin_name, lazy = false, priority = 1000 },
    {
      "LazyVim/LazyVim",
      opts = {
        colorscheme = active_theme,
      },
    },
  }
end
