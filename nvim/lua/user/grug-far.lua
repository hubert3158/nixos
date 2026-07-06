-- grug-far — ripgrep-backed project search/replace with live preview.
-- Replaced nvim-spectre (stale, sed-based replace). Loaded via lz.n on
-- keys/cmd (plugin/lazy-load.lua); keymaps here bind after first load.

local grug = require("grug-far")

grug.setup({})

vim.keymap.set("n", "<leader>S", function()
	grug.open()
end, { desc = "Search & Replace (grug-far)" })

vim.keymap.set("n", "<leader>sw", function()
	grug.open({ prefills = { search = vim.fn.expand("<cword>") } })
end, { desc = "Search & Replace word under cursor" })

vim.keymap.set("v", "<leader>sw", function()
	grug.with_visual_selection()
end, { desc = "Search & Replace selection" })

-- <leader>sf (NOT <leader>sp — that's the global "toggle spell" map in
-- user/keymaps.lua)
vim.keymap.set("n", "<leader>sf", function()
	grug.open({ prefills = { paths = vim.fn.expand("%") } })
end, { desc = "Search & Replace in current file" })
