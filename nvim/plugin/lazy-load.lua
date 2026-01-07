-- Lazy loading configuration using lz.n
-- This defers plugin initialization for faster startup

require("lz.n").load({
	-- ============================================================================
	-- HEAVY UI PLUGINS - Load after startup
	-- ============================================================================
	{
		"lualine.nvim",
		event = "VeryLazy",
		after = function()
			require("user.visual-enhancements").setup()
		end,
	},
	{
		"smear-cursor.nvim",
		event = "VeryLazy",
		after = function()
			require("user.smear-cursor")
		end,
	},
	{
		"twilight.nvim",
		cmd = "Twilight",
		after = function()
			require("user.twilight")
		end,
	},

	-- ============================================================================
	-- FILE/BUFFER PLUGINS - Load on file open
	-- ============================================================================
	{
		"nvim-ufo",
		event = { "BufReadPre", "BufNewFile" },
		after = function()
			require("user.nvimUfo")
		end,
	},
	{
		"todo-comments.nvim",
		event = { "BufReadPre", "BufNewFile" },
		after = function()
			require("user.todo-comments")
		end,
	},
	{
		"conform.nvim",
		event = "BufWritePre",
		after = function()
			require("user.conform")
		end,
	},
	{
		"nvim-lint",
		event = { "BufReadPre", "BufNewFile" },
		after = function()
			require("user.nvimLint")
		end,
	},

	-- ============================================================================
	-- TOOLS - Load on command/key
	-- ============================================================================
	{
		"harpoon",
		keys = {
			{ "<leader>ha", desc = "Harpoon add" },
			{ "<leader>hh", desc = "Harpoon menu" },
		},
		after = function()
			require("user.harpoon")
		end,
	},
	{
		"neoscroll.nvim",
		keys = { "<C-u>", "<C-d>", "<C-b>", "<C-f>" },
		after = function()
			require("user.neoscroll")
		end,
	},
	{
		"auto-session",
		event = "VimEnter",
		after = function()
			require("user.auto-session")
		end,
	},

	-- ============================================================================
	-- GIT - Load on command
	-- ============================================================================
	{
		"lazygit.nvim",
		cmd = "LazyGit",
		keys = { { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" } },
	},
	{
		"git-conflict.nvim",
		event = "VeryLazy",
		after = function()
			require("user.git-conflict")
		end,
	},

	-- ============================================================================
	-- HEAVY OPTIONAL - Load on demand
	-- ============================================================================
	{
		"codesnap.nvim",
		cmd = { "CodeSnap", "CodeSnapSave" },
		after = function()
			require("user.codeSnap")
		end,
	},
	{
		"codecompanion.nvim",
		cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions" },
		after = function()
			require("user.codeCompanion")
		end,
	},
	{
		"kulala.nvim",
		ft = "http",
		after = function()
			require("user.kulala")
		end,
	},
	{
		"nvim-spectre",
		cmd = "Spectre",
		after = function()
			require("user.spectre")
		end,
	},
	{
		"debugprint.nvim",
		keys = { { "<leader>dp", desc = "Debug print" } },
		after = function()
			require("user.debugprint")
		end,
	},
	{
		"venn.nvim",
		cmd = { "VBox", "VBoxD", "VBoxH", "VBoxO" },
		after = function()
			require("user.venn-easyalign")
		end,
	},
})
