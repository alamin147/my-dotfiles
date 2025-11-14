return {
  {
    "andweeb/presence.nvim",
    event = "VeryLazy",
    config = function()
      require("presence").setup({
        neovim_image_text = "Neovim",
        main_image = "file",
        enable_line_number = false,
      })
    end,
  },
}
