-- Global keymaps. Plugin-specific maps that should only exist once the
-- plugin is loaded live in their plugin's config module instead
-- (user/dap.lua, user/kulala.lua, user/harpoon.lua, user/telescope.lua).

local map = vim.keymap.set

-- ============================================================================
-- Telescope (commands are stubs until telescope loads on DeferredUIEnter;
-- <leader>ff / <leader>fF are defined in user/telescope.lua)
-- ============================================================================
map("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", { silent = true, desc = "Find Old Files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { silent = true, desc = "Live Grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { silent = true, desc = "Find Buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { silent = true, desc = "Find Help Tags" })
map("n", "<leader>fs", "<cmd>Telescope builtin<CR>", { silent = true, desc = "Search Telescope Builtins" })
map("n", "<leader>fc", "<cmd>Telescope commands<CR>", { silent = true, desc = "Find Commands" })
map("n", "<leader>fk", "<cmd>Telescope keymaps<CR>", { silent = true, desc = "Find Keymaps" })
map("n", "<leader>fm", "<cmd>Telescope marks<CR>", { silent = true, desc = "Find Marks" })
map("n", "<leader>cd", "<cmd>Telescope zoxide list<cr>", { silent = true, desc = "Zoxide Directory Jump" })

-- ============================================================================
-- Neo-tree
-- ============================================================================
map("n", "<leader>nf", "<cmd>Neotree reveal<CR>", { silent = true, desc = "Find file in neo-tree" })
map("n", "<leader>nt", "<cmd>Neotree toggle<CR>", { silent = true, desc = "Toggle neo-tree" })

-- ============================================================================
-- Lint + format
-- ============================================================================
map("n", "<leader>nn", function()
	print("Linting and Formatting...")
	require("lint").try_lint()
	require("conform").format({ async = false, lsp_fallback = true })
end, { desc = "Lint then Format with Conform" })

-- neogen
map("n", "<Leader>nc", function()
	require("neogen").generate()
end, { silent = true, desc = " [C]omment Documentation Generation" })

-- ============================================================================
-- Buffers, tabs, windows
-- ============================================================================
map("n", "<leader>q", ":q<CR>", { silent = true, desc = "Quit" })
map("n", "<leader>l", ":bnext<CR>", { silent = true, desc = "Next Buffer" })
map("n", "<leader>h", ":bprev<CR>", { silent = true, desc = "Previous Buffer" })
for i = 1, 5 do
	map("n", "<leader>" .. i, i .. "gt", { silent = true, desc = "Go to Tab " .. i })
end
map("n", "<leader>bd", ":bd<CR>", { silent = true, desc = "Close Buffer" })
map("n", "<leader>bo", ":%bd|e#|bd#<CR>", { silent = true, desc = "Close All Buffers Except Current" })

map("n", "<leader>sv", ":vsp<CR>", { silent = true, desc = "Vertical Split" })
map("n", "<leader>sh", ":sp<CR>", { silent = true, desc = "Horizontal Split" })

-- Window navigation
map("n", "<C-h>", "<C-w>h", { silent = true, desc = "Move to Left Window" })
map("n", "<C-j>", "<C-w>j", { silent = true, desc = "Move to Lower Window" })
map("n", "<C-k>", "<C-w>k", { silent = true, desc = "Move to Upper Window" })
map("n", "<C-l>", "<C-w>l", { silent = true, desc = "Move to Right Window" })

-- Window resizing
map("n", "<C-Up>", ":resize -2<CR>", { silent = true, desc = "Decrease Window Height" })
map("n", "<C-Down>", ":resize +2<CR>", { silent = true, desc = "Increase Window Height" })
map("n", "<C-Left>", ":vertical resize -2<CR>", { silent = true, desc = "Decrease Window Width" })
map("n", "<C-Right>", ":vertical resize +2<CR>", { silent = true, desc = "Increase Window Width" })

-- Move selection up/down
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { silent = true, desc = "Move Selection Down" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { silent = true, desc = "Move Selection Up" })

-- Better indenting
map("v", "<", "<gv", { silent = true, desc = "Indent Left and Reselect" })
map("v", ">", ">gv", { silent = true, desc = "Indent Right and Reselect" })

-- Save (no other <leader>w* maps — keeps it instant, no timeoutlen wait)
map("n", "<leader>w", ":w<CR>", { silent = true, desc = "Save File" })

-- ============================================================================
-- Clipboard
-- ============================================================================
map("v", "<leader>y", '"+y', { silent = true, desc = "Yank to System Clipboard" })
map("n", "<leader>Y", 'gg"+yG', { silent = true, desc = "Yank Entire Buffer to Clipboard" })

-- ============================================================================
-- Search / replace / toggles
-- ============================================================================
map(
	"n",
	"<leader>sr",
	":%s/\\<<C-r><C-w>\\>//g<Left><Left>",
	{ desc = "Search and Replace Word Under Cursor" }
)
map(
	"v",
	"<leader>sr",
	'"zy:%s/\\(<C-r>z\\)/\\1/g<Left><Left><Left>',
	{ desc = "Search and Replace Selection with Capture Group" }
)
map("n", "<leader>tl", ":set relativenumber!<CR>", { silent = true, desc = "[T]oggle Relative [L]ine Numbers" })
map("n", "<leader>ch", ":nohlsearch<CR>", { silent = true, desc = "Clear Search Highlighting" })
map("n", "<leader>sp", ":set spell!<CR>", { silent = true, desc = "Toggle Spell Check" })
map("n", "<leader>tw", ":set wrap!<CR>", { silent = true, desc = "[T]oggle [W]rap Mode" })

-- ============================================================================
-- Git (vim-fugitive)
-- ============================================================================
map("n", "<leader>gs", ":Git<CR>", { silent = true, desc = "Git Status" })
map("n", "<leader>gc", ":Git commit<CR>", { silent = true, desc = "Git Commit" })
map("n", "<leader>gp", ":Git push<CR>", { silent = true, desc = "Git Push" })

-- ============================================================================
-- Quickfix
-- ============================================================================
map("n", "]q", ":cnext<CR>", { silent = true, desc = "Next Quickfix Item" })
map("n", "[q", ":cprev<CR>", { silent = true, desc = "Previous Quickfix Item" })

-- Undo tree
map("n", "<leader><F5>", ":UndotreeToggle<CR>", { silent = true, desc = "Toggle Undo Tree" })

-- Toggle terminal
map("n", "<leader>tt", "<cmd>ToggleTerm<CR>", { silent = true, desc = "Toggle Terminal" })

-- ============================================================================
-- Commenting (Comment.nvim)
-- ============================================================================
map("n", "<leader>/", function()
	require("Comment.api").toggle.linewise.current()
end, { silent = true, desc = "Toggle Comment" })
map(
	"v",
	"<leader>/",
	'<ESC><cmd>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>',
	{ silent = true, desc = "Toggle Comment in Selection" }
)

-- ============================================================================
-- Trouble
-- ============================================================================
map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { silent = true, desc = "Toggle Diagnostics (Trouble)" })
map(
	"n",
	"<leader>xe",
	"<cmd>Trouble diagnostics toggle filter.severity=ERROR<cr>",
	{ silent = true, desc = "Show Errors Only (Trouble)" }
)
map(
	"n",
	"<leader>xX",
	"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
	{ silent = true, desc = "Toggle Diagnostics for Buffer (Trouble)" }
)
map("n", "<leader>xs", "<cmd>Trouble symbols toggle focus=false<cr>", { silent = true, desc = "Toggle Symbols (Trouble)" })
map(
	"n",
	"<leader>xl",
	"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
	{ silent = true, desc = "Toggle LSP (Trouble)" }
)
map("n", "<leader>xL", "<cmd>Trouble loclist toggle<cr>", { silent = true, desc = "Toggle Location List (Trouble)" })
map("n", "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", { silent = true, desc = "Toggle Quickfix List (Trouble)" })
map("n", "<leader>xt", "<cmd>Trouble todo<cr>", { silent = true, desc = "Show TODOs (Trouble)" })
map(
	"n",
	"<leader>xw",
	"<cmd>Trouble diagnostics toggle focus=false<cr>",
	{ silent = true, desc = "Workspace Diagnostics (Trouble)" }
)
map("n", "<leader>xT", "<cmd>TodoTelescope<cr>", { silent = true, desc = "Search TODOs with Telescope" })
map("n", "<leader>xd", function()
	require("telescope").extensions["todo-comments"].todo({
		default_text = "DEBUGPRINT | DEV",
	})
end, { silent = true, desc = "Search 'DEBUGPRINT' in TODOs" })

-- ============================================================================
-- Yazi
-- ============================================================================
map("n", "<leader>y", function()
	require("yazi").yazi()
end, { silent = true, desc = "Open [Y]azi" })

-- ============================================================================
-- vim-dadbod-ui
-- ============================================================================
map("n", "<leader>dt", function()
	-- Check if any DBUI windows are open
	local dbui_wins = {}
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local buf = vim.api.nvim_win_get_buf(win)
		local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })
		local buf_name = vim.api.nvim_buf_get_name(buf)
		-- Match DBUI drawer, query buffers, and result buffers
		if ft == "dbui" or ft == "dbout" or string.match(buf_name, "dbui") or string.match(buf_name, "DBUIQuery") then
			table.insert(dbui_wins, win)
		end
	end

	if #dbui_wins > 0 then
		for _, win in ipairs(dbui_wins) do
			if vim.api.nvim_win_is_valid(win) then
				vim.api.nvim_win_close(win, true)
			end
		end
	else
		vim.cmd("DBUIToggle")
	end
end, { silent = true, desc = "Toggle Database UI" })
map("n", "<leader>df", ":DBUIFindBuffer<CR>", { silent = true, desc = "Find Database Buffer" })
map("n", "<leader>dr", ":DBUIRenameBuffer<CR>", { silent = true, desc = "Rename Database Buffer" })
map("n", "<leader>da", ":DBUIAddConnection<CR>", { silent = true, desc = "Add Database Connection" })
map("n", "<leader>dl", ":DBUILastQueryInfo<CR>", { silent = true, desc = "Last Query Info" })
map("v", "<leader>ds", ":DB<CR>", { silent = true, desc = "Execute Selected Query" })
map("n", "<leader>ds", ":DB<CR>", { silent = true, desc = "Execute Current Query" })
map("n", "<leader>dw", ":w<CR>", { silent = true, desc = "Save Query Buffer" })

