local M = {}

function M.highlights()
  local c = require("base46").get_theme_tb("base_30")
  local panel = vim.g.dms_transparent and "NONE" or c.black2
  local selected = { fg = c.white, bg = c.one_bg2, bold = true, italic = false }
  local h = {
    fill = { bg = panel },
    background = { fg = c.light_grey, bg = panel },
    tab = { fg = c.light_grey, bg = panel },
    tab_selected = selected,
    tab_close = { fg = c.red, bg = panel },
    offset_separator = { fg = c.line, bg = panel },
  }
  for name, fg in pairs({
    buffer = c.light_grey,
    close_button = c.light_grey,
    numbers = c.light_grey,
    modified = c.yellow,
    diagnostic = c.light_grey,
    error = c.red,
    error_diagnostic = c.red,
    warning = c.yellow,
    warning_diagnostic = c.yellow,
    info = c.blue,
    info_diagnostic = c.blue,
    hint = c.purple,
    hint_diagnostic = c.purple,
    duplicate = c.grey_fg,
  }) do
    h[name] = { fg = fg, bg = panel }
    h[name .. "_visible"] = { fg = fg, bg = panel }
    h[name .. "_selected"] = { fg = fg, bg = c.one_bg2, bold = true }
  end
  h.buffer_selected = selected
  h.numbers_selected = selected
  h.indicator_selected = { fg = c.blue, bg = c.one_bg2 }
  h.indicator_visible = { fg = c.line, bg = panel }
  h.separator = { fg = c.line, bg = panel }
  h.separator_visible = { fg = c.line, bg = panel }
  h.separator_selected = { fg = c.line, bg = c.one_bg2 }
  return h
end

return M
