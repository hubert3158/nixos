local dap = require('dap')
local dapui = require('dapui')

dapui.setup()

dap.adapters.java = {
    type = 'server',
    host = '127.0.0.1',
    port = 5006,
    options = {
        timeout = 10000 -- Increase the timeout to 10 seconds
    }
}

dap.configurations.java = {
    {
        type = 'java',
        request = 'attach',
        name = "Attach to Java process",
        hostName = "127.0.0.1",
        port = 5006,
    },
}

dap.set_log_level('TRACE')

