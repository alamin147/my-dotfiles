local M = {}

local modes = {
  { id = "n", name = "Normal" },
  { id = "x", name = "Visual" },
  { id = "s", name = "Select" },
  { id = "o", name = "Operator" },
  { id = "i", name = "Insert" },
  { id = "c", name = "Command" },
  { id = "t", name = "Terminal" },
}

local mode_names = {}
for _, mode in ipairs(modes) do
  mode_names[mode.id] = mode.name
end

local function normalize_mode(mode)
  return mode == "v" and "x" or mode
end

local function normalize_lhs(lhs)
  lhs = tostring(lhs or "")

  -- Active mappings expose lhsraw, while :help index mostly uses printable
  -- notation. Convert both to the same keytrans form before comparing them.
  if not lhs:find("[%z\1-\31\128-\255]") then
    lhs = lhs:gsub("CTRL%-([%w%p])", "<C-%1>")
    lhs = lhs:gsub(">_<", "><")
    lhs = vim.api.nvim_replace_termcodes(lhs, true, true, true)
  end

  return vim.fn.keytrans(lhs)
end

-- Each group is injected into Telescope's searchable text when any member is
-- present. This makes conceptual searches work: "error" finds diagnostics,
-- "fix" finds code actions, and "docs" finds help/hover mappings.
local related_terms = {
  {
    "diagnostic",
    "diagnostics",
    "error",
    "errors",
    "warning",
    "warnings",
    "problem",
    "problems",
    "issue",
    "issues",
    "lint",
    "quickfix",
    "trouble",
    "severity",
  },
  {
    "debug",
    "debugger",
    "breakpoint",
    "breakpoints",
    "step",
    "inspect",
    "variable",
    "variables",
    "stack",
    "trace",
    "continue",
    "pause",
    "repl",
  },
  { "search", "find", "locate", "lookup", "grep", "filter", "fuzzy" },
  { "file", "files", "document", "documents", "buffer", "buffers" },
  { "save", "write", "update", "persist" },
  { "quit", "close", "exit" },
  { "undo", "revert", "history", "change", "changes", "older" },
  { "redo", "repeat", "again", "newer" },
  { "format", "formatter", "formatting", "prettify", "style", "indent" },
  { "completion", "complete", "autocomplete", "suggest", "suggestion", "suggestions" },
  { "definition", "declaration", "implementation", "reference", "references", "symbol", "symbols", "lsp", "language" },
  { "rename", "refactor", "action", "actions", "fix", "fixes", "repair" },
  { "git", "version", "control", "commit", "branch", "diff", "blame", "hunk" },
  { "window", "windows", "split", "pane", "panes", "layout", "resize", "focus" },
  { "tab", "tabs", "tabpage", "page" },
  { "terminal", "shell", "console", "command" },
  { "navigate", "navigation", "move", "jump", "goto", "previous", "next", "back", "forward" },
  { "copy", "yank", "clipboard", "paste", "put" },
  { "delete", "remove", "cut", "erase" },
  { "select", "visual", "selection" },
  { "fold", "collapse", "expand" },
  { "comment", "uncomment", "todo", "note" },
  { "test", "tests", "testing", "spec" },
  { "run", "execute", "build", "compile", "task" },
  { "hover", "documentation", "docs", "help", "manual", "keybind", "keymap", "shortcut", "mapping" },
  { "replace", "substitute" },
  { "spell", "spelling", "typo" },
  { "session", "restore", "persistence" },
  { "bookmark", "mark", "marks", "jumplist" },
  { "macro", "record", "replay" },
  { "uppercase", "lowercase", "case" },
  { "line", "lines", "word", "words", "character", "characters", "text" },
}

local description_overrides = {
  ["n:<Space>cf"] = "Format current file or visual selection",
  ["n:<Space>cd"] = "Show diagnostic under cursor",
  ["n:<Space>xX"] = "Show current-file diagnostics, errors, and warnings",
  ["n:<Space>xx"] = "Show project diagnostics, errors, and warnings",
  ["n:;e"] = "Search diagnostics, errors, and warnings",
  ["n:[d"] = "Go to previous diagnostic, error, or warning",
  ["n:]d"] = "Go to next diagnostic, error, or warning",
  ["n:[e"] = "Go to previous error",
  ["n:]e"] = "Go to next error",
  ["n:[w"] = "Go to previous warning",
  ["n:]w"] = "Go to next warning",
}

