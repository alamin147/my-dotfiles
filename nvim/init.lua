-- Preserve the shell's logical working directory (including symlink paths).
-- Some project tools otherwise replace it with the resolved physical path.
vim.opt.autochdir = false

local shell_cwd = vim.env.PWD
if shell_cwd and shell_cwd ~= "" and vim.fn.isdirectory(shell_cwd) == 1 then
  vim.g.original_cwd = shell_cwd
  pcall(vim.api.nvim_set_current_dir, shell_cwd)
else
  vim.g.original_cwd = vim.fn.getcwd()
end

require("config.lazy")
