return {
  -- Disable LazyVim's default copilot integration
  {
    "zbirenbaum/copilot.lua",
    event = "VeryLazy",
    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = true,
          auto_trigger = true,
          accept = false,
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

      vim.keymap.set("i", "<Tab>", function()
        if require("copilot.suggestion").is_visible() then
          require("copilot.suggestion").accept()
        else
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
        end
      end, {
        silent = true,
      })
    end,
  }, -- Use blink-copilot for blink.cmp integration
  {
    "giuxtaposition/blink-copilot",
    dependencies = { "saghen/blink.cmp" },
    opts = {
      -- Disable copilot for C++ and Python
      filetypes = {
        cpp = false,
        c = false,
        python = false,
        ["*"] = true, -- Enable for all other filetypes
      },
    },
  },
}
