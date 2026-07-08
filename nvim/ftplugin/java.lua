-- Java-specific performance optimizations and settings
-- Applied when opening .java files

local opt_local = vim.opt_local

-- Performance settings for large Java files
-- NOTE: no foldmethod/foldexpr override here — nvim-ufo owns folding
-- (options.lua foldlevel=99 + user/nvimUfo.lua treesitter/indent provider).
-- The previous "nvim_treesitter#foldexpr()" was the removed master-branch
-- Vimscript API and broke both folds and ufo on java buffers.
opt_local.synmaxcol = 300 -- Increase slightly for Java (longer lines common)

-- Indentation for Java
opt_local.shiftwidth = 4
opt_local.tabstop = 4
opt_local.expandtab = true

-- Better wrap settings for long method signatures
opt_local.breakindent = true
opt_local.breakindentopt = "shift:2,min:40"

-- Don't show end-of-line whitespace in Java (Spring Boot generates lots)
opt_local.listchars:append({ trail = " " })

-- Increase updatetime for Java files (LSP is expensive)
opt_local.updatetime = 500 -- Slower than global (300) for less LSP overhead

-- Disable some expensive features for very large Java files
local buf_size = vim.fn.getfsize(vim.fn.expand("%"))
if buf_size > 200000 then -- > 200KB
	opt_local.foldmethod = "manual" -- Disable auto-folding
	vim.notify("Large Java file detected - some features disabled for performance", vim.log.levels.WARN)
end

-- Java-specific keybindings — localleader (,), buffer-local, per the
-- filetype-maps rule in user/keymaps.lua. Java-only commands have no
-- business in the global <leader> namespace.
local map = vim.keymap.set
local opts = { buffer = true, silent = true }

-- Build / project (jdtls)
map("n", "<localleader>o", "<cmd>JavaOrganizeImports<CR>", vim.tbl_extend("force", opts, { desc = "Organize imports" }))
map("n", "<localleader>b", "<cmd>JavaBuildProject<CR>", vim.tbl_extend("force", opts, { desc = "Build project" }))
map("n", "<localleader>c", "<cmd>JavaCleanBuild<CR>", vim.tbl_extend("force", opts, { desc = "Clean and build" }))
map("n", "<localleader>u", "<cmd>JavaUpdateProject<CR>", vim.tbl_extend("force", opts, { desc = "Update project" }))
map(
	"n",
	"<localleader>w",
	"<cmd>JavaCleanWorkspace<CR>",
	vim.tbl_extend("force", opts, { desc = "Clean jdtls workspace" })
)

-- Quick navigation for Spring Boot
map("n", "<localleader>m", function()
	require("telescope.builtin").lsp_document_symbols({ symbols = { "method", "function" } })
end, vim.tbl_extend("force", opts, { desc = "Find methods" }))

map("n", "<localleader>C", function()
	require("telescope.builtin").lsp_document_symbols({ symbols = { "class" } })
end, vim.tbl_extend("force", opts, { desc = "Find classes" }))

-- Spring Boot specific: find REST endpoints
map("n", "<localleader>e", function()
	require("telescope.builtin").live_grep({ default_text = "@.*Mapping" })
end, vim.tbl_extend("force", opts, { desc = "Find endpoints (Spring)" }))

-- Find Spring components
map("n", "<localleader>s", function()
	require("telescope.builtin").live_grep({
		default_text = "@(Service|Repository|Controller|Component|RestController)",
	})
end, vim.tbl_extend("force", opts, { desc = "Find Spring components" }))

-- Disable some expensive LSP features for better responsiveness
vim.api.nvim_create_autocmd("LspAttach", {
	buffer = 0,
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client and client.name == "jdtls" then
			-- Reduce semantic token refresh for performance
			client.server_capabilities.semanticTokensProvider = nil

			-- Optionally disable inlay hints for large files (they can be expensive)
			if buf_size > 100000 then
				vim.lsp.inlay_hint.enable(false, { bufnr = 0 })
			end
		end
	end,
})

-- Auto-organize imports on save (optional - comment out if too slow)
-- vim.api.nvim_create_autocmd("BufWritePre", {
-- 	buffer = 0,
-- 	callback = function()
-- 		vim.lsp.buf.code_action({
-- 			context = { only = { "source.organizeImports" } },
-- 			apply = true,
-- 		})
-- 	end,
-- })
