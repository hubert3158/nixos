-- Filetype detection for .http files
vim.filetype.add({
	extension = {
		http = "http",
	},
	pattern = {
		-- dadbod-ui saved queries are often extensionless (e.g. db_ui/nexus/temp);
		-- without a filetype, commentstring stays empty and gcc breaks.
		-- Negative priority = fallback only, so connections.json etc. keep their ft.
		[".*/db_ui/.*"] = { "sql", { priority = -math.huge } },
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

-- ============================================================================
-- Treesitter highlighting — enabled per buffer for every filetype with an
-- installed grammar (grammars come from nvim-treesitter.withPlugins in
-- packages/neovim/plugins.nix). nvim-treesitter master does NOT auto-enable
-- highlighting without configs.setup(), which this config never called —
-- without this autocmd every buffer silently fell back to regex :syntax.
-- pcall: filetypes without a parser keep regex syntax; bigfile.lua still
-- calls vim.treesitter.stop() afterwards for oversized files.
-- ============================================================================
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("TreesitterHighlight", { clear = true }),
	callback = function(args)
		pcall(vim.treesitter.start, args.buf)
	end,
})

-- Kulala itself is loaded lazily on ft=http (see plugin/lazy-load.lua and
-- lua/user/kulala.lua) — only the parser registration above must be eager.
-- (The generic FileType autocmd above covers http buffers too, via the
-- kulala_http parser registered for the "http" filetype.)
