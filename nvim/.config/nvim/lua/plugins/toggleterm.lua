-- lua/plugins/toggleterm.lua
return {
  "akinsho/toggleterm.nvim",
  version = "*",
  cmd = { "ToggleTerm", "TermExec" },
  config = function()
    require("toggleterm").setup({
      -- Size of terminal
      size = function(term)
        if term.direction == "horizontal" then
          return 10 -- height in lines (reduced from 15)
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.3 -- 30% of columns (reduced from 40%)
        end
      end,

      -- No default open_mapping - use custom keybindings instead
      open_mapping = nil,

      -- Hide terminal line numbers
      hide_numbers = true,

      -- Add shading to terminal (makes it look nicer)
      shade_terminals = true,
      shading_factor = 2,

      -- Start in insert mode when opening terminal
      start_in_insert = true,
      insert_mappings = false, -- disable open_mapping in insert mode
      terminal_mappings = false, -- disable open_mapping in terminal mode

      -- Persist terminal size
      persist_size = true,
      persist_mode = true,

      -- Direction: 'vertical' | 'horizontal' | 'tab' | 'float'
      direction = "float",

      -- Close terminal when process exits
      close_on_exit = true,

      -- Shell to use
      shell = vim.o.shell,

      -- Floating terminal options
      float_opts = {
        border = "curved", -- 'single' | 'double' | 'shadow' | 'curved'
        width = math.floor(vim.o.columns * 0.6), -- 70% of screen width (reduced from 85%)
        height = math.floor(vim.o.lines * 0.65), -- 70% of screen height (reduced from 85%)
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

    -- Function to set terminal keymaps
    function _G.set_terminal_keymaps()
      local opts = { buffer = 0 }
      -- Easy escape from terminal mode (just hide, don't kill)
      vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
      vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)

      -- KILL terminal (close and delete it)
      vim.keymap.set("t", "<C-q>", [[<C-\><C-n>:bd!<CR>]], opts) -- Ctrl+q to kill terminal
      vim.keymap.set("t", "<C-x>", [[<C-\><C-n>:bd!<CR>]], opts) -- Ctrl+x alternative

      -- Navigate windows in terminal mode
      vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
      vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
      vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
      vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
      vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
    end

    -- Apply terminal keymaps automatically
    vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
  end,
}
