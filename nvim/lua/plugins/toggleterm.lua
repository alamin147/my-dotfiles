-- lua/plugins/toggleterm-editor-only.lua
return {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    local Terminal = require("toggleterm.terminal").Terminal

    -- Function to get sidebar width (works for NvimTree)
    local function sidebar_width()
      local ok, view = pcall(require, "nvim-tree.view")
      if ok and view.is_visible() then
        return view.View.width
      end
      return 0
    end

    -- Custom terminal aligned with editor only
    local editor_term = Terminal:new({
      hidden = true,
      direction = "float",
      float_opts = {
        border = "none",
        width = function()
          return vim.o.columns - sidebar_width()
        end,
        height = 5, -- terminal height
        row = vim.o.lines - 2, -- push to bottom
        col = function()
          return sidebar_width()
        end,
      },
      start_in_insert = true,
    })

    -- Keymap to toggle it
    vim.keymap.set("n", "<leader>tt", function()
      editor_term:toggle()
    end, { desc = "Toggle editor-only terminal" })

    -- Force close shortcut
    vim.keymap.set("n", "<leader>tc", function()
      if editor_term:is_open() then
        editor_term:close()
      end
    end, { desc = "Close editor-only terminal" })
  end,
}
