-- Editor options and plugin globals. Loaded first from init.lua.

local opt = vim.o
local g = vim.g

-- ============================================================================
-- Plugin globals
-- ============================================================================
g.editorconfig = true
-- let sqlite.lua (which some plugins depend on) know where to find sqlite
g.sqlite_clib_path = require("luv").os_getenv("LIBSQLITE")
g.mkdp_browser = "google-chrome"
g.slime_target = "tmux"

-- markdown-preview.nvim configuration
g.mkdp_auto_start = 0
g.mkdp_auto_close = 0
g.mkdp_refresh_slow = 0
g.mkdp_command_for_global = 0
g.mkdp_open_to_the_world = 0
g.mkdp_open_ip = ""
g.mkdp_echo_preview_url = 0
g.mkdp_browserfunc = ""
g.mkdp_preview_options = {
	mkit = {},
	katex = {},
	uml = {},
	maid = {},
	disable_sync_scroll = 0,
	sync_scroll_type = "middle",
	hide_yaml_meta = 1,
	sequence_diagrams = {},
	flowchart_diagrams = {},
	content_editable = false,
	disable_filename = 0,
	toc = {},
}
g.mkdp_markdown_css = ""
g.mkdp_highlight_css = ""
g.mkdp_port = ""
g.mkdp_page_title = "「${name}」"
g.mkdp_filetypes = { "markdown", "mdown", "mkd", "mkdn", "mdx", "md" }
g.mkdp_enabled = 1

-- ============================================================================
-- Disable unused providers and builtin plugins (startup time)
-- ============================================================================
g.loaded_python3_provider = 0
g.loaded_ruby_provider = 0
g.loaded_perl_provider = 0
g.loaded_node_provider = 0

local disabled_built_ins = {
	"gzip",
	"zip",
	"zipPlugin",
	"tar",
	"tarPlugin",
	"getscript",
	"getscriptPlugin",
	"vimball",
	"vimballPlugin",
	"2html_plugin",
	"logipat",
	"rrhelper",
	"spellfile_plugin",
}
for _, plugin in pairs(disabled_built_ins) do
	g["loaded_" .. plugin] = 1
end

-- ============================================================================
-- Core options
-- ============================================================================
opt.termguicolors = true
opt.incsearch = true
opt.relativenumber = true
opt.number = true
opt.ignorecase = true

-- Folding (nvim-ufo)
opt.foldcolumn = "1"
opt.foldlevel = 99 -- Using ufo provider need a large value
opt.foldlevelstart = 99
opt.foldenable = true
opt.foldtext = ""

-- Performance
opt.updatetime = 300 -- Faster completion and diagnostics (default 4000)
opt.timeoutlen = 400 -- Faster key sequence timeout (default 1000)
opt.redrawtime = 1500 -- Time for syntax highlighting (default 2000)
opt.synmaxcol = 240 -- Don't syntax highlight super long lines

-- File handling
opt.swapfile = false -- No swap files (we have auto-session for recovery)
opt.backup = false
opt.writebackup = false
opt.undofile = true
opt.undodir = vim.fn.stdpath("data") .. "/undo"
opt.undolevels = 10000
opt.undoreload = 10000

-- Shada (session data) optimization
opt.shada = "!,'100,<50,s10,h" -- Limit shada size for faster startup

-- Session restore must include localoptions so filetype survives the
-- restore — without it FileType autocmds (vim.lsp.enable, lazydev) never
-- fire on restored buffers and no LSP attaches.
opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- NOTE: deliberately NOT appending "**" to 'path' — it makes :find / gf /
-- path-completion recursively crawl the whole CWD tree (multi-second stalls
-- on big repos). Use Telescope find_files for fuzzy path lookup instead.

-- Indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true

-- ============================================================================
-- UI
-- ============================================================================
opt.pumheight = 15 -- Limit completion menu height
opt.pumblend = 0 -- Solid completion menu background
opt.cmdheight = 1
opt.showtabline = 2 -- Always show tabline
opt.laststatus = 3 -- Global statusline
opt.winblend = 0 -- Solid floating window backgrounds
opt.cursorline = true
opt.signcolumn = "yes:2" -- Always show sign column with space for 2 signs
-- colorcolumn is owned by smartcolumn.nvim (user/smartcolumn.lua) — setting
-- it statically here fights the plugin's per-filetype show/hide logic.
opt.list = true -- Show invisible characters
opt.listchars = "tab:→ ,trail:·,extends:›,precedes:‹,nbsp:␣"
opt.fillchars = "fold: ,foldopen:▾,foldsep: ,foldclose:▸,stl: ,eob: "

-- Cursor and scrolling
opt.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50"
opt.scrolloff = 8
opt.sidescrolloff = 8
