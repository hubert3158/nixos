-- ═══════════════════════════════════════════════════════════════════════════
-- KEYBINDING PHILOSOPHY
-- ═══════════════════════════════════════════════════════════════════════════
-- Influences: Helix space mode (leader = discoverable menu of pickers/actions),
-- Doom Emacs / LazyVim (mnemonic single-letter domains), vim-unimpaired
-- (bracket pairs for prev/next), vim tradition (localleader = filetype).
--
-- 1. ONE PREFIX = ONE DOMAIN. Each <leader> letter owns exactly one topic and
--    is registered as a which-key group (plugin/which-key.lua). Press <leader>
--    and pause: the popup reads as a menu, like Helix's space mode.
--
-- 2. SAME KEY, SAME CONCEPT, EVERY LANGUAGE. Generic maps dispatch to generic
--    backends (overseer for run, DAP for debug, neotest for tests). Language
--    plugins override the SAME lhs buffer-locally with a richer backend
--    (rust: <leader>rr becomes cargo runnables via rustaceanvim). Muscle
--    memory transfers; the buffer decides the implementation.
--
-- 3. FILETYPE-ONLY KEYS LIVE ON LOCALLEADER (,). Java build commands and HTTP
--    request keys mean nothing outside their filetype, so they stay out of
--    the global <leader> namespace (ftplugin/java.lua, user/kulala.lua).
--
-- 4. NEVER CLOBBER BUILT-INS. { } remain paragraph motions. Prev/next pairs
--    are unimpaired-style: [d ]d diagnostics, [e ]e errors, [q ]q quickfix,
--    [t ]t failed tests, [h ]h git hunks, [a ]a outline symbols.
--
-- 5. DESCRIPTIONS: verb-first sentence case ("Find files"). No [B]racket
--    markup — which-key already highlights the key itself.
--
-- ─────────────────────────────────────────────────────────────────────────────
-- NAMESPACE REGISTRY (owner → where the maps live)
-- ─────────────────────────────────────────────────────────────────────────────
--   <leader>a    AI (CodeCompanion)         user/codeCompanion.lua
--   <leader>b    buffers                    here (<S-h>/<S-l> = prev/next)
--   <leader>c    code: LSP, format, docs    here + user/lsp-on-attach.lua + plugin/lsp.lua
--   <leader>d    debug (DAP)                user/dap.lua (F5/F9/F10/F11 = VSCode)
--   <leader>D    database (dadbod)          here
--   <leader>e/E  explorer (neo-tree)        here
--   <leader>f    find (telescope)           here + user/telescope.lua
--   <leader>g    git                        here + user/gitsigns.lua + plugin/lazy-load.lua
--   <leader>h    harpoon                    user/harpoon.lua (+ <leader>1..4 select)
--   <leader>m    markdown                   here
--   <leader>r    run / tasks                here (generic; rust overrides in user/rustaceanvim.lua)
--   <leader>s    search & replace           here + user/grug-far.lua
--   <leader>t    test (neotest)             user/neotest.lua
--   <leader>u    UI toggles                 here + plugin/notify.lua + user/lsp-on-attach.lua
--   <leader>x    diagnostics lists          here (Trouble)
--   <leader>w    save (kept as the ONLY w-map so it fires instantly)
--   <leader>y/Y  clipboard yank (v) / yazi (n, plugin/lazy-load.lua)
--   <leader>/    toggle comment      <leader>| <leader>-  splits
--   <C-\>        terminal (toggleterm)      ,  localleader = filetype maps
-- ═══════════════════════════════════════════════════════════════════════════

local map = vim.keymap.set

-- ============================================================================
-- Editing basics
-- ============================================================================
map("n", "<leader>w", ":w<CR>", { silent = true, desc = "Save file" })
map({ "n", "i" }, "<C-s>", "<cmd>w<CR>", { silent = true, desc = "Save file" })

map("n", "<Esc>", "<cmd>nohlsearch<CR>", { silent = true, desc = "Clear search highlight" })

-- Move selection up/down
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { silent = true, desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { silent = true, desc = "Move selection up" })

-- Better indenting
map("v", "<", "<gv", { silent = true, desc = "Indent left and reselect" })
map("v", ">", ">gv", { silent = true, desc = "Indent right and reselect" })

-- Clipboard (n-mode <leader>y opens yazi — see plugin/lazy-load.lua)
map("v", "<leader>y", '"+y', { silent = true, desc = "Yank to system clipboard" })
map("n", "<leader>Y", 'gg"+yG', { silent = true, desc = "Yank buffer to clipboard" })

