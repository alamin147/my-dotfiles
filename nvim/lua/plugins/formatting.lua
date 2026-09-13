-- Formatting configuration with conform.nvim
return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        -- C/C++
        c = { "clang-format" },
        cpp = { "clang-format" },

        -- Python
        python = { "black" },

        -- JavaScript/TypeScript
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },

        -- Web
        html = { "prettier" },
        css = { "prettier" },

        -- Config files
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },

        -- Lua
        lua = { "stylua" },

        -- Java
        java = { "google-java-format" },
      },
      -- Disable auto-format on save completely
      -- Use <leader>cf to format manually (LazyVim default)
      format_on_save = nil,
      format_after_save = nil,
    },
  },
}
