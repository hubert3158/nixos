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

-- Current-scope indicator — the ACTIVE half of the indent hierarchy.
-- ibl (user/indent-blankline.lua) draws every level in flat sumiInk4 and has
-- its own scope feature disabled; this one glows crystalBlue and animates, so
-- exactly one line is ever "lit". Symbol matches the ▏ used by ibl and by
-- fillchars vert, so all three read as the same ink stroke.
local indentscope = require("mini.indentscope")
indentscope.setup({
	symbol = "▏",
	draw = {
		delay = 60,
		-- ease out: quick to appear, settles gently (~90ms total on shallow
		-- scopes) — matches the emphasizedDecel feel of the hyprland beziers
		animation = indentscope.gen_animation.quadratic({
			easing = "out",
			duration = 12,
			unit = "step",
		}),
	},
	options = { try_as_border = true },
})

-- Surfaces that paint their own chrome shouldn't get a scope line through it
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("MiniIndentscopeDisable", { clear = true }),
	pattern = {
		"dashboard",
		"snacks_dashboard",
		"help",
		"man",
		"neo-tree",
		"Trouble",
		"trouble",
		"toggleterm",
		"lazy",
		"mason",
	},
	callback = function()
		vim.b.miniindentscope_disable = true
	end,
})

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
