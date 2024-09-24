-- local parser_install_dir = vim.fn.expand('/home/hubert/temp')

require('nvim-treesitter.configs').setup {

	-- ensure_installed = { "c", "query", "lua", "java", "nix", "vimdoc", "luadoc", "vim", "markdown", "markdown_inline" },
	-- This is not needed / causes problems

	auto_install = false,

	highlight = {
		enable = true,
		-- disable = { "c", "rust","vimdoc" },
	},

	indent = { enable = true },

	-- Set the parser install directory to the expanded path
	-- parser_install_dir = parser_install_dir
}

-- Optional: Create the directory if it doesn't exist
-- vim.fn.mkdir(parser_install_dir, 'p')

