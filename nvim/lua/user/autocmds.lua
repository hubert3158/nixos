-- Global autocmds. Format-on-save lives in conform's own config
-- (user/conform.lua format_on_save); lint-on-save in user/nvimLint.lua.

-- Auto-save when focus is lost
vim.api.nvim_create_autocmd("FocusLost", {
	pattern = "*",
	command = "silent! wa",
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "sql", "DBUIQuery" },
	callback = function()
		vim.bo.omnifunc = "" -- prevent fallback to SQLComplete
	end,
})

-- Lazy load neo-tree (only load when opening a directory or no args)
vim.api.nvim_create_autocmd("BufEnter", {
	once = true,
	callback = function()
		if vim.fn.isdirectory(vim.fn.expand("%")) == 1 or vim.fn.argc() == 0 then
			require("user.neo-tree")
		end
	end,
})

-- No indent guides in UI-ish buffers
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "help", "alpha", "dashboard", "neo-tree", "Trouble" },
	callback = function()
		vim.b.indent_blankline_enabled = false
	end,
})
