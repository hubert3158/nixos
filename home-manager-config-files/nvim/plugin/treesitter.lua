require('nvim-treesitter.configs').setup {
	ensure_installed = {
		"lua",
		"java",
		"nix",
		"vimdoc",
		"luadoc",
		"vim",
		"lua",
		"markdown"
	},

	auto_install = false,

	highlight = { enable = true },

	indent = { enable = true },

	-- Add the following line to set the parser install directory
	parser_install_dir = vim.fn.stdpath('data') .. '/parsers'
}

-- Optional: Create the directory if it doesn't exist
vim.fn.mkdir(vim.fn.stdpath('data') .. '/parsers', 'p')

