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

-- Debug Adapter for Node.js
dap.adapters["pwa-node"] = {
  type = "server",
  host = "localhost",
  port = "${port}",
  executable = {
    command = "/nix/store/1lvskcxsbgisxqabkwfnchqicw4w5l7l-vscode-js-debug-1.97.1/bin/js-debug",
    args = {"${port}"},
  }
}

dap.adapters.firefox = {
  type = 'executable',
  command = 'node',
  args = {
    '/nix/store/fczhm3sb9mh44v4zgzlmlms6jaicxbrs-vscode-extension-firefox-devtools-vscode-firefox-debug-2.9.10/share/vscode/extensions/firefox-devtools.vscode-firefox-debug/dist/adapter.bundle.js'
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
    name = 'Debug with Firefox',
    type = 'firefox',
    request = 'launch',
    reAttach = true,
    url = 'http://localhost:3000',
    webRoot = '${workspaceFolder}',
    firefoxExecutable = '/run/current-system/sw/bin/firefox',
  },
}

dap.configurations.javascript = js_ts_configs
dap.configurations.typescript = js_ts_configs
dap.configurations.typescriptreact = js_ts_configs

