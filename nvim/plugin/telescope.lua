local ignore = require("user.ignore-patterns")

require("telescope").setup({
	defaults = {
		path_display = { "truncate" },
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
