-- Diagnostic display configuration

vim.diagnostic.config({
	virtual_text = {
		spacing = 4,
		source = "if_many",
		prefix = "●",
		format = function(diagnostic)
			local severity_icons = {
				[vim.diagnostic.severity.ERROR] = " ",
				[vim.diagnostic.severity.WARN] = " ",
				[vim.diagnostic.severity.INFO] = " ",
				[vim.diagnostic.severity.HINT] = "󰌶 ",
			}
			local icon = severity_icons[diagnostic.severity] or "■ "
			return icon .. diagnostic.message
		end,
	},
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = " ",
			[vim.diagnostic.severity.WARN] = " ",
			[vim.diagnostic.severity.INFO] = " ",
			[vim.diagnostic.severity.HINT] = "󰌶 ",
		},
	},
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		focusable = false,
		style = "minimal",
		border = "rounded",
		source = "always",
		header = "",
		prefix = "",
		suffix = "",
		format = function(diagnostic)
			return string.format("%s: %s", diagnostic.source or "LSP", diagnostic.message)
		end,
	},
})

-- Global float border for LSP/UI floats (nvim 0.11+)
vim.o.winborder = "rounded"
