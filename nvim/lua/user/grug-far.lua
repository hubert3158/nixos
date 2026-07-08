-- grug-far — ripgrep-backed project search/replace with live preview.
-- Replaced nvim-spectre (stale, sed-based replace). Loaded via lz.n on
-- keys/cmd (plugin/lazy-load.lua); keymaps here bind after first load.

local grug = require("grug-far")

grug.setup({})

-- <leader>s = search/replace (namespace registry: user/keymaps.lua;
-- <leader>ss = native :%s substitute lives there)
vim.keymap.set("n", "<leader>sr", function()
	grug.open()
end, { desc = "Search & replace in project" })

vim.keymap.set("n", "<leader>sw", function()
	grug.open({ prefills = { search = vim.fn.expand("<cword>") } })
end, { desc = "Search & replace word under cursor" })

vim.keymap.set("v", "<leader>sw", function()
	grug.with_visual_selection()
end, { desc = "Search & replace selection" })

vim.keymap.set("n", "<leader>sf", function()
	grug.open({ prefills = { paths = vim.fn.expand("%") } })
end, { desc = "Search & replace in current file" })
