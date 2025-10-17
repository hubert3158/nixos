--[[
Neovim LSP bootstrap — diagnostics fixed (logic preserved)
- Suppress legitimate monkey-patch warning
- Type-hint custom fields
- Nil-guards where LuaLS requests them
- Correct param types for stop_client / requests
]]

------------------------------------------------------------
-- 0) Guard: prevent unwanted auto-start of JDTLS
------------------------------------------------------------
local original_start_client = vim.lsp.start_client

---@class JdtlsClientConfig: lsp.ClientConfig
---@field custom_jdtls? boolean

---Block non-custom jdtls startups while preserving original API
---@param config JdtlsClientConfig
---@diagnostic disable-next-line: duplicate-set-field
vim.lsp.start_client = function(config)
	if config and (config.name == "jdtls" or (config.cmd and config.cmd[1] and config.cmd[1]:match("jdtls"))) then
		if not config.custom_jdtls then
			return nil
		end
	end
	return original_start_client(config)
end

-- Ensure auto-started jdtls clients from other plugins are stopped for Java buffers
vim.api.nvim_create_autocmd("FileType", {
	pattern = "java",
	callback = function()
		local clients = vim.lsp.get_clients({ name = "jdtls" })
		for _, client in ipairs(clients) do
			-- guard client.config and the custom flag (LuaLS nil-checks)
			if not (client and client.config and client.config.custom_jdtls) then
				vim.lsp.stop_client(client.id)
			end
		end
	end,
})

------------------------------------------------------------
-- 1) Helpers and capability wiring
------------------------------------------------------------
-- Safe require with user-facing error
local function check_dependency(module, name)
	local ok, mod = pcall(require, module)
	if not ok then
		vim.notify(string.format("%s is not available. Please install it.", name), vim.log.levels.ERROR)
		return nil
	end
	return mod
end

-- Build a Lua workspace library for better Lua completion
local function get_lua_workspace_library()
	local library = {}
	library[vim.fn.expand("$VIMRUNTIME/lua")] = true
	library[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true

	local config_path = vim.fn.stdpath("config")
	if config_path and #config_path > 0 then
		library[config_path .. "/lua"] = true
	end

	for _, path in ipairs(vim.api.nvim_list_runtime_paths()) do
		local lua_path = path .. "/lua"
		if vim.fn.isdirectory(lua_path) == 1 then
			library[lua_path] = true
		end
	end

	return vim.tbl_keys(library)
end

-- External integrations (optional)
local blink_cmp = check_dependency("blink.cmp", "Blink.cmp")
local telescope_builtin = check_dependency("telescope.builtin", "Telescope")

if not blink_cmp then
	return
end

------------------------------------------------------------
-- 2) on_attach: common keymaps and UX
------------------------------------------------------------
local function general_on_attach(_, bufnr)
	local function bufmap(keys, fn)
		vim.keymap.set("n", keys, fn, { buffer = bufnr })
	end

	-- Navigation
	bufmap("gd", vim.lsp.buf.definition)
	bufmap("gD", vim.lsp.buf.declaration)
	bufmap("gi", vim.lsp.buf.implementation)
	bufmap("K", vim.lsp.buf.hover)

	-- Diagnostics navigation
	bufmap("[d", function()
		vim.diagnostic.jump({ count = -1, float = true })
	end)
	bufmap("]d", function()
		vim.diagnostic.jump({ count = 1, float = true })
	end)
	bufmap("[e", function()
		vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR, float = true })
	end)
	bufmap("]e", function()
		vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR, float = true })
	end)
	bufmap("<leader>ee", function()
		vim.diagnostic.open_float(nil, { focus = false, scope = "cursor" })
	end)

	if telescope_builtin then
		bufmap("gs", telescope_builtin.lsp_document_symbols)
	end
end

------------------------------------------------------------
-- 3) Client capabilities: derived from blink.cmp + enriched
------------------------------------------------------------
local general_capabilities = blink_cmp.get_lsp_capabilities()

if vim.env.DEBUG_LSP then
	vim.print("Blink.cmp LSP capabilities:", general_capabilities)
end

-- Nil-guard ladders for LuaLS satisfaction
local td = general_capabilities.textDocument or {}
local comp = td.completion or {}
local item = comp.completionItem or {}
item.snippetSupport = true
item.resolveSupport = { properties = { "documentation", "detail", "additionalTextEdits" } }
item.insertReplaceSupport = true
item.deprecatedSupport = true
item.commitCharactersSupport = true
item.tagSupport = { valueSet = { 1 } }
item.labelDetailsSupport = true
comp.completionItem = item

