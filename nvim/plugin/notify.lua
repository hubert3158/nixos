-- nvim-notify — single source of truth for notification config.

local notify = require("notify")

notify.setup({
	background_colour = "#1e1e2e", -- catppuccin mocha base
	merge_duplicates = true,
	timeout = 3000,
	max_height = function()
		return math.floor(vim.o.lines * 0.75)
	end,
	max_width = function()
		return math.floor(vim.o.columns * 0.75)
	end,
	stages = "fade_in_slide_out",
	render = "compact",
	icons = {
		ERROR = " ",
		WARN = " ",
		INFO = " ",
		DEBUG = " ",
		TRACE = "✎ ",
	},
})

-- Route vim.notify through nvim-notify (noice re-routes again once loaded)
vim.notify = notify

vim.keymap.set("n", "<leader>un", function()
	notify.dismiss({ silent = true, pending = true })
end, { silent = true, desc = "Dismiss Notifications" })
