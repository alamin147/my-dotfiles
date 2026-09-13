return {
  {
    "akinsho/bufferline.nvim",
    opts = function(_, opts)
      opts.highlights = require("config.appearance").bufferline_highlights
      opts.options = vim.tbl_deep_extend("force", opts.options or {}, {
        mode = "buffers",
        numbers = "none",
        indicator = {
          icon = "▎",
          style = "icon",
        },
        buffer_close_icon = "󰅖",
        modified_icon = "●",
        left_trunc_marker = "",
        right_trunc_marker = "",
        max_name_length = 24,
        max_prefix_length = 18,
        tab_size = 18,
        diagnostics = "nvim_lsp",
        diagnostics_update_in_insert = false,
        enforce_regular_tabs = false,
        separator_style = "thin",
        show_buffer_close_icons = true,
        show_close_icon = false,
        show_duplicate_prefix = true,
        persist_buffer_sort = true,
        sort_by = "insert_after_current",
        always_show_bufferline = true,
        hover = {
          enabled = true,
          delay = 180,
          reveal = { "close" },
        },
        offsets = {
          {
            filetype = "neo-tree",
            text = "  EXPLORER",
            highlight = "Directory",
            text_align = "left",
            separator = true,
          },
          { filetype = "snacks_layout_box" },
        },
      })
    end,
    keys = {
      { "<Tab>", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
      { "<S-Tab>", "<cmd>BufferLineCyclePrev<cr>", desc = "Previous buffer" },
      { "<leader>bo", "<cmd>BufferLineCloseOthers<cr>", desc = "Close other buffers" },
    },
  },
}
