-- nvim-dap setup
local dap = require('dap')
local dapui = require('dapui')

-- nvim-dap-ui setup
dapui.setup()

-- nvim-dap-java setup
require('jdtls').setup_dap({ hotcodereplace = 'auto' })

-- Keybindings for nvim-dap
vim.api.nvim_set_keymap('n', '<F5>', ":lua require'dap'.continue()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<F10>', ":lua require'dap'.step_over()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<F11>', ":lua require'dap'.step_into()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<F12>', ":lua require'dap'.step_out()<CR>", { noremap = true, silent = true })

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

-- Configure Java DAP adapter
dap.adapters.java = function(callback)
  require('jdtls').setup_dap({ hotcodereplace = 'auto' })
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

