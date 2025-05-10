local cmd = vim.cmd
local fn = vim.fn
local opt = vim.o
local g = vim.g

-- Temporary supression of deprecated functions
vim.tbl_islist = vim.islist or vim.tbl_islist

-- Set leader keys
g.mapleader = " " -- Make sure to set `mapleader` before lazy so your mappings are correct
g.maplocalleader = "," -- Same for `maplocalleader`
g.editorconfig = true
-- let sqlite.lua (which some plugins depend on) know where to find sqlite
g.sqlite_clib_path = require("luv").os_getenv("LIBSQLITE")
g.copilot_enabled = false
-- Native plugins

cmd.filetype("plugin", "indent", "on")
cmd.packadd("cfilter") -- Allows filtering the quickfix list with :cfdo
-- Colorscheme
cmd("colorscheme gruvbox")

-- General settings
opt.compatible = false
opt.scrolloff = 6
opt.incsearch = true -- Do incremental searching
opt.relativenumber = true
opt.number = true
opt.ignorecase = true
opt.foldcolumn = "1" -- '0' is not bad
opt.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
opt.foldlevelstart = 99
opt.foldenable = true

-- Search down into subfolders
opt.path = vim.o.path .. "**"
opt.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]

-- Indentation settings
opt.tabstop = 4 -- Number of spaces that a <Tab> in the file counts for
opt.shiftwidth = 4 -- Number of spaces to use for each step of (auto)indent
opt.expandtab = true -- Convert tabs to spaces

-- Enable true colour support
if fn.has("termguicolors") then
	opt.termguicolors = true
end

-- Auto-save when focus is lost
vim.api.nvim_create_autocmd("FocusLost", {
	pattern = "*",
	command = "silent! wa",
})

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		require("conform").format({ bufnr = args.buf })
	end,
})
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	callback = function()
		require("lint").try_lint()
	end,
})

require("user.mason")
require("user.nvimLint")
require("user.conform")
require("user.neoscroll")
require("user.harpoon")
require("user.codeSnap")
require("user.codeCompanion")
require("user.twilight")
require("user.nvimUfo")
require("user.kulala")

-- Telescope keybindings
vim.api.nvim_set_keymap(
	"n",
	"<leader>ff",
	"<cmd>Telescope find_files<CR>",
	{ noremap = true, silent = true, desc = "Find Files" }
)
vim.api.nvim_set_keymap(
	"n",
	"<leader>fo",
	"<cmd>Telescope oldfiles<CR>",
	{ noremap = true, silent = true, desc = "Find Old Files" }
)
vim.api.nvim_set_keymap(
	"n",
	"<leader>fg",
	"<cmd>Telescope live_grep<CR>",
	{ noremap = true, silent = true, desc = "Live Grep" }
)
vim.api.nvim_set_keymap(
	"n",
	"<leader>fb",
	"<cmd>Telescope buffers<CR>",
	{ noremap = true, silent = true, desc = "Find Buffers" }
)
vim.api.nvim_set_keymap(
	"n",
	"<leader>fh",
	"<cmd>Telescope help_tags<CR>",
	{ noremap = true, silent = true, desc = "Find Help Tags" }
)
vim.api.nvim_set_keymap(
	"n",
	"<leader>fs",
	"<cmd>Telescope builtin<CR>",
	{ noremap = true, silent = true, desc = "Search Telescope Builtins" }
)
vim.api.nvim_set_keymap(
	"n",
	"<leader>fc",
	"<cmd>Telescope commands<CR>",
	{ noremap = true, silent = true, desc = "Find Commands" }
)
vim.api.nvim_set_keymap(
	"n",
	"<leader>fk",
	"<cmd>Telescope keymaps<CR>",
	{ noremap = true, silent = true, desc = "Find Keymaps" }
)
vim.api.nvim_set_keymap(
	"n",
	"<leader>fm",
	"<cmd>Telescope marks<CR>",
	{ noremap = true, silent = true, desc = "Find Marks" }
)

-- NERDTree keybindings
vim.api.nvim_set_keymap("n", "<leader>nf", ":NERDTreeFind<CR>", { silent = true, desc = "Focus NERDTree" })
vim.api.nvim_set_keymap("n", "<leader>nt", ":NERDTreeToggle<CR>", { silent = true, desc = "Toggle NERDTree" })

-- NeoFormat keybinding

