-- mini.nvim modules. Loaded via lz.n on DeferredUIEnter.

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
-- Treesitter textobjects (queries from nvim-treesitter-textobjects, eager in
-- plugins.nix): vaf/vif function, vac/vic class, vao/vio conditional/loop.
local ai = require("mini.ai")
ai.setup({
	n_lines = 200,
	custom_textobjects = {
		f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
		c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
		o = ai.gen_spec.treesitter({
			a = { "@conditional.outer", "@loop.outer" },
			i = { "@conditional.inner", "@loop.inner" },
		}),
	},
})
