-- Check for required dependencies
local function check_dependency(module, name)
	local ok, mod = pcall(require, module)
	if not ok then
		vim.notify(string.format("%s is not available. Please install it.", name), vim.log.levels.ERROR)
		return nil
	end
	return mod
end

-- Get Neovim runtime and plugin paths for better Lua completion
local function get_lua_workspace_library()
	local library = {}

	-- Add Neovim runtime
	library[vim.fn.expand("$VIMRUNTIME/lua")] = true
	library[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true

	-- Add Neovim config directory
	local config_path = vim.fn.stdpath("config")
	if config_path then
		library[config_path .. "/lua"] = true
	end

	-- Add plugin directories from runtimepath
	local rtp_dirs = vim.api.nvim_list_runtime_paths()
	for _, path in ipairs(rtp_dirs) do
		local lua_path = path .. "/lua"
		if vim.fn.isdirectory(lua_path) == 1 then
			library[lua_path] = true
		end
	end

	return vim.tbl_keys(library)
end

local blink_cmp = check_dependency("blink.cmp", "Blink.cmp")
local telescope_builtin = check_dependency("telescope.builtin", "Telescope")

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

-- Debug: Verify blink.cmp capabilities are properly set
if vim.env.DEBUG_LSP then
	vim.print("Blink.cmp LSP capabilities:", general_capabilities)
end

-- Enhance capabilities with additional LSP features
general_capabilities.textDocument = general_capabilities.textDocument or {}
general_capabilities.textDocument.completion = general_capabilities.textDocument.completion or {}
general_capabilities.textDocument.completion.completionItem = general_capabilities.textDocument.completion.completionItem
	or {}
general_capabilities.textDocument.completion.completionItem.snippetSupport = true
general_capabilities.textDocument.completion.completionItem.resolveSupport = {
	properties = { "documentation", "detail", "additionalTextEdits" },
}
general_capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
general_capabilities.textDocument.completion.completionItem.deprecatedSupport = true
general_capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
general_capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
general_capabilities.textDocument.completion.completionItem.labelDetailsSupport = true

-- Debug utilities for LSP completion
local function debug_lsp_completion()
	local clients = vim.lsp.get_clients({ bufnr = 0 })
	if #clients == 0 then
		vim.notify("No LSP clients attached to current buffer", vim.log.levels.WARN)
		return
	end

	for _, client in ipairs(clients) do
		local capabilities = client.server_capabilities
		vim.print("=== LSP Client: " .. client.name .. " ===")
		vim.print("Completion provider:", capabilities.completionProvider)
		if capabilities.completionProvider then
			vim.print("Trigger characters:", capabilities.completionProvider.triggerCharacters)
			vim.print("Resolve provider:", capabilities.completionProvider.resolveProvider)
		end
		vim.print("Hover provider:", capabilities.hoverProvider)
		vim.print("Definition provider:", capabilities.definitionProvider)
	end

	-- Check blink.cmp setup
	vim.print("=== Blink.cmp Debug ===")
	local ok, blink = pcall(require, "blink.cmp")
	if ok then
		-- Test if we can get completion at cursor
		local ok2, completion = pcall(blink.show)
		vim.print("Blink completion test:", ok2)

		-- Check current buffer LSP clients
		local bufnr = vim.api.nvim_get_current_buf()
		local lsp_clients = vim.lsp.get_clients({ bufnr = bufnr })
		vim.print("LSP clients for current buffer:")
		for _, client in ipairs(lsp_clients) do
			vim.print("  - " .. client.name)
		end
	else
		vim.print("Blink.cmp not available")
	end
end

-- Test completion at current position
local function test_completion()
	local bufnr = vim.api.nvim_get_current_buf()
	local clients = vim.lsp.get_clients({ bufnr = bufnr })

	if #clients == 0 then
		vim.notify("No LSP clients attached", vim.log.levels.WARN)
		return
	end

	local cursor = vim.api.nvim_win_get_cursor(0)
	local line = cursor[1] - 1
	local col = cursor[2]

	local params = vim.lsp.util.make_position_params()

	for _, client in ipairs(clients) do
		if client.server_capabilities.completionProvider then
			vim.print("Testing completion with " .. client.name)
			client.request("textDocument/completion", params, function(err, result)
				if err then
					vim.print("Completion error: " .. vim.inspect(err))
				else
					if result and result.items then
						vim.print("Got " .. #result.items .. " completion items")
						for i, item in ipairs(result.items) do
							if i <= 5 then -- Show first 5 items
								vim.print("  " .. item.label .. " (" .. (item.kind or "unknown") .. ")")
							end
						end
					elseif result then
						vim.print("Got completion result but no items: " .. vim.inspect(result))
					else
						vim.print("No completion result")
					end
				end
			end, bufnr)
		end
	end
end

-- User commands for debugging
vim.api.nvim_create_user_command("LspDebugCompletion", debug_lsp_completion, {
	desc = "Debug LSP completion setup",
})

vim.api.nvim_create_user_command("LspTestCompletion", test_completion, {
	desc = "Test LSP completion at cursor position",
})

vim.api.nvim_create_user_command("LspRestartAll", function()
	vim.lsp.stop_client(vim.lsp.get_clients())
	vim.defer_fn(function()
		vim.cmd("edit")
		vim.notify("All LSP clients restarted", vim.log.levels.INFO)
	end, 1000)
end, {
	desc = "Restart all LSP clients",
})

local servers = {
	lua_ls = {
		on_attach = general_on_attach,
		capabilities = general_capabilities,
		root_dir = vim.fs.root(
			0,
			{ ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", ".git" }
		),
		cmd = { "lua-language-server" },
		settings = {
			Lua = {
				runtime = {
					version = "LuaJIT",
				},
				diagnostics = {
					globals = { "vim" },
				},
				workspace = {
					checkThirdParty = false,
					library = get_lua_workspace_library(),
					maxPreload = 100000,
					preloadFileSize = 10000,
				},
				completion = {
					callSnippet = "Replace",
				},
				telemetry = { enable = false },
				hint = {
					enable = true,
					setType = false,
					paramType = true,
					paramName = "Disable",
					semicolon = "Disable",
					arrayIndex = "Disable",
				},
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
	local jdk11 = os.getenv("JAVA_HOME11")
	local jdk21 = os.getenv("JAVA_HOME21")

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
