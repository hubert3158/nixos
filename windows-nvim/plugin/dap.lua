local dap = require("dap")
local dapui = require("dapui")

dapui.setup()

-- Open DAP UI automatically on debugging start
dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close()
end

-- Debug Adapter for Node.js
dap.adapters["pwa-node"] = {
	type = "server",
	host = "localhost",
	port = "${port}",
	executable = {
		command = vim.fn.exepath("js-debug-adapter"), -- install via :MasonInstall js-debug-adapter
		args = { "${port}" },
	},
}

dap.adapters.firefox = {
	type = "executable",
	command = "node",
	args = {
		vim.fn.expand("$MASON/packages/firefox-debug-adapter/dist/adapter.bundle.js"),
	},
}

-- Debug Configurations for JavaScript & TypeScript
local js_ts_configs = {
	-- Launch JavaScript/TypeScript file
	{
		type = "pwa-node",
		request = "launch",
		name = "Launch File",
		program = "${file}",
		cwd = "${workspaceFolder}",
	},
	-- Attach to running Node.js process
	{
		type = "pwa-node",
		request = "attach",
		name = "Attach to Running Process",
		port = 9229,
		cwd = "${workspaceFolder}",
	},
	-- Debug with Firefox
	{
		name = "Debug with Firefox",
		type = "firefox",
		request = "launch",
		reAttach = true,
		url = "http://localhost:3000",
		webRoot = "${workspaceFolder}",
		firefoxExecutable = "firefox", -- must be on PATH (Windows)
	},
}

dap.configurations.javascript = js_ts_configs
dap.configurations.typescript = js_ts_configs
dap.configurations.typescriptreact = js_ts_configs
