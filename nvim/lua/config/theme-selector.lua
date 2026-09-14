local M = { active = "dms" }
local state_path = vim.fn.stdpath("state") .. "/dms-theme.json"
local state = { theme = "dms", transparency = {} }
local ready = false

function M.themes()
  local names, seen = { "dms" }, { dms = true }
  for _, path in ipairs(vim.api.nvim_get_runtime_file("lua/base46/themes/*.lua", true)) do
    local name = vim.fn.fnamemodify(path, ":t:r")
    if not seen[name] then
      names[#names + 1], seen[name] = name, true
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

local function valid(name)
  return type(name) == "string" and vim.tbl_contains(M.themes(), name)
end

local function persist()
  vim.fn.mkdir(vim.fn.fnamemodify(state_path, ":h"), "p")
  local temporary = state_path .. "." .. vim.fn.getpid() .. ".tmp"
  local ok, err = pcall(vim.fn.writefile, { vim.json.encode(state) }, temporary)
  if ok then
    ok, err = vim.uv.fs_rename(temporary, state_path)
  end
  if not ok then
    vim.notify("Could not save theme: " .. tostring(err), vim.log.levels.ERROR)
  end
  return ok
end

function M.lualine_theme()
  if M.active == "dms" then
    package.loaded["lualine.themes.dms"] = nil
    return require("lualine.themes.dms")
  end
  local c = require("base46").get_theme_tb("base_30")
  local bg = vim.g.dms_transparent and "NONE" or c.statusline_bg
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
      a = { fg = c.black, bg = accent, gui = "bold" },
      b = { fg = c.white, bg = bg },
      c = { fg = c.white, bg = bg },
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
    -- Also support :colorscheme nvchad after visiting the DMS colorscheme.
    M.active = opts.theme
    vim.g.dms_transparent = state.transparency[M.active] == true
  end
  opts.theme = M.active
  opts.transparency = vim.g.dms_transparent == true
  -- Set background before compiling: a few upstream integrations inspect it.
  -- Clear the previous colorscheme name to avoid background triggering it again.
  vim.g.colors_name = nil
  require("plenary.reload").reload_module("base46")
  vim.o.background = require("base46").get_theme_tb("type")
  vim.cmd("highlight clear")
  vim.g.colors_name = "nvchad"
  require("base46").load_all_highlights()
  -- NvChad's terminal component normally loads this cache separately.
  dofile(vim.g.base46_cache .. "term")
  require("config.appearance").apply()
end

function M.apply(name, save)
  if not valid(name) then
    error("Unknown DMS/NvChad theme: " .. tostring(name))
  end
  local previous, previous_transparency = M.active, vim.g.dms_transparent
  M.active = name
  local transparent = state.transparency[name]
  if transparent == nil then
    transparent = name == "dms"
  end
  vim.g.dms_transparent = transparent
  local ok, err = pcall(vim.cmd.colorscheme, name == "dms" and "dms" or "nvchad")
  if not ok then
    M.active = previous
    vim.g.dms_transparent = previous_transparency
    local restored, restore_error = pcall(vim.cmd.colorscheme, previous == "dms" and "dms" or "nvchad")
    if not restored then
      vim.notify("Could not restore previous theme: " .. tostring(restore_error), vim.log.levels.ERROR)
    end
    error(err)
  end
  if save then
    state.theme = name
    persist()
  end
end

function M.toggle_transparency()
  state.transparency[M.active] = not vim.g.dms_transparent
  M.apply(M.active)
  persist()
end

function M.startup()
  M.setup()
  local ok, err = pcall(M.apply, state.theme)
  if not ok then
    vim.notify("Theme unavailable; using DMS. " .. tostring(err), vim.log.levels.WARN)
    M.apply("dms")
  end
end

function M.setup()
  if ready then
    return
  end
  ready = true
  -- Do not share/overwrite the exploratory NvChad installation's bytecode.
  local cache_path = vim.fn.stdpath("cache") .. "/dms-base46/" .. vim.fn.getpid() .. "/"
  vim.g.base46_cache = cache_path
  local ok, saved = pcall(function()
    return vim.json.decode(table.concat(vim.fn.readfile(state_path), "\n"))
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
  local group = vim.api.nvim_create_augroup("DmsThemeController", { clear = true })
  vim.api.nvim_create_autocmd("VimLeavePre", {
    group = group,
    callback = function()
      -- Only this process's generated bytecode; concurrent editor previews
      -- must not overwrite another editor's lazy-loaded highlights.
      vim.fn.delete(cache_path, "rf")
    end,
  })
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = group,
    callback = function()
      -- Includes DMS's Matugen watcher, not only picker-driven changes.
      if vim.g.colors_name == "dms" then
        M.active = "dms"
      end
      vim.schedule(M.refresh_statusline)
    end,
  })
  vim.api.nvim_create_autocmd("User", {
    group = group,
    pattern = "LazyLoad",
    callback = function()
      -- Late-loaded plugins can install their own highlights. Replay compiled
      -- integrations after their setup, without re-compiling or loading plugins.
      vim.schedule(function()
        if vim.g.colors_name ~= "nvchad" then
          return
        end
        for _, path in ipairs(vim.fn.glob(vim.g.base46_cache .. "*", false, true)) do
          if not vim.tbl_contains({ "colors", "term" }, vim.fn.fnamemodify(path, ":t")) then
            dofile(path)
          end
        end
        require("config.appearance").apply()
      end)
    end,
  })
  vim.api.nvim_create_user_command("Theme", function(args)
    if args.args == "" then
      M.open()
    else
      M.apply(args.args, true)
    end
  end, {
    nargs = "?",
    complete = function()
      return M.themes()
    end,
    desc = "Select a DMS or NvChad theme",
  })