-- Commenting (Comment.nvim)
map("n", "<leader>/", function()
	require("Comment.api").toggle.linewise.current()
end, { silent = true, desc = "Toggle comment" })
map(
	"v",
	"<leader>/",
	'<ESC><cmd>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>',
	{ silent = true, desc = "Toggle comment on selection" }
)

-- Align (vim-easy-align, start plugin)
map({ "n", "x" }, "ga", "<Plug>(EasyAlign)", { remap = true, silent = true, desc = "Easy align" })

-- ============================================================================
-- Windows & splits
-- ============================================================================
map("n", "<C-h>", "<C-w>h", { silent = true, desc = "Move to left window" })
map("n", "<C-j>", "<C-w>j", { silent = true, desc = "Move to lower window" })
map("n", "<C-k>", "<C-w>k", { silent = true, desc = "Move to upper window" })
map("n", "<C-l>", "<C-w>l", { silent = true, desc = "Move to right window" })

map("n", "<leader>|", ":vsp<CR>", { silent = true, desc = "Split vertical" })
map("n", "<leader>-", ":sp<CR>", { silent = true, desc = "Split horizontal" })

map("n", "<C-Up>", ":resize -2<CR>", { silent = true, desc = "Decrease window height" })
map("n", "<C-Down>", ":resize +2<CR>", { silent = true, desc = "Increase window height" })
map("n", "<C-Left>", ":vertical resize -2<CR>", { silent = true, desc = "Decrease window width" })
map("n", "<C-Right>", ":vertical resize +2<CR>", { silent = true, desc = "Increase window width" })

-- ============================================================================
-- Buffers (<leader>1..4 select harpoon files — user/harpoon.lua; tabs: gt/gT)
-- ============================================================================
map("n", "<S-l>", ":bnext<CR>", { silent = true, desc = "Next buffer" })
map("n", "<S-h>", ":bprev<CR>", { silent = true, desc = "Previous buffer" })
map("n", "<leader>bd", ":bd<CR>", { silent = true, desc = "Delete buffer" })
map("n", "<leader>bo", ":%bd|e#|bd#<CR>", { silent = true, desc = "Delete other buffers" })

