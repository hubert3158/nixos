-- Advanced visual enhancements and modern touches
local M = {}

function M.setup()
    -- Enable 24-bit RGB colors
    vim.opt.termguicolors = true
    
    -- Better cursor shape in different modes
    vim.opt.guicursor = {
        "n-v-c:block-Cursor/lCursor",
        "i-ci-ve:ver25-Cursor/lCursor",
        "r-cr:hor20-Cursor/lCursor",
        "o:hor50-Cursor/lCursor",
        "a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor",
        "sm:block-Cursor/lCursor-blinkwait175-blinkoff150-blinkon175",
    }
    
    -- Modern UI settings
    vim.opt.pumheight = 10 -- Maximum number of entries in popup menu
    vim.opt.pumblend = 10 -- Transparency for popup menu
    vim.opt.winblend = 0 -- Transparency for floating windows
    
    -- Enhanced signcolumn
    vim.opt.signcolumn = "yes:2" -- Always show signcolumn with 2 columns
    
    -- Better splits
    vim.opt.splitbelow = true -- Horizontal splits go below
    vim.opt.splitright = true -- Vertical splits go right
    vim.opt.splitkeep = "screen" -- Keep text on screen when splitting
    
    -- Enhanced scrolling
    vim.opt.scrolloff = 8 -- Keep 8 lines above/below cursor
    vim.opt.sidescrolloff = 8 -- Keep 8 columns left/right of cursor
    vim.opt.smoothscroll = true -- Enable smooth scrolling
    
    -- Better visual feedback
    vim.opt.cursorline = true -- Highlight current line
    vim.opt.cursorcolumn = false -- Don't highlight current column (can be distracting)
    vim.opt.colorcolumn = "80,120" -- Show column guides at 80 and 120
    
    -- Enhanced list characters for better visibility
    vim.opt.list = true
    vim.opt.listchars = {
        tab = "→ ",
        eol = "↲",
        nbsp = "␣",
        lead = "·",
        space = "·",
        trail = "•",
        extends = "⟩",
        precedes = "⟨",
    }
    
    -- Better diff colors
    vim.opt.diffopt:append("linematch:60")
    
    -- Enhanced search appearance
    vim.opt.hlsearch = true
    vim.opt.incsearch = true
    vim.opt.ignorecase = true
    vim.opt.smartcase = true
    
    -- Modern completion
    vim.opt.completeopt = { "menu", "menuone", "noselect" }
    vim.opt.shortmess:append("c") -- Don't show completion messages
    
    -- Better command line
    vim.opt.cmdheight = 1 -- Height of command line
    vim.opt.showcmd = true -- Show partial commands
    vim.opt.showmode = false -- Don't show mode (we have lualine)
    
    -- Enhanced title
    vim.opt.title = true
    vim.opt.titlestring = "%<%F%=%l/%L - nvim"
    
    -- Custom highlight groups for modern look
    local modern_highlights = {
        -- Enhanced cursor line
        CursorLine = { bg = "#32302f" },
        CursorLineNr = { fg = "#fabd2f", bg = "#32302f", bold = true },
        
        -- Better column guides
        ColorColumn = { bg = "#3c3836" },
        
        -- Enhanced list characters
        Whitespace = { fg = "#504945" },
        NonText = { fg = "#504945" },
        SpecialKey = { fg = "#504945" },
        
        -- Better split borders
        WinSeparator = { fg = "#665c54", bg = "NONE" },
        VertSplit = { fg = "#665c54", bg = "NONE" },
        
        -- Enhanced status line separator
        StatusLineSeparator = { fg = "#fabd2f", bg = "#32302f" },
        
        -- Better popup menu
        Pmenu = { fg = "#ebdbb2", bg = "#32302f" },
        PmenuSel = { fg = "#282828", bg = "#fabd2f", bold = true },
        PmenuSbar = { bg = "#504945" },
        PmenuThumb = { bg = "#a89984" },
        
        -- Enhanced wild menu
        WildMenu = { fg = "#282828", bg = "#fabd2f", bold = true },
        
        -- Better diff colors
        DiffAdd = { bg = "#2d4f2d", fg = "NONE" },
        DiffChange = { bg = "#4d4d2d", fg = "NONE" },
        DiffDelete = { bg = "#4d2d2d", fg = "#fb4934" },
        DiffText = { bg = "#5d5d2d", fg = "NONE", bold = true },
        
        -- Enhanced terminal colors
        Terminal = { fg = "#ebdbb2", bg = "#1d2021" },
        
        -- Better fold appearance
        Folded = { bg = "#3c3836", fg = "#a89984", italic = true },
        FoldColumn = { bg = "NONE", fg = "#665c54" },
        
        -- Enhanced title
        Title = { fg = "#fabd2f", bold = true },
        
        -- Better end of buffer
        EndOfBuffer = { fg = "#32302f" },
        
        -- Enhanced question/more prompts
        Question = { fg = "#8ec07c", bold = true },
        MoreMsg = { fg = "#8ec07c", bold = true },
        
        -- Better error/warning messages
        ErrorMsg = { fg = "#fb4934", bold = true },
        WarningMsg = { fg = "#fabd2f", bold = true },
        
        -- Enhanced spell checking
        SpellBad = { undercurl = true, sp = "#fb4934" },
        SpellCap = { undercurl = true, sp = "#83a598" },
        SpellLocal = { undercurl = true, sp = "#8ec07c" },
        SpellRare = { undercurl = true, sp = "#d3869b" },
        
        -- Better tab line
        TabLine = { fg = "#a89984", bg = "#32302f" },
        TabLineFill = { bg = "#1d2021" },
        TabLineSel = { fg = "#fabd2f", bg = "#504945", bold = true },
        
        -- Enhanced visual selection
        Visual = { bg = "#504945" },
        VisualNOS = { bg = "#504945" },
        
        -- Better search highlighting with animation-like effect
        Search = { fg = "#1d2021", bg = "#fabd2f", bold = true },
        IncSearch = { fg = "#1d2021", bg = "#fe8019", bold = true },
        CurSearch = { fg = "#1d2021", bg = "#fb4934", bold = true },
        
        -- Enhanced matching brackets
        MatchParen = { fg = "#1d2021", bg = "#fe8019", bold = true },
        
        -- Better directory colors
        Directory = { fg = "#83a598", bold = true },
        
        -- Enhanced conceal
        Conceal = { fg = "#928374", bg = "NONE" },
        
        -- Better line numbers
        LineNr = { fg = "#665c54", bg = "NONE" },
        LineNrAbove = { fg = "#504945", bg = "NONE" },
        LineNrBelow = { fg = "#504945", bg = "NONE" },
    }
    
    -- Apply all modern highlights
    for hl, col in pairs(modern_highlights) do
        vim.api.nvim_set_hl(0, hl, col)
    end
    
    -- Auto commands for enhanced visual feedback
    local augroup = vim.api.nvim_create_augroup("VisualEnhancements", { clear = true })
    
    -- Highlight on yank
    vim.api.nvim_create_autocmd("TextYankPost", {
        group = augroup,
        pattern = "*",
        callback = function()
            vim.highlight.on_yank({
                higroup = "Search",
                timeout = 200,
            })
        end,
    })
    
    -- Auto resize splits when vim is resized
    vim.api.nvim_create_autocmd("VimResized", {
        group = augroup,
        pattern = "*",
        command = "wincmd =",
    })
    
    -- Close certain windows with q
    vim.api.nvim_create_autocmd("FileType", {
        group = augroup,
        pattern = {
            "qf", "help", "man", "lspinfo", "spectre_panel", "lir",
            "DressingSelect", "tsplayground", "Markdown"
        },
        callback = function(event)
            vim.bo[event.buf].buflisted = false
            vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
        end,
    })
    
    -- Show cursor line only in active window
    vim.api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, {
        group = augroup,
        pattern = "*",
        callback = function()
            vim.opt_local.cursorline = true
        end,
    })
    
    vim.api.nvim_create_autocmd({ "InsertEnter", "WinLeave" }, {
        group = augroup,
        pattern = "*",
        callback = function()
            vim.opt_local.cursorline = false
        end,
    })
    
    -- Check if we need to reload the file when it changed
    vim.api.nvim_create_autocmd({"FocusGained", "TermClose", "TermLeave"}, {
        group = augroup,
        command = "checktime",
    })
    
    -- Go to last location when opening a buffer
    vim.api.nvim_create_autocmd("BufReadPost", {
        group = augroup,
        callback = function(event)
            local exclude = { "gitcommit" }
            local buf = event.buf
            if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
                return
            end
            vim.b[buf].lazyvim_last_loc = true
            local mark = vim.api.nvim_buf_get_mark(buf, '"')
            local lcount = vim.api.nvim_buf_line_count(buf)
            if mark[1] > 0 and mark[1] <= lcount then
                pcall(vim.api.nvim_win_set_cursor, 0, mark)
            end
        end,
    })
    
    -- Set up modern borders for LSP windows
    local border = {
        { "╭", "FloatBorder" },
        { "─", "FloatBorder" },
        { "╮", "FloatBorder" },
        { "│", "FloatBorder" },
        { "╯", "FloatBorder" },
        { "─", "FloatBorder" },
        { "╰", "FloatBorder" },
        { "│", "FloatBorder" },
    }
    
    -- LSP handlers with beautiful borders
    local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
    function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
        opts = opts or {}
        opts.border = opts.border or border
        return orig_util_open_floating_preview(contents, syntax, opts, ...)
    end
end

return M