-- ============================================================================
-- Misc
-- ============================================================================
map("n", "<leader>rr", "<cmd>:!!<CR>", { silent = true, desc = "[R]erun last shell command" })
map("n", "<leader>mm", function()
	require("mini.map").toggle()
end, { silent = true, desc = "[M]ini [M]ap Toggle" })
map("n", "<leader>mt", "<cmd>Twilight<CR>", { silent = true, desc = "[M]isc [T]wilight" })

-- markdown-preview.nvim
map("n", "<leader>mp", "<Plug>MarkdownPreviewToggle", { silent = true, desc = "Toggle Markdown [P]review" })

-- Open current file in Obsidian (native mermaid render + click-to-zoom).
-- Requires the file to live inside a registered Obsidian vault.
map("n", "<leader>mo", function()
	local path = vim.fn.expand("%:p")
	if path == "" then
		vim.notify("No file to open in Obsidian", vim.log.levels.WARN)
		return
	end
	local uri = "obsidian://open?path=" .. vim.uri_encode(path)
	vim.fn.jobstart({ "xdg-open", uri }, { detach = true })
	vim.notify("Obsidian: " .. vim.fn.expand("%:t"), vim.log.levels.INFO)
end, { silent = true, desc = "Open current file in [O]bsidian" })

map("n", "<leader>mP", function()
	if vim.g.mkdp_enabled == 1 then
		vim.g.mkdp_enabled = 0
		print("Markdown Preview Plugin: DISABLED")
	else
		vim.g.mkdp_enabled = 1
		print("Markdown Preview Plugin: ENABLED")
	end
end, { silent = true, desc = "Toggle Markdown [P]lugin On/Off" })

