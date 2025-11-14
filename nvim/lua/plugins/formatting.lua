-- Formatting configuration with conform.nvim
return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        -- Languages with auto-format on save
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        lua = { "stylua" },

        -- C++ and Python - formatters available but NO auto-format
        cpp = { "clang-format" },
        c = { "clang-format" },
        python = { "black" }, -- or use "autopep8" if you prefer
      },
      -- Completely disable format_on_save, we'll control it per-buffer
      format_on_save = nil,
      -- Instead, use this function to selectively enable format on save
      format_after_save = function(bufnr)
        local filetype = vim.bo[bufnr].filetype

        -- NEVER auto-format C++, C, and Python
        if filetype == "cpp" or filetype == "c" or filetype == "python" or filetype == "markdown" then
          return nil
        end

        -- Check if autoformat is disabled for this buffer
        if vim.b[bufnr].autoformat == false then
          return nil
        end

        -- Enable auto-format for all other filetypes
        return {
          timeout_ms = 500,
          lsp_fallback = true,
        }
      end,
    },
  },
}
