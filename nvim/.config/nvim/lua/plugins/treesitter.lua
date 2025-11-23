return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = function()
      return {
        auto_install = true,
        ensure_installed = {
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
          "c",
          "cpp",
          "python",
          "bash",
          "markdown",
          "markdown_inline",
          "jsonc",
        },
        highlight = {
          enable = true,
        },
        indent = {
          enable = true,
        },
      }
    end,
  },
}
