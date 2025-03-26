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
  args = {'/nix/store/fczhm3sb9mh44v4zgzlmlms6jaicxbrs-vscode-extension-firefox-devtools-vscode-firefox-debug-2.9.10/share/vscode/extensions/firefox-devtools.vscode-firefox-debug/dist/adapter.bundle.js'},
}

-- Debug Configuration for JavaScript & TypeScript
dap.configurations.javascript = {
  -- Launch JavaScript file
  {
    type = "pwa-node",
    request = "launch",
    name = "Launch JavaScript File",
    program = "${file}",
    cwd = "${workspaceFolder}",
  },
  -- Attach to running Node.js process
  {
    type = "pwa-node",
    request = "attach",
    name = "Attach to Running JS Process",
    port = 9229,
    cwd = "${workspaceFolder}",
  },
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

-- Debug Configuration for TypeScript
dap.configurations.typescript = {
  -- Launch TypeScript file with ts-node
  {
    type = "pwa-node",
    request = "launch",
    name = "Launch TypeScript File",
    program = "${file}",
    cwd = "${workspaceFolder}",
    runtimeExecutable = "ts-node",
    runtimeArgs = {"--loader", "ts-node/esm"},
    sourceMaps = true,
    skipFiles = { '<node_internals>/**', 'node_modules/**' },
    protocol = "inspector",
  },
  -- Attach to running ts-node process
  {
    type = "pwa-node",
    request = "attach",
    name = "Attach to Running TS Process",
    port = 9229,
    cwd = "${workspaceFolder}",
  },
}

dap.configurations.typescriptreact = {
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

