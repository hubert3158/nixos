local dap = require('dap')
local dapui = require('dapui')

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

dap.adapters.firefox = {
  type = 'executable',
  command = 'node',
  args = {'/nix/store/fczhm3sb9mh44v4zgzlmlms6jaicxbrs-vscode-extension-firefox-devtools-vscode-firefox-debug-2.9.10/share/vscode/extensions/firefox-devtools.vscode-firefox-debug/dist/adapter.bundle.js'},
}

dap.configurations.typescript = {
  {
  name = 'Debug with Firefox',
  type = 'firefox',
  request = 'launch',
  reAttach = true,
  url = 'http://localhost:3000',
  webRoot = '${workspaceFolder}',
  firefoxExecutable = '/run/current-system/sw/bin/firefox'
  }
}

dap.configurations.javascript = dap.configurations.typescript
dap.configurations.typescriptreact = dap.configurations.javascript

