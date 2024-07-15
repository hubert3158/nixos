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
local config = {
    cmd = {'/home/hubert/.nix-profile/bin/jdtls'}, -- Update the path to your jdtls executable if different
    root_dir = vim.fs.dirname(vim.fs.find({'gradlew', '.git', 'mvnw'}, { upward = true })[1]),
    init_options = {
      bundles = {
        vim.fn.glob('/nix/store/id0zrxghssr6mkzxaaphs9yy1sjn7f57-vscode-extension-vscjava-vscode-java-debug-0.55.2023121302/share/vscode/extensions/vscjava.vscode-java-debug/server/com.microsoft.java.debug.plugin-0.50.0.jar', true), -- Update the path to your bundles
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
    request = 'attach',
    name = "Debug (Attach) - Remote",
    hostName = "127.0.0.1",
    port = 5005,
  },
}

-- Make sure to attach jdtls to dap
require('jdtls').setup_dap({ hotcodereplace = 'auto' })

