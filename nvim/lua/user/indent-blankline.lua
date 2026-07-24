-- Indent guides — the passive layer of the ink hierarchy.
--
-- scope is deliberately OFF: mini.indentscope (user/mini.lua) owns the
-- current-scope indicator. ibl 3.x defaults scope.enabled = true, so running
-- both draws two guides in the same column plus ibl's start/end underlines.
--
-- Division of labour:
--   ibl              → every indent level, sumiInk4, static  (quiet chrome)
--   mini.indentscope → the scope you're in, crystalBlue, animated (the accent)
--
-- IblIndent / IblWhitespace are recolored in init.lua so the guides read as
-- the same ink stroke as the ▏ window separators (fillchars in options.lua).
require("ibl").setup({
	indent = {
		char = "▏",
		tab_char = "▏",
		highlight = "IblIndent",
	},

	whitespace = {
		highlight = "IblWhitespace",
		remove_blankline_trail = true,
	},

	scope = { enabled = false },

	exclude = {
		-- ibl's defaults, plus the surfaces this config paints itself
		filetypes = {
			"",
			"checkhealth",
			"dashboard",
			"gitcommit",
			"help",
			"lspinfo",
			"man",
			"neo-tree",
			"packer",
			"snacks_dashboard",
			"TelescopePrompt",
			"TelescopeResults",
			"toggleterm",
			"trouble",
			"Trouble",
		},
		buftypes = { "terminal", "nofile", "quickfix", "prompt" },
	},
})