td.completion = comp
general_capabilities.textDocument = td

------------------------------------------------------------
-- 4) Debug utilities and user commands
------------------------------------------------------------
local function debug_lsp_completion()
	local clients = vim.lsp.get_clients({ bufnr = 0 })
	if #clients == 0 then
		vim.notify("No LSP clients attached to current buffer", vim.log.levels.WARN)
		return
	end

	for _, client in ipairs(clients) do
		local caps = client and client.server_capabilities or nil
		if caps then
			vim.print("=== LSP Client: " .. (client.name or "<unknown>") .. " ===")
			vim.print("Completion provider:", caps.completionProvider)
			if caps.completionProvider then
				vim.print("Trigger characters:", caps.completionProvider.triggerCharacters)
				vim.print("Resolve provider:", caps.completionProvider.resolveProvider)
			end
			vim.print("Hover provider:", caps.hoverProvider)
			vim.print("Definition provider:", caps.definitionProvider)
		end
	end

	vim.print("=== Blink.cmp Debug ===")
	local ok, blink = pcall(require, "blink.cmp")
	if ok then
		---@diagnostic disable-next-line: missing-parameter
		local ok2 = pcall(blink.show) -- may require params; debug-only
		vim.print("Blink completion test:", ok2)

		local bufnr = vim.api.nvim_get_current_buf()
		local lsp_clients = vim.lsp.get_clients({ bufnr = bufnr })
		vim.print("LSP clients for current buffer:")
		for _, c in ipairs(lsp_clients) do
			vim.print("  - " .. (c.name or tostring(c.id)))
		end
	else
		vim.print("Blink.cmp not available")
	end
end

local function test_completion()
	local bufnr = vim.api.nvim_get_current_buf()
	local clients = vim.lsp.get_clients({ bufnr = bufnr })
	if #clients == 0 then
		vim.notify("No LSP clients attached", vim.log.levels.WARN)
		return
	end

	local params = vim.lsp.util.make_position_params()
	-- Use buf_request to satisfy LuaLS types and Neovim API
	for _, client in ipairs(clients) do
		if client.server_capabilities and client.server_capabilities.completionProvider then
			vim.print("Testing completion with " .. (client.name or tostring(client.id)))
			vim.lsp.buf_request(bufnr, "textDocument/completion", params, function(err, result)
				if err then
					vim.print("Completion error: " .. vim.inspect(err))
					return
				end
				if result and result.items then
					vim.print("Got " .. #result.items .. " completion items")
					for i, it in ipairs(result.items) do
						if i <= 5 then
							vim.print("  " .. (it.label or "<no-label>") .. " (" .. (it.kind or "unknown") .. ")")
						end
					end
				elseif result then
					vim.print("Got completion result but no items: " .. vim.inspect(result))
				else
					vim.print("No completion result")
				end
			end)
		end
	end
end

vim.api.nvim_create_user_command("LspDebugCompletion", debug_lsp_completion, { desc = "Debug LSP completion setup" })
vim.api.nvim_create_user_command(
	"LspTestCompletion",
	test_completion,
	{ desc = "Test LSP completion at cursor position" }
)
vim.api.nvim_create_user_command("LspRestartAll", function()
	local all = vim.lsp.get_clients()
	local ids = {}
	for _, c in ipairs(all) do
		ids[#ids + 1] = c.id
	end
	if #ids > 0 then
		vim.lsp.stop_client(ids)
	end
	vim.defer_fn(function()
		vim.cmd("edit")
		vim.notify("All LSP clients restarted", vim.log.levels.INFO)
	end, 1000)
end, { desc = "Restart all LSP clients" })

------------------------------------------------------------
-- 5) Server table: per-language settings
------------------------------------------------------------
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
				runtime = { version = "LuaJIT" },
				diagnostics = { globals = { "vim" } },
				workspace = {
					checkThirdParty = false,
					library = get_lua_workspace_library(),
					maxPreload = 100000,
					preloadFileSize = 10000,
				},
				completion = { callSnippet = "Replace" },
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
	html = { on_attach = general_on_attach, capabilities = general_capabilities },
	bashls = { on_attach = general_on_attach, capabilities = general_capabilities },
	zls = { on_attach = general_on_attach, capabilities = general_capabilities },
	eslint = {
		on_attach = function(client, bufnr)
			general_on_attach(client, bufnr)
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
	clangd = { on_attach = general_on_attach, capabilities = general_capabilities },
	pyright = { on_attach = general_on_attach, capabilities = general_capabilities },
	cssls = { on_attach = general_on_attach, capabilities = general_capabilities },
	jsonls = { on_attach = general_on_attach, capabilities = general_capabilities },
	nginx_language_server = { on_attach = general_on_attach, capabilities = general_capabilities },
	nil_ls = { on_attach = general_on_attach, capabilities = general_capabilities },
	marksman = { on_attach = general_on_attach, capabilities = general_capabilities },
	sqls = { on_attach = general_on_attach, capabilities = general_capabilities },
	rust_analyzer = { on_attach = general_on_attach, capabilities = general_capabilities },
	tinymist = {
		on_attach = general_on_attach,
		capabilities = general_capabilities,
		settings = { exportPdf = "onSave", formatterMode = "typstyle" },
	},
}

-- Register servers (except jdtls which is handled separately)
for server, cfg in pairs(servers) do
	if server ~= "jdtls" then
		vim.lsp.config[server] = cfg
		vim.lsp.enable(server)
	end
end

------------------------------------------------------------
-- 6) Java (JDTLS): dedicated setup via nvim-jdtls
---------------------------------------------------------------