-- ============================================================================
-- Find (telescope; <leader>ff / <leader>fF live in user/telescope.lua)
-- ============================================================================
map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { silent = true, desc = "Grep project" })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { silent = true, desc = "Find buffers" })
map("n", "<leader>fr", "<cmd>Telescope oldfiles<CR>", { silent = true, desc = "Find recent files" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { silent = true, desc = "Find help" })
map("n", "<leader>fk", "<cmd>Telescope keymaps<CR>", { silent = true, desc = "Find keymaps" })
map("n", "<leader>fm", "<cmd>Telescope marks<CR>", { silent = true, desc = "Find marks" })
map("n", "<leader>fc", "<cmd>Telescope commands<CR>", { silent = true, desc = "Find commands" })
map("n", "<leader>ft", "<cmd>Telescope builtin<CR>", { silent = true, desc = "Find telescope pickers" })
map("n", "<leader>fz", "<cmd>Telescope zoxide list<CR>", { silent = true, desc = "Jump to directory (zoxide)" })

-- ============================================================================
-- Explorer (neo-tree)
-- ============================================================================
map("n", "<leader>e", "<cmd>Neotree toggle<CR>", { silent = true, desc = "Toggle explorer" })
map("n", "<leader>E", "<cmd>Neotree reveal<CR>", { silent = true, desc = "Reveal file in explorer" })

-- ============================================================================
-- Search & replace (grug-far project-wide maps live in user/grug-far.lua:
-- <leader>sr project, <leader>sw word/selection, <leader>sf current file)
-- ============================================================================
map("n", "<leader>ss", ":%s/\\<<C-r><C-w>\\>//g<Left><Left>", { desc = "Substitute word under cursor" })
map("v", "<leader>ss", '"zy:%s/\\(<C-r>z\\)/\\1/g<Left><Left><Left>', { desc = "Substitute selection" })

-- ============================================================================
-- Code (<leader>ca code action + <leader>cd line diagnostics are buffer-local
-- LSP maps in user/lsp-on-attach.lua; <leader>ce eslint fix in plugin/lsp.lua;
-- <leader>cg generate docs in plugin/lazy-load.lua)
-- ============================================================================
map("n", "<leader>cf", function()
	require("lint").try_lint()
	require("conform").format({ async = false, lsp_fallback = true })
end, { desc = "Format & lint buffer" })

-- LSP rename with live preview (inc-rename.nvim loads on the :IncRename cmd)
map("n", "<leader>cr", function()
	return ":IncRename " .. vim.fn.expand("<cword>")
end, { expr = true, desc = "Rename symbol (live preview)" })

-- Code outline (aerial)
map("n", "<leader>cs", "<cmd>AerialToggle!<CR>", { silent = true, desc = "Toggle symbols outline" })
map("n", "[a", "<cmd>AerialPrev<CR>", { silent = true, desc = "Previous symbol" })
map("n", "]a", "<cmd>AerialNext<CR>", { silent = true, desc = "Next symbol" })

-- ============================================================================
-- Run / tasks — generic backends; rust buffers override rr/rp/rd with cargo
-- runnables (user/rustaceanvim.lua). Tests are <leader>t (neotest).
-- ============================================================================
local function overseer()
	-- overseer is opt (lz.n cmd trigger); force-load before using its API
	require("lz.n").trigger_load("overseer.nvim")
	return require("overseer")
end

map("n", "<leader>rr", function()
	local ov = overseer()
	local tasks = ov.list_tasks({ recent_first = true })
	if #tasks == 0 then
		vim.cmd("OverseerRun")
	else
		ov.run_action(tasks[1], "restart")
	end
end, { silent = true, desc = "Run last task (or pick)" })
map("n", "<leader>rp", "<cmd>OverseerRun<CR>", { silent = true, desc = "Pick task to run" })
map("n", "<leader>rt", "<cmd>OverseerToggle<CR>", { silent = true, desc = "Toggle task list" })

map("n", "<leader>rd", function()
	local ok, dap = pcall(require, "dap")
	if ok then
		dap.run_last()
	else
		vim.notify("DAP not loaded yet", vim.log.levels.WARN)
	end
end, { silent = true, desc = "Debug last session" })

-- Open the project manifest for the current buffer's language
local manifest_by_ft = {
	rust = { "Cargo.toml" },
	javascript = { "package.json" },
	javascriptreact = { "package.json" },
	typescript = { "package.json" },
	typescriptreact = { "package.json" },
	java = { "pom.xml", "build.gradle", "build.gradle.kts" },
	python = { "pyproject.toml", "setup.py" },
	go = { "go.mod" },
	zig = { "build.zig" },
	nix = { "flake.nix" },
}
map("n", "<leader>rc", function()
	local names = manifest_by_ft[vim.bo.filetype]
		or { "Cargo.toml", "package.json", "pyproject.toml", "go.mod", "pom.xml", "flake.nix" }
	local found = vim.fs.find(names, { upward = true, path = vim.fn.expand("%:p:h") })[1]
	if found then
		vim.cmd.edit(found)
	else
		vim.notify("No project manifest found", vim.log.levels.WARN)
	end
end, { silent = true, desc = "Open project manifest" })

-- ============================================================================
-- Git (hunk maps ]h [h / stage / reset / blame live in user/gitsigns.lua;
-- <leader>gg lazygit in plugin/lazy-load.lua)
-- ============================================================================
map("n", "<leader>gs", ":Git<CR>", { silent = true, desc = "Git status" })
map("n", "<leader>gc", ":Git commit<CR>", { silent = true, desc = "Git commit" })
map("n", "<leader>gp", ":Git push<CR>", { silent = true, desc = "Git push" })

map("n", "<leader>gd", function()
	-- toggle: close if a diffview is open, open otherwise
	local ok, lib = pcall(require, "diffview.lib")
	if ok and lib.get_current_view() then
		vim.cmd("DiffviewClose")
	else
		vim.cmd("DiffviewOpen")
	end
end, { silent = true, desc = "Toggle working tree diff" })
map("n", "<leader>gh", "<cmd>DiffviewFileHistory %<CR>", { silent = true, desc = "File history" })
map("n", "<leader>gH", "<cmd>DiffviewFileHistory<CR>", { silent = true, desc = "Repo history" })

-- ============================================================================
-- Diagnostics lists (Trouble)
-- ============================================================================
map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { silent = true, desc = "Diagnostics" })
map("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { silent = true, desc = "Buffer diagnostics" })
map(
	"n",
	"<leader>xe",
	"<cmd>Trouble diagnostics toggle filter.severity=ERROR<cr>",
	{ silent = true, desc = "Errors only" }
)
map("n", "<leader>xs", "<cmd>Trouble symbols toggle focus=false<cr>", { silent = true, desc = "Symbols" })
map("n", "<leader>xl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", { silent = true, desc = "LSP references" })
map("n", "<leader>xL", "<cmd>Trouble loclist toggle<cr>", { silent = true, desc = "Location list" })
map("n", "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", { silent = true, desc = "Quickfix list" })
map("n", "<leader>xt", "<cmd>Trouble todo<cr>", { silent = true, desc = "Todos" })
map("n", "<leader>xT", "<cmd>TodoTelescope<cr>", { silent = true, desc = "Search todos" })
map("n", "<leader>xd", function()
	require("telescope").extensions["todo-comments"].todo({
		default_text = "DEBUGPRINT | DEV | todo!",
	})
end, { silent = true, desc = "Search debug markers" })

map("n", "]q", ":cnext<CR>", { silent = true, desc = "Next quickfix item" })
map("n", "[q", ":cprev<CR>", { silent = true, desc = "Previous quickfix item" })

-- ============================================================================
-- Database (vim-dadbod-ui)
-- ============================================================================
map("n", "<leader>Dt", function()
	-- Close all DBUI windows if any are open, otherwise open the drawer
	local dbui_wins = {}
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local buf = vim.api.nvim_win_get_buf(win)
		local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })
		local buf_name = vim.api.nvim_buf_get_name(buf)
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
end, { silent = true, desc = "Toggle database UI" })
map("n", "<leader>Df", ":DBUIFindBuffer<CR>", { silent = true, desc = "Find database buffer" })
map("n", "<leader>Dr", ":DBUIRenameBuffer<CR>", { silent = true, desc = "Rename database buffer" })
map("n", "<leader>Da", ":DBUIAddConnection<CR>", { silent = true, desc = "Add database connection" })
map("n", "<leader>Dl", ":DBUILastQueryInfo<CR>", { silent = true, desc = "Last query info" })
map({ "n", "v" }, "<leader>Ds", ":DB<CR>", { silent = true, desc = "Execute query" })

