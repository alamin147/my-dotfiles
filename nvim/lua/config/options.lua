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

-- removeeee
-- ========================================
-- Performance Optimizations
-- ========================================

-- Reduce update time for faster CursorHold events and better responsiveness
vim.opt.updatetime = 250 -- default is 4000ms

-- Faster key sequence completion
vim.opt.timeoutlen = 300 -- default is 1000ms

-- Make background transparent in Neovim
--vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
--vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
--vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
--vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
