-- Lualine
require("lualine").setup({
    icons_enabled = true,
    -- theme = 'onedark',
})

-- Colorscheme
vim.cmd("colorscheme gruvbox")

vim.cmd [[
  highlight Normal guibg=NONE ctermbg=NONE
  highlight NonText guibg=NONE ctermbg=NONE
]]

-- Comment
require("Comment").setup()


-- require("nvim-notify").setup({})
-- require("notify").setup()
-- require("notify")("My super important message")
-- require("notify")("hey there")
-- require("notify")("check out LudoPinelli/comment-box.nvim  <>cbccbox")
-- require("notify")("install lazy git")
-- vim.notify = require('notify')
-- vim.notify("This is an error message", "error")
--
-- require("notify").setup({
--   keys = {
--     {
--       "<leader>un",
--       function()
--         require("notify").dismiss({ silent = true, pending = true })
--       end,
--       desc = "Dismiss All Notifications",
--     },
--   },
--   opts = {
--     stages = "static",
--     timeout = 3000,
--     max_height = function()
--       return math.floor(vim.o.lines * 0.75)
--     end,
--     max_width = function()
--       return math.floor(vim.o.columns * 0.75)
--     end,
--     on_open = function(win)
--       vim.api.nvim_win_set_config(win, { zindex = 100 })
--     end,
--   },
--   init = function()
--     -- when noice is not enabled, install notify on VeryLazy
--   end,
-- })
