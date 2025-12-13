return {
  -- Enhanced Treesitter for better syntax understanding
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
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
      })

      opts.highlight = opts.highlight or {}
      opts.highlight.enable = true
      opts.highlight.additional_vim_regex_highlighting = false

      opts.indent = opts.indent or {}
      opts.indent.enable = true

      opts.incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      }
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
