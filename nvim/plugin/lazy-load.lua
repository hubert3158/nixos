-- Lazy loading via lz.n. Every plugin listed here is marked
-- `optional = true` in packages/neovim/plugins.nix, so it lands in
-- pack/*/opt and is NOT sourced at startup — lz.n packadds it on trigger.
-- Names must match the plugin's nixpkgs pname (= pack directory name).

require("lz.n").load({
	-- ============================================================================
	-- UI — load right after the first frame is drawn
	-- ============================================================================
	{
		"lualine.nvim",
		event = "DeferredUIEnter",
		after = function()
			-- bufferline is opt (packadd before visual-enhancements requires it)
			vim.cmd.packadd("bufferline.nvim")
			require("user.visual-enhancements").setup()
		end,
	},
	{
		"barbecue.nvim",
		event = "DeferredUIEnter",
		after = function()
			require("barbecue").setup()
		end,
	},
	{
		"smear-cursor.nvim",
		event = "DeferredUIEnter",
		after = function()
			require("user.smear-cursor")
		end,
	},
	{
		"noice.nvim",
		event = "DeferredUIEnter",
		after = function()
			require("user.noice")
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
	-- Core tools — deferred off the startup path, loaded before first keypress
	-- ============================================================================
	{
		"telescope.nvim",
		event = "DeferredUIEnter",
		after = function()
			require("user.telescope")
		end,
	},
	{
		"mini.nvim",
		event = "DeferredUIEnter",
		after = function()
			require("user.mini")
		end,
	},
	{
		"nvim-dap",
		event = "DeferredUIEnter",
		after = function()
			require("user.dap")
		end,
	},
	{
		"debugprint.nvim",
		event = "DeferredUIEnter",
		after = function()
			require("user.debugprint")
		end,
	},
	{
		"git-conflict.nvim",
		event = "DeferredUIEnter",
		after = function()
			require("user.git-conflict")
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
		-- BufWritePre included so `:enew`-created buffers still get
		-- format_on_save registered on their first write.
		"conform.nvim",
		event = { "BufReadPre", "BufNewFile", "BufWritePre" },
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
	{
		"gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		after = function()
			require("user.gitsigns")
		end,
	},
	{
		"indent-blankline.nvim",
		event = { "BufReadPre", "BufNewFile" },
		after = function()
			require("user.indent-blankline")
		end,
	},
	{
		"nvim-colorizer.lua",
		event = { "BufReadPre", "BufNewFile" },
		after = function()
			require("user.colorizer")
		end,
	},
	{
		"smartcolumn.nvim",
		event = { "BufReadPre", "BufNewFile" },
		after = function()
			require("user.smartcolumn")
		end,
	},

	-- ============================================================================
	-- TOOLS - Load on command/key
	-- ============================================================================
	{
		"harpoon2",
		keys = {
			{ "<leader>pa", desc = "Harpoon add file" },
			{ "<leader>pl", desc = "Harpoon quick menu" },
			{ "<leader>p1", desc = "Harpoon file 1" },
			{ "<leader>p2", desc = "Harpoon file 2" },
			{ "<leader>p3", desc = "Harpoon file 3" },
			{ "<leader>p4", desc = "Harpoon file 4" },
			{ "<leader>pp", desc = "Harpoon prev" },
			{ "<leader>pn", desc = "Harpoon next" },
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

	-- ============================================================================
	-- GIT - Load on command
	-- ============================================================================
	{
		"lazygit.nvim",
		cmd = "LazyGit",
		keys = { { "<leader>gg", function() require("lazygit").lazygit() end, desc = "LazyGit" } },
	},
	{
		"vim-fugitive",
		cmd = { "Git", "G" },
	},

	-- ============================================================================
	-- FILES / UI TOOLS - Load on command or key
	-- ============================================================================
	{
		-- Also triggered by the dir-open autocmd in user/autocmds.lua via
		-- lz.n trigger_load (netrw hijack needs neo-tree loaded).
		"neo-tree.nvim",
		cmd = "Neotree",
		after = function()
			-- window-picker is opt; neo-tree's open-with-picker actions need it
			vim.cmd.packadd("nvim-window-picker")
			require("window-picker").setup()
			require("user.neo-tree")
		end,
	},
	{
		"yazi.nvim",
		keys = {
			{ "<leader>y", function() require("yazi").yazi() end, desc = "Open [Y]azi" },
		},
		after = function()
			require("yazi").setup()
		end,
	},
	{
		"toggleterm.nvim",
		cmd = { "ToggleTerm", "TermExec" },
		keys = { [[<c-\>]] },
		after = function()
			require("user.toggleterm")
		end,
	},
	{
		"trouble.nvim",
		cmd = "Trouble",
		after = function()
			require("trouble").setup()
		end,
	},
	{
		"aerial.nvim",
		cmd = { "AerialToggle", "AerialPrev", "AerialNext" },
		after = function()
			require("aerial").setup()
		end,
	},
	{
		"undotree",
		cmd = "UndotreeToggle",
	},
	{
		"neogen",
		keys = {
			{ "<leader>nc", function() require("neogen").generate() end, desc = " [C]omment Documentation Generation" },
		},
		after = function()
			require("neogen").setup()
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
		keys = {
			{ "<leader>cc", desc = "Open chat" },
			{ "<leader>ca", desc = "Actions" },
			{ "<leader>ct", desc = "Toggle chat" },
			{ "<leader>ci", desc = "Inline assistant" },
			{ "<leader>cb", desc = "Add buffer to chat" },
			{ "<leader>cv", desc = "Add selection to chat", mode = "v" },
			{ "<leader>cs", desc = "Stop request" },
			{ "<leader>ce", desc = "Explain code", mode = "v" },
			{ "<leader>cr", desc = "Review code", mode = "v" },
			{ "<leader>cx", desc = "Fix code", mode = "v" },
		},
		after = function()
			require("user.codeCompanion")
		end,
	},
	{
		"render-markdown.nvim",
		ft = { "markdown", "mdx" },
		after = function()
			require("user.render-markdown")
		end,
	},
	{
		-- Node-backed preview server; g:mkdp_* globals are set eagerly in
		-- user/options.lua so they're ready whenever this loads.
		"markdown-preview.nvim",
		ft = { "markdown", "mdx" },
	},
	{
		"typst-preview.nvim",
		ft = "typst",
	},
	{
		"lazydev.nvim",
		ft = "lua",
		after = function()
			require("lazydev").setup({})
		end,
	},
	{
		"fidget.nvim",
		event = "LspAttach",
		after = function()
			require("fidget").setup()
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
		-- `after` (post-packadd): rustaceanvim must be on rtp so user.rustaceanvim
		-- can require("rustaceanvim.config") for the codelldb DAP adapter. lz.n
		-- re-fires the FileType event after this hook, so vim.g.rustaceanvim is
		-- still set before rust-analyzer starts.
		"rustaceanvim",
		ft = "rust",
		after = function()
			require("user.rustaceanvim")
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
		"venn.nvim",
		cmd = { "VBox", "VBoxD", "VBoxH", "VBoxO" },
		after = function()
			require("user.venn-easyalign")
		end,
	},
})
