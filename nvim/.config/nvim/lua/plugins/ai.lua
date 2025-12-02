return {
  -- Copilot for blink.cmp integration
  {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    config = function()
      vim.schedule(function()
        require("copilot").setup({
          suggestion = {
            enabled = false, -- Disabled, using blink-copilot instead
          },
          panel = {
            enabled = false,
          },
          filetypes = {
            markdown = true,
            help = true,
            html = true,
            javascript = true,
            typescript = true,
            cpp = false,
            c = false,
            ["*"] = true,
          },
        })
      end)
    end,
  },
  -- Blink-copilot integration
  {
    "giuxtaposition/blink-cmp-copilot",
    dependencies = { "saghen/blink.cmp" },
  },
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false,
    opts = {
      debug = false,

      -- Choose your main provider
      provider = "copilot", -- or "copilot", "ollama"

      auto_suggestions_provider = nil,

      providers = {
        openai = {
          endpoint = "https://api.openai.com/v1",
          model = "gpt-4o-mini", -- switch to gpt-4o if you want more power
          timeout = 30000,

          -- All OpenAI request settings are now here
          extra_request_body = {
            temperature = 0,
            max_completion_tokens = 8192,
          },
        },

        ollama = {
          model = "qwen3:1.7b",
        },
      },
    },

    build = "make",
    dependencies = {
      "zbirenbaum/copilot.lua",
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "hrsh7th/nvim-cmp",
      "nvim-tree/nvim-web-devicons",
    },
  },
}
