return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    lazy = false,
      keys = {
      { "<leader>tr", "<cmd>Neotree toggle<cr>", desc = "Toggle NeoTree" },
    },
    config = function()
      require("neo-tree").setup({
        window = {
          width = 28,
        },
        filesystem = {
          filtered_items = {
            visible = true,
            hide_dotfiles = false,
            hide_gitignored = false,
            hide_hidden = false,
          },
        },
      })
    end,
  },
}