local function clean(value)
  return tostring(value or ""):gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")
end

local function search_terms(text)
  local lowered = text:lower()
  local additions = {}

  for _, group in ipairs(related_terms) do
    local matched = false
    for _, term in ipairs(group) do
      if lowered:find(term, 1, true) then
        matched = true
        break
      end
    end
    if matched then
      vim.list_extend(additions, group)
    end
  end

  return table.concat(additions, " ")
end

local function mapping_source(mapping)
  if type(mapping.callback) ~= "function" then
    return "Active map"
  end

  local info = debug.getinfo(mapping.callback, "S")
  local source = info and info.source or ""
  source = source:gsub("^@", "")

  local config = vim.fn.stdpath("config")
  if vim.startswith(source, config .. "/") then
    return "My config"
  end
  if source:find("/LazyVim/", 1, true) then
    return "LazyVim"
  end
  local plugin = source:match("/lazy/([^/]+)/")
  if plugin then
    return plugin
  end
  if source:find("/runtime/", 1, true) then
    return "Neovim"
  end
  return "Active map"
end

local function active_entries()
  local by_id = {}

  local function entry(mapping, buffer_local, requested_mode)
    local mode = normalize_mode(mapping.mode ~= "" and mapping.mode or requested_mode)
    local lhs = normalize_lhs(mapping.lhsraw or mapping.lhs)
    if lhs:find("<Plug>", 1, true) then
      return
    end

    local id = mode .. "\0" .. lhs
    local rhs = clean(mapping.rhs)
    local description = description_overrides[mode .. ":" .. lhs] or clean(mapping.desc) or rhs
    if description == "" then
      description = rhs ~= "" and rhs or "Lua callback"
    end

    local source = mapping_source(mapping)
    if buffer_local then
      source = source .. " (buffer)"
    end

    return id,
      {
        mode = mode,
        mode_name = mode_names[mode] or mode,
        lhs = lhs,
        description = description,
        rhs = clean(mapping.rhs),
        source = source,
        kind = "active",
      }
  end

  -- Globals establish the baseline. A current-buffer mapping with the same
  -- normalized mode + lhs replaces it because that is what Neovim executes.
  for _, mode in ipairs(modes) do
    for _, mapping in ipairs(vim.api.nvim_get_keymap(mode.id)) do
      local id, value = entry(mapping, false, mode.id)
      if id then
        by_id[id] = value
      end
    end
  end

  if vim.api.nvim_get_current_buf() ~= 0 then
    for _, mode in ipairs(modes) do
      for _, mapping in ipairs(vim.api.nvim_buf_get_keymap(0, mode.id)) do
        local id, value = entry(mapping, true, mode.id)
        if id then
          by_id[id] = value
        end
      end
    end
  end

  local entries = {}
  for _, value in pairs(by_id) do
    entries[#entries + 1] = value
  end

  return entries, by_id
end

local index_modes = {
  ["Insert mode"] = { id = "i", name = "Insert" },
  ["Normal mode"] = { id = "n", name = "Normal" },
  ["Visual mode"] = { id = "x", name = "Visual" },
  ["Command-line editing"] = { id = "c", name = "Command" },
  ["Terminal mode"] = { id = "t", name = "Terminal" },
}

local function native_entries(occupied)
  local path = vim.api.nvim_get_runtime_file("doc/index.txt", false)[1]
  if not path then
    return {}
  end

  local lines = vim.fn.readfile(path)
  local entries = {}
  local seen = {}
  local current_mode
  local current_entry

  for _, line in ipairs(lines) do
    local section = line:match("^%d+%.%s+([^%*]+)")
    if section then
      section = clean(section)
      current_mode = index_modes[section]
      current_entry = nil
    elseif current_mode then
      local tag, rest = line:match("^|([^|]+)|%s*(.+)$")
      if tag and rest then
        local lhs, description = rest:match("^(.-)%s%s+(.+)$")
        lhs = normalize_lhs(clean(lhs))
        description = clean(description)

        if lhs ~= "" and description ~= "" and not description:find("not used", 1, true) then
          local mode = normalize_mode(current_mode.id)
          local id = mode .. "\0" .. lhs

          if not occupied[id] and not seen[id] then
            seen[id] = true
            current_entry = {
              mode = mode,
              mode_name = current_mode.name,
              lhs = lhs,
              description = description,
              rhs = "",
              source = "Neovim default",
              kind = "native",
              tag = tag,
            }
            entries[#entries + 1] = current_entry
          else
            current_entry = nil
          end
        else
          current_entry = nil
        end
      elseif current_entry and line:match("^%s+") and not line:match("^%s*[-=]+") then
        local continuation = clean(line)
        if continuation ~= "" and not continuation:match("^%*") then
          current_entry.description = clean(current_entry.description .. " " .. continuation)
        end
      end
    end
  end

  return entries
end

function M.search_text(item)
  local searchable = table.concat({
    item.mode,
    item.mode_name,
    item.lhs,
    item.description,
    item.rhs,
    item.source,
  }, " ")
  return searchable .. " " .. search_terms(searchable)
end

function M.collect()
  local entries, occupied = active_entries()
  vim.list_extend(entries, native_entries(occupied))

  table.sort(entries, function(a, b)
    if a.kind ~= b.kind then
      return a.kind == "active"
    end
    if a.mode ~= b.mode then
      return a.mode < b.mode
    end
    return a.lhs < b.lhs
  end)

  return entries
end

function M.show()
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local config = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  local entry_display = require("telescope.pickers.entry_display")
  local previewers = require("telescope.previewers")

  local displayer = entry_display.create({
    separator = "  ",
    items = {
      { width = 8 },
      { width = 22 },
      { remaining = true },
      { width = 20 },
    },
  })

  local entries = M.collect()
  local active_count = 0
  local native_count = 0
  for _, entry in ipairs(entries) do
    if entry.kind == "active" then
      active_count = active_count + 1
    else
      native_count = native_count + 1
    end
  end
  pickers
    .new({}, {
      prompt_title = ("Keybinds · %d active + %d Neovim defaults · search actions or related words"):format(
        active_count,
        native_count
      ),
      results_title = "Enter opens :help for Neovim defaults",
      finder = finders.new_table({
        results = entries,
        entry_maker = function(item)
          return {
            value = item,
            ordinal = M.search_text(item),
            display = function(entry)
              local value = entry.value
              return displayer({
                { value.mode_name, "TelescopeResultsIdentifier" },
                { value.lhs, "TelescopeResultsNumber" },
                value.description,
                { value.source, "TelescopeResultsComment" },
              })
            end,
          }
        end,
      }),
      sorter = config.generic_sorter({}),
      previewer = previewers.new_buffer_previewer({
        define_preview = function(self, entry)
          local item = entry.value
          local lines = {
            item.description,
            "",
            "Key:     " .. item.lhs,
            "Mode:    " .. item.mode_name .. " (" .. item.mode .. ")",
            "Source:  " .. item.source,
          }
          if item.rhs ~= "" then
            lines[#lines + 1] = "Command: " .. item.rhs
          end
          if item.tag then
            lines[#lines + 1] = "Help:    :help " .. item.tag
            lines[#lines + 1] = ""
            lines[#lines + 1] = "Press Enter to open the full Neovim help page."
          end
          vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)
          vim.bo[self.state.bufnr].filetype = "help"
        end,
      }),
      attach_mappings = function(prompt_bufnr)
        actions.select_default:replace(function()
          local selection = action_state.get_selected_entry()
          actions.close(prompt_bufnr)
          if selection and selection.value.tag then
            vim.cmd.help(selection.value.tag)
          elseif selection then
            vim.notify(
              ("%s [%s] — %s"):format(selection.value.lhs, selection.value.mode_name, selection.value.description),
              vim.log.levels.INFO,
              { title = selection.value.source }
            )
          end
        end)
        return true
      end,
    })
    :find()
end

return M
