-- Bufferline configuration for active tab highlighting
return {
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    opts = {
      options = {
        indicator = {
          icon = "▎",
          style = "icon",
        },
        tab_size = 18,
        enforce_regular_tabs = false,
        show_buffer_close_icons = true,
        show_close_icon = true,
      },
    },
    config = function(_, opts)
      require("bufferline").setup(opts)

      -- Apply theme-aware highlights after colorscheme loads
      local function apply_bufferline_highlights()
        vim.api.nvim_set_hl(0, "BufferLineBufferSelected", {
          fg = "#ffffff",
          bold = true,
          italic = true,
        })
        vim.api.nvim_set_hl(0, "BufferLineIndicatorSelected", {
          fg = "#ffffff",
          bold = true,
          italic = true,
        })
        vim.api.nvim_set_hl(0, "BufferLineTabSelected", {
          fg = "#ffffff",
          bold = true,
          italic = true,
        })
      end

      -- Apply on colorscheme change
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("BufferlineHighlight", { clear = true }),
        callback = apply_bufferline_highlights,
      })

      -- Apply on startup
      vim.api.nvim_create_autocmd("VimEnter", {
        group = vim.api.nvim_create_augroup("BufferlineHighlight", { clear = false }),
        callback = function()
          vim.defer_fn(apply_bufferline_highlights, 50)
        end,
      })
    end,
  },
}
