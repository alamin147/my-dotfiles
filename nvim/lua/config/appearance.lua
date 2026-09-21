local M = {}

local function highlight(name)
  local ok, value = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
  return ok and value or {}
end

local function first(groups, attribute)
  for _, name in ipairs(groups) do
    local value = highlight(name)[attribute]

    if value ~= nil then
      return value
    end
  end
end

local function set(name, value)
  vim.api.nvim_set_hl(0, name, value)
end

local function improve_picker_directories()
  -- Snacks uses these groups for directories/path prefixes.
  -- Use the current theme's own directory/accent color instead
  -- of Snacks' intentionally dim default.
  local fg = first({
    "Directory",
    "NeoTreeDirectoryName",
    "Special",
    "Identifier",
    "SnacksPickerFile",
    "Normal",
  }, "fg")

  if not fg then
    return
  end

  -- Path part:
  -- lua/config/theme-selector.lua
  -- ^^^^^^^^^^^
  set("SnacksPickerDir", {
    fg = fg,
  })

  -- Actual directory entries in Snacks explorer/pickers.
  set("SnacksPickerDirectory", {
    fg = fg,
    bold = true,
  })
end

local function hex_color(value)
  if type(value) ~= "string" then
    return nil
  end

  return tonumber(value:gsub("^#", ""), 16)
end

local function dms_palette()
  local cache_home = vim.env.XDG_CACHE_HOME

  if not cache_home or cache_home == "" then
    cache_home = vim.fs.joinpath(vim.env.HOME, ".cache")
  end

  local file = io.open(
    vim.fs.joinpath(
      cache_home,
      "DankMaterialShell",
      "dms-colors.json"
    ),
    "r"
  )

  if not file then
    return {}
  end

  local ok, cache = pcall(
    vim.json.decode,
    file:read("*a")
  )

  file:close()

  local colors =
    ok
    and cache
    and cache.colors
    and cache.colors[vim.o.background]

  return type(colors) == "table"
      and colors
    or {}
end

local function luminance(color)
  local channels = {
    math.floor(color / 0x10000) % 0x100,
    math.floor(color / 0x100) % 0x100,
    color % 0x100,
  }

  for index, channel in ipairs(channels) do
    channel = channel / 255

    channels[index] =
      channel <= 0.03928
          and channel / 12.92
        or ((channel + 0.055) / 1.055) ^ 2.4
  end

  return
    0.2126 * channels[1]
    + 0.7152 * channels[2]
    + 0.0722 * channels[3]
end

local function contrast(foreground, background)
  local foreground_luminance =
    luminance(foreground)

  local background_luminance =
    luminance(background)

  local brightest =
    math.max(
      foreground_luminance,
      background_luminance
    )

  local darkest =
    math.min(
      foreground_luminance,
      background_luminance
    )

  return
    (brightest + 0.05)
    / (darkest + 0.05)
end

local function blend(from, to, amount)
  local function channel(color, shift)
    return math.floor(color / shift) % 0x100
  end

  local red =
    math.floor(
      channel(from, 0x10000) * (1 - amount)
        + channel(to, 0x10000) * amount
        + 0.5
    )

  local green =
    math.floor(
      channel(from, 0x100) * (1 - amount)
        + channel(to, 0x100) * amount
        + 0.5
    )

  local blue =
    math.floor(
      channel(from, 1) * (1 - amount)
        + channel(to, 1) * amount
        + 0.5
    )

  return
    red * 0x10000
    + green * 0x100
    + blue
end

local function readable(
  foreground,
  background,
  preferred,
  minimum
)
  if
    not foreground
    or not background
    or contrast(
      foreground,
      background
    ) >= minimum
  then
    return foreground
  end

  if
    not preferred
    or contrast(
      preferred,
      background
    ) < minimum
  then
    local black = 0x000000
    local white = 0xffffff

    preferred =
      contrast(
        white,
        background
      ) >= contrast(
        black,
        background
      )
          and white
        or black
  end

  for step = 1, 10 do
    local candidate =
      blend(
        foreground,
        preferred,
        step / 10
      )

    if
      contrast(
        candidate,
        background
      ) >= minimum
    then
      return candidate
    end
  end

  return preferred