vim.api.nvim_set_keymap(
	"n",
	"<leader>nn",
	":lua print('Linting and Formatting...'); require('lint').try_lint(); require('conform').format({ async = false, lsp_fallback = true })<CR>",
	{ noremap = true, silent = false, desc = "Lint then Format with Conform" }
)

-- neogen
vim.api.nvim_set_keymap(
	"n",
	"<Leader>nc",
	":lua require'neogen'.generate()<CR>",
	{ noremap = true, silent = true, desc = " [C]omment Documentation Generation" }
)

-- Tab management
-- vim.api.nvim_set_keymap("n", "<leader>t", ":tabnew<CR>",
--     { silent = true, desc = "New Tab" })
vim.api.nvim_set_keymap("n", "<leader>q", ":q<CR>", { silent = true, desc = "Quit" })
vim.api.nvim_set_keymap("n", "<leader>l", ":tabnext<CR>", { silent = true, desc = "Next Tab" })
vim.api.nvim_set_keymap("n", "<leader>h", ":tabprevious<CR>", { silent = true, desc = "Previous Tab" })
vim.api.nvim_set_keymap("n", "<leader>1", "1gt<CR>", { noremap = true, silent = true, desc = "Go to Tab 1" })
vim.api.nvim_set_keymap("n", "<leader>2", "2gt<CR>", { noremap = true, silent = true, desc = "Go to Tab 2" })
vim.api.nvim_set_keymap("n", "<leader>3", "3gt<CR>", { noremap = true, silent = true, desc = "Go to Tab 3" })
vim.api.nvim_set_keymap("n", "<leader>4", "4gt<CR>", { noremap = true, silent = true, desc = "Go to Tab 4" })
vim.api.nvim_set_keymap("n", "<leader>5", "5gt<CR>", { noremap = true, silent = true, desc = "Go to Tab 5" })

-- Buffer navigation
vim.api.nvim_set_keymap("n", "<leader>bn", ":bnext<CR>", { noremap = true, silent = true, desc = "Next Buffer" })
vim.api.nvim_set_keymap(
	"n",
	"<leader>bp",
	":bprevious<CR>",
	{ noremap = true, silent = true, desc = "Previous Buffer" }
)
vim.api.nvim_set_keymap("n", "<leader>bd", ":bd<CR>", { noremap = true, silent = true, desc = "Close Buffer" })

-- Window management
vim.api.nvim_set_keymap("n", "<leader>sv", ":vsp<CR>", { noremap = true, silent = true, desc = "Vertical Split" })
vim.api.nvim_set_keymap("n", "<leader>sh", ":sp<CR>", { noremap = true, silent = true, desc = "Horizontal Split" })

-- Window navigation
vim.api.nvim_set_keymap("n", "<C-h>", "<C-w>h", { noremap = true, silent = true, desc = "Move to Left Window" })
vim.api.nvim_set_keymap("n", "<C-j>", "<C-w>j", { noremap = true, silent = true, desc = "Move to Lower Window" })
vim.api.nvim_set_keymap("n", "<C-k>", "<C-w>k", { noremap = true, silent = true, desc = "Move to Upper Window" })
vim.api.nvim_set_keymap("n", "<C-l>", "<C-w>l", { noremap = true, silent = true, desc = "Move to Right Window" })

-- Window resizing
vim.api.nvim_set_keymap(
	"n",
	"<C-Up>",
	":resize -2<CR>",
	{ noremap = true, silent = true, desc = "Decrease Window Height" }
)
vim.api.nvim_set_keymap(
	"n",
	"<C-Down>",
	":resize +2<CR>",
	{ noremap = true, silent = true, desc = "Increase Window Height" }
)
vim.api.nvim_set_keymap(
	"n",
	"<C-Left>",
	":vertical resize -2<CR>",
	{ noremap = true, silent = true, desc = "Decrease Window Width" }
)
vim.api.nvim_set_keymap(
	"n",
	"<C-Right>",
	":vertical resize +2<CR>",
	{ noremap = true, silent = true, desc = "Increase Window Width" }
)
vim.api.nvim_set_keymap(
	"n",
	"<leader>w=",
	":vertical resize +5<CR>",
	{ noremap = true, silent = true, desc = "Increase Window Width" }
)
vim.api.nvim_set_keymap(
	"n",
	"<leader>w-",
	":vertical resize -5<CR>",
	{ noremap = true, silent = true, desc = "Decrease Window Width" }
)

