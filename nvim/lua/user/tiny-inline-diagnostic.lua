-- tiny-inline-diagnostic — pretty cursor-line diagnostics (modern preset).
-- Replaces vim.diagnostic virtual_text: the plugin renders the current line's
-- diagnostic in a styled chip; other lines keep signs/underline only.
-- Loaded via lz.n on BufReadPre/BufNewFile.

require("tiny-inline-diagnostic").setup({
	preset = "modern",
	options = {
		show_source = { enabled = true, if_multiple = true },
		multilines = { enabled = true },
		severity = {
			vim.diagnostic.severity.ERROR,
			vim.diagnostic.severity.WARN,
			vim.diagnostic.severity.INFO,
			vim.diagnostic.severity.HINT,
		},
	},
})

-- virtual_text off — tiny-inline-diagnostic renders instead
-- (base config lives in user/diagnostics.lua; this narrows it after load)
vim.diagnostic.config({ virtual_text = false })
