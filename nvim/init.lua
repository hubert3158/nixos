-- Entry point. Heavy lifting lives in lua/user/*:
--   options.lua      — vim options + plugin globals
--   diagnostics.lua  — vim.diagnostic config
--   keymaps.lua      — global keymaps
--   autocmds.lua     — global autocmds
--   commands.lua     — user commands
-- Plugin loading is deferred via lz.n (plugin/lazy-load.lua); plugins
-- managed there are marked `optional = true` in packages/neovim/plugins.nix
-- so they are NOT sourced at startup.

-- Leader keys must be set before any keymaps/plugins
vim.g.mapleader = " "
vim.g.maplocalleader = ","

require("user.options")
require("user.diagnostics")
require("user.keymaps")
require("user.autocmds")
require("user.commands")

-- Allows filtering the quickfix list with :Cfilter
vim.cmd.packadd("cfilter")

-- ============================================================================
-- Colorscheme — single source of truth (do not also configure in plugins.nix)
-- ============================================================================
require("catppuccin").setup({
	flavour = "mocha",
	integrations = {
		aerial = true,
		barbecue = {
			dim_dirname = true,
			bold_basename = true,
			dim_context = false,
			alt_background = false,
		},
		blink_cmp = true,
		dap = true,
		dap_ui = true,
		dashboard = true,
		fidget = true,
		gitsigns = true,
		harpoon = true,
		indent_blankline = { enabled = true },
		lsp_trouble = true,
		markdown = true,
		mini = { enabled = true },
		native_lsp = {
			enabled = true,
			underlines = {
				errors = { "undercurl" },
				hints = { "undercurl" },
				warnings = { "undercurl" },
				information = { "undercurl" },
			},
		},
		navic = { enabled = true },
		neotree = true,
		noice = true,
		notify = true,
		render_markdown = true,
		telescope = { enabled = true },
		treesitter = true,
		ufo = true,
		which_key = true,
	},
})
vim.cmd.colorscheme("catppuccin")

-- ============================================================================
-- Session restore — must be set up before VimEnter, so loaded eagerly
-- ============================================================================
require("user.auto-session")

-- ============================================================================
-- Performance modules
-- ============================================================================
require("user.bigfile").setup({
	size_threshold = 1024 * 1024, -- 1MB
	line_threshold = 10000,
	notify = true,
})

require("user.buffer-cleanup").setup({
	max_inactive_minutes = 30,
	max_buffers = 20,
	cleanup_interval = 10,
	notify = false, -- Set to true to see when buffers are cleaned
})
