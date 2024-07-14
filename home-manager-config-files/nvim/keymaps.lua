vim.g.mapleader = " " -- Make sure to set `mapleader` before lazy so your mappings are correct
vim.g.maplocalleader = " " -- Same for `maplocalleader`
vim.g.scrolloff = 5
vim.opt.incsearch = true -- Do incremental searching. map Q gq
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.ignorecase = true



vim.api.nvim_set_keymap("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { noremap = true, silent = true })
-- vim.keymap.set("n", "<leader>fo", builtin.oldfiles, { desc = "find_old_files" })
-- vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "live_grep" })
-- vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "find_buffers" })
-- vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "find_help_tags" })
-- vim.keymap.set("n", "<leader>fs", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })

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