-- Move text up and down
-- vim.api.nvim_set_keymap('n', '<A-j>', ':m .+1<CR>==',
--     { noremap = true, silent = true, desc = "Move Line Down" })
-- vim.api.nvim_set_keymap('n', '<A-k>', ':m .-2<CR>==',
--     { noremap = true, silent = true, desc = "Move Line Up" })
-- vim.api.nvim_set_keymap('i', '<A-j>', '<Esc>:m .+1<CR>==gi',
--     { noremap = true, silent = true, desc = "Move Line Down in Insert Mode" })
-- vim.api.nvim_set_keymap('i', '<A-k>', '<Esc>:m .-2<CR>==gi',
--     { noremap = true, silent = true, desc = "Move Line Up in Insert Mode" })
vim.api.nvim_set_keymap(
	"v",
	"<A-j>",
	":m '>+1<CR>gv=gv",
	{ noremap = true, silent = true, desc = "Move Selection Down" }
)
vim.api.nvim_set_keymap("v", "<A-k>", ":m '<-2<CR>gv=gv", { noremap = true, silent = true, desc = "Move Selection Up" })

-- Better indenting
vim.api.nvim_set_keymap("v", "<", "<gv", { noremap = true, silent = true, desc = "Indent Left and Reselect" })
vim.api.nvim_set_keymap("v", ">", ">gv", { noremap = true, silent = true, desc = "Indent Right and Reselect" })

-- Save and Quit shortcuts
vim.api.nvim_set_keymap("n", "<leader>w", ":w<CR>", { noremap = true, silent = true, desc = "Save File" })
vim.api.nvim_set_keymap("n", "<leader>qa", ":qa!<CR>", { noremap = true, silent = true, desc = "Quit All" })

-- Copy to system clipboard
vim.api.nvim_set_keymap("v", "<leader>y", '"+y', { noremap = true, silent = true, desc = "Yank to System Clipboard" })
vim.api.nvim_set_keymap(
	"n",
	"<leader>Y",
	'gg"+yG',
	{ noremap = true, silent = true, desc = "Yank Entire Buffer to Clipboard" }
)

-- Paste from system clipboard
vim.api.nvim_set_keymap(
	"n",
	"<leader>p",
	'"+p',
	{ noremap = true, silent = true, desc = "Paste from System Clipboard" }
)
vim.api.nvim_set_keymap(
	"n",
	"<leader>P",
	'"+P',
	{ noremap = true, silent = true, desc = "Paste Before from System Clipboard" }
)

-- Search and replace
vim.api.nvim_set_keymap(
	"n",
	"<leader>sr",
	":%s/\\<<C-r><C-w>\\>//g<Left><Left>",
	{ noremap = true, silent = false, desc = "Search and Replace Word Under Cursor" }
)

-- Toggle relative line numbers
vim.api.nvim_set_keymap(
	"n",
	"<leader>ln",
	":set relativenumber!<CR>",
	{ noremap = true, silent = true, desc = "Toggle Relative Line Numbers" }
)

-- Clear search highlighting
vim.api.nvim_set_keymap(
	"n",
	"<leader>cc",
	":nohlsearch<CR>",
	{ noremap = true, silent = true, desc = "Clear Search Highlighting" }
)

-- Open config file
vim.api.nvim_set_keymap(
	"n",
	"<leader>ve",
	":e $MYVIMRC<CR>",
	{ noremap = true, silent = true, desc = "Edit Neovim Config" }
)
vim.api.nvim_set_keymap(
	"n",
	"<leader>vs",
	":source $MYVIMRC<CR>",
	{ noremap = true, silent = true, desc = "Source Neovim Config" }
)

-- Toggle spell check
vim.api.nvim_set_keymap(
	"n",
	"<leader>sp",
	":set spell!<CR>",
	{ noremap = true, silent = true, desc = "Toggle Spell Check" }
)

-- Git integration (vim-fugitive)
vim.api.nvim_set_keymap("n", "<leader>gs", ":Git<CR>", { noremap = true, silent = true, desc = "Git Status" })
vim.api.nvim_set_keymap("n", "<leader>gc", ":Git commit<CR>", { noremap = true, silent = true, desc = "Git Commit" })
vim.api.nvim_set_keymap("n", "<leader>gp", ":Git push<CR>", { noremap = true, silent = true, desc = "Git Push" })