end

local function readable_context()
  local dms = dms_palette()

  local background =
    hex_color(dms.background)
    or first(
      {
        "Normal",
        "NormalFloat",
      },
      "bg"
    )

  local preferred =
    hex_color(dms.on_surface)
    or first(
      {
        "Normal",
      },
      "fg"
    )

  local foreground =
    readable(
      first(
        {
          "Normal",
        },
        "fg"
      ),
      background,
      preferred,
      5.5
    )
    or preferred

  return {
    background = background,
    foreground = foreground,
    preferred = preferred,
  }
end

local function palette()
  local light =
    vim.o.background == "light"

  local fallback_fg =
    light
        and 0x202124
      or 0xe6e1e5

  local fallback_bg =
    light
        and 0xf1f3f4
      or 0x1d1b20

  local context =
    readable_context()

  local normal_fg =
    context.foreground
    or fallback_fg

  local panel_bg =
    first(
      {
        "TabLine",
        "NormalFloat",
        "Pmenu",
        "CursorLine",
        "Normal",
      },
      "bg"
    )
    or fallback_bg

  local fill_bg =
    first(
      {
        "TabLineFill",
        "Normal",
        "NormalFloat",
      },
      "bg"
    )
    or panel_bg

  local visible_bg =
    first(
      {
        "CursorLine",
        "TabLine",
        "NormalFloat",
      },
      "bg"
    )
    or panel_bg

  local active_bg =
    first(
      {
        "Visual",
        "PmenuSel",
        "StatusLine",
        "CursorLine",
      },
      "bg"
    )
    or visible_bg

  local active_fg =
    first(
      {
        "Visual",
        "PmenuSel",
        "StatusLine",
        "Normal",
      },
      "fg"
    )
    or normal_fg

  active_fg =
    readable(
      active_fg,
      active_bg,
      normal_fg,
      4.5
    )
    or normal_fg

  return {
    normal_fg = normal_fg,
    panel_bg = panel_bg,
    fill_bg = fill_bg,
    visible_bg = visible_bg,
    active_bg = active_bg,
    active_fg = active_fg,
  }
end

