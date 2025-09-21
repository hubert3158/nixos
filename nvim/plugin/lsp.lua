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

require("lspconfig").tinymist.setup({
	on_attach = general_on_attach,
	capabilities = general_capabilities,
	settings = {
		exportPdf = "onSave", -- "never", "onType", "onSave"
		formatterMode = "typstyle", -- built-in formatter
	},
})

local home = os.getenv("HOME")
local jdtls = require("jdtls")
local fmt = string.format

-- Paths & JDK installations
local lombok = home .. "/nixos/dotfiles/lombok-1.18.38.jar"
-- local jakarta_annotation = home .. "/nixos/dotfiles/jakarta.annotation-api-1.3.5.jar"
local javax_annotation = home .. "/nixos/dotfiles/javax.annotation-api-1.3.2.jar"
local jdk11 = "/nix/store/lvrsn84nvwv9q4ji28ygchhvra7rsfwv-openjdk-11.0.19+7/lib/openjdk"
local jdk21 = "/nix/store/55qm2mvhmv7n2n6yzym1idrvnlwia73z-openjdk-21.0.5+11/lib/openjdk"

-- Define the bundles
local bundles = {
	javax_annotation,
}

-- Determine project root: prefer aggregator POM, fallback to Git
local root_dir = jdtls.setup.find_root({ "pom.xml", ".git" })
if not root_dir then
	return
end

-- Workspace directory for Eclipse data
local project_name = vim.fn.fnamemodify(root_dir, ":t")
local workspace_dir = home .. "/.local/share/eclipse/" .. project_name

-- Use JDK21 to run JDTLS with proper module setup
local cmd = {
	"jdtls",
	fmt("--jvm-arg=-Dosgi.java.home=%s", jdk21),
	"--jvm-arg=--add-opens=java.base/java.lang=ALL-UNNAMED",
	"--jvm-arg=--add-opens=java.base/java.util=ALL-UNNAMED",
	fmt("--jvm-arg=-javaagent:%s", lombok),
	"--jvm-arg=-Djdt.ls.lombokSupport=true",
	"-data",
	workspace_dir,
}

-- LSP configuration for Java
local config = {
	cmd = cmd,
	root_dir = root_dir,
	init_options = { bundles = bundles },
	settings = {
		java = {
			home = jdk21,
			import = {
				enabled = true,
				maven = {
					downloadSources = true,
					downloadJavadoc = true,
				},
			},
			autoBuild = {
				enabled = true,
			},
			configuration = {
				compiler = {
					apt = {
						enabled = true,
						options = { "-Xlint:-processing" },
					},
					annotationProcessing = {
						enabled = true,
						args = { "-proc:none" },
					},
				},
				updateBuildConfiguration = "interactive",
				runtimes = {
					{ name = "JavaSE-11", path = jdk11 },
					{ name = "JavaSE-21", path = jdk21 },
				},
				checkProjectCompliance = false,
			},
			project = { referencedLibraries = { lombok, javax_annotation } },
			annotationProcessing = {
				enabled = true,
				factoryPath = { lombok },
				generatedSourcesOutputDirectory = "target/generated-sources/annotations",
			},
		},
	},
	on_attach = general_on_attach,
	capabilities = general_capabilities,
}

-- Auto-start or attach JDTLS for Java files
vim.api.nvim_create_autocmd("FileType", {
	pattern = "java",
	callback = function()
		-- Ensure this only runs once per buffer
		local bufnr = vim.api.nvim_get_current_buf()
		if vim.b[bufnr].jdtls_attached then
			return
		end
		vim.b[bufnr].jdtls_attached = true

		-- Check if we're inside a valid project
		if not config.root_dir then
			vim.notify("No project root found for JDTLS", vim.log.levels.WARN)
			return
		end

		require("jdtls").start_or_attach(config)
	end,
})
