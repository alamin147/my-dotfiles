return {
  "akinsho/bufferline.nvim",
  version = "*",
  dependencies = "nvim-tree/nvim-web-devicons",
  config = function()
    require("bufferline").setup({
      options = {
        mode = "buffers",
        diagnostics = "nvim_lsp",
        separator_style = "slant",
        show_buffer_close_icons = false,
        show_close_icon = false,
        always_show_bufferline = true,

        -- 👇 This aligns bufferline with editor when NvimTree is open
        offsets = {
          {
            filetype = "NvimTree",
            text = "File Explorer", -- optional text above sidebar
            highlight = "Directory",
            separator = true, -- adds a separator between tree and buffers
          },
        },
      },
    })
  end,
}
