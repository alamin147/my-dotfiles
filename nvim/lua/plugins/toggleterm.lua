local function terminal_height()
  return math.max(10, math.min(18, math.floor(vim.o.lines * 0.3)))
end

local function set_terminal_keymaps(term)
  local opts = { buffer = term.bufnr, silent = true }

  vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], opts)
  vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)

  -- Hiding keeps the shell and its running commands alive.
  vim.keymap.set(
    "t",
    "<C-\\>",
    "<Cmd>ToggleTerm<CR>",
    vim.tbl_extend("force", opts, {
      desc = "Hide terminal",
    })
  )

  local function kill_terminal()
    term:shutdown()
  end

  -- Ctrl+Q is terminal-local, so editor/window navigation stays untouched.
  vim.keymap.set(
    { "n", "t" },
    "<C-q>",
    kill_terminal,
    vim.tbl_extend("force", opts, {
      desc = "Kill terminal",
    })
  )

  vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
  vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
end

return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    cmd = { "ToggleTerm", "TermExec" },
    config = function()
      require("toggleterm").setup({
        size = function(term)
          if term.direction == "horizontal" then
            return terminal_height()
          elseif term.direction == "vertical" then
            return math.floor(vim.o.columns * 0.3)
          end
        end,

        -- No default open_mapping - use custom keybindings instead
        open_mapping = nil,

        -- Hide terminal line numbers
        hide_numbers = true,

        -- Let the shared appearance layer control terminal transparency/colors.
        shade_terminals = false,

        -- Start in insert mode when opening terminal
        start_in_insert = true,
        insert_mappings = false, -- disable open_mapping in insert mode
        terminal_mappings = false, -- disable open_mapping in terminal mode

        -- Persist terminal size
        persist_size = true,
        persist_mode = true,

        -- Default for optional ToggleTerm commands. Ctrl+\ uses the local
        -- editor-column panel in config/editor-terminal.lua instead.
        direction = "horizontal",

        -- Close terminal when process exits
        close_on_exit = true,

        -- Shell to use
        shell = vim.o.shell,

        on_open = set_terminal_keymaps,

        -- Floating terminal options
        float_opts = {
          border = "curved", -- 'single' | 'double' | 'shadow' | 'curved'
          width = math.floor(vim.o.columns * 0.6),
          height = math.floor(vim.o.lines * 0.65),
          winblend = 0,
          highlights = {
            border = "Normal",
            background = "Normal",
          },
        },

        -- Window options
        winbar = {
          enabled = false,
        },
      })
    end,
  },
}