function M.bufferline_highlights()
  if vim.g.colors_name == "nvchad" then
    return require(
      "config.theme-bufferline"
    ).highlights()
  end

  local colors = palette()

  local transparent =
    vim.g.dms_transparent ~= false

  local panel_bg =
    transparent
        and "NONE"
      or colors.panel_bg

  local fill_bg =
    transparent
        and "NONE"
      or colors.fill_bg

  local visible_bg =
    transparent
        and "NONE"
      or colors.visible_bg

  local separator_fg =
    first(
      {
        "WinSeparator",
        "FloatBorder",
        "Comment",
      },
      "fg"
    )
    or colors.normal_fg

  local inactive = {
    fg = colors.normal_fg,
    bg = panel_bg,
  }

  local visible = {
    fg = colors.normal_fg,
    bg = visible_bg,
  }

  local selected = {
    fg = colors.active_fg,
    bg = colors.active_bg,
    bold = true,
    italic = false,
  }

  local values = {
    fill = {
      fg = colors.normal_fg,
      bg = fill_bg,
    },

    background = inactive,
    buffer = inactive,
    buffer_visible = visible,
    buffer_selected = selected,

    close_button = inactive,
    close_button_visible = visible,
    close_button_selected = selected,

    numbers = inactive,
    numbers_visible = visible,
    numbers_selected = selected,

    tab = inactive,
    tab_selected = selected,
    tab_close = inactive,

    indicator_selected = selected,

    offset_separator = {
      fg =
        first(
          {
            "WinSeparator",
            "FloatBorder",
          },
          "fg"
        )
        or colors.normal_fg,

      bg = fill_bg,
    },

    separator = {
      fg = separator_fg,
      bg = panel_bg,
    },

    separator_visible = {
      fg = separator_fg,
      bg = visible_bg,
    },

    separator_selected = {
      fg = colors.active_bg,
      bg = fill_bg,
    },
  }

  local accents = {
    modified =
      first(
        {
          "DiagnosticWarn",
          "Directory",
          "Normal",
        },
        "fg"
      )
      or colors.normal_fg,

    diagnostic =
      colors.normal_fg,

    error =
      first(
        {
          "DiagnosticError",
          "ErrorMsg",
          "Normal",
        },
        "fg"
      )
      or colors.normal_fg,

    error_diagnostic =
      first(
        {
          "DiagnosticError",
          "ErrorMsg",
          "Normal",
        },
        "fg"
      )
      or colors.normal_fg,

    warning =
      first(
        {
          "DiagnosticWarn",
          "WarningMsg",
          "Normal",
        },
        "fg"
      )
      or colors.normal_fg,

    warning_diagnostic =
      first(
        {
          "DiagnosticWarn",
          "WarningMsg",
          "Normal",
        },
        "fg"
      )
      or colors.normal_fg,

    info =
      first(
        {
          "DiagnosticInfo",
          "Directory",
          "Normal",
        },
        "fg"
      )
      or colors.normal_fg,

    info_diagnostic =
      first(
        {
          "DiagnosticInfo",
          "Directory",
          "Normal",
        },
        "fg"
      )
      or colors.normal_fg,

    hint =
      first(
        {
          "DiagnosticHint",
          "Directory",
          "Normal",
        },
        "fg"
      )
      or colors.normal_fg,

    hint_diagnostic =
      first(
        {
          "DiagnosticHint",
          "Directory",
          "Normal",
        },
        "fg"
      )
      or colors.normal_fg,
  }

  for name, foreground in pairs(accents) do
    values[name] = {
      fg = foreground,
      bg = panel_bg,
    }

    values[name .. "_visible"] = {
      fg = foreground,
      bg = visible_bg,
    }

    values[name .. "_selected"] = {
      fg = foreground,
      bg = colors.active_bg,
      bold = true,
    }
  end

  return values
end

local function improve_text_contrast()
  local context =
    readable_context()

  if
    not context.background
    or not context.foreground
  then
    return
  end

  local groups = {
    "Normal",
    "NormalNC",
    "NormalFloat",
    "Pmenu",
    "Comment",
    "Constant",
    "String",
    "Character",
    "Number",
    "Boolean",
    "Identifier",
    "Function",
    "Statement",
    "Operator",
    "Keyword",
    "PreProc",
    "Type",
    "Special",

    "@comment",
    "@keyword",
    "@keyword.function",
    "@keyword.operator",
    "@function",
    "@function.builtin",
    "@function.call",
    "@constructor",
    "@string",
    "@string.escape",
    "@number",
    "@operator",
    "@variable",
    "@variable.builtin",
    "@variable.parameter",
    "@constant",
    "@constant.builtin",
    "@type",
    "@type.builtin",
    "@property",
    "@field",
    "@punctuation.bracket",
    "@punctuation.delimiter",
    "@tag",
    "@tag.attribute",
    "@tag.delimiter",

    "NeoTreeNormal",
    "NeoTreeNormalNC",
    "NeoTreeFileName",
    "NeoTreeDirectoryName",

    "TelescopeNormal",

    "WhichKeyDesc",
    "BlinkCmpMenu",
  }

  for _, group in ipairs(groups) do
    local value =
      highlight(group)

    if value.fg then
      value.fg =
        readable(
          value.fg,
          context.background,
          context.preferred,
          4.5
        )

      set(
        group,
        value
      )
    end
  end

  for _, group in ipairs({
    "Normal",
    "NormalNC",
    "NormalFloat",
    "Pmenu",
    "NeoTreeNormal",
    "NeoTreeNormalNC",
  }) do
    local value =
      highlight(group)

    value.fg =
      context.foreground

    set(
      group,
      value
    )
  end
end

