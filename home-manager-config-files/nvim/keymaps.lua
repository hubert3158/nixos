vim.g.mapleader = " " -- Make sure to set `mapleader` before lazy so your mappings are correct
vim.g.maplocalleader = " " -- Same for `maplocalleader`
vim.g.scrolloff = 5
vim.opt.incsearch = true -- Do incremental searching. map Q gq
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.ignorecase = true



vim.api.nvim_set_keymap("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { noremap = true, silent = true , desc = "find_files"})
vim.api.nvim_set_keymap("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", { noremap = true, silent = true, desc = "find_old_files" })
vim.api.nvim_set_keymap("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { noremap = true, silent = true, desc = "live_grep" })
vim.api.nvim_set_keymap("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { noremap = true, silent = true, desc = "find_buffers" })
vim.api.nvim_set_keymap("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { noremap = true, silent = true, desc = "find_help_tags" })
vim.api.nvim_set_keymap("n", "<leader>fs", "<cmd>Telescope builtin<CR>", { noremap = true, silent = true, desc = "[S]earch [S]elect Telescope" })
-- vim.api.nvim_set_keymap("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { noremap = true, silent = true })

vim.api.nvim_set_keymap("n", "<leader>p", ":Neotree<CR>", { silent = true })

vim.api.nvim_set_keymap("n", "<leader>t", ":terminal<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<leader>q", ":q<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<leader>l", ":tabnext<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<leader>h", ":tabprevious<CR>", { silent = true })

-- vim.api.nvim_set_keymap("n", "<leader>r", ":Neoformat<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<leader>S", "<Plug>(Sneak-s)", { silent = true })
vim.api.nvim_set_keymap("n", "<leader>s", "<Plug>(Sneak_S)", { silent = true })

--- Vim fugitive
-- vim.api.nvim_set_keymap("n", "<leader>gs", ":G status<CR>", { silent = true })
-- vim.api.nvim_set_keymap("n", "<leader>ga", ":G add %<CR>", { silent = true })
-- vim.api.nvim_set_keymap("n", "<leader>gA", ":G add .<CR>", { silent = true })
-- vim.api.nvim_set_keymap("n", "<leader>gc", ":G commit -v<CR>", { silent = true })
-- vim.api.nvim_set_keymap("n", "<leader>gph", ":G push<CR>", { silent = true })
-- vim.api.nvim_set_keymap("n", "<leader>gpl", ":G pull<CR>", { silent = true })
-- vim.api.nvim_set_keymap("n", "<leader>gb", ":G blame<CR>", { silent = true })
-- vim.api.nvim_set_keymap("n", "<leader>gd", ":G diff --staged<CR>", { silent = true })

--log
-- vim.api.nvim_set_keymap(
-- 	"n",
-- 	"<leader>gl",
-- 	":G log --graph --pretty=format:'%C(auto)%h %d %s %C(bold blue)<%an> %C(white)(%ar)' --all<CR>",
-- 	{ silent = true }
-- )


-- notify
vim.notify = require('notify')
vim.notify("This is an error message", "error")
require("notify")("My super important message")
require("notify")("hey there")
require("notify")("check out LudoPinelli/comment-box.nvim  <>cbccbox")
require("notify")("install lazy git")

vim.api.nvim_set_keymap("n", "<leader>un", ":lua require('notify').dismiss({ silent = true, pending = true })<CR>", { noremap = true, silent = true, desc = "[U]nnotify [N]otify dismiss" })









--                                      ╭╮
--                                      │test│
--                                      ╰╯
--                                  ╭─────────╮
--                                  │ this is │
--                                  ╰─────────╯
--                                  
--
--
--
--          ╭─────────────────────────────────────────────────────────╮
--          │                        test test                        │
--          ╰─────────────────────────────────────────────────────────╯












