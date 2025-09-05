local util = require("lspconfig.util")
local general_on_attach = function(client, bufnr)
	local bufmap = function(keys, func)
		vim.keymap.set("n", keys, func, { buffer = bufnr })
	end

	-- Core LSP Navigation & Information
	bufmap("gd", vim.lsp.buf.definition) -- Go to definition
	bufmap("gD", vim.lsp.buf.declaration) -- Go to declaration
	bufmap("gi", vim.lsp.buf.implementation) -- Go to implementation
	bufmap("K", vim.lsp.buf.hover) -- Show hover information

	-- Diagnostics
	bufmap("[d", function()
		vim.diagnostic.jump({ count = -1, float = true })
	end) -- Go to the previous diagnostic
	bufmap("]d", function()
		vim.diagnostic.jump({ count = 1, float = true })
	end) -- Go to the next diagnostic
	bufmap("[e", function()
		vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR, float = true })
	end) -- Go to the previous error diagnostic
	bufmap("]e", function()
		vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR, float = true })
	end) -- Go to the next error diagnostic
	-- Show diagnostic float at cursor
	bufmap("<leader>ee", function()
		vim.diagnostic.open_float(nil, { focus = false, scope = "cursor" })
	end)

	-- Telescope Integration
	bufmap("gs", require("telescope.builtin").lsp_document_symbols)
end
local general_capabilities = require("blink.cmp").get_lsp_capabilities(
	--     {
	-- 	textDocument = { completion = { completionItem = { snippetSupport = false } } },
	-- }
)

require("lspconfig").lua_ls.setup({
	on_attach = general_on_attach,
	capabilities = general_capabilities,
	root_dir = util.root_pattern(".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", ".git"),
	cmd = { "lua-language-server" },
	settings = {
		Lua = {
			workspace = { checkThirdParty = false },
			telemetry = { enable = false },
		},
	},
})

require("lspconfig").html.setup({
	on_attach = general_on_attach,
	capabilities = general_capabilities,
})
require("lspconfig").bashls.setup({
	on_attach = general_on_attach,
	capabilities = general_capabilities,
})

require("lspconfig").zls.setup({
	on_attach = general_on_attach,
	capabilities = general_capabilities,
})

require("lspconfig").eslint.setup({
	-- This 'on_attach' is specific to ESLint
	on_attach = function(client, bufnr)
		general_on_attach(client, bufnr)

		-- 2. Add ESLint-specific behavior
		print("ESLint specific on_attach: Setting up EslintFixAll for buffer: " .. bufnr) -- For debugging

		-- It's good practice to put autocommands in a group so they can be cleared.
		-- Create a unique group name per buffer to avoid issues if the buffer is reloaded.
		local augroup_name = "LspEslintFixOnSave_" .. bufnr
		vim.api.nvim_create_augroup(augroup_name, { clear = true })

		vim.api.nvim_create_autocmd("BufWritePre", {
			group = augroup_name,
			buffer = bufnr,
			command = "EslintFixAll",
			desc = "Run EslintFixAll on save for this buffer (ESLint LSP)",
		})
	end,
	capabilities = general_capabilities,
	-- Any other ESLint specific settings can go here
	-- settings = { ... }
})

require("lspconfig").sourcekit.setup({ -- c++lsp
	capabilities = general_capabilities,
})

require("lspconfig").clangd.setup({ -- c
	on_attach = general_on_attach,
	capabilities = general_capabilities,
})

require("lspconfig").pyright.setup({
	on_attach = general_on_attach,
	capabilities = general_capabilities,
})

require("lspconfig").cssls.setup({
	on_attach = general_on_attach,
	capabilities = general_capabilities,
})

require("lspconfig").jsonls.setup({ -- this has been replaced by conform
	on_attach = general_on_attach,
	capabilities = general_capabilities,
})
require("lspconfig").nginx_language_server.setup({
	on_attach = general_on_attach,
	capabilities = general_capabilities,
})

require("lspconfig").nil_ls.setup({
	on_attach = general_on_attach,
	capabilities = general_capabilities,
})

require("lspconfig").marksman.setup({
	on_attach = general_on_attach,
	capabilities = general_capabilities,
})
require("lspconfig").sqls.setup({
	on_attach = general_on_attach,
	capabilities = general_capabilities,
})


require("lspconfig").rust_analyzer.setup({
        on_attach = general_on_attach,
        capabilities = general_capabilities,
})

-- Java support via nvim-java with Lombok
require("java").setup({
        lombok = {
                version = "nightly",
        },
})
require("lspconfig").jdtls.setup({
        on_attach = general_on_attach,
        capabilities = general_capabilities,
})
