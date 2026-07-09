-- Entry point. Heavy lifting lives in lua/user/*:
--   options.lua      — vim options + plugin globals
--   diagnostics.lua  — vim.diagnostic config
--   keymaps.lua      — global keymaps
--   autocmds.lua     — global autocmds
--   commands.lua     — user commands
-- Plugin loading is deferred via lz.n (plugin/lazy-load.lua); plugins
-- managed there are marked `optional = true` in packages/neovim/plugins.nix
-- so they are NOT sourced at startup.

-- NOTE: vim.loader.enable() is injected by mkNeovim.nix before this file.

-- Leader keys must be set before any keymaps/plugins
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Deprecated-API compat shims — must load before ANY plugin code
require("user.compat")

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
-- kanagawa "wave" matches helix's built-in kanagawa theme.
-- Custom overrides build a "sumi-e ink" look: floats/pickers/menus render as
-- solid borderless ink blocks on layered background shades, with sparing
-- glow accents (carpYellow matches, crystalBlue titles).
require("kanagawa").setup({
	theme = "wave",
	background = { dark = "wave", light = "lotus" },
	dimInactive = true, -- unfocused windows fade into the paper
	commentStyle = { italic = true },
	keywordStyle = { italic = true },
	statementStyle = { bold = true },
	colors = {
		theme = { all = { ui = { bg_gutter = "none" } } }, -- clean gutter
	},
	overrides = function(colors)
		local theme = colors.theme
		local p = colors.palette
		return {
			-- ══ Floats: solid ink blocks, border melts into the panel ══
			NormalFloat = { bg = theme.ui.bg_m3 },
			FloatBorder = { bg = theme.ui.bg_m3, fg = theme.ui.bg_m3 },
			FloatTitle = { bg = p.crystalBlue, fg = theme.ui.bg_m3, bold = true },

			-- ══ Telescope: three-tone block composition ══
			TelescopeTitle = { fg = theme.ui.special, bold = true },
			TelescopePromptNormal = { bg = theme.ui.bg_p1 },
			TelescopePromptBorder = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1 },
			TelescopeResultsNormal = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1 },
			TelescopeResultsBorder = { fg = theme.ui.bg_m1, bg = theme.ui.bg_m1 },
			TelescopePreviewNormal = { bg = theme.ui.bg_dim },
			TelescopePreviewBorder = { bg = theme.ui.bg_dim, fg = theme.ui.bg_dim },
			TelescopeSelection = { bg = p.waveBlue1, bold = true },
			TelescopeMatching = { fg = p.carpYellow, bold = true },

			-- ══ Completion menu (blink) ══
			Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 },
			PmenuSel = { fg = "NONE", bg = p.waveBlue1 },
			PmenuSbar = { bg = theme.ui.bg_m1 },
			PmenuThumb = { bg = p.crystalBlue },
			BlinkCmpMenu = { bg = theme.ui.bg_p1 },
			BlinkCmpMenuBorder = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1 },
			BlinkCmpMenuSelection = { bg = p.waveBlue1, bold = true },
			BlinkCmpLabelMatch = { fg = p.carpYellow, bold = true },
			BlinkCmpGhostText = { fg = theme.ui.nontext, italic = true },

			-- ══ Chrome: thin ink separators, glowing cursor line number ══
			WinSeparator = { fg = p.sumiInk4 },
			CursorLineNr = { fg = p.carpYellow, bold = true },
			WhichKeyFloat = { bg = theme.ui.bg_m3 },

			-- ══ Noice command palette ══
			NoiceCmdlinePopup = { bg = theme.ui.bg_m3 },
			NoiceCmdlinePopupBorder = { fg = p.crystalBlue },
			NoiceCmdlineIcon = { fg = p.surimiOrange },

			-- ══ Dashboard (snacks) ══
			SnacksDashboardHeader = { fg = p.crystalBlue },
			SnacksDashboardFooter = { fg = p.fujiGray, italic = true },
			SnacksDashboardIcon = { fg = p.springBlue },
			SnacksDashboardKey = { fg = p.carpYellow, bold = true },
			SnacksDashboardDesc = { fg = theme.ui.fg },
			SnacksDashboardTitle = { fg = theme.ui.special, bold = true },
			SnacksDashboardDir = { fg = p.fujiGray },

			-- ══ Rainbow delimiters: muted kanagawa inks, no neon ══
			RainbowDelimiterRed = { fg = p.waveRed },
			RainbowDelimiterYellow = { fg = p.carpYellow },
			RainbowDelimiterBlue = { fg = p.crystalBlue },
			RainbowDelimiterOrange = { fg = p.surimiOrange },
			RainbowDelimiterGreen = { fg = p.springGreen },
			RainbowDelimiterViolet = { fg = p.oniViolet },
			RainbowDelimiterCyan = { fg = p.waveAqua2 },
		}
	end,
})
vim.cmd.colorscheme("kanagawa")

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
