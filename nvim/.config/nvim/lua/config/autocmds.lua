-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Disable automatic LSP formatting (format-on-save) globally.
-- Some LazyVim or plugin configs attach an autocmd that calls formatting on BufWritePre.
-- To permanently prevent automatic formatting after save, disable the formatting
-- capability on attach for all LSP clients. This preserves manual formatting
-- (e.g. `:lua vim.lsp.buf.format{}`) if you ever want it.
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserDisableLspFormatting", { clear = true }),
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client and client.server_capabilities then
			client.server_capabilities.documentFormattingProvider = false
			client.server_capabilities.documentRangeFormattingProvider = false
		end
	end,
})

-- Disable autoformat for C++, C, and Python files
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "cpp", "c", "python" },
	group = vim.api.nvim_create_augroup("DisableAutoformatCppPython", { clear = true }),
	callback = function()
		vim.b.autoformat = false
	end,
})


