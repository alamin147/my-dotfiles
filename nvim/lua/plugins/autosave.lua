return {
  "pocco81/auto-save.nvim",
  event = "BufReadPost",
  config = function()
    require("auto-save").setup({
      enabled = true,
      execution_message = {
        message = function()
          return ""
        end, -- no echo message
        dim = 0.18,
        cleaning_interval = 1250,
      },
      trigger_events = { "InsertLeave", "TextChanged", "TextChangedI" }, -- auto-save triggers
      debounce_delay = 2000, -- 2 seconds after change
      condition = function(buf)
        local fn = vim.fn
        local utils = require("auto-save.utils.data")
        if fn.getbufvar(buf, "&modifiable") == 1 and utils.not_in(fn.getbufvar(buf, "&filetype"), {}) then
          return true
        end
        return false
      end,
      write_all_buffers = false,
    })
  end,
}