local function apply_transparency()
  if vim.g.dms_transparent == false then
    return
  end

  -- Keep selected rows and the active buffer filled;
  -- everything else remains transparent.
  for _, group in ipairs({
    "Normal",
    "NormalNC",
    "NormalFloat",
    "FloatBorder",
    "Pmenu",
    "Terminal",
    "EndOfBuffer",
    "FoldColumn",
    "SignColumn",
    "WhichKeyFloat",

    "TelescopeBorder",
    "TelescopeNormal",
    "TelescopePromptBorder",
    "TelescopePromptNormal",
    "TelescopePromptTitle",

    "NeoTreeNormal",
    "NeoTreeNormalNC",
    "NeoTreeVertSplit",
    "NeoTreeWinSeparator",
    "NeoTreeEndOfBuffer",

    "NvimTreeNormal",
    "NvimTreeVertSplit",
    "NvimTreeEndOfBuffer",

    "SnacksPicker",
    "SnacksPickerBorder",

    "NoiceCmdlinePopup",
    "NoiceCmdlinePopupBorder",
    "NoiceCmdlinePopupTitle",

    "BlinkCmpMenu",
    "LazyNormal",
    "MasonNormal",

    "TabLine",
    "TabLineFill",

    "BufferLineFill",
    "BufferLineBackground",
    "BufferLineBuffer",
    "BufferLineBufferVisible",
    "BufferLineCloseButton",
    "BufferLineCloseButtonVisible",
    "BufferLineNumbers",
    "BufferLineNumbersVisible",
    "BufferLineTab",
    "BufferLineTabClose",
    "BufferLineSeparator",
    "BufferLineSeparatorVisible",
    "BufferLineSeparatorSelected",
    "BufferLineOffsetSeparator",

    "NotifyINFOBody",
    "NotifyERRORBody",
    "NotifyWARNBody",
    "NotifyTRACEBody",
    "NotifyDEBUGBody",

    "NotifyINFOTitle",
    "NotifyERRORTitle",
    "NotifyWARNTitle",
    "NotifyTRACETitle",
    "NotifyDEBUGTitle",

    "NotifyINFOBorder",
    "NotifyERRORBorder",
    "NotifyWARNBorder",
    "NotifyTRACEBorder",
    "NotifyDEBUGBorder",
  }) do
    local value =
      highlight(group)

    value.bg = nil

    set(
      group,
      value
    )
  end
end

