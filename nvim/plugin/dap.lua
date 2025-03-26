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

-- Apply the same configurations for TypeScript React
dap.configurations.typescriptreact = dap.configurations.typescript