-- Toggle wrap mode
vim.api.nvim_set_keymap(
	"n",
	"<leader>wr",
	":set wrap!<CR>",
	{ noremap = true, silent = true, desc = "Toggle Wrap Mode" }
)

-- Close buffer
vim.api.nvim_set_keymap("n", "<leader>bd", ":bd<CR>", { noremap = true, silent = true, desc = "Close Buffer" })

-- Quickfix list navigation
vim.api.nvim_set_keymap("n", "]q", ":cnext<CR>", { noremap = true, silent = true, desc = "Next Quickfix Item" })
vim.api.nvim_set_keymap("n", "[q", ":cprev<CR>", { noremap = true, silent = true, desc = "Previous Quickfix Item" })

-- Undo tree
vim.api.nvim_set_keymap(
	"n",
	"<leader><F5>",
	":UndotreeToggle<CR>",
	{ noremap = true, silent = true, desc = "Toggle Undo Tree" }
)

-- Dismiss notifications
vim.api.nvim_set_keymap(
	"n",
	"<leader>un",
	":lua require('notify').dismiss({ silent = true, pending = true })<CR>",
	{ noremap = true, silent = true, desc = "Dismiss Notifications" }
)

-- Toggle terminal (if using toggleterm.nvim)
vim.api.nvim_set_keymap(
	"n",
	"<leader>tt",
	"<cmd>ToggleTerm<CR>",
	{ noremap = true, silent = true, desc = "Toggle Terminal" }
)

-- Commenting (if using Comment.nvim)
vim.api.nvim_set_keymap(
	"n",
	"<leader>/",
	'<cmd>lua require("Comment.api").toggle.linewise.current()<CR>',
	{ noremap = true, silent = true, desc = "Toggle Comment" }
)
vim.api.nvim_set_keymap(
	"v",
	"<leader>/",
	'<ESC><cmd>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>',
	{ noremap = true, silent = true, desc = "Toggle Comment in Selection" }
)

-- Trouble.nvim keybindings
vim.api.nvim_set_keymap(
	"n",
	"<leader>xx",
	"<cmd>Trouble diagnostics toggle<cr>",
	{ noremap = true, silent = true, desc = "Toggle Diagnostics (Trouble)" }
)
vim.api.nvim_set_keymap(
	"n",
	"<leader>xX",
	"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
	{ noremap = true, silent = true, desc = "Toggle Diagnostics for Buffer (Trouble)" }
)
vim.api.nvim_set_keymap(
	"n",
	"<leader>xs",
	"<cmd>Trouble symbols toggle focus=false<cr>",
	{ noremap = true, silent = true, desc = "Toggle Symbols (Trouble)" }
)
vim.api.nvim_set_keymap(
	"n",
	"<leader>xl",
	"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
	{ noremap = true, silent = true, desc = "Toggle LSP (Trouble)" }
)
vim.api.nvim_set_keymap(
	"n",
	"<leader>xL",
	"<cmd>Trouble loclist toggle<cr>",
	{ noremap = true, silent = true, desc = "Toggle Location List (Trouble)" }
)
vim.api.nvim_set_keymap(
	"n",
	"<leader>xQ",
	"<cmd>Trouble qflist toggle<cr>",
	{ noremap = true, silent = true, desc = "Toggle Quickfix List (Troule)" }
)
vim.api.nvim_set_keymap(
	"n",
	"<leader>xt",
	"<cmd>Trouble todo<cr>",
	{ noremap = true, silent = true, desc = "Show TODOs (Trouble)" }
)
vim.api.nvim_set_keymap(
	"n",
	"<leader>xw",
	"<cmd>Trouble diagnostics toggle focus=false<cr>",
	{ noremap = true, silent = true, desc = "Workspace Diagnostics (Trouble)" }
)

vim.api.nvim_set_keymap(
	"n",
	"<leader>xT",
	"<cmd>TodoTelescope<cr>",
	{ noremap = true, silent = true, desc = "Search TODOs with Telescope" }
)

-- Zoxide integration
vim.api.nvim_set_keymap(
	"n",
	"<leader>cd",
	"<cmd>Telescope zoxide list<cr>",
	{ noremap = true, silent = true, desc = "Zoxide Directory Jump" }
)

