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
-- kanagawa "wave" matches helix's built-in kanagawa theme
-- (kanagawa.nvim ships highlight groups for treesitter/telescope/dap/etc.
-- out of the box — no integrations table needed).
require("kanagawa").setup({
	theme = "wave",
	background = { dark = "wave", light = "lotus" },
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
