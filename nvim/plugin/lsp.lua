-- Check for required dependencies
local function check_dependency(module, name)
	local ok, mod = pcall(require, module)
	if not ok then
		vim.notify(string.format("%s is not available. Please install it.", name), vim.log.levels.ERROR)
		return nil
	end
	return mod
end

local telescope_builtin = check_dependency("telescope.builtin", "Telescope")
local blink_cmp = check_dependency("blink.cmp", "Blink.cmp")

if not blink_cmp then
	return -- Exit early if blink.cmp is not available
end

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

	-- Telescope Integration (only if available)
	if telescope_builtin then
		bufmap("gs", telescope_builtin.lsp_document_symbols)
	end
end

local general_capabilities = blink_cmp.get_lsp_capabilities()

-- Configure all LSP servers
local servers = {
	lua_ls = {
		on_attach = general_on_attach,
		capabilities = general_capabilities,
		root_dir = vim.fs.root(0, { ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", ".git" }),
		cmd = { "lua-language-server" },
		settings = {
			Lua = {
				workspace = { checkThirdParty = false },
				telemetry = { enable = false },
			},
		},
	},
	html = {
		on_attach = general_on_attach,
		capabilities = general_capabilities,
	},
	bashls = {
		on_attach = general_on_attach,
		capabilities = general_capabilities,
	},
	zls = {
		on_attach = general_on_attach,
		capabilities = general_capabilities,
	},
	eslint = {
		on_attach = function(client, bufnr)
			general_on_attach(client, bufnr)

			print("ESLint specific on_attach: Setting up EslintFixAll for buffer: " .. bufnr)

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
	},
	sourcekit = {
		capabilities = general_capabilities,
	},
	clangd = {
		on_attach = general_on_attach,
		capabilities = general_capabilities,
	},
	pyright = {
		on_attach = general_on_attach,
		capabilities = general_capabilities,
	},
	cssls = {
		on_attach = general_on_attach,
		capabilities = general_capabilities,
	},
	jsonls = {
		on_attach = general_on_attach,
		capabilities = general_capabilities,
	},
	nginx_language_server = {
		on_attach = general_on_attach,
		capabilities = general_capabilities,
	},
	nil_ls = {
		on_attach = general_on_attach,
		capabilities = general_capabilities,
	},
	marksman = {
		on_attach = general_on_attach,
		capabilities = general_capabilities,
	},
	sqls = {
		on_attach = general_on_attach,
		capabilities = general_capabilities,
	},
	rust_analyzer = {
		on_attach = general_on_attach,
		capabilities = general_capabilities,
	},
	tinymist = {
		on_attach = general_on_attach,
		capabilities = general_capabilities,
		settings = {
			exportPdf = "onSave",
			formatterMode = "typstyle",
		},
	},
}

-- Apply configurations and enable servers
for server_name, config in pairs(servers) do
	vim.lsp.config[server_name] = config
	vim.lsp.enable(server_name)
end

-- Java JDTLS Setup (separate handling due to complexity)
local jdtls = check_dependency("jdtls", "nvim-jdtls")
if jdtls then
	local home = os.getenv("HOME")
	local fmt = string.format

	-- Paths & JDK installations
	local lombok = home .. "/nixos/dotfiles/lombok-1.18.38.jar"
	local javax_annotation = home .. "/nixos/dotfiles/javax.annotation-api-1.3.2.jar"
	local jdk11 = "/nix/store/lvrsn84nvwv9q4ji28ygchhvra7rsfwv-openjdk-11.0.19+7/lib/openjdk"
	local jdk21 = "/nix/store/55qm2mvhmv7n2n6yzym1idrvnlwia73z-openjdk-21.0.5+11/lib/openjdk"

	-- Validate paths exist
	local function file_exists(path)
		return vim.fn.filereadable(path) == 1 or vim.fn.isdirectory(path) == 1
	end

	if not file_exists(jdk21) then
		vim.notify("JDK21 path not found: " .. jdk21, vim.log.levels.WARN)
	end

	local bundles = {}
	if file_exists(javax_annotation) then
		table.insert(bundles, javax_annotation)
	end

	-- Auto-start JDTLS for Java files
	vim.api.nvim_create_autocmd("FileType", {
		pattern = "java",
		callback = function()
			local bufnr = vim.api.nvim_get_current_buf()
			if vim.b[bufnr].jdtls_attached then
				return
			end
			vim.b[bufnr].jdtls_attached = true

			local root_dir = jdtls.setup.find_root({ "pom.xml", ".git" })
			if not root_dir then
				vim.notify("No Java project root found", vim.log.levels.WARN)
				return
			end

			local project_name = vim.fn.fnamemodify(root_dir, ":t")
			local workspace_dir = home .. "/.local/share/eclipse/" .. project_name

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
						autoBuild = { enabled = true },
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

			jdtls.start_or_attach(config)
		end,
	})
end

vim.notify("LSP configuration loaded successfully", vim.log.levels.INFO)
