-- DAP + dapui setup and keymaps. Loaded via lz.n on DeferredUIEnter
-- (nvim-dap and nvim-dap-ui are opt plugins).

vim.cmd.packadd("nvim-dap-ui")
vim.cmd.packadd("nvim-dap-virtual-text")

local dap = require("dap")
local dapui = require("dapui")

dapui.setup()

-- Inline variable values next to code while stepping
require("nvim-dap-virtual-text").setup({})

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
-- Keymaps — <leader>d = debug (namespace registry: user/keymaps.lua).
-- F-keys follow the VSCode standard: F5 continue, F9 breakpoint, F10 step
-- over, F11 step into. <leader>rd (run group) re-runs the last session.
-- ============================================================================
local map = vim.keymap.set

-- Session control
map("n", "<F5>", dap.continue, { silent = true, desc = "Debug: continue" })
map("n", "<F10>", dap.step_over, { silent = true, desc = "Debug: step over" })
map("n", "<F11>", dap.step_into, { silent = true, desc = "Debug: step into" })
map("n", "<leader>dc", dap.continue, { silent = true, desc = "Continue" })
map("n", "<leader>dO", dap.step_over, { silent = true, desc = "Step over" })
map("n", "<leader>di", dap.step_into, { silent = true, desc = "Step into" })
map("n", "<leader>do", dap.step_out, { silent = true, desc = "Step out" })
map("n", "<leader>dd", dap.disconnect, { silent = true, desc = "Disconnect" })

-- Breakpoints
map("n", "<F9>", dap.toggle_breakpoint, { silent = true, desc = "Debug: toggle breakpoint" })
map("n", "<leader>db", dap.toggle_breakpoint, { silent = true, desc = "Toggle breakpoint" })
map("n", "<leader>dB", function()
	dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, { silent = true, desc = "Conditional breakpoint" })
map("n", "<leader>dC", dap.clear_breakpoints, { silent = true, desc = "Clear all breakpoints" })

-- Inspection
map("n", "<leader>du", dapui.toggle, { silent = true, desc = "Toggle debug UI" })
map("n", "<leader>dh", function()
	require("dap.ui.widgets").hover()
end, { silent = true, desc = "Hover variable" })
map("n", "<leader>ds", function()
	local widgets = require("dap.ui.widgets")
	widgets.centered_float(widgets.scopes)
end, { silent = true, desc = "Show scopes" })
map("n", "<leader>df", function()
	local widgets = require("dap.ui.widgets")
	widgets.centered_float(widgets.frames)
end, { silent = true, desc = "Show frames" })
map("n", "<leader>dr", dap.repl.open, { silent = true, desc = "Open REPL" })
