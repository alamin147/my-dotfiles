local function clock_12h()
  return "󰥔 " .. os.date("%I:%M %p"):gsub("^0", "")
end

local function add_clean_breadcrumbs(opts)
  local ok, trouble = pcall(require, "trouble")
  if not ok then
    return
  end

  local symbols = trouble.statusline({
    mode = "symbols",
    groups = {},
    title = false,
    filter = { range = true },
    format = "{kind_icon:Normal}{symbol.name:Normal}",
    hl_group = "lualine_c_normal",
  })

  table.insert(opts.sections.lualine_c, {
    function()
      -- Trouble terminates each highlighted fragment with `%*`, which resets
      -- to StatusLine and leaks its colored background between breadcrumb
      -- items. Restore this section's highlight instead.
      return symbols.get():gsub("%%%*", "%%#lualine_c_normal#")
    end,
    cond = function()
      return vim.b.trouble_lualine ~= false and symbols.has()
    end,
  })
end

return {
  {
    "nvim-lualine/lualine.nvim",
    init = function()
      -- Replace LazyVim's per-kind colors with a neutral breadcrumb below.
      vim.g.trouble_lualine = false
    end,
    opts = function(_, opts)
      opts.options = opts.options or {}
      opts.options.theme = require("config.theme-selector").lualine_theme()
      opts.sections = opts.sections or {}
      opts.sections.lualine_c = opts.sections.lualine_c or {}
      opts.sections.lualine_z = { clock_12h }
      add_clean_breadcrumbs(opts)
    end,
  },
}
