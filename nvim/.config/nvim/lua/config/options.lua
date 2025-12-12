-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.mapleader = " "

vim.scriptencoding = "utf-8"
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"

vim.opt.number = true

vim.opt.title = true
vim.opt.autoindent = false
vim.opt.smartindent = false
vim.opt.hlsearch = true
vim.opt.backup = false
vim.opt.showcmd = true
vim.opt.cmdheight = 0
vim.opt.laststatus = 3
vim.opt.expandtab = true
vim.opt.scrolloff = 10
vim.opt.inccommand = "split"
vim.opt.ignorecase = true
vim.opt.smarttab = true
vim.opt.breakindent = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.wrap = true
vim.opt.backspace = { "start", "eol", "indent" }
vim.opt.path:append({ "**" })
vim.opt.wildignore:append({ "*/node_modules/*" })
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.splitkeep = "cursor"

-- Add asterisks in block comments
vim.opt.formatoptions:append({ "r" })

-- ========================================
-- Diagnostic Configuration
-- ========================================

-- Hide diagnostics in insert mode, only show in normal mode
vim.diagnostic.config({
  virtual_text = false, -- Disable inline virtual text by default
  signs = true,         -- Keep error signs in the gutter
  underline = true,     -- Keep underlining errors
  update_in_insert = false, -- Don't update diagnostics while typing
})

-- Show diagnostics only in normal mode
vim.api.nvim_create_autocmd("ModeChanged", {
  pattern = "*",
  callback = function()
    local mode = vim.fn.mode()
    if mode == "n" then
      -- Show virtual text in normal mode
      vim.diagnostic.config({ virtual_text = true })
    else
      -- Hide virtual text in insert/visual modes
      vim.diagnostic.config({ virtual_text = false })
    end
  end,
})

-- removeeee
-- ========================================
-- Performance Optimizations
-- ========================================

-- Reduce update time for faster CursorHold events and better responsiveness
vim.opt.updatetime = 250 -- default is 4000ms

-- Faster key sequence completion
vim.opt.timeoutlen = 300 -- default is 1000ms

-- ========================================
-- Filetype detection for extensionless config files
-- ========================================
vim.filetype.add({
  filename = {
    ["config"] = "bash",
    ["hyprland.conf"] = "hyprlang",
    ["hyprlock.conf"] = "hyprlang",
    ["hyprpaper.conf"] = "hyprlang",
  },
  pattern = {
    -- Ghostty config files
    [".*/.config/ghostty/.*"] = "bash",
    -- Hyprland config files
    [".*/.config/hypr/.*%.conf"] = "hyprlang",
    -- Generic config files
    [".*%.conf"] = function(path, bufnr)
      -- Check if it looks like a shell/bash config
      local first_line = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1] or ""
      if first_line:match("^#!.*sh") then
        return "sh"
      end
      return "conf"
    end,
    -- Files in .config with no extension
    [".*/%.config/.*/[^%.]+$"] = function(path, bufnr)
      local first_line = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1] or ""
      if first_line:match("^#") then
        return "bash"
      end
      return "conf"
    end,
  },
})

-- Make background transparent in Neovim
--vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
--vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
--vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
--vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
