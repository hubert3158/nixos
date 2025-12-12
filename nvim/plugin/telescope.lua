require("telescope").setup({
	defaults = {
		path_display = { "truncate" },
		-- Performance optimizations
		vimgrep_arguments = {
			"rg",
			"--color=never",
			"--no-heading",
			"--with-filename",
			"--line-number",
			"--column",
			"--smart-case",
			"--hidden", -- Search hidden files
			"--glob=!.git/", -- Exclude .git
			"--glob=!node_modules/", -- Exclude node_modules
			"--glob=!target/", -- Exclude Java/Rust target
			"--glob=!build/", -- Exclude build directories
			"--glob=!dist/", -- Exclude dist
			"--glob=!.next/", -- Exclude Next.js
			"--glob=!coverage/", -- Exclude coverage
		},
		file_ignore_patterns = {
			"^.git/",
			"^node_modules/",
			"^target/",
			"^build/",
			"^dist/",
			"^.next/",
			"^coverage/",
			"^.cache/",
			"%.class$",
			"%.jar$",
			"%.war$",
			"%.ear$",
			"%.zip$",
			"%.tar.gz$",
			"%.o$",
			"%.a$",
			"%.so$",
			"%.dylib$",
			"%.dll$",
			"%.exe$",
			"%.out$",
			"%.png$",
			"%.jpg$",
			"%.jpeg$",
			"%.gif$",
			"%.svg$",
			"%.ico$",
			"%.pdf$",
		},
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
	},
})

require("telescope").load_extension("fzf")
