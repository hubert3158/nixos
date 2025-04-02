local notify = require("notify")

notify.setup({ background_colour = "#000000", merge_duplicates = true })

-- Register keybindings separately
vim.api.nvim_set_keymap(
	"n",
	"<leader>un",
	":lua require('notify').dismiss({ silent = true, pending = true })<CR>",
	{ noremap = true, silent = true, desc = "Dismiss All Notifications" }
)
