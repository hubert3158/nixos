-- Beautiful which-key configuration
local M = {}

function M.setup()
    local wk = require("which-key")
    
    wk.setup({
        plugins = {
            marks = true,
            registers = true,
            spelling = {
                enabled = true,
                suggestions = 20,
            },
            presets = {
                operators = false,
                motions = true,
                text_objects = true,
                windows = true,
                nav = true,
                z = true,
                g = true,
            },
        },
        operators = { gc = "Comments" },
        key_labels = {
            ["<space>"] = "SPC",
            ["<cr>"] = "RET",
            ["<tab>"] = "TAB",
        },
        motions = {
            count = true,
        },
        icons = {
            breadcrumb = "»",
            separator = "➜",
            group = "+",
        },
        popup_mappings = {
            scroll_down = "<c-d>",
            scroll_up = "<c-u>",
        },
        window = {
            border = "rounded",
            position = "bottom",
            margin = { 1, 0, 1, 0 },
            padding = { 1, 2, 1, 2 },
            winblend = 0,
            zindex = 1000,
        },
        layout = {
            height = { min = 4, max = 25 },
            width = { min = 20, max = 50 },
            spacing = 3,
            align = "left",
        },
        ignore_missing = true,
        hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "^:", "^ ", "^call ", "^lua " },
        show_help = true,
        show_keys = true,
        triggers = "auto",
        triggers_nowait = {
            "`",
            "'",
            "g`",
            "g'",
            '"',
            "<c-r>",
            "z=",
        },
        triggers_blacklist = {
            i = { "j", "k" },
            v = { "j", "k" },
        },
        disable = {
            buftypes = {},
            filetypes = {},
        },
    })
    
    -- Register key mappings with descriptions
    wk.register({
        f = {
            name = " Find",
            f = { "<cmd>Telescope find_files<cr>", "Find Files" },
            g = { "<cmd>Telescope live_grep<cr>", "Live Grep" },
            b = { "<cmd>Telescope buffers<cr>", "Buffers" },
            h = { "<cmd>Telescope help_tags<cr>", "Help Tags" },
            s = { "<cmd>Telescope builtin<cr>", "Telescope Builtins" },
            c = { "<cmd>Telescope commands<cr>", "Commands" },
            k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
            m = { "<cmd>Telescope marks<cr>", "Marks" },
            o = { "<cmd>Telescope oldfiles<cr>", "Recent Files" },
        },
        g = {
            name = " Git",
            s = { "<cmd>Git<cr>", "Status" },
            c = { "<cmd>Git commit<cr>", "Commit" },
            p = { "<cmd>Git push<cr>", "Push" },
            g = { "<cmd>LazyGit<cr>", "LazyGit" },
        },
        n = {
            name = " File Explorer",
            t = { "<cmd>NvimTreeToggle<cr>", "Toggle NvimTree" },
            f = { "<cmd>NvimTreeFocus<cr>", "Focus NvimTree" },
        },
        x = {
            name = " Diagnostics",
            x = { "<cmd>Trouble diagnostics toggle<cr>", "Toggle Diagnostics" },
            X = { "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", "Buffer Diagnostics" },
            s = { "<cmd>Trouble symbols toggle focus=false<cr>", "Symbols" },
            l = { "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", "LSP" },
            L = { "<cmd>Trouble loclist toggle<cr>", "Location List" },
            Q = { "<cmd>Trouble qflist toggle<cr>", "Quickfix List" },
            t = { "<cmd>Trouble todo<cr>", "TODOs" },
            w = { "<cmd>Trouble diagnostics toggle focus=false<cr>", "Workspace Diagnostics" },
            T = { "<cmd>TodoTelescope<cr>", "Search TODOs" },
        },
        c = {
            name = " Code",
            c = { "<cmd>CodeCompanionChat anthropic<cr>", "Code Companion Chat" },
            a = { "<cmd>CodeCompanionActions<cr>", "Code Companion Actions" },
            h = { "<cmd>nohlsearch<cr>", "Clear Highlights" },
        },
        r = {
            name = " Refactor",
            e = { "Extract Function" },
            f = { "Extract Function To File" },
            v = { "Extract Variable" },
            I = { "Inline Function" },
            i = { "Inline Variable" },
            b = {
                name = "Extract Block",
                b = { "Extract Block" },
                f = { "Extract Block To File" },
            },
        },
        b = {
            name = " Buffer",
            n = { "<cmd>bnext<cr>", "Next Buffer" },
            p = { "<cmd>bprevious<cr>", "Previous Buffer" },
            d = { "<cmd>bd<cr>", "Delete Buffer" },
        },
        s = {
            name = " Split",
            v = { "<cmd>vsp<cr>", "Vertical Split" },
            h = { "<cmd>sp<cr>", "Horizontal Split" },
            r = { ":%s/\\<<C-r><C-w>\\>//g<Left><Left>", "Search & Replace" },
            p = { "<cmd>set spell!<cr>", "Toggle Spell Check" },
        },
        t = {
            name = " Toggle",
            t = { "<cmd>ToggleTerm<cr>", "Terminal" },
            l = { "<cmd>set relativenumber!<cr>", "Relative Numbers" },
        },
        w = {
            name = " Window",
            ["="] = { "<cmd>vertical resize +5<cr>", "Increase Width" },
            ["-"] = { "<cmd>vertical resize -5<cr>", "Decrease Width" },
            r = { "<cmd>set wrap!<cr>", "Toggle Wrap" },
        },
        m = {
            name = " Misc",
            m = { "<cmd>lua require'mini.map'.toggle()<cr>", "Toggle Mini Map" },
            t = { "<cmd>Twilight<cr>", "Twilight" },
            a = { "<cmd>MarkdownPreviewToggle<cr>", "Markdown Preview" },
        },
        e = {
            name = " Debug",
            b = { "Toggle Breakpoint" },
            B = { "Conditional Breakpoint" },
            C = { "Clear All Breakpoints" },
            d = { "Disconnect" },
            h = { "Hover Variable" },
            s = { "Show Scopes" },
            f = { "Show Frames" },
            r = { "Open REPL" },
        },
        k = {
            name = " Kulala HTTP",
            s = { "Execute Request" },
            a = { "Execute All Requests" },
            r = { "Replay Request" },
            b = { "Show Response Body" },
            h = { "Show Response Headers" },
            S = { "Open Scratchpad" },
            o = { "Open in New Buffer" },
            t = { "Toggle View" },
            f = { "Search Endpoints" },
            c = { "Copy Command" },
        },
        y = { "<cmd>lua require'yazi'.yazi()<cr>", " Open Yazi" },
        q = { "<cmd>q<cr>", " Quit" },
        w = { "<cmd>w<cr>", " Save" },
        v = {
            name = " Config",
            e = { "<cmd>e $MYVIMRC<cr>", "Edit Config" },
            s = { "<cmd>source $MYVIMRC<cr>", "Source Config" },
        },
        u = {
            name = " Utils",
            n = { "<cmd>lua require('notify').dismiss({ silent = true, pending = true })<cr>", "Dismiss Notifications" },
        },
        ["<F5>"] = { "<cmd>UndotreeToggle<cr>", "Undo Tree" },
        ["/"] = { "Toggle Comment" },
        h = { "<cmd>bprev<cr>", "Previous Buffer" },
        l = { "<cmd>bnext<cr>", "Next Buffer" },
        p = { '"+p', "Paste from Clipboard" },
        P = { '"+P', "Paste Before from Clipboard" },
        Y = { 'gg"+yG', "Yank All to Clipboard" },
        nn = { "Lint and Format" },
        nc = { "Generate Documentation" },
        cd = { "<cmd>Telescope zoxide list<cr>", "Zoxide Jump" },
        rr = { "<cmd>!!<cr>", "Rerun Last Command" },
    }, { prefix = "<leader>" })
    
    -- Register visual mode mappings
    wk.register({
        ["/"] = { "Toggle Comment" },
        y = { '"+y', "Yank to Clipboard" },
        r = {
            name = " Refactor",
            e = { "Extract Function" },
            f = { "Extract Function To File" },
            v = { "Extract Variable" },
            I = { "Inline Function" },
            i = { "Inline Variable" },
            b = {
                name = "Extract Block",
                b = { "Extract Block" },
                f = { "Extract Block To File" },
            },
        },
    }, { mode = "v", prefix = "<leader>" })
    
    -- Custom highlights for which-key
    local wk_highlights = {
        WhichKey = { fg = "#fabd2f", bold = true },
        WhichKeyGroup = { fg = "#8ec07c", bold = true }, 
        WhichKeyDesc = { fg = "#ebdbb2" },
        WhichKeySeperator = { fg = "#928374" },
        WhichKeySeparator = { fg = "#928374" },
        WhichKeyFloat = { bg = "#32302f" },
        WhichKeyBorder = { fg = "#a89984", bg = "#32302f" },
        WhichKeyValue = { fg = "#83a598" },
    }
    
    for hl, col in pairs(wk_highlights) do
        vim.api.nvim_set_hl(0, hl, col)
    end
end

return M