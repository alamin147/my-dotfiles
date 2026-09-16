local M = { active = "dms" }

local state_path = vim.fn.stdpath("state") .. "/dms-theme.json"
local state = {
  theme = "dms",
  transparency = {},
}

local ready = false
------------ M.themes start
function M.themes()
  local names, seen = { "dms" }, { dms = true }

  for _, path in ipairs(vim.api.nvim_get_runtime_file("lua/base46/themes/*.lua", true)) do
    local name = vim.fn.fnamemodify(path, ":t:r")

    if not seen[name] then
      names[#names + 1] = name
      seen[name] = true
    end
  end

  table.sort(names, function(a, b)
    if a == "dms" then
      return true
    end

    if b == "dms" then
      return false
    end

    return a < b
  end)

  return names
end
----------- end M.themes
local function valid(name)
  return type(name) == "string" and vim.tbl_contains(M.themes(), name)
end

local function persist()
  vim.fn.mkdir(vim.fn.fnamemodify(state_path, ":h"), "p")

  local temporary = state_path .. "." .. vim.fn.getpid() .. ".tmp"

  local ok, err = pcall(
    vim.fn.writefile,
    { vim.json.encode(state) },
    temporary
  )

  if ok then
    ok, err = vim.uv.fs_rename(temporary, state_path)
  end

  if not ok then
    vim.notify(
      "Could not save theme: " .. tostring(err),
      vim.log.levels.ERROR
    )
  end

  return ok
end

function M.lualine_theme()
  if M.active == "dms" then
    package.loaded["lualine.themes.dms"] = nil
    return require("lualine.themes.dms")
  end

  local c = require("base46").get_theme_tb("base_30")

  local bg = vim.g.dms_transparent
      and "NONE"
    or c.statusline_bg

  local theme = {}

  for mode, accent in pairs({
    normal = c.blue,
    insert = c.green,
    visual = c.purple,
    replace = c.red,
    command = c.yellow,
    terminal = c.teal,
    inactive = c.grey_fg,
  }) do
    theme[mode] = {
      a = {
        fg = c.black,
        bg = accent,
        gui = "bold",
      },

      b = {
        fg = c.white,
        bg = bg,
      },

      c = {
        fg = c.white,
        bg = bg,
      },
    }
  end

  return theme
end

function M.refresh_statusline()
  local lualine = package.loaded.lualine

  if lualine and lualine.get_config then
    local config = lualine.get_config()

    if config.options then
      config.options.theme = M.lualine_theme()
      lualine.setup(config)
    end
  end
end

function M.load_base46()
  local opts = require("nvconfig").base46

  if M.active == "dms" then
    -- Also support :colorscheme nvchad after visiting DMS.
    M.active = opts.theme

    vim.g.dms_transparent =
      state.transparency[M.active] == true
  end

  opts.theme = M.active
  opts.transparency = vim.g.dms_transparent == true

  -- Set background before compiling because some
  -- upstream integrations inspect it.
  vim.g.colors_name = nil

  require("plenary.reload").reload_module("base46")

  vim.o.background =
    require("base46").get_theme_tb("type")

  vim.cmd("highlight clear")

  vim.g.colors_name = "nvchad"

  require("base46").load_all_highlights()

  -- NvChad terminal component.
  dofile(vim.g.base46_cache .. "term")

  require("config.appearance").apply()
end

function M.apply(name, save)
  if not valid(name) then
    error(
      "Unknown DMS/NvChad theme: "
        .. tostring(name)
    )
  end

  local previous = M.active
  local previous_transparency =
    vim.g.dms_transparent

  M.active = name

  local transparent =
    state.transparency[name]

  if transparent == nil then
    transparent = name == "dms"
  end

  vim.g.dms_transparent = transparent

  local ok, err = pcall(
    vim.cmd.colorscheme,
    name == "dms"
        and "dms"
      or "nvchad"
  )

  if not ok then
    M.active = previous

    vim.g.dms_transparent =
      previous_transparency

    local restored, restore_error = pcall(
      vim.cmd.colorscheme,
      previous == "dms"
          and "dms"
        or "nvchad"
    )

    if not restored then
      vim.notify(
        "Could not restore previous theme: "
          .. tostring(restore_error),
        vim.log.levels.ERROR
      )
    end

    error(err)
  end

  if save then
    state.theme = name
    persist()
  end
end

function M.toggle_transparency()
  state.transparency[M.active] =
    not vim.g.dms_transparent

  M.apply(M.active)

  persist()
end

function M.startup()
  M.setup()

  local ok, err = pcall(
    M.apply,
    state.theme
  )

  if not ok then
    vim.notify(
      "Theme unavailable; using DMS. "
        .. tostring(err),
      vim.log.levels.WARN
    )

    M.apply("dms")
  end
end

function M.setup()
  if ready then
    return
  end

  ready = true

  -- Separate Base46 cache for this Neovim process.
  local cache_path =
    vim.fn.stdpath("cache")
    .. "/dms-base46/"
    .. vim.fn.getpid()
    .. "/"

  vim.g.base46_cache = cache_path

  local ok, saved = pcall(function()
    return vim.json.decode(
      table.concat(
        vim.fn.readfile(state_path),
        "\n"
      )
    )
  end)

  if ok and type(saved) == "table" then
    if valid(saved.theme) then
      state.theme = saved.theme
    end

    if type(saved.transparency) == "table" then
      for name, value in pairs(saved.transparency) do
        if type(value) == "boolean" then
          state.transparency[name] = value
        end
      end
    end
  end

  local group =
    vim.api.nvim_create_augroup(
      "DmsThemeController",
      { clear = true }
    )

  vim.api.nvim_create_autocmd(
    "VimLeavePre",
    {
      group = group,

      callback = function()
        vim.fn.delete(
          cache_path,
          "rf"
        )
      end,
    }
  )

  vim.api.nvim_create_autocmd(
    "ColorScheme",
    {
      group = group,

      callback = function()
        -- Includes DMS Matugen changes.
        if vim.g.colors_name == "dms" then
          M.active = "dms"
        end

        vim.schedule(
          M.refresh_statusline
        )
      end,
    }
  )

  vim.api.nvim_create_autocmd(
    "User",
    {
      group = group,
      pattern = "LazyLoad",

      callback = function()
        vim.schedule(function()
          if vim.g.colors_name ~= "nvchad" then
            return
          end

          for _, path in ipairs(
            vim.fn.glob(
              vim.g.base46_cache .. "*",
              false,
              true
            )
          ) do
            local name =
              vim.fn.fnamemodify(
                path,
                ":t"
              )

            if not vim.tbl_contains(
              { "colors", "term" },
              name
            ) then
              dofile(path)
            end
          end

          require(
            "config.appearance"
          ).apply()
        end)
      end,
    }
  )

  vim.api.nvim_create_user_command(
    "Theme",
    function(args)
      if args.args == "" then
        M.open()
      else
        M.apply(
          args.args,
          true
        )
      end
    end,
    {
      nargs = "?",

      complete = function()
        return M.themes()
      end,

      desc =
        "Select a DMS or NvChad theme",
    }
  )
end

function M.open()
  local actions =
    require("telescope.actions")

  local action_state =
    require("telescope.actions.state")

  local previewers =
    require("telescope.previewers")

  local pickers =
    require("telescope.pickers")

  local finders =
    require("telescope.finders")

  local telescope_config =
    require("telescope.config").values

  local previous = M.active
  local confirmed = false

  ------------------------------------------------------------
  -- Capture current editor buffer before Telescope opens
  ------------------------------------------------------------

  local source_buf =
    vim.api.nvim_get_current_buf()

  local source_win =
    vim.api.nvim_get_current_win()

  local source_lines =
    vim.api.nvim_buf_get_lines(
      source_buf,
      0,
      -1,
      false
    )

  local source_ft =
    vim.bo[source_buf].filetype

  local source_name =
    vim.api.nvim_buf_get_name(
      source_buf
    )

  local source_cursor =
    vim.api.nvim_win_get_cursor(
      source_win
    )

  local source_label

  if source_name ~= "" then
    source_label =
      vim.fn.fnamemodify(
        source_name,
        ":t"
      )
  else
    source_label = "[No Name]"
  end

  local preview_key

  if source_name ~= "" then
    preview_key = source_name
  else
    preview_key =
      "dms-theme-preview:"
      .. source_buf
  end

  ------------------------------------------------------------
  -- Theme list + current active theme
  ------------------------------------------------------------

  local themes = M.themes()

  local current_index = 1

  for index, name in ipairs(themes) do
    if name == M.active then
      current_index = index
      break
    end
  end

  ------------------------------------------------------------
  -- Live theme preview
  ------------------------------------------------------------

  local function preview_selection()
    local entry =
      action_state.get_selected_entry()

    if not entry then
      return
    end

    if entry.value == M.active then
      return
    end

    local ok, err = pcall(
      M.apply,
      entry.value
    )

    if not ok then
      vim.notify(
        tostring(err),
        vim.log.levels.ERROR
      )
    end
  end

  ------------------------------------------------------------
  -- Current file preview
  ------------------------------------------------------------

  local previewer =
    previewers.new_buffer_previewer({
      title = "Current file",

      -- Reuse one preview buffer while switching themes.
      get_buffer_by_name = function()
        return preview_key
      end,

      dyn_title = function(_, entry)
        return source_label
          .. "  ·  "
          .. entry.value
      end,

      define_preview = function(self)
        local bufnr =
          self.state.bufnr

        local winid =
          self.state.winid

        --------------------------------------------------------
        -- Populate preview only once
        --------------------------------------------------------

        if not vim.b[bufnr].dms_theme_preview_loaded then
          vim.api.nvim_buf_set_lines(
            bufnr,
            0,
            -1,
            false,
            source_lines
          )

          if source_ft ~= "" then
            vim.bo[bufnr].filetype =
              source_ft

            local lang =
              vim.treesitter.language.get_lang(
                source_ft
              )
              or source_ft

            pcall(
              vim.treesitter.start,
              bufnr,
              lang
            )
          end

          vim.b[bufnr].dms_theme_preview_loaded =
            true
        end

        --------------------------------------------------------
        -- Preview same area as current editor cursor
        --------------------------------------------------------

        vim.schedule(function()
          if
            not vim.api.nvim_win_is_valid(
              winid
            )
          then
            return
          end

          if
            not vim.api.nvim_buf_is_valid(
              bufnr
            )
          then
            return
          end

          if
            vim.api.nvim_win_get_buf(
              winid
            ) ~= bufnr
          then
            return
          end

          local line_count =
            vim.api.nvim_buf_line_count(
              bufnr
            )

          local row =
            math.min(
              source_cursor[1],
              line_count
            )

          local line =
            vim.api.nvim_buf_get_lines(
              bufnr,
              row - 1,
              row,
              false
            )[1]
            or ""

          local col =
            math.min(
              source_cursor[2],
              #line
            )

          pcall(
            vim.api.nvim_win_set_cursor,
            winid,
            {
              row,
              col,
            }
          )

          vim.api.nvim_win_call(
            winid,
            function()
              vim.cmd(
                "normal! zz"
              )
            end
          )
        end)
      end,
    })

  ------------------------------------------------------------
  -- Telescope theme picker
  ------------------------------------------------------------

  local picker = pickers.new(
    {},
    {
      prompt_title =
        "Themes · DMS + NvChad",

      finder =
        finders.new_table({
          results = themes,

          entry_maker = function(name)
            return {
              value = name,
              ordinal = name,

              display =
                name == "dms"
                    and "dms  ·  dynamic desktop"
                  or name,
            }
          end,
        }),

      sorter =
        telescope_config.generic_sorter(
          {}
        ),

      --------------------------------------------------------
      -- IMPORTANT:
      -- keep selection at current theme on picker startup.
      --------------------------------------------------------

      selection_strategy = "follow",

      default_selection_index =
        current_index,

      previewer = previewer,

      layout_config = {
        preview_width = 0.68,
        preview_cutoff = 1,
      },

      --------------------------------------------------------
      -- Apply initially selected theme
      --------------------------------------------------------

      on_complete = {
        preview_selection,
      },

      --------------------------------------------------------
      -- Enter = save selected theme
      --------------------------------------------------------

      attach_mappings = function(
        prompt_bufnr,
        map
      )
        actions.select_default:replace(
          function()
            local entry =
              action_state.get_selected_entry()

            if not entry then
              return
            end

            confirmed = true

            actions.close(
              prompt_bufnr
            )

            M.apply(
              entry.value,
              true
            )
          end
        )

        ------------------------------------------------------
        -- Esc = cancel
        ------------------------------------------------------

        map(
          "i",
          "<Esc>",
          actions.close
        )

        map(
          "n",
          "<Esc>",
          actions.close
        )

        return true
      end,
    }
  )

  ------------------------------------------------------------
  -- Apply theme while moving through picker
  ------------------------------------------------------------

  local set_selection =
    picker.set_selection

  picker.set_selection =
    function(self, row)
      set_selection(
        self,
        row
      )

      preview_selection()
    end

  ------------------------------------------------------------
  -- Restore previous theme when picker is cancelled
  ------------------------------------------------------------

  local close_windows =
    picker.close_windows

  picker.close_windows =
    function(status)
      close_windows(status)

      if not confirmed then
        M.apply(previous)
      end
    end

  picker:find()
end

return M