--yazi
vim.api.nvim_set_keymap(
	"n",
	"<leader>y",
	":lua require'yazi'.yazi()<CR>",
	{ noremap = true, silent = true, desc = "Opnen [Y]azi" }
)

vim.api.nvim_set_keymap("n", "<leader>gg", ":LazyGit<CR>", { noremap = true, silent = true, desc = "Lazy [[G]]it" })

-- DAP (Debug Adapter Protocol) UI toggling, continue, disconnect, stepping, and breakpoints
vim.api.nvim_set_keymap(
	"n",
	"<F1>",
	":lua require('dapui').toggle()<CR>",
	{ noremap = true, silent = true, desc = "Toggle DAP UI" }
)
vim.api.nvim_set_keymap(
	"n",
	"<F5>",
	":lua require('dap').step_over()<CR>",
	{ noremap = true, silent = true, desc = "DAP Step Over" }
)
vim.api.nvim_set_keymap(
	"n",
	"<F6>",
	":lua require('dap').continue()<CR>",
	{ noremap = true, silent = true, desc = "DAP Continue" }
)
vim.api.nvim_set_keymap(
	"n",
	"<F4>",
	":lua require('dap').step_into()<CR>",
	{ noremap = true, silent = true, desc = "DAP Step Into" }
)
vim.api.nvim_set_keymap(
	"n",
	"<F3>",
	":lua require('dap').step_out()<CR>",
	{ noremap = true, silent = true, desc = "DAP Step Out" }
)
-- DAP Widgets (under <leader>d prefix)
vim.api.nvim_set_keymap(
	"n",
	"<leader>eh",
	":lua require('dap.ui.widgets').hover()<CR>",
	{ noremap = true, silent = true, desc = "DAP Hover Variable" }
)
vim.api.nvim_set_keymap(
	"n",
	"<leader>es",
	":lua local widgets=require('dap.ui.widgets');widgets.centered_float(widgets.scopes)<CR>",
	{ noremap = true, silent = true, desc = "DAP Show Scopes" }
)
vim.api.nvim_set_keymap(
	"n",
	"<leader>ef",
	":lua local widgets=require('dap.ui.widgets');widgets.centered_float(widgets.frames)<CR>",
	{ noremap = true, silent = true, desc = "DAP Show Frames" }
)

vim.api.nvim_set_keymap(
	"n",
	"<leader>ed",
	":lua require('dap').disconnect()<CR>",
	{ noremap = true, silent = true, desc = "DAP Disconnect" }
)
-- Breakpoints: toggle breakpoint, conditional breakpoint, and clear all breakpoints
vim.api.nvim_set_keymap(
	"n",
	"<leader>eb",
	":lua require('dap').toggle_breakpoint()<CR>",
	{ noremap = true, silent = true, desc = "Toggle Breakpoint" }
)
vim.api.nvim_set_keymap(
	"n",
	"<leader>eB",
	":lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
	{ noremap = true, silent = true, desc = "Set Conditional Breakpoint" }
)
vim.api.nvim_set_keymap(
	"n",
	"<leader>eC",
	":lua require('dap').clear_breakpoints()<CR>",
	{ noremap = true, silent = true, desc = "Clear All Breakpoints" }
)

-- Open DAP REPL
vim.api.nvim_set_keymap(
	"n",
	"<leader>er",
	":lua require('dap').repl.open()<CR>",
	{ noremap = true, silent = true, desc = "Open DAP REPL" }
)

-- Miscellaneous keybindings
vim.api.nvim_set_keymap(
	"n",
	"<leader>mm",
	":lua require'mini.map'.toggle()<CR>",
	{ noremap = true, silent = true, desc = "[M]isscellineous [M]ini Map [T]oggle" }
)
vim.api.nvim_set_keymap(
	"n",
	"<leader>mt",
	"<cmd>Twilight<CR>",
	{ noremap = true, silent = true, desc = "[M]isscellineous [T]wilight" }
)
vim.api.nvim_set_keymap(
	"n",
	"<leader>mt",
	"<cmd>Twilight<CR>",
	{ noremap = true, silent = true, desc = "[M]isscellineous [T]wilight" }
)

-- refactor
vim.keymap.set({ "n", "x" }, "<leader>re", function()
	return require("refactoring").refactor("Extract Function")
end, { expr = true, desc = "Extract Function" })