-- render-markdown.nvim (loaded on markdown ft; pcall for non-markdown buffers)
map("n", "<leader>mr", function()
	local ok = pcall(function()
		require("render-markdown").toggle()
	end)
	if not ok then
		vim.notify("render-markdown not loaded (markdown buffers only)", vim.log.levels.WARN)
	end
end, { silent = true, desc = "Toggle Markdown [R]endering" })

-- ============================================================================
-- Aerial (code outline)
-- ============================================================================
map("n", "<leader>a", "<cmd>AerialToggle!<CR>", { silent = true, desc = "Toggle Aerial Code Outline" })
map("n", "{", "<cmd>AerialPrev<CR>", { silent = true, desc = "Jump to Previous Symbol" })
map("n", "}", "<cmd>AerialNext<CR>", { silent = true, desc = "Jump to Next Symbol" })

-- ============================================================================
-- Performance toggles (commands defined in user/commands.lua)
-- ============================================================================
map("n", "<leader>tc", "<cmd>ToggleSmearCursor<CR>", { silent = true, desc = "[T]oggle Smear [C]ursor" })
map("n", "<leader>tp", "<cmd>DisableHeavyFeatures<CR>", { silent = true, desc = "[T]oggle [P]erformance mode (disable heavy features)" })
map("n", "<leader>tP", "<cmd>EnableHeavyFeatures<CR>", { silent = true, desc = "[T]oggle [P]erformance mode (enable heavy features)" })

-- Java/Spring Boot (command defined in plugin/lsp.lua)
map("n", "<leader>jw", "<cmd>JavaCleanWorkspace<CR>", { silent = true, desc = "[J]ava Clean [W]orkspace" })
