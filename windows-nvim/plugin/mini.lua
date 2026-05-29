require("mini.pairs").setup({})
require("mini.surround").setup({})
require("mini.map").setup({
	integrations = {
		require("mini.map").gen_integration.builtin_search(),
		require("mini.map").gen_integration.gitsigns(),
		require("mini.map").gen_integration.diagnostic(),
	},
})
require("mini.indentscope").setup({})
require("mini.cursorword").setup({})
require("mini.ai").setup({})