vim.keymap.set({ "n", "x" }, "<leader>rf", function()
	return require("refactoring").refactor("Extract Function To File")
end, { expr = true, desc = "Extract Function To File" })

vim.keymap.set({ "n", "x" }, "<leader>rv", function()
	return require("refactoring").refactor("Extract Variable")
end, { expr = true, desc = "Extract Variable" })

vim.keymap.set({ "n", "x" }, "<leader>rI", function()
	return require("refactoring").refactor("Inline Function")
end, { expr = true, desc = "Inline Function" })

vim.keymap.set({ "n", "x" }, "<leader>ri", function()
	return require("refactoring").refactor("Inline Variable")
end, { expr = true, desc = "Inline Variable" })

vim.keymap.set({ "n", "x" }, "<leader>rbb", function()
	return require("refactoring").refactor("Extract Block")
end, { expr = true, desc = "Extract Block" })

vim.keymap.set({ "n", "x" }, "<leader>rbf", function()
	return require("refactoring").refactor("Extract Block To File")
end, { expr = true, desc = "Extract Block To File" })

-- Configure Neovim diagnostic messages
local function prefix_diagnostic(prefix, diagnostic)
	return string.format(prefix .. " %s", diagnostic.message)
end

vim.diagnostic.config({
	virtual_text = {
		prefix = "",
		format = function(diagnostic)
			local severity = diagnostic.severity
			if severity == vim.diagnostic.severity.ERROR then
				return prefix_diagnostic("󰅚", diagnostic)
			end
			if severity == vim.diagnostic.severity.WARN then
				return prefix_diagnostic("⚠", diagnostic)
			end
			if severity == vim.diagnostic.severity.INFO then
				return prefix_diagnostic("ⓘ", diagnostic)
			end
			if severity == vim.diagnostic.severity.HINT then
				return prefix_diagnostic("󰌶", diagnostic)
			end
			return prefix_diagnostic("■", diagnostic)
		end,
	},
	signs = {
		text = {
			-- Requires Nerd fonts
			[vim.diagnostic.severity.ERROR] = "󰅚",
			[vim.diagnostic.severity.WARN] = "⚠",
			[vim.diagnostic.severity.INFO] = "ⓘ",
			[vim.diagnostic.severity.HINT] = "󰌶",
		},
	},
	update_in_insert = false,
	underline = true,
	severity_sort = true,
	float = {
		focusable = false,
		style = "minimal",
		border = "rounded",
		source = "if_many",
		header = "",
		prefix = "",
	},
})

-- Kulala HTTP Client Keybindings
-- Robust configuration for making HTTP requests within Neovim
vim.keymap.set("n", "<leader>ks", function()
	local kulala = require("kulala")
	kulala.run()
end, { noremap = true, silent = true, desc = "Execute HTTP request under cursor" })

vim.keymap.set("n", "<leader>ka", function()
	local kulala = require("kulala")
	kulala.run_all()
end, { noremap = true, silent = true, desc = "Execute all HTTP requests in file" })

vim.keymap.set("n", "<leader>kr", function()
	local kulala = require("kulala")
	kulala.replay()
end, { noremap = true, silent = true, desc = "Replay last HTTP request" })

vim.keymap.set("n", "<leader>kb", function()
	local kulala = require("kulala.ui")
	kulala.show_body()
end, { noremap = true, silent = true, desc = "Display response body" })
vim.keymap.set("n", "<leader>kh", function()
	local kulala = require("kulala.ui")
	kulala.show_headers()
end, { noremap = true, silent = true, desc = "Display response headers" })

vim.keymap.set("n", "<leader>kS", function()
	require("kulala").scratchpad()
end, { noremap = true, silent = true, desc = "Open HTTP request scratchpad" })

vim.keymap.set("n", "<leader>ko", function()
	require("kulala").open()
end, { noremap = true, silent = true, desc = "Open request in new buffer" })

vim.keymap.set("n", "<leader>kt", function()
	require("kulala").toggle_view()
end, { noremap = true, silent = true, desc = "Toggle between request/response views" })

vim.keymap.set("n", "<leader>kf", function()
	require("kulala").search()
end, { noremap = true, silent = true, desc = "Search for HTTP endpoints" })

vim.keymap.set("n", "<leader>kc", function()
	require("kulala").copy()
end, { noremap = true, silent = true, desc = "Copy HTTP command to clipboard" })
