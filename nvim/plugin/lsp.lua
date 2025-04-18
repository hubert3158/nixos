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
	-- Show diagnostic float at cursor
	bufmap("<leader>e", function()
		vim.diagnostic.open_float(nil, { focus = false, scope = "cursor" })
	end)

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
	root_dir = vim.fs.dirname(vim.fs.find("package.json", { path = startpath, upward = true })[1]),
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

require("lspconfig").jsonls.setup({ -- this has been replaced by conform
	on_attach = on_attach,
	capabilities = capabilities,
})
require("lspconfig").nginx_language_server.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})
require("lspconfig").sqlls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

local home = os.getenv("HOME")

-- Paths
-- local lombok = home .. "/.m2/repository/org/projectlombok/lombok/1.18.30/lombok-1.18.30.jar"
local lombok = home .. "/nixos/dotfiles/lombok-1.18.26.jar"
local java_11 = "/nix/store/lvrsn84nvwv9q4ji28ygchhvra7rsfwv-openjdk-11.0.19+7"
local workspace_dir = vim.fn.expand("~/.local/share/eclipse/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t"))

require("lspconfig").jdtls.setup({
	cmd = {
		"jdtls",
		"--jvm-arg=-javaagent:" .. lombok,
		"--jvm-arg=-Xbootclasspath/a:" .. lombok,
		"-data",
		workspace_dir,
	},

	root_dir = function(startpath)
		return vim.fs.dirname(vim.fs.find(".git", { path = startpath, upward = true })[1])
	end,

	settings = {
		java = {
			signatureHelp = { enabled = true },
			contentProvider = { preferred = "fernflower" },
			errors = {
				incompleteClasspath = {
					severity = "ignore",
				},
			},
			configuration = {
				updateBuildConfiguration = "automatic",
				runtimes = {
					{
						name = "JavaSE-11",
						path = java_11,
					},
				},
				annotationProcessing = {
					enabled = true,
					factoryPath = { lombok },
					generatedSourcesOutputDirectory = "target/generated-sources/annotations",
				},

				-- ✨ Fix module build dependency messages
				project = {
					referencedLibraries = {
						"common/target/classes",
						"*/target/classes",
					},
				},
				maven = {
					downloadSources = true,
				},
			},
		},
	},

	init_options = {
		bundles = {},
	},

	on_attach = on_attach,
	capabilities = capabilities,
})
