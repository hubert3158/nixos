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

-- Enable treesitter highlighting for http files using the STANDARD `http`
-- parser explicitly (not kulala's bundled `kulala_http`, which can't build on Windows).
vim.api.nvim_create_autocmd("FileType", {
	pattern = "http",
	callback = function(ev)
		pcall(vim.treesitter.start, ev.buf, "http")
	end,
})

-- Initialize Kulala
require("kulala").setup({
	default_view = "body",
})

-- kulala registers its own `kulala_http` grammar for the `http` filetype, which
-- triggers a parser build that fails on Windows. Re-map the filetype back to the
-- standard `http` parser so kulala_http is never requested/built.
pcall(vim.treesitter.language.register, "http", "http")
