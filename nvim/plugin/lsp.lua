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

-- jdtls + Lombok setup for Neovim (multi-module Maven + Lombok + proper workspace import)
local home = os.getenv("HOME")
local jdtls = require("jdtls")
local fmt = string.format

-- Paths & JDK installations
local lombok = home .. "/nixos/dotfiles/lombok-1.18.38.jar"
local jdk11 = "/nix/store/lvrsn84nvwv9q4ji28ygchhvra7rsfwv-openjdk-11.0.19+7/lib/openjdk"
local jdk21 = "/nix/store/55qm2mvhmv7n2n6yzym1idrvnlwia73z-openjdk-21.0.5+11/lib/openjdk"

-- Diagnostics config
do
	vim.diagnostic.config({
		virtual_text = { prefix = "●", spacing = 2 },
		signs = true,
		underline = true,
		update_in_insert = false,
	})
end

-- Define root by looking for parent aggregator POM first, then Git
local root_dir = jdtls.setup.find_root({ "pom.xml", ".git" })
if not root_dir then
	return
end

-- Build list of workspace folders: include root and modules
local project_name = vim.fn.fnamemodify(root_dir, ":t")
local workspace_dir = home .. "/.local/share/eclipse/" .. project_name
local modules = vim.fn.glob(root_dir .. "/*/pom.xml", true, true)
local workspace_folders = { { name = project_name, uri = vim.uri_from_fname(root_dir) } }
for _, pom in ipairs(modules) do
	local module_dir = vim.fn.fnamemodify(pom, ":h")
	table.insert(
		workspace_folders,
		{ name = vim.fn.fnamemodify(module_dir, ":t"), uri = vim.uri_from_fname(module_dir) }
	)
end

-- JDTLS command
local cmd = {
	"jdtls",
	fmt("--jvm-arg=-Dosgi.java.home=%s", jdk21),
	fmt("--jvm-arg=--add-modules=ALL-SYSTEM"),
	fmt("--jvm-arg=-javaagent:%s", lombok),
	fmt("--jvm-arg=-Xbootclasspath/a:%s", lombok),
	"-data",
	workspace_dir,
}

-- LSP configuration
local config = {
	cmd = cmd,
	root_dir = root_dir,
	init_options = { bundles = {} },
	settings = {
		java = {
			home = jdk21,
			import = { -- enable maven import
				enabled = true,
				maven = { downloadSources = true, downloadJavadoc = true },
			},
			configuration = {
				updateBuildConfiguration = "interactive",
				runtimes = {
					{ name = "JavaSE-11", path = jdk11 },
					{ name = "JavaSE-21", path = jdk21 },
				},
				checkProjectCompliance = false,
			},
			project = { referencedLibraries = { lombok } },
			annotationProcessing = {
				enabled = true,
				factoryPath = { lombok },
				generatedSourcesOutputDirectory = "target/generated-sources/annotations",
			},
		},
	},
	on_attach = function(client, bufnr)
		-- Keymaps
		local function nmap(lhs, fn)
			vim.keymap.set("n", lhs, fn, { buffer = bufnr, silent = true, noremap = true })
		end
		nmap("gd", vim.lsp.buf.definition)
		nmap("gr", vim.lsp.buf.references)
		nmap("K", vim.lsp.buf.hover)
	end,
	capabilities = require("cmp_nvim_lsp").default_capabilities(),
}

-- Auto-start/attach for Java files
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
	pattern = "*.java",
	callback = function()
		jdtls.start_or_attach(config)
	end,
})
