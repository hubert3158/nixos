-- nvim-dap setup
local dap = require('dap')
local dapui = require('dapui')

-- nvim-dap-ui setup
dapui.setup()

-- Open DAP UI automatically
dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close()
end

-- jdtls setup
local function setup_jdtls()
	local config = {
		cmd = {'/etc/profiles/per-user/hubert/bin/jdtls'}, -- Update the path to your jdtls executable
		root_dir = vim.fs.dirname(vim.fs.find({'gradlew', '.git', 'mvnw'}, { upward = true })[1]),
		init_options = {
			bundles = {
				vim.fn.glob('/nix/store/id0zrxghssr6mkzxaaphs9yy1sjn7f57-vscode-extension-vscjava-vscode-java-debug-0.55.2023121302/share/vscode/extensions/vscjava.vscode-java-debug/server/com.microsoft.java.debug.plugin-0.50.0.jar', true),
			}
		}
	}

	require('jdtls').start_or_attach(config)

	-- Allow time for jdtls to fully load the project
	local timer = 2500
	for i = 0, 12, 1 do
		vim.defer_fn(function() require('jdtls.dap').setup_dap_main_class_configs() end, timer)
		timer = timer + 2500
	end

	-- Configure Java DAP adapter
	dap.adapters.java = function(callback)
		callback({
			type = 'server',
			host = '127.0.0.1',
			port = 5005,
		})
	end

	dap.configurations.java = {
		{
			type = 'java',
			request = 'launch',
			name = "Launch Java Program",
			mainClass = function()
				return vim.fn.input('Main class: ', vim.fn.getcwd() .. '.', 'file')
			end,
			cwd = vim.fn.getcwd(),
			args = {},
			projectName = "MyJavaProject",
		},
		{
			type = 'java',
			request = 'attach',
			name = "Attach to running Java program",
			hostName = "127.0.0.1",
			port = 5005,
		},
	}

	-- Make sure to attach jdtls to dap
	require('jdtls').setup_dap({ hotcodereplace = 'auto' })
end

-- Setup Java LSP only for Java files
vim.api.nvim_create_autocmd("FileType", {
	pattern = "java",
	callback = function()
		setup_jdtls()
	end,
})

