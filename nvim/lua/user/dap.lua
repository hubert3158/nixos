-- DAP + dapui setup and keymaps. Loaded via lz.n on DeferredUIEnter
-- (nvim-dap and nvim-dap-ui are opt plugins).

vim.cmd.packadd("nvim-dap-ui")

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
		command = "/run/current-system/sw/bin/js-debug",
		args = { "${port}" },
	},
}

dap.adapters.firefox = {
	type = "executable",
	command = "node",
	args = {
		"/nix/store/fczhm3sb9mh44v4zgzlmlms6jaicxbrs-vscode-extension-firefox-devtools-vscode-firefox-debug-2.9.10/share/vscode/extensions/firefox-devtools.vscode-firefox-debug/dist/adapter.bundle.js",
	},
}

-- Debug Configurations for JavaScript & TypeScript
local js_ts_configs = {
	{
		type = "pwa-node",
		request = "launch",
		name = "Launch File",
		program = "${file}",
		cwd = "${workspaceFolder}",
	},
	{
		type = "pwa-node",
		request = "attach",
		name = "Attach to Running Process",
		port = 9229,
		cwd = "${workspaceFolder}",
	},
	{
		name = "Debug with Firefox",
		type = "firefox",
		request = "launch",
		reAttach = true,
		url = "http://localhost:3000",
		webRoot = "${workspaceFolder}",
		firefoxExecutable = "/run/current-system/sw/bin/firefox",
	},
}

dap.configurations.javascript = js_ts_configs
dap.configurations.typescript = js_ts_configs
dap.configurations.typescriptreact = js_ts_configs

-- ============================================================================
-- Keymaps
-- ============================================================================
local map = vim.keymap.set

map("n", "<F1>", function()
	dapui.toggle()
end, { silent = true, desc = "Toggle DAP UI" })
map("n", "<F5>", function()
	dap.step_over()
end, { silent = true, desc = "DAP Step Over" })
map("n", "<F6>", function()
	dap.continue()
end, { silent = true, desc = "DAP Continue" })
map("n", "<F4>", function()
	dap.step_into()
end, { silent = true, desc = "DAP Step Into" })
map("n", "<F3>", function()
	dap.step_out()
end, { silent = true, desc = "DAP Step Out" })

-- DAP widgets
map("n", "<leader>eh", function()
	require("dap.ui.widgets").hover()
end, { silent = true, desc = "DAP Hover Variable" })
map("n", "<leader>es", function()
	local widgets = require("dap.ui.widgets")
	widgets.centered_float(widgets.scopes)
end, { silent = true, desc = "DAP Show Scopes" })
map("n", "<leader>ef", function()
	local widgets = require("dap.ui.widgets")
	widgets.centered_float(widgets.frames)
end, { silent = true, desc = "DAP Show Frames" })
map("n", "<leader>ed", function()
	dap.disconnect()
end, { silent = true, desc = "DAP Disconnect" })

-- Breakpoints
map("n", "<leader>eb", function()
	dap.toggle_breakpoint()
end, { silent = true, desc = "Toggle Breakpoint" })
map("n", "<leader>eB", function()
	dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, { silent = true, desc = "Set Conditional Breakpoint" })
map("n", "<leader>eC", function()
	dap.clear_breakpoints()
end, { silent = true, desc = "Clear All Breakpoints" })

-- REPL
map("n", "<leader>er", function()
	dap.repl.open()
end, { silent = true, desc = "Open DAP REPL" })
