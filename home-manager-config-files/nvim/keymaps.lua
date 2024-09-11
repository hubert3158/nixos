vim.g.mapleader = " "      -- Make sure to set `mapleader` before lazy so your mappings are correct
vim.g.maplocalleader = "," -- Same for `maplocalleader`
vim.opt.scrolloff = 6
vim.opt.incsearch = true   -- Do incremental searching. map Q gq
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.ignorecase = true

vim.opt.tabstop = 4      -- Number of spaces that a <Tab> in the file counts for
vim.opt.shiftwidth = 4   -- Number of spaces to use for each step of (auto)indent
vim.opt.expandtab = true -- Convert tabs to spaces


vim.api.nvim_create_autocmd("FocusLost", {
    pattern = "*",
    command = "silent! wa"
})



vim.api.nvim_set_keymap("n", "<leader>ff", "<cmd>Telescope find_files<CR>",
    { noremap = true, silent = true, desc = "find_files" })
vim.api.nvim_set_keymap("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>",
    { noremap = true, silent = true, desc = "find_old_files" })
vim.api.nvim_set_keymap("n", "<leader>fg", "<cmd>Telescope live_grep<CR>",
    { noremap = true, silent = true, desc = "live_grep" })
vim.api.nvim_set_keymap("n", "<leader>fb", "<cmd>Telescope buffers<CR>",
    { noremap = true, silent = true, desc = "find_buffers" })
vim.api.nvim_set_keymap("n", "<leader>fh", "<cmd>Telescope help_tags<CR>",
    { noremap = true, silent = true, desc = "find_help_tags" })
vim.api.nvim_set_keymap("n", "<leader>fs", "<cmd>Telescope builtin<CR>",
    { noremap = true, silent = true, desc = "[S]earch [S]elect Telescope" })
-- vim.api.nvim_set_keymap("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { noremap = true, silent = true })

vim.api.nvim_set_keymap("n", "<leader>nn", ":NERDTreeFocus<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<leader>n", ":NERDTreeFocus<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<leader>nt", ":NERDTreeToggle<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<leader>nf", ":NERDTreeFind<CR>", { silent = true })



vim.api.nvim_set_keymap("n", "<leader>t", ":terminal<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<leader>q", ":q<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<leader>l", ":tabnext<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<leader>h", ":tabprevious<CR>", { silent = true })

-- vim.api.nvim_set_keymap("n", "<leader>r", ":Neoformat<CR>", { silent = true })
-- vim.api.nvim_set_keymap("n", "<leader>s", "<Plug>(Sneak_S)", { silent = true })
-- vim.api.nvim_set_keymap("n", "<leader>s", "<Plug>(Sneak_S)", { silent = true })

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
require("notify")("check out LudoPinelli/comment-box.nvim  <>cbccbox")

vim.api.nvim_set_keymap("n", "<leader>un", ":lua require('notify').dismiss({ silent = true, pending = true })<CR>",
    { noremap = true, silent = true, desc = "[U]nnotify [N]otify dismiss" })




--DAP
vim.api.nvim_set_keymap('n', '<F4>', ":lua require('dapui').toggle()<CR>",
    { noremap = true, silent = true, desc = "show dap ui" })
vim.api.nvim_set_keymap('n', '<F5>', ":lua require'dap'.continue()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<F6>', ":lua require'dap'.disconnect()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<F10>', ":lua require'dap'.step_over()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<F11>', ":lua require'dap'.step_into()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<F12>', ":lua require'dap'.step_out()<CR>", { noremap = true, silent = true })



vim.api.nvim_set_keymap('n', "<leader>mo", ":lua require'mini.map'.open()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', "<leader>mc", ":lua require'mini.map'.close()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', "<leader>mt", ":lua require'mini.map'.toggle()<CR>", { noremap = true, silent = true })




-- trouble.nvim
vim.api.nvim_set_keymap('n', "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', "<leader>xL", "<cmd>Trouble loclist toggle<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', "<leader>xt", "<cmd>Trouble todo<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', "<leader>xT", "<cmd>TodoTelescope<cr>", { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', "<leader>cd", "<cmd>Telescope zoxide list<cr>", { noremap = true, silent = true })


vim.api.nvim_set_keymap('n', '<leader>sv', ':vsp<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>sh', ':sp<CR>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<leader>bn', ':bnext<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>bp', ':bprevious<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>w=', ':vertical resize +5<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>w-', ':vertical resize -5<CR>', { noremap = true, silent = true })




