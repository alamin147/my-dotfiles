return {
  -- Enhanced completion with blink.cmp (LazyVim default)
  {
    "saghen/blink.cmp",
    opts = {
      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = "mono",
      },
      completion = {
        accept = {
          auto_brackets = {
            enabled = true,
          },
        },
        menu = {
          auto_show = true,
          draw = {
            treesitter = { "lsp" },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
        },
        ghost_text = {
          enabled = true,
        },
      },
      signature = {
        enabled = true,
      },
      sources = {
        -- Use a function so LazyVim's list-extension merge does not duplicate
        -- the default providers.
        default = function()
          return { "lsp", "path", "snippets", "buffer" }
        end,
      },
      keymap = {
        preset = "super-tab",
      },
    },
  },
 {
    "saghen/blink.pairs",
    version = "*",
    dependencies = "saghen/blink.lib",

    build = function()
      require("blink.pairs").download():pwait(60000)
    end,

    opts = {
      -- Don't replace your existing auto-pair behavior.
      mappings = {
        enabled = false,
      },

      highlights = {
        enabled = true,

        -- Don't rainbow-color every bracket.
        groups = { "Delimiter" },

        matchparen = {
          enabled = true,

          -- IMPORTANT:
          -- highlight the nearest {} / () / [] surrounding the cursor
          include_surrounding = true,

          group = "MatchParen",
          priority = 250,
        },
      },
    },
  },
  -- Tailwind CSS color preview
  {
    "roobert/tailwindcss-colorizer-cmp.nvim",
    config = function()
      require("tailwindcss-colorizer-cmp").setup({
        color_square_width = 2,
      })
    end,
  },

  -- Better snippets
  {
    "L3MON4D3/LuaSnip",
    build = "make install_jsregexp",
    dependencies = {
      "rafamadriz/friendly-snippets",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
      end,
    },
    opts = {
      history = true,
      delete_check_events = "TextChanged",
      region_check_events = "CursorMoved",
    },
  },
}