-- ============================================================================
-- Markdown
-- ============================================================================
map("n", "<leader>mp", "<Plug>MarkdownPreviewToggle", { silent = true, desc = "Toggle preview" })
map("n", "<leader>mP", function()
	if vim.g.mkdp_enabled == 1 then
		vim.g.mkdp_enabled = 0
		print("Markdown Preview Plugin: DISABLED")
	else
		vim.g.mkdp_enabled = 1
		print("Markdown Preview Plugin: ENABLED")
	end
end, { silent = true, desc = "Toggle preview plugin on/off" })

-- render-markdown.nvim (loaded on markdown ft; pcall for non-markdown buffers)
map("n", "<leader>mr", function()
	local ok = pcall(function()
		require("render-markdown").toggle()
	end)
	if not ok then
		vim.notify("render-markdown not loaded (markdown buffers only)", vim.log.levels.WARN)
	end
end, { silent = true, desc = "Toggle inline rendering" })

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
end, { silent = true, desc = "Open in Obsidian" })

-- ============================================================================
-- UI toggles (<leader>uh inlay hints: user/lsp-on-attach.lua;
-- <leader>un dismiss notifications: plugin/notify.lua)
-- ============================================================================
map("n", "<leader>ul", ":set relativenumber!<CR>", { silent = true, desc = "Toggle relative line numbers" })
map("n", "<leader>uw", ":set wrap!<CR>", { silent = true, desc = "Toggle line wrap" })
map("n", "<leader>us", ":set spell!<CR>", { silent = true, desc = "Toggle spell check" })
map("n", "<leader>uu", ":UndotreeToggle<CR>", { silent = true, desc = "Toggle undo tree" })
map("n", "<leader>ut", "<cmd>Twilight<CR>", { silent = true, desc = "Toggle twilight dimming" })
map("n", "<leader>uc", "<cmd>ToggleSmearCursor<CR>", { silent = true, desc = "Toggle smear cursor" })
map("n", "<leader>up", "<cmd>DisableHeavyFeatures<CR>", { silent = true, desc = "Performance mode on" })
map("n", "<leader>uP", "<cmd>EnableHeavyFeatures<CR>", { silent = true, desc = "Performance mode off" })
map("n", "<leader>um", function()
	-- mini.nvim loads on DeferredUIEnter; guard the first-instant race
	local ok, minimap = pcall(require, "mini.map")
	if ok then
		minimap.toggle()
	end
end, { silent = true, desc = "Toggle minimap" })
map("n", "<leader>uv", function()
	-- venn is opt (lz.n cmd trigger); force-load before toggling draw mode
	require("lz.n").trigger_load("venn.nvim")
	_G.Toggle_venn()
end, { silent = true, desc = "Toggle venn drawing mode" })
