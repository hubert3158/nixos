local cmp = require("blink.cmp")
local luasnip = require("luasnip")
require("luasnip.loaders.from_vscode").lazy_load()
luasnip.config.setup({})

-- Snippet keybinding
vim.keymap.set({ "i", "s" }, "<C-k>", function()
	if luasnip.expand_or_jumpable() then
		luasnip.expand_or_jump()
	end
end, { silent = true })

cmp.setup({
	keymap = { preset = "default" },
	snippets = {
		preset = "luasnip",
	},
	completion = { documentation = { auto_show = true } },
	signature = { enabled = true },
	sources = {
		default = {
			"lsp",
			"path",
			"buffer",
			"snippets",
			"codecompanion",
			"omni",
			"cmdline",
		},
		per_filetype = {
			sql = { "snippets", "dadbod", "buffer" },
		},
		providers = {
			dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
		},
	},

	fuzzy = { implementation = "prefer_rust_with_warning" },
})