local jdtls = check_dependency("jdtls", "nvim-jdtls")
if jdtls then
	local fmt = string.format
	local home = os.getenv("HOME") or ""
	local data = vim.fn.stdpath("data")

	-- Mason jdtls paths
	local jdtls_root = data .. "/mason/packages/jdtls"
	local launcher_jar = vim.fn.glob(jdtls_root .. "/plugins/org.eclipse.equinox.launcher_*.jar")
	local config_dir = jdtls_root .. "/config_linux"

	local function exists(p)
		return type(p) == "string" and #p > 0 and (vim.fn.filereadable(p) == 1 or vim.fn.isdirectory(p) == 1)
	end

	if launcher_jar == "" or not exists(launcher_jar) then
		vim.notify("jdtls launcher not found under " .. jdtls_root .. "/plugins", vim.log.levels.ERROR)
		return
	end

	if not exists(config_dir) then
		vim.notify("jdtls config_linux not found under " .. jdtls_root, vim.log.levels.ERROR)
		return
	end

	-- Java versions
	local jdk25 = os.getenv("JAVA_HOME25")
	local jdk21 = os.getenv("JAVA_HOME21")
	local jdk11 = os.getenv("JAVA_HOME11")

	local function pick_runtime_java()
		-- For running jdtls itself, prefer Java 17 or 21 (most stable)
		if exists(jdk21) then
			return jdk21, "21"
		end
		if exists(jdk11) then
			return jdk11, "11"
		end
		if exists(jdk25) then
			-- Use 25 only if no other option
			return jdk25, "25"
		end
		return nil, nil
	end

	local runtime_java, runtime_ver = pick_runtime_java()
	if not runtime_java then
		vim.notify("Set JAVA_HOME17 (preferred for jdtls) or JAVA_HOME21/11/25", vim.log.levels.ERROR)
		return
	end

	-- Project Java version (what your code uses)
	local project_java = jdk25 or jdk21 or jdk11

	local lombok = home .. "/nixos/dotfiles/lombok-1.18.38.jar"
	local javax_annotation = home .. "/nixos/dotfiles/javax.annotation-api-1.3.2.jar"

	local bundles = {}
	if exists(javax_annotation) then
		table.insert(bundles, javax_annotation)
	end

	-- Add debug adapter bundles if available
	local debugger_path = data .. "/mason/packages/java-debug-adapter"
	local test_path = data .. "/mason/packages/java-test"

	if exists(debugger_path) then
		local debug_bundle =
			vim.fn.glob(debugger_path .. "/extension/server/com.microsoft.java.debug.plugin-*.jar", true)
		if debug_bundle ~= "" then
			table.insert(bundles, debug_bundle)
		end
	end

	if exists(test_path) then
		vim.list_extend(bundles, vim.split(vim.fn.glob(test_path .. "/extension/server/*.jar", true), "\n"))
	end

	local function workspace_for(root_dir)
		local name = vim.fn.fnamemodify(root_dir, ":t")
		return home .. "/.local/share/eclipse/" .. name
	end

	vim.api.nvim_create_autocmd("FileType", {
		pattern = "java",
		callback = function()
			local bufnr = vim.api.nvim_get_current_buf()
			if vim.b[bufnr].jdtls_attached then
				return
			end

			local root_dir = jdtls.setup.find_root({ ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" })
			if not root_dir then
				vim.notify("No Java project root found", vim.log.levels.WARN)
				return
			end

			local ws = workspace_for(root_dir)

			-- Build the command based on Java version
			local cmd = {
				runtime_java .. "/bin/java",
			}

			-- Add JVM memory settings
			vim.list_extend(cmd, {
				"-Declipse.application=org.eclipse.jdt.ls.core.id1",
				"-Dosgi.bundles.defaultStartLevel=4",
				"-Declipse.product=org.eclipse.jdt.ls.core.product",
				"-Dlog.protocol=true",
				"-Dlog.level=ALL",
				"-Xmx1g",
				"-Xms100m",
			})

			-- Add javaagent for lombok if it exists
			if exists(lombok) then
				table.insert(cmd, "-javaagent:" .. lombok)
			end

			-- Java version specific flags
			if runtime_ver == "17" or runtime_ver == "21" or runtime_ver == "25" then
				vim.list_extend(cmd, {
					"--add-modules=ALL-SYSTEM",
					"--add-opens",
					"java.base/java.util=ALL-UNNAMED",
					"--add-opens",
					"java.base/java.lang=ALL-UNNAMED",
				})
			end

			-- Add the jar and configuration
			vim.list_extend(cmd, {
				"-jar",
				launcher_jar,
				"-configuration",
				config_dir,
				"-data",
				ws,
				"--add-modules=ALL-SYSTEM",
				"--add-opens",
				"java.base/java.util=ALL-UNNAMED",
				"--add-opens",
				"java.base/java.lang=ALL-UNNAMED",
			})

			-- Java runtime configurations for different versions
			local java_runtimes = {}
			if exists(jdk25) then
				table.insert(java_runtimes, {
					name = "JavaSE-25",
					path = jdk25,
					default = project_java == jdk25,
				})
			end
			if exists(jdk21) then
				table.insert(java_runtimes, {
					name = "JavaSE-21",
					path = jdk21,
					default = project_java == jdk21,
				})
			end
			if exists(jdk17) then
				table.insert(java_runtimes, {
					name = "JavaSE-17",
					path = jdk17,
					default = project_java == jdk17,
				})
			end
			if exists(jdk11) then
				table.insert(java_runtimes, {
					name = "JavaSE-11",
					path = jdk11,
					default = project_java == jdk11,
				})
			end

			local config = {
				cmd = cmd,
				root_dir = root_dir,
				init_options = {
					bundles = bundles,
				},
				settings = {
					java = {
						home = project_java,
						eclipse = {
							downloadSources = true,
						},
						configuration = {
							runtimes = java_runtimes,
							updateBuildConfiguration = "interactive",
						},
						maven = {
							downloadSources = true,
						},
						implementationsCodeLens = {
							enabled = true,
						},
						referencesCodeLens = {
							enabled = true,
						},
						references = {
							includeDecompiledSources = true,
						},
						format = {
							enabled = true,
						},
						signatureHelp = { enabled = true },
						contentProvider = { preferred = nil },
						completion = {
							favoriteStaticMembers = {
								"org.junit.jupiter.api.Assertions.*",
								"org.junit.Assert.*",
								"org.mockito.Mockito.*",
							},
						},
					},
				},
				on_attach = general_on_attach,
				capabilities = general_capabilities,
			}

			-- If using lombok, add special settings
			if exists(lombok) then
				config.settings.java.project = {
					referencedLibraries = { lombok, javax_annotation },
				}
				config.settings.java.eclipse = {
					downloadSources = true,
				}
				config.settings["java.jdt.ls.lombokSupport.enabled"] = true
			end

			-- Start jdtls
			jdtls.start_or_attach(config)
			vim.b[bufnr].jdtls_attached = true
			vim.notify(
				fmt(
					"JDTLS running on Java %s, project uses %s",
					runtime_ver or "?",
					project_java and vim.fn.fnamemodify(project_java, ":t") or "default"
				),
				vim.log.levels.INFO
			)
		end,
	})
end

vim.notify("LSP configuration loaded successfully", vim.log.levels.INFO)
