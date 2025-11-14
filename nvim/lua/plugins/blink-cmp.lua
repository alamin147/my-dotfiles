return {
  {
    "saghen/blink.cmp",
    opts = {
      completion = {
        ghost_text = {
          enabled = false, -- Disable inline ghost text
        },
      },
      sources = {
        -- Conditionally enable copilot based on filetype
        default = function()
          local filetype = vim.bo.filetype
          -- Disable copilot for C++, C, and Python
          if filetype == "cpp" or filetype == "c" or filetype == "python" then
            return { "lsp", "path", "snippets", "buffer" }
          end
          -- Enable copilot for all other filetypes
          return { "lsp", "path", "snippets", "buffer", "copilot" }
        end,
        providers = {
          copilot = {
            name = "copilot",
            module = "blink-copilot",
            score_offset = 100,
            async = true,
          },
        },
      },
    },
  },
}