function M.apply()
  ------------------------------------------------------------
  -- Base46 / NvChad themes
  ------------------------------------------------------------

  if vim.g.colors_name == "nvchad" then
  local c = require("base46").get_theme_tb("base_30")

  local transparent = vim.g.dms_transparent == true
  local outer_bg = transparent and "NONE" or c.black
  local panel = transparent and "NONE" or c.darker_black
  local elevated = transparent and "NONE" or c.black2

  -- Main floating windows
  set("NormalFloat", { fg = c.white, bg = panel })
  set("FloatBorder", { fg = c.line or c.grey, bg = outer_bg })
  set("FloatTitle", { fg = c.blue, bg = panel, bold = true })

  -- Telescope
  set("TelescopeNormal", { fg = c.white, bg = panel })
  set("TelescopeBorder", { fg = c.line or c.grey, bg = outer_bg })

  set("TelescopePromptNormal", {
    fg = c.white,
    bg = elevated,
  })

  set("TelescopePromptBorder", {
    fg = c.blue,
    bg = outer_bg,
  })

  set("TelescopeSelection", {
    fg = c.white,
    bg = c.one_bg2,
    bold = true,
  })

  set("TelescopeMatching", {
    fg = c.blue,
    bold = true,
  })

  -- Completion popup
  set("BlinkCmpMenu", { fg = c.white, bg = panel })
  set("BlinkCmpMenuBorder", { fg = c.line or c.grey, bg = outer_bg })

  set("BlinkCmpMenuSelection", {
    fg = c.white,
    bg = c.one_bg2,
    bold = true,
  })

  set("BlinkCmpDoc", { fg = c.white, bg = panel })
  set("BlinkCmpDocBorder", { fg = c.line or c.grey, bg = outer_bg })

  -- Neo-tree
  set("NeoTreeNormal", { fg = c.white, bg = panel })
  set("NeoTreeNormalNC", { fg = c.white, bg = panel })

  set("NeoTreeWinSeparator", {
    fg = c.line or c.grey,
    bg = outer_bg,
  })

  set("NeoTreeCursorLine", {
    fg = c.white,
    bg = c.one_bg2,
  })

  -- Snacks
  set("SnacksPicker", { fg = c.white, bg = panel })
  set("SnacksPickerBorder", { fg = c.line or c.grey, bg = outer_bg })

  set("SnacksPickerCursorLine", {
    fg = c.white,
    bg = c.one_bg2,
  })

  -- Noice
  set("NoiceCmdlinePopup", { fg = c.white, bg = panel })

  set("NoiceCmdlinePopupBorder", {
    fg = c.blue,
    bg = outer_bg,
  })

  -- WhichKey
  set("WhichKeyFloat", { bg = panel })
  set("WhichKey", { fg = c.blue, bold = true })
  set("WhichKeyDesc", { fg = c.white })

  improve_picker_directories()
  apply_transparency()
  return
  end

  ------------------------------------------------------------
  -- DMS theme
  ------------------------------------------------------------

  improve_text_contrast()

  -- Fix dim path/folder names in Snacks Picker.
  improve_picker_directories()

  local colors =
    palette()

  local selected = {
    fg = colors.active_fg,
    bg = colors.active_bg,
    bold = true,
    italic = false,
  }

  -- Noice's bottom-search view links to MsgArea,
  -- which may not define a foreground after updates.
  set(
    "MsgArea",
    {
      fg = colors.normal_fg,
    }
  )

  set(
    "NoiceCmdline",
    {
      fg = colors.normal_fg,
    }
  )

  ------------------------------------------------------------
  -- Bufferline
  ------------------------------------------------------------

  for name, value in pairs(
    M.bufferline_highlights()
  ) do
    local group =
      "BufferLine"
      .. name
        :gsub(
          "^%l",
          string.upper
        )
        :gsub(
          "_(%l)",
          string.upper
        )

    set(
      group,
      value
    )
  end

  ------------------------------------------------------------
  -- Selected rows
  ------------------------------------------------------------

  for _, group in ipairs({
    "BlinkCmpMenuSelection",
    "NeoTreeCursorLine",
    "PmenuSel",
    "SnacksPickerCursorLine",
    "TelescopeSelection",
  }) do
    set(
      group,
      selected
    )
  end

  set(
    "NeoTreeFileNameOpened",
    {
      fg = colors.active_fg,
      bold = true,
    }
  )

  apply_transparency()
end

function M.setup()
  local group =
    vim.api.nvim_create_augroup(
      "UserThemeAppearance",
      {
        clear = true,
      }
    )

  ------------------------------------------------------------
  -- Reapply after every colorscheme change
  ------------------------------------------------------------

  vim.api.nvim_create_autocmd(
    "ColorScheme",
    {
      group = group,

      callback = function()
        vim.schedule(
          M.apply
        )
      end,
    }
  )

  ------------------------------------------------------------
  -- Snacks / other UI plugins may load after the colorscheme
  ------------------------------------------------------------

  vim.api.nvim_create_autocmd(
    "User",
    {
      group = group,
      pattern = "LazyLoad",

      callback = function()
        vim.schedule(function()
          improve_picker_directories()
        end)
      end,
    }
  )

  ------------------------------------------------------------
  -- Transparency command
  ------------------------------------------------------------

  vim.api.nvim_create_user_command(
    "EditorTransparencyToggle",
    function()
      require(
        "config.theme-selector"
      ).toggle_transparency()
    end,
    {
      desc =
        "Toggle the transparent editor canvas",
    }
  )

  vim.schedule(
    M.apply
  )
end

return M
