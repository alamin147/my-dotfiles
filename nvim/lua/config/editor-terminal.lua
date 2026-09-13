local M = {}

local state = {
  buffer = nil,
  window = nil,
  last_editor_window = nil,
  height = nil,
}

local function valid_window(window)
  return window and vim.api.nvim_win_is_valid(window)
end

local function valid_buffer(buffer)
  return buffer and vim.api.nvim_buf_is_valid(buffer)
end

local function is_editor_window(window)
  if not valid_window(window) or vim.api.nvim_win_get_tabpage(window) ~= vim.api.nvim_get_current_tabpage() then
    return false
  end

  local config = vim.api.nvim_win_get_config(window)
  if config.relative ~= "" then
    return false
  end

  local buffer = vim.api.nvim_win_get_buf(window)
  return not vim.b[buffer].editor_terminal
    and vim.bo[buffer].buftype == ""
    and vim.bo[buffer].filetype ~= "neo-tree"
end

local function remember_editor_window()
  local window = vim.api.nvim_get_current_win()
  if is_editor_window(window) then
    state.last_editor_window = window
  end
end

local function find_editor_window()
  local current = vim.api.nvim_get_current_win()
  if is_editor_window(current) then
    return current
  end

  if is_editor_window(state.last_editor_window) then
    return state.last_editor_window
  end

  for _, window in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if is_editor_window(window) then
      return window
    end
  end
end

local function desired_height(editor_window)
  local available = math.max(3, vim.api.nvim_win_get_height(editor_window) - 3)
  local default = math.max(10, math.min(18, math.floor(vim.o.lines * 0.3)))
  return math.max(3, math.min(state.height or default, available))
end

local function focus_editor()
  if is_editor_window(state.last_editor_window) then
    pcall(vim.api.nvim_set_current_win, state.last_editor_window)
  end
end

local function hide_terminal()
  if not valid_window(state.window) then
    state.window = nil
    return
  end

  state.height = vim.api.nvim_win_get_height(state.window)
  local terminal_was_current = vim.api.nvim_get_current_win() == state.window
  pcall(vim.api.nvim_win_hide, state.window)
  state.window = nil

  if terminal_was_current then
    focus_editor()
  end
end

local function set_terminal_keymaps(buffer)
  local opts = { buffer = buffer, silent = true }

  vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], opts)
  vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
  vim.keymap.set({ "n", "t" }, "<C-\\>", function()
    M.toggle()
  end, vim.tbl_extend("force", opts, { desc = "Hide bottom terminal" }))
  vim.keymap.set({ "n", "t" }, "<C-q>", function()
    M.kill()
  end, vim.tbl_extend("force", opts, { desc = "Kill bottom terminal" }))

  vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
  vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
end

local function create_terminal(editor_window)
  local buffer = vim.api.nvim_create_buf(false, false)
  vim.b[buffer].editor_terminal = true
  local window = vim.api.nvim_open_win(buffer, true, {
    split = "below",
    win = editor_window,
    height = desired_height(editor_window),
  })

  local job = vim.fn.jobstart({ vim.o.shell }, {
    cwd = vim.g.original_cwd or vim.fn.getcwd(),
    term = true,
  })

  if job <= 0 then
    pcall(vim.api.nvim_win_close, window, true)
    pcall(vim.api.nvim_buf_delete, buffer, { force = true })
    vim.notify("Could not start the editor terminal", vim.log.levels.ERROR)
    return
  end

  state.buffer = buffer
  state.window = window

  vim.bo[buffer].bufhidden = "hide"
  vim.bo[buffer].buflisted = false
  vim.wo[window].winfixheight = true
  set_terminal_keymaps(buffer)

  vim.api.nvim_create_autocmd("TermClose", {
    buffer = buffer,
    once = true,
    callback = function(args)
      vim.schedule(function()
        if state.buffer ~= args.buf then
          return
        end

        if valid_window(state.window) then
          pcall(vim.api.nvim_win_hide, state.window)
        end
        state.buffer = nil
        state.window = nil
        pcall(vim.api.nvim_buf_delete, args.buf, { force = true })
        focus_editor()
      end)
    end,
  })
end

local function show_terminal(editor_window)
  state.window = vim.api.nvim_open_win(state.buffer, true, {
    split = "below",
    win = editor_window,
    height = desired_height(editor_window),
  })
  vim.wo[state.window].winfixheight = true
end

function M.toggle()
  if valid_window(state.window) then
    hide_terminal()
    return
  end

  local editor_window = find_editor_window()
  if not editor_window then
    vim.notify("No editor window is available for the terminal", vim.log.levels.WARN)
    return
  end

  state.last_editor_window = editor_window
  if valid_buffer(state.buffer) then
    show_terminal(editor_window)
  else
    create_terminal(editor_window)
  end

  if valid_window(state.window) then
    vim.cmd("startinsert")
  end
end

function M.kill()
  local buffer = state.buffer
  local editor_window = state.last_editor_window

  state.buffer = nil
  state.window = nil

  if valid_buffer(buffer) then
    local job = vim.b[buffer].terminal_job_id
    if job then
      pcall(vim.fn.jobstop, job)
    end
    pcall(vim.api.nvim_buf_delete, buffer, { force = true })
  end

  if is_editor_window(editor_window) then
    pcall(vim.api.nvim_set_current_win, editor_window)
  end
end

local group = vim.api.nvim_create_augroup("UserEditorTerminal", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
  group = group,
  callback = remember_editor_window,
})
remember_editor_window()

return M
