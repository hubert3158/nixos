-- Telescope setup. Loaded via lz.n on DeferredUIEnter (telescope and its
-- extensions are opt plugins — packadd the extensions before setup).

for _, ext in ipairs({
	"telescope-fzf-native.nvim",
	"telescope-frecency.nvim",
	"telescope-zoxide",
	"telescope-symbols.nvim",
}) do
	vim.cmd.packadd(ext)
end

local ignore = require("user.ignore-patterns")

-- Fix "Invalid window id" race condition in telescope buffer_previewer.lua
-- The previewer sets vim.wo[window_id] without checking if the window is still valid,
-- which errors when scrolling results quickly. Wrap the class preview method with pcall.
do
	local Previewer = require("telescope.previewers.previewer")
	local original_preview = Previewer.preview
	function Previewer:preview(entry, status)
		local ok, err = pcall(original_preview, self, entry, status)
		if not ok and not tostring(err):find("Invalid window id") then
			error(err)
		end
	end
end

require("telescope").setup({
	defaults = {
		-- sumi-e block look: colors come from kanagawa overrides (init.lua).
		-- selection_caret must NOT be a byte-prefix of entry_prefix and must keep
		-- the same display width (2 cells): update_prefix() finds the old prefix by
		-- byte comparison, and an all-space caret matches every line — each deselect
		-- then leaks one extra leading space (rows drift right while moving j/k).
		prompt_prefix = "   ",
		selection_caret = "❯ ",
		entry_prefix = "  ",
		multi_icon = "+",
		results_title = false,
		-- Replicates the builtin "truncate" style with a fast-event guard.
		-- Upstream bug: path_truncate calls nvim_get_current_buf while finder
		-- results arrive in a fast event context (E5560, "Finder failed").
		-- telescope guards path_abs with vim.in_fast_event() but not truncate.
		-- A custom path_display also replaces frecency's default, which is what
		-- relativized its absolute paths — so relativize here before truncating
		-- (left-truncated: the tail/filename always stays visible).
		path_display = function(opts, path)
			local rel = opts.cwd and vim.fs.relpath(opts.cwd, path)
			if rel then
				path = rel
			else
				local home = os.getenv("HOME")
				if home and vim.startswith(path, home .. "/") then
					path = "~" .. path:sub(#home + 1)
				end
			end
			if opts.__length == nil then
				if vim.in_fast_event() then
					return path -- can't measure the window here; truncate on the next safe call
				end
				local status = require("telescope.state").get_status(vim.api.nvim_get_current_buf())
				opts.__length = vim.api.nvim_win_get_width(status.layout.results.winid)
					- #status.picker.selection_caret
					- 2
			end
			return require("plenary.strings").truncate(path, opts.__length - (opts.__prefix or 0), nil, -1)
		end,
		-- ripgrep respects .gitignore by default
		vimgrep_arguments = ignore.get_rg_args(),
		-- Dynamic patterns from .gitignore + base binary patterns
		file_ignore_patterns = ignore.get_file_ignore_patterns(),
		-- Sorting and performance
		sorting_strategy = "ascending",
		layout_config = {
			prompt_position = "top",
		},
		-- Faster file operations
		cache_picker = {
			num_pickers = 10, -- Cache last 10 pickers
		},
		-- Reduce lag when opening large results
		scroll_strategy = "limit",
		-- Use less memory
		preview = {
			filesize_limit = 1, -- MB - don't preview huge files
			timeout = 200, -- ms - timeout preview if slow
		},
	},
	pickers = {
		find_files = {
			hidden = true,
			find_command = { "rg", "--files", "--hidden", "--glob", "!.git/" },
		},
		live_grep = {
			additional_args = function()
				return { "--hidden" }
			end,
		},
	},
	extensions = {
		fzf = {
			override_generic_sorter = true,
			override_file_sorter = true,
			case_mode = "smart_case",
			fuzzy = true,
		},
		frecency = {
			-- Database is stored in data directory
			db_safe_mode = false, -- Faster writes
			show_filter_column = false, -- drop "workspace/" tag column — path gets full width
			show_scores = false, -- Hide frecency scores in results
			show_unindexed = true, -- Show files not yet in database
			ignore_patterns = { "*.git/*", "*/tmp/*", "*/node_modules/*" },
			workspaces = {
				["nixos"] = "/home/hubert/nixos",
			},
		},
	},
})

require("telescope").load_extension("fzf")
require("telescope").load_extension("frecency")
require("telescope").load_extension("zoxide")

-- Keymaps for frecency (smart file finding based on frequency + recency)
vim.keymap.set("n", "<leader>ff", function()
	require("telescope").extensions.frecency.frecency({
		workspace = "CWD", -- Use current working directory
	})
end, { desc = "Find files (frecency)" })

-- Keep original find_files on different binding if needed
vim.keymap.set("n", "<leader>fF", function()
	require("telescope.builtin").find_files()
end, { desc = "Find files (all)" })
