-- Beautiful scrollbar configuration
local M = {}

function M.setup()
    local ok, scrollbar = pcall(require, "nvim-scrollbar")
    if not ok then
        vim.notify("nvim-scrollbar not found, skipping setup", vim.log.levels.WARN)
        return
    end
    
    scrollbar.setup({
        show = true,
        show_in_active_only = false,
        set_highlights = true,
        folds = 1000,
        max_lines = false,
        hide_if_all_visible = false,
        throttle_ms = 100,
        handle = {
            text = " ",
            blend = 30,
            color = "#fabd2f",
            color_nr = nil,
            highlight = "CursorColumn",
            hide_if_all_visible = true,
        },
        marks = {
            Cursor = {
                text = "•",
                priority = 0,
                gui = nil,
                color = "#fe8019",
                cterm = nil,
                color_nr = nil,
                highlight = "Normal",
            },
            Search = {
                text = { "-", "=" },
                priority = 1,
                gui = nil,
                color = "#fabd2f",
                cterm = nil,
                color_nr = nil,
                highlight = "Search",
            },
            Error = {
                text = { "-", "=" },
                priority = 2,
                gui = nil,
                color = "#fb4934",
                cterm = nil,
                color_nr = nil,
                highlight = "DiagnosticVirtualTextError",
            },
            Warn = {
                text = { "-", "=" },
                priority = 3,
                gui = nil,
                color = "#fabd2f",
                cterm = nil,
                color_nr = nil,
                highlight = "DiagnosticVirtualTextWarn",
            },
            Info = {
                text = { "-", "=" },
                priority = 4,
                gui = nil,
                color = "#83a598",
                cterm = nil,
                color_nr = nil,
                highlight = "DiagnosticVirtualTextInfo",
            },
            Hint = {
                text = { "-", "=" },
                priority = 5,
                gui = nil,
                color = "#8ec07c",
                cterm = nil,
                color_nr = nil,
                highlight = "DiagnosticVirtualTextHint",
            },
            Misc = {
                text = { "-", "=" },
                priority = 6,
                gui = nil,
                color = "#d3869b",
                cterm = nil,
                color_nr = nil,
                highlight = "Normal",
            },
            GitAdd = {
                text = "┆",
                priority = 7,
                gui = nil,
                color = "#8ec07c",
                cterm = nil,
                color_nr = nil,
                highlight = "GitSignsAdd",
            },
            GitChange = {
                text = "┆",
                priority = 7,
                gui = nil,
                color = "#fabd2f",
                cterm = nil,
                color_nr = nil,
                highlight = "GitSignsChange",
            },
            GitDelete = {
                text = "▁",
                priority = 7,
                gui = nil,
                color = "#fb4934",
                cterm = nil,
                color_nr = nil,
                highlight = "GitSignsDelete",
            },
        },
        excluded_buftypes = {
            "terminal",
        },
        excluded_filetypes = {
            "cmp_docs",
            "cmp_menu",
            "noice",
            "prompt",
            "TelescopePrompt",
            "alpha",
            "dashboard",
            "NvimTree",
            "lazy",
            "mason",
            "trouble",
        },
        autocmd = {
            render = {
                "BufWinEnter",
                "TabEnter",
                "TermEnter",
                "WinEnter",
                "CmdwinLeave",
                "TextChanged",
                "VimResized",
                "WinScrolled",
            },
            clear = {
                "BufWinLeave",
                "TabLeave",
                "TermLeave",
                "WinLeave",
            },
        },
        handlers = {
            cursor = true,
            diagnostic = true,
            gitsigns = true,
            handle = true,
            search = false,
            ale = false,
        },
    })
    
    -- Custom highlights for scrollbar
    local scrollbar_highlights = {
        ScrollbarHandle = { bg = "#fabd2f", fg = "NONE" },
        ScrollbarCursor = { bg = "#fe8019", fg = "NONE" },
        ScrollbarCursorHandle = { bg = "#fe8019", fg = "NONE" },
        ScrollbarSearch = { bg = "#fabd2f", fg = "NONE" },
        ScrollbarSearchHandle = { bg = "#fabd2f", fg = "NONE" },
        ScrollbarError = { bg = "#fb4934", fg = "NONE" },
        ScrollbarErrorHandle = { bg = "#fb4934", fg = "NONE" },
        ScrollbarWarn = { bg = "#fabd2f", fg = "NONE" },
        ScrollbarWarnHandle = { bg = "#fabd2f", fg = "NONE" },
        ScrollbarInfo = { bg = "#83a598", fg = "NONE" },
        ScrollbarInfoHandle = { bg = "#83a598", fg = "NONE" },
        ScrollbarHint = { bg = "#8ec07c", fg = "NONE" },
        ScrollbarHintHandle = { bg = "#8ec07c", fg = "NONE" },
        ScrollbarMisc = { bg = "#d3869b", fg = "NONE" },
        ScrollbarMiscHandle = { bg = "#d3869b", fg = "NONE" },
        ScrollbarGitAdd = { bg = "#8ec07c", fg = "NONE" },
        ScrollbarGitAddHandle = { bg = "#8ec07c", fg = "NONE" },
        ScrollbarGitChange = { bg = "#fabd2f", fg = "NONE" },
        ScrollbarGitChangeHandle = { bg = "#fabd2f", fg = "NONE" },
        ScrollbarGitDelete = { bg = "#fb4934", fg = "NONE" },
        ScrollbarGitDeleteHandle = { bg = "#fb4934", fg = "NONE" },
    }
    
    for hl, col in pairs(scrollbar_highlights) do
        vim.api.nvim_set_hl(0, hl, col)
    end
end

return M