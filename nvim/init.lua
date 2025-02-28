local cmd = vim.cmd
local fn = vim.fn
local opt = vim.o
local g = vim.g



-- <leader> key. Defaults to `\`. Some people prefer space.
-- g.mapleader = ' '
-- g.maplocalleader = ' '

opt.compatible = false

-- Enable true colour support
if fn.has('termguicolors') then
  opt.termguicolors = true
end

-- See :h <option> to see what the options do

-- Search down into subfolders
opt.path = vim.o.path .. '**'









-- Set leader keys
vim.g.mapleader = " "      -- Make sure to set `mapleader` before lazy so your mappings are correct
vim.g.maplocalleader = "," -- Same for `maplocalleader`

-- General settings
vim.opt.scrolloff = 6
vim.opt.incsearch = true   -- Do incremental searching
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.ignorecase = true
vim.opt.foldmethod ="marker"
vim.opt.foldmarker="// region,// endregion,/* region */,/* endregion */,# region,# endregion"


-- Indentation settings
vim.opt.tabstop = 4      -- Number of spaces that a <Tab> in the file counts for
vim.opt.shiftwidth = 4   -- Number of spaces to use for each step of (auto)indent
vim.opt.expandtab = true -- Convert tabs to spaces

-- Auto-save when focus is lost
vim.api.nvim_create_autocmd("FocusLost", {
    pattern = "*",
    command = "silent! wa"
})

-- Telescope keybindings
vim.api.nvim_set_keymap("n", "<leader>ff", "<cmd>Telescope find_files<CR>",
    { noremap = true, silent = true, desc = "Find Files" })
vim.api.nvim_set_keymap("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>",
    { noremap = true, silent = true, desc = "Find Old Files" })
vim.api.nvim_set_keymap("n", "<leader>fg", "<cmd>Telescope live_grep<CR>",
    { noremap = true, silent = true, desc = "Live Grep" })
vim.api.nvim_set_keymap("n", "<leader>fb", "<cmd>Telescope buffers<CR>",
    { noremap = true, silent = true, desc = "Find Buffers" })
vim.api.nvim_set_keymap("n", "<leader>fh", "<cmd>Telescope help_tags<CR>",
    { noremap = true, silent = true, desc = "Find Help Tags" })
vim.api.nvim_set_keymap("n", "<leader>fs", "<cmd>Telescope builtin<CR>",
    { noremap = true, silent = true, desc = "Search Telescope Builtins" })
vim.api.nvim_set_keymap('n', '<leader>fc', '<cmd>Telescope commands<CR>',
    { noremap = true, silent = true, desc = "Find Commands" })
vim.api.nvim_set_keymap('n', '<leader>fk', '<cmd>Telescope keymaps<CR>',
    { noremap = true, silent = true, desc = "Find Keymaps" })
vim.api.nvim_set_keymap('n', '<leader>fm', '<cmd>Telescope marks<CR>',
    { noremap = true, silent = true, desc = "Find Marks" })

-- NERDTree keybindings
vim.api.nvim_set_keymap("n", "<leader>nf", ":NERDTreeFind<CR>",
    { silent = true, desc = "Focus NERDTree" })
vim.api.nvim_set_keymap("n", "<leader>nt", ":NERDTreeToggle<CR>",
    { silent = true, desc = "Toggle NERDTree" })

-- NeoFormat keybinding
vim.api.nvim_set_keymap("n", "<leader>nn", ":Neoformat<CR>",
    { silent = true, desc = "[N]eo[F]ormat" })

-- neogen
vim.api.nvim_set_keymap("n", "<Leader>nc", ":lua require'neogen'.generate()<CR>", { noremap = true, silent = true ,desc=" [C]omment Documentation Generation"})

-- Tab management
vim.api.nvim_set_keymap("n", "<leader>t", ":tabnew<CR>",
    { silent = true, desc = "New Tab" })
vim.api.nvim_set_keymap("n", "<leader>q", ":q<CR>",
    { silent = true, desc = "Quit" })
vim.api.nvim_set_keymap("n", "<leader>l", ":tabnext<CR>",
    { silent = true, desc = "Next Tab" })
vim.api.nvim_set_keymap("n", "<leader>h", ":tabprevious<CR>",
    { silent = true, desc = "Previous Tab" })
vim.api.nvim_set_keymap('n', '<leader>1', '1gt<CR>',
    { noremap = true, silent = true, desc = "Go to Tab 1" })
vim.api.nvim_set_keymap('n', '<leader>2', '2gt<CR>',
    { noremap = true, silent = true, desc = "Go to Tab 2" })
vim.api.nvim_set_keymap('n', '<leader>3', '3gt<CR>',
    { noremap = true, silent = true, desc = "Go to Tab 3" })
vim.api.nvim_set_keymap('n', '<leader>4', '4gt<CR>',
    { noremap = true, silent = true, desc = "Go to Tab 4" })
vim.api.nvim_set_keymap('n', '<leader>5', '5gt<CR>',
    { noremap = true, silent = true, desc = "Go to Tab 5" })

-- Buffer navigation
vim.api.nvim_set_keymap('n', '<leader>bn', ':bnext<CR>',
    { noremap = true, silent = true, desc = "Next Buffer" })
vim.api.nvim_set_keymap('n', '<leader>bp', ':bprevious<CR>',
    { noremap = true, silent = true, desc = "Previous Buffer" })
vim.api.nvim_set_keymap('n', '<leader>bd', ':bd<CR>',
    { noremap = true, silent = true, desc = "Close Buffer" })

-- Window management
vim.api.nvim_set_keymap('n', '<leader>sv', ':vsp<CR>',
    { noremap = true, silent = true, desc = "Vertical Split" })
vim.api.nvim_set_keymap('n', '<leader>sh', ':sp<CR>',
    { noremap = true, silent = true, desc = "Horizontal Split" })

-- Window navigation
vim.api.nvim_set_keymap('n', '<C-h>', '<C-w>h',
    { noremap = true, silent = true, desc = "Move to Left Window" })
vim.api.nvim_set_keymap('n', '<C-j>', '<C-w>j',
    { noremap = true, silent = true, desc = "Move to Lower Window" })
vim.api.nvim_set_keymap('n', '<C-k>', '<C-w>k',
    { noremap = true, silent = true, desc = "Move to Upper Window" })
vim.api.nvim_set_keymap('n', '<C-l>', '<C-w>l',
    { noremap = true, silent = true, desc = "Move to Right Window" })

-- Window resizing
vim.api.nvim_set_keymap('n', '<C-Up>', ':resize -2<CR>',
    { noremap = true, silent = true, desc = "Decrease Window Height" })
vim.api.nvim_set_keymap('n', '<C-Down>', ':resize +2<CR>',
    { noremap = true, silent = true, desc = "Increase Window Height" })
vim.api.nvim_set_keymap('n', '<C-Left>', ':vertical resize -2<CR>',
    { noremap = true, silent = true, desc = "Decrease Window Width" })
vim.api.nvim_set_keymap('n', '<C-Right>', ':vertical resize +2<CR>',
    { noremap = true, silent = true, desc = "Increase Window Width" })
vim.api.nvim_set_keymap('n', '<leader>w=', ':vertical resize +5<CR>',
    { noremap = true, silent = true, desc = "Increase Window Width" })
vim.api.nvim_set_keymap('n', '<leader>w-', ':vertical resize -5<CR>',
    { noremap = true, silent = true, desc = "Decrease Window Width" })

-- Move text up and down
vim.api.nvim_set_keymap('n', '<A-j>', ':m .+1<CR>==',
    { noremap = true, silent = true, desc = "Move Line Down" })
vim.api.nvim_set_keymap('n', '<A-k>', ':m .-2<CR>==',
    { noremap = true, silent = true, desc = "Move Line Up" })
-- vim.api.nvim_set_keymap('i', '<A-j>', '<Esc>:m .+1<CR>==gi',
--     { noremap = true, silent = true, desc = "Move Line Down in Insert Mode" })
-- vim.api.nvim_set_keymap('i', '<A-k>', '<Esc>:m .-2<CR>==gi',
--     { noremap = true, silent = true, desc = "Move Line Up in Insert Mode" })
vim.api.nvim_set_keymap('v', '<A-j>', ":m '>+1<CR>gv=gv",
    { noremap = true, silent = true, desc = "Move Selection Down" })
vim.api.nvim_set_keymap('v', '<A-k>', ":m '<-2<CR>gv=gv",
    { noremap = true, silent = true, desc = "Move Selection Up" })

-- Better indenting
vim.api.nvim_set_keymap('v', '<', '<gv',
    { noremap = true, silent = true, desc = "Indent Left and Reselect" })
vim.api.nvim_set_keymap('v', '>', '>gv',
    { noremap = true, silent = true, desc = "Indent Right and Reselect" })

-- Save and Quit shortcuts
vim.api.nvim_set_keymap('n', '<leader>w', ':w<CR>',
    { noremap = true, silent = true, desc = "Save File" })
vim.api.nvim_set_keymap('n', '<leader>qa', ':qa!<CR>',
    { noremap = true, silent = true, desc = "Quit All" })

-- Copy to system clipboard
vim.api.nvim_set_keymap('v', '<leader>y', '"+y',
    { noremap = true, silent = true, desc = "Yank to System Clipboard" })
vim.api.nvim_set_keymap('n', '<leader>Y', 'gg"+yG',
    { noremap = true, silent = true, desc = "Yank Entire Buffer to Clipboard" })

-- Paste from system clipboard
vim.api.nvim_set_keymap('n', '<leader>p', '"+p',
    { noremap = true, silent = true, desc = "Paste from System Clipboard" })
vim.api.nvim_set_keymap('n', '<leader>P', '"+P',
    { noremap = true, silent = true, desc = "Paste Before from System Clipboard" })

-- Search and replace
vim.api.nvim_set_keymap('n', '<leader>sr', ':%s/\\<<C-r><C-w>\\>//g<Left><Left>',
    { noremap = true, silent = false, desc = "Search and Replace Word Under Cursor" })

-- Toggle relative line numbers
vim.api.nvim_set_keymap('n', '<leader>ln', ':set relativenumber!<CR>',
    { noremap = true, silent = true, desc = "Toggle Relative Line Numbers" })

-- Clear search highlighting
vim.api.nvim_set_keymap('n', '<leader>c', ':nohlsearch<CR>',
    { noremap = true, silent = true, desc = "Clear Search Highlighting" })

-- Open config file
vim.api.nvim_set_keymap('n', '<leader>ve', ':e $MYVIMRC<CR>',
    { noremap = true, silent = true, desc = "Edit Neovim Config" })
vim.api.nvim_set_keymap('n', '<leader>vs', ':source $MYVIMRC<CR>',
    { noremap = true, silent = true, desc = "Source Neovim Config" })

-- Toggle spell check
vim.api.nvim_set_keymap('n', '<leader>sp', ':set spell!<CR>',
    { noremap = true, silent = true, desc = "Toggle Spell Check" })

-- Git integration (vim-fugitive)
vim.api.nvim_set_keymap('n', '<leader>gs', ':Git<CR>',
    { noremap = true, silent = true, desc = "Git Status" })
vim.api.nvim_set_keymap('n', '<leader>gc', ':Git commit<CR>',
    { noremap = true, silent = true, desc = "Git Commit" })
vim.api.nvim_set_keymap('n', '<leader>gp', ':Git push<CR>',
    { noremap = true, silent = true, desc = "Git Push" })

-- Toggle wrap mode
vim.api.nvim_set_keymap('n', '<leader>wr', ':set wrap!<CR>',
    { noremap = true, silent = true, desc = "Toggle Wrap Mode" })

-- Close buffer
vim.api.nvim_set_keymap('n', '<leader>bd', ':bd<CR>',
    { noremap = true, silent = true, desc = "Close Buffer" })

-- Quickfix list navigation
vim.api.nvim_set_keymap('n', ']q', ':cnext<CR>',
    { noremap = true, silent = true, desc = "Next Quickfix Item" })
vim.api.nvim_set_keymap('n', '[q', ':cprev<CR>',
    { noremap = true, silent = true, desc = "Previous Quickfix Item" })

-- Undo tree
vim.api.nvim_set_keymap('n', '<leader><F5>', ':UndotreeToggle<CR>',
    { noremap = true, silent = true, desc = "Toggle Undo Tree" })

-- Dismiss notifications
vim.api.nvim_set_keymap("n", "<leader>un", ":lua require('notify').dismiss({ silent = true, pending = true })<CR>",
    { noremap = true, silent = true, desc = "Dismiss Notifications" })

-- Toggle terminal (if using toggleterm.nvim)
vim.api.nvim_set_keymap('n', '<leader>tt', '<cmd>ToggleTerm<CR>',
    { noremap = true, silent = true, desc = "Toggle Terminal" })

-- Commenting (if using Comment.nvim)
vim.api.nvim_set_keymap('n', '<leader>/', '<cmd>lua require("Comment.api").toggle.linewise.current()<CR>',
    { noremap = true, silent = true, desc = "Toggle Comment" })
vim.api.nvim_set_keymap('v', '<leader>/', '<ESC><cmd>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>',
    { noremap = true, silent = true, desc = "Toggle Comment in Selection" })

-- Trouble.nvim keybindings
vim.api.nvim_set_keymap('n', "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>",
    { noremap = true, silent = true, desc = "Toggle Diagnostics (Trouble)" })
vim.api.nvim_set_keymap('n', "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
    { noremap = true, silent = true, desc = "Toggle Diagnostics for Buffer (Trouble)" })
vim.api.nvim_set_keymap('n', "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>",
    { noremap = true, silent = true, desc = "Toggle Symbols (Trouble)" })
vim.api.nvim_set_keymap('n', "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
    { noremap = true, silent = true, desc = "Toggle LSP (Trouble)" })
vim.api.nvim_set_keymap('n', "<leader>xL", "<cmd>Trouble loclist toggle<cr>",
    { noremap = true, silent = true, desc = "Toggle Location List (Trouble)" })
vim.api.nvim_set_keymap('n', "<leader>xQ", "<cmd>Trouble qflist toggle<cr>",
    { noremap = true, silent = true, desc = "Toggle Quickfix List (Trouble)" })
vim.api.nvim_set_keymap('n', "<leader>xt", "<cmd>Trouble todo<cr>",
    { noremap = true, silent = true, desc = "Show TODOs (Trouble)" })
vim.api.nvim_set_keymap('n', "<leader>xT", "<cmd>TodoTelescope<cr>",
    { noremap = true, silent = true, desc = "Search TODOs with Telescope" })

-- Zoxide integration
vim.api.nvim_set_keymap('n', "<leader>cd", "<cmd>Telescope zoxide list<cr>",
    { noremap = true, silent = true, desc = "Zoxide Directory Jump" })

-- Mini.map keybindings
vim.api.nvim_set_keymap('n', "<leader>mo", ":lua require'mini.map'.open()<CR>",
    { noremap = true, silent = true, desc = "Open Mini Map" })
vim.api.nvim_set_keymap('n', "<leader>mc", ":lua require'mini.map'.close()<CR>",
    { noremap = true, silent = true, desc = "Close Mini Map" })
vim.api.nvim_set_keymap('n', "<leader>mt", ":lua require'mini.map'.toggle()<CR>",
    { noremap = true, silent = true, desc = "Toggle Mini Map" })

--yazi
vim.api.nvim_set_keymap('n', "<leader>y", ":lua require'yazi'.yazi()<CR>",
    { noremap = true, silent = true, desc = "Opnen [Y]azi" })

vim.api.nvim_set_keymap('n', "<leader>gg", ":LazyGit<CR>",
    { noremap = true, silent = true, desc = "Lazy [[G]]it" })



-- vim.g.mapleader = " "      -- Make sure to set `mapleader` before lazy so your mappings are correct
-- vim.g.maplocalleader = "," -- Same for `maplocalleader`
-- vim.opt.scrolloff = 6
-- vim.opt.incsearch = true   -- Do incremental searching. map Q gq
-- vim.opt.relativenumber = true
-- vim.opt.number = true
-- vim.opt.ignorecase = true
--
-- vim.opt.tabstop = 4      -- Number of spaces that a <Tab> in the file counts for
-- vim.opt.shiftwidth = 4   -- Number of spaces to use for each step of (auto)indent
-- vim.opt.expandtab = true -- Convert tabs to spaces
--
-- vim.api.nvim_create_autocmd("FocusLost", {
--     pattern = "*",
--     command = "silent! wa"
-- })
--
-- vim.api.nvim_set_keymap("n", "<leader>ff", "<cmd>Telescope find_files<CR>",
--     { noremap = true, silent = true, desc = "Find Files" })
-- vim.api.nvim_set_keymap("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>",
--     { noremap = true, silent = true, desc = "Find Old Files" })
-- vim.api.nvim_set_keymap("n", "<leader>fg", "<cmd>Telescope live_grep<CR>",
--     { noremap = true, silent = true, desc = "Live Grep" })
-- vim.api.nvim_set_keymap("n", "<leader>fb", "<cmd>Telescope buffers<CR>",
--     { noremap = true, silent = true, desc = "Find Buffers" })
-- vim.api.nvim_set_keymap("n", "<leader>fh", "<cmd>Telescope help_tags<CR>",
--     { noremap = true, silent = true, desc = "Find Help Tags" })
-- vim.api.nvim_set_keymap("n", "<leader>fs", "<cmd>Telescope builtin<CR>",
--     { noremap = true, silent = true, desc = "Search Telescope Builtins" })
--
-- vim.api.nvim_set_keymap("n", "<leader>nn", ":NERDTreeFocus<CR>", { silent = true, desc = "Focus NERDTree" })
-- vim.api.nvim_set_keymap("n", "<leader>n", ":NERDTreeFocus<CR>", { silent = true, desc = "Focus NERDTree" })
-- vim.api.nvim_set_keymap("n", "<leader>nt", ":NERDTreeToggle<CR>", { silent = true, desc = "Toggle NERDTree" })
-- vim.api.nvim_set_keymap("n", "<leader>nf", ":NERDTreeFind<CR>", { silent = true, desc = "Find in NERDTree" })
--
-- vim.api.nvim_set_keymap("n", "<leader>t", ":tabnew<CR>", { silent = true, desc = "New Tab" })
-- vim.api.nvim_set_keymap("n", "<leader>q", ":q<CR>", { silent = true, desc = "Quit" })
-- vim.api.nvim_set_keymap("n", "<leader>l", ":tabnext<CR>", { silent = true, desc = "Next Tab" })
-- vim.api.nvim_set_keymap("n", "<leader>h", ":tabprevious<CR>", { silent = true, desc = "Previous Tab" })
--
-- -- notify
-- vim.notify = require('notify')
-- vim.notify("This is an error message", "error")
-- require("notify")("check out LudoPinelli/comment-box.nvim  <>cbccbox")
--
-- vim.api.nvim_set_keymap("n", "<leader>un", ":lua require('notify').dismiss({ silent = true, pending = true })<CR>",
--     { noremap = true, silent = true, desc = "Dismiss Notifications" })
--
-- -- DAP (Debug Adapter Protocol)
-- vim.api.nvim_set_keymap('n', '<F4>', ":lua require('dapui').toggle()<CR>",
--     { noremap = true, silent = true, desc = "Toggle DAP UI" })
-- vim.api.nvim_set_keymap('n', '<F5>', ":lua require'dap'.continue()<CR>",
--     { noremap = true, silent = true, desc = "DAP Continue" })
-- vim.api.nvim_set_keymap('n', '<F6>', ":lua require'dap'.disconnect()<CR>",
--     { noremap = true, silent = true, desc = "DAP Disconnect" })
-- vim.api.nvim_set_keymap('n', '<F10>', ":lua require'dap'.step_over()<CR>",
--     { noremap = true, silent = true, desc = "DAP Step Over" })
-- vim.api.nvim_set_keymap('n', '<F11>', ":lua require'dap'.step_into()<CR>",
--     { noremap = true, silent = true, desc = "DAP Step Into" })
-- vim.api.nvim_set_keymap('n', '<F12>', ":lua require'dap'.step_out()<CR>",
--     { noremap = true, silent = true, desc = "DAP Step Out" })
--
-- vim.api.nvim_set_keymap('n', "<leader>mo", ":lua require'mini.map'.open()<CR>",
--     { noremap = true, silent = true, desc = "Open Mini Map" })
-- vim.api.nvim_set_keymap('n', "<leader>mc", ":lua require'mini.map'.close()<CR>",
--     { noremap = true, silent = true, desc = "Close Mini Map" })
-- vim.api.nvim_set_keymap('n', "<leader>mt", ":lua require'mini.map'.toggle()<CR>",
--     { noremap = true, silent = true, desc = "Toggle Mini Map" })
--
-- -- trouble.nvim
-- vim.api.nvim_set_keymap('n', "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>",
--     { noremap = true, silent = true, desc = "Toggle Diagnostics (Trouble)" })
-- vim.api.nvim_set_keymap('n', "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
--     { noremap = true, silent = true, desc = "Toggle Diagnostics for Buffer (Trouble)" })
-- vim.api.nvim_set_keymap('n', "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>",
--     { noremap = true, silent = true, desc = "Toggle Symbols (Trouble)" })
-- vim.api.nvim_set_keymap('n', "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
--     { noremap = true, silent = true, desc = "Toggle LSP (Trouble)" })
-- vim.api.nvim_set_keymap('n', "<leader>xL", "<cmd>Trouble loclist toggle<cr>",
--     { noremap = true, silent = true, desc = "Toggle Location List (Trouble)" })
-- vim.api.nvim_set_keymap('n', "<leader>xQ", "<cmd>Trouble qflist toggle<cr>",
--     { noremap = true, silent = true, desc = "Toggle Quickfix List (Trouble)" })
-- vim.api.nvim_set_keymap('n', "<leader>xt", "<cmd>Trouble todo<cr>",
--     { noremap = true, silent = true, desc = "Show TODOs (Trouble)" })
-- vim.api.nvim_set_keymap('n', "<leader>xT", "<cmd>TodoTelescope<cr>",
--     { noremap = true, silent = true, desc = "Search TODOs with Telescope" })
--
-- vim.api.nvim_set_keymap('n', "<leader>cd", "<cmd>Telescope zoxide list<cr>",
--     { noremap = true, silent = true, desc = "Zoxide Directory Jump" })
--
-- vim.api.nvim_set_keymap('n', '<leader>sv', ':vsp<CR>',
--     { noremap = true, silent = true, desc = "Vertical Split" })
-- vim.api.nvim_set_keymap('n', '<leader>sh', ':sp<CR>',
--     { noremap = true, silent = true, desc = "Horizontal Split" })
--
-- vim.api.nvim_set_keymap('n', '<leader>bn', ':bnext<CR>',
--     { noremap = true, silent = true, desc = "Next Buffer" })
-- vim.api.nvim_set_keymap('n', '<leader>bp', ':bprevious<CR>',
--     { noremap = true, silent = true, desc = "Previous Buffer" })
-- vim.api.nvim_set_keymap('n', '<leader>w=', ':vertical resize +5<CR>',
--     { noremap = true, silent = true, desc = "Increase Window Width" })
-- vim.api.nvim_set_keymap('n', '<leader>w-', ':vertical resize -5<CR>',
--     { noremap = true, silent = true, desc = "Decrease Window Width" })
--
-- vim.api.nvim_set_keymap('n', '<leader><F5>', ':UndotreeToggle<CR>',
--     { noremap = true, silent = true, desc = "Toggle Undo Tree" })
--
-- vim.api.nvim_set_keymap('n', '<leader>1', ':1gt<CR>',
--     { noremap = true, silent = true, desc = "Go to Tab 1" })
-- vim.api.nvim_set_keymap('n', '<leader>2', ':2gt<CR>',
--     { noremap = true, silent = true, desc = "Go to Tab 2" })
-- vim.api.nvim_set_keymap('n', '<leader>3', ':3gt<CR>',
--     { noremap = true, silent = true, desc = "Go to Tab 3" })
-- vim.api.nvim_set_keymap('n', '<leader>4', ':4gt<CR>',
--     { noremap = true, silent = true, desc = "Go to Tab 4" })
-- vim.api.nvim_set_keymap('n', '<leader>5', ':5gt<CR>',
--     { noremap = true, silent = true, desc = "Go to Tab 5" })
-- vim.api.nvim_set_keymap('n', '<leader>6', ':6gt<CR>',
--     { noremap = true, silent = true, desc = "Go to Tab 5" })
-- vim.api.nvim_set_keymap('n', '<leader>7', ':7gt<CR>',
--     { noremap = true, silent = true, desc = "Go to Tab 5" })


























opt.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]

-- Configure Neovim diagnostic messages

local function prefix_diagnostic(prefix, diagnostic)
  return string.format(prefix .. ' %s', diagnostic.message)
end

vim.diagnostic.config {
  virtual_text = {
    prefix = '',
    format = function(diagnostic)
      local severity = diagnostic.severity
      if severity == vim.diagnostic.severity.ERROR then
        return prefix_diagnostic('󰅚', diagnostic)
      end
      if severity == vim.diagnostic.severity.WARN then
        return prefix_diagnostic('⚠', diagnostic)
      end
      if severity == vim.diagnostic.severity.INFO then
        return prefix_diagnostic('ⓘ', diagnostic)
      end
      if severity == vim.diagnostic.severity.HINT then
        return prefix_diagnostic('󰌶', diagnostic)
      end
      return prefix_diagnostic('■', diagnostic)
    end,
  },
  signs = {
    text = {
      -- Requires Nerd fonts
      [vim.diagnostic.severity.ERROR] = '󰅚',
      [vim.diagnostic.severity.WARN] = '⚠',
      [vim.diagnostic.severity.INFO] = 'ⓘ',
      [vim.diagnostic.severity.HINT] = '󰌶',
    },
  },
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  float = {
    focusable = false,
    style = 'minimal',
    border = 'rounded',
    source = 'if_many',
    header = '',
    prefix = '',
  },
}

g.editorconfig = true

vim.opt.colorcolumn = '100'

-- Native plugins
cmd.filetype('plugin', 'indent', 'on')
cmd.packadd('cfilter') -- Allows filtering the quickfix list with :cfdo

-- let sqlite.lua (which some plugins depend on) know where to find sqlite
vim.g.sqlite_clib_path = require('luv').os_getenv('LIBSQLITE')

require('user.mason')
require('user.nvimLint')

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  callback = function()

    -- try_lint without arguments runs the linters defined in `linters_by_ft`
    -- for the current filetype
    require("lint").try_lint()

    -- You can call `try_lint` with a linter name or a list of names to always
    -- run specific linters, independent of the `linters_by_ft` configuration
    -- require("lint").try_lint("cspell")
  end,
})
