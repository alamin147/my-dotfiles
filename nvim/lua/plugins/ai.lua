return {
  -- Optional GitHub Copilot inline suggestions. Regular completion keeps
  -- working through blink.cmp even when Copilot is signed out or unavailable.
  {
    "zbirenbaum/copilot.lua",
    version = "v2.0.1", -- Avoid newer releases' very large bundled cross-platform LSP checkout
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = true,
          auto_trigger = true,
          hide_during_completion = true,
          debounce = 75,
          keymap = {
            accept = "<M-l>",
            accept_word = "<M-w>",
            accept_line = "<M-j>",
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<C-]>",
          },
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
          ["*"] = true,
        },
      })

      local group = vim.api.nvim_create_augroup("CopilotBlinkCompletion", { clear = true })
      vim.api.nvim_create_autocmd("User", {
        group = group,
        pattern = "BlinkCmpMenuOpen",
        callback = function()
          vim.b.copilot_suggestion_hidden = true
        end,
      })
      vim.api.nvim_create_autocmd("User", {
        group = group,
        pattern = "BlinkCmpMenuClose",
        callback = function()
          vim.b.copilot_suggestion_hidden = false
        end,
      })
    end,
  },
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    cond = function()
      local config_dir = vim.env.XDG_CONFIG_HOME or vim.fn.expand("~/.config")
      return vim.fn.filereadable(config_dir .. "/github-copilot/apps.json") == 1
        or vim.fn.filereadable(config_dir .. "/github-copilot/hosts.json") == 1
    end,
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
