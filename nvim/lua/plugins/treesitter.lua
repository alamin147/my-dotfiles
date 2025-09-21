return {
  {
    "nvim-treesitter/nvim-treesitter",
    tag = "v0.9.1",
    build = ":TSUpdate",
    opts = function()
      local langs = {
        "javascript",
        "typescript",
        "css",
        "gitignore",
        "graphql",
        "http",
        "json",
        "scss",
        "sql",
        "vim",
        "lua",
      }

      return {
        ensure_installed = langs,
        highlight = {
          enable = true,
          -- only enable highlight for the defined langs
          disable = function(lang, _)
            return not vim.tbl_contains(langs, lang)
          end,
        },
        query_linter = {
          enable = true,
          use_virtual_text = true,
          lint_events = { "BufWrite", "CursorHold" },
        },
      }
    end,
  },
}
