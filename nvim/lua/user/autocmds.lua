-- Global autocmds. Format-on-save lives in conform's own config
-- (user/conform.lua format_on_save); lint-on-save in user/nvimLint.lua.

local group = vim.api.nvim_create_augroup("UserAutocmds", { clear = true })

-- Auto-save when focus is lost
vim.api.nvim_create_autocmd("FocusLost", {
	group = group,
	pattern = "*",
	command = "silent! wa",
})

vim.api.nvim_create_autocmd("FileType", {
	group = group,
	pattern = { "sql", "DBUIQuery" },
	callback = function()
		vim.bo.omnifunc = "" -- prevent fallback to SQLComplete
	end,
})

-- Load neo-tree when opening a directory or starting with no args (netrw
-- hijack needs it loaded). neo-tree is opt — go through lz.n, which packadds
-- it and runs its config hook (window-picker + user/neo-tree).
vim.api.nvim_create_autocmd("BufEnter", {
	group = group,
	once = true,
	callback = function()
		if vim.fn.isdirectory(vim.fn.expand("%")) == 1 or vim.fn.argc() == 0 then
			require("lz.n").trigger_load("neo-tree.nvim")
		end
	end,
})

-- No indent guides in UI-ish buffers
vim.api.nvim_create_autocmd("FileType", {
	group = group,
	pattern = { "help", "dashboard", "neo-tree", "Trouble" },
	callback = function()
		vim.b.indent_blankline_enabled = false
	end,
})
