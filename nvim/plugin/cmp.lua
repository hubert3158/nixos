local cmp = require("blink.cmp")
local luasnip = require("luasnip")

require("luasnip.loaders.from_vscode").lazy_load()
luasnip.config.setup({})

cmp.setup({
	keymap = { preset = "default" },
	sources = {
		luasnip = {
			providers = { "default" },
		},
	},
})