end

function M.open()
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  local previous, confirmed = M.active, false
  local function preview_selection()
    local entry = action_state.get_selected_entry()
    if entry and entry.value ~= M.active then
      local ok, err = pcall(M.apply, entry.value)
      if not ok then
        vim.notify(tostring(err), vim.log.levels.ERROR)
      end
    end
  end
  local previewer = require("telescope.previewers").new_buffer_previewer({
    title = "Live theme preview",
    define_preview = function(self, entry)
      vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, {
        "-- " .. entry.value .. (entry.value == "dms" and " (dynamic desktop colors)" or " (NvChad Base46)"),
        "-- Enter: keep theme   Esc: restore previous theme",
        "",
        'local message = "Your editor, one palette"',
        "local function greet(name)",
        "  -- Comments, strings, functions and UI follow the theme",
        '  return message .. ": " .. name, 42',
        "end",
        'print(greet("Alamin"))',
        "",
        "-- Preview is applied across the editor.",
      })
      vim.bo[self.state.bufnr].filetype = "lua"
    end,
  })
  local picker = require("telescope.pickers").new({}, {
    prompt_title = "Themes · DMS + NvChad",
    finder = require("telescope.finders").new_table({
      results = M.themes(),
      entry_maker = function(name)
        return { value = name, ordinal = name, display = name == "dms" and "dms  ·  dynamic desktop" or name }
      end,
    }),
    sorter = require("telescope.config").values.generic_sorter({}),
    previewer = previewer,
    on_complete = { preview_selection },
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        local entry = action_state.get_selected_entry()
        if not entry then
          return
        end
        confirmed = true
        actions.close(prompt_bufnr)
        M.apply(entry.value, true)
      end)
      map("i", "<Esc>", actions.close)
      return true
    end,
  })
  -- Match Telescope's own colorscheme picker lifecycle. Selection hooks also
  -- work when a narrow terminal hides the optional code preview pane.
  local set_selection = picker.set_selection
  picker.set_selection = function(self, row)
    set_selection(self, row)
    preview_selection()
  end
  local close_windows = picker.close_windows
  picker.close_windows = function(status)
    close_windows(status)
    if not confirmed then
      M.apply(previous)
    end
  end
  picker:find()
end

return M
