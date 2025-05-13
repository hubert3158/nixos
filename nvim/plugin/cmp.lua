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
	sources = {
		default = { "lsp", "path", "buffer", "snippets" },
	},
})
