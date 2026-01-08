-- Filetype detection for .http files
vim.filetype.add({
	extension = {
		http = "http",
	},
})

-- Register kulala_http treesitter parser from Nix-built grammar
local kulala_parser_path = vim.env.KULALA_HTTP_PARSER
if kulala_parser_path then
	-- Add parser
	vim.treesitter.language.add("kulala_http", {
		path = kulala_parser_path .. "/parser",
	})
	-- Map filetype "http" to language "kulala_http"
	vim.treesitter.language.register("kulala_http", "http")
	-- Add queries to runtimepath
	vim.opt.runtimepath:append(kulala_parser_path)
end

-- Enable treesitter highlighting for http files
vim.api.nvim_create_autocmd("FileType", {
	pattern = "http",
	callback = function()
		vim.treesitter.start()
	end,
})

-- Initialize Kulala
require("kulala").setup({
	default_view = "body",
})
