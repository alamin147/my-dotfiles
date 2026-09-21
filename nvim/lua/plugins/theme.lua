local function open_themes()
  require("config.theme-selector").open()
end

return {
  {
    "NvChad/base46",
    branch = "v3.0",
    lazy = false,
    priority = 11000, -- expose the catalog before LazyVim restores the saved theme
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("config.theme-selector").setup()
    end,
    keys = {
      { "<leader>uC", open_themes, desc = "Themes (DMS / NvChad)" },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = function()
        require("config.theme-selector").startup()
      end,
    },
  },
  -- Base46 supplies these palettes; separate colorscheme engines are unnecessary.
  { "folke/tokyonight.nvim", enabled = false },
  { "catppuccin/nvim", name = "catppuccin", enabled = false },
  -- Keep LazyVim's Snacks colorscheme picker from claiming the custom picker key.
  {
    "folke/snacks.nvim",
    keys = { { "<leader>uC", false } },
  },
}
