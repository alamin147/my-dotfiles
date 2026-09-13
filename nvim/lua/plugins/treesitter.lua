return {
  -- Enhanced Treesitter for better syntax understanding
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      local parsers = {
        -- Web Development
        "html",
        "css",
        "scss",
        "javascript",
        "typescript",
        "tsx",
        "jsx",
        "json",
        "jsonc",

        -- Systems Programming
        "c",
        "cpp",
        "cmake",
        "make",

        -- Python
        "python",

        -- Config files
        "lua",
        "vim",
        "vimdoc",
        "markdown",
        "markdown_inline",
        "bash",
        "regex",
      }

      opts.ensure_installed = opts.ensure_installed or {}
      for _, parser in ipairs(parsers) do
        if not vim.tbl_contains(opts.ensure_installed, parser) then
          table.insert(opts.ensure_installed, parser)
        end
      end

      opts.highlight = opts.highlight or {}
      opts.highlight.enable = true
      opts.highlight.additional_vim_regex_highlighting = false

      opts.indent = opts.indent or {}
      opts.indent.enable = true
    end,
  },

  -- Context-aware commenting
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    opts = {
      enable_autocmd = false,
    },
  },
}
