local on_attach = function(client, bufnr)
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

	-- Telescope Integration
	bufmap("gs", require("telescope.builtin").lsp_document_symbols)

	-- Formatting
	vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
		vim.lsp.buf.format()
	end, {})
end
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

require("lspconfig").lua_ls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	root_dir = function()
		return vim.loop.cwd()
	end,
	cmd = { "lua-language-server" },
	settings = {
		Lua = {
			workspace = { checkThirdParty = false },
			telemetry = { enable = false },
		},
	},
})

require("lspconfig").html.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})
require("lspconfig").bashls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

require("lspconfig").zls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

require("lspconfig").eslint.setup({
	on_attach = function(client, bufnr)
		-- Ensure keybindings and other LSP-specific features work
		if type(on_attach) == "function" then
			on_attach(client, bufnr)
		end

		-- Auto-fix ESLint issues before saving the file
		vim.api.nvim_create_autocmd("BufWritePre", {
			buffer = bufnr,
			callback = function()
				vim.lsp.buf.format({ async = false }) -- Use LSP's built-in formatting
			end,
		})
	end,
	capabilities = capabilities or vim.lsp.protocol.make_client_capabilities(),
	root_dir = require("lspconfig").util.find_package_json_ancestor,
	-- cmd = { "vscode-eslint-language-server", "--stdio" },
})

require("lspconfig").sourcekit.setup({ -- c++
	on_attach = on_attach,
	capabilities = capabilities,
})

require("lspconfig").clangd.setup({ -- c
	on_attach = on_attach,
	capabilities = capabilities,
})

require("lspconfig").ts_ls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	cmd = { "typescript-language-server", "--stdio" },
})

require("lspconfig").pyright.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

require("lspconfig").cssls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

-- local lombok_path = vim.fn.stdpath("data") .. "/lombok.jar"  -- Adjust the path if necessary
local lombok_path = "/home/hubert/nixos/dotfiles/lombok.jar"
require("lspconfig").jdtls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	cmd = { "/etc/profiles/per-user/hubert/bin/jdtls" }, -- Update the path to your jdtls executable

	root_dir = function(fname)
		return require("lspconfig.util").root_pattern("pom.xml", "build.gradle", ".git")(fname) or vim.loop.os_homedir()
	end,
	settings = {
		java = {
			signatureHelp = { enabled = true },
			contentProvider = { preferred = "fernflower" },
			completion = {
				favoriteStaticMembers = {
					"org.hamcrest.MatcherAssert.assertThat",
					"org.hamcrest.Matchers.*",
					"org.hamcrest.CoreMatchers.*",
					"org.junit.jupiter.api.Assertions.*",
					"java.util.Objects.requireNonNull",
					"java.util.Objects.requireNonNullElse",
				},
			},
			project = {
				referencedLibraries = {
					lombok_path,
				},
			},
		},
	},
	init_options = {
		bundles = {
			lombok_path,
			vim.fn.glob(
				"/nix/store/id0zrxghssr6mkzxaaphs9yy1sjn7f57-vscode-extension-vscjava-vscode-java-debug-0.55.2023121302/share/vscode/extensions/vscjava.vscode-java-debug/server/com.microsoft.java.debug.plugin-0.50.0.jar",
				true
			),
		},
	},
})

require("lspconfig").jsonls.setup({ -- this has been replaced by conform
	on_attach = on_attach,
	capabilities = capabilities,
})
require("lspconfig").nginx_language_server.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})
