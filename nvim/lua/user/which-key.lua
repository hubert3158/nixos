-- Beautiful which-key configuration
local M = {}

function M.setup()
    local wk = require("which-key")
    
    wk.setup({
        preset = "modern",
        notify = false,
        triggers = {
            { "<leader>", mode = { "n", "v" } },
        },
        spec = {
            -- Find mappings
            { "<leader>f", group = " Find" },
            { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
            { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
            { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
            { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help Tags" },
            { "<leader>fs", "<cmd>Telescope builtin<cr>", desc = "Telescope Builtins" },
            { "<leader>fc", "<cmd>Telescope commands<cr>", desc = "Commands" },
            { "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
            { "<leader>fm", "<cmd>Telescope marks<cr>", desc = "Marks" },
            { "<leader>fo", "<cmd>Telescope oldfiles<cr>", desc = "Recent Files" },
            
            -- Git mappings
            { "<leader>g", group = " Git" },
            { "<leader>gs", "<cmd>Git<cr>", desc = "Status" },
            { "<leader>gc", "<cmd>Git commit<cr>", desc = "Commit" },
            { "<leader>gp", "<cmd>Git push<cr>", desc = "Push" },
            { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
            
            -- File Explorer
            { "<leader>n", group = " File Explorer" },
            { "<leader>nt", "<cmd>NvimTreeToggle<cr>", desc = "Toggle NvimTree" },
            { "<leader>nf", "<cmd>NvimTreeFocus<cr>", desc = "Focus NvimTree" },
            
            -- Diagnostics
            { "<leader>x", group = " Diagnostics" },
            { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Toggle Diagnostics" },
            { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics" },
            { "<leader>xs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols" },
            { "<leader>xl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP" },
            { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List" },
            { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List" },
            { "<leader>xt", "<cmd>Trouble todo<cr>", desc = "TODOs" },
            { "<leader>xw", "<cmd>Trouble diagnostics toggle focus=false<cr>", desc = "Workspace Diagnostics" },
            { "<leader>xT", "<cmd>TodoTelescope<cr>", desc = "Search TODOs" },
            
            -- Code mappings
            { "<leader>c", group = " Code" },
            { "<leader>cc", "<cmd>CodeCompanionChat anthropic<cr>", desc = "Code Companion Chat" },
            { "<leader>ca", "<cmd>CodeCompanionActions<cr>", desc = "Code Companion Actions" },
            { "<leader>ch", "<cmd>nohlsearch<cr>", desc = "Clear Highlights" },
            
            -- Refactor mappings (normal mode)
            { "<leader>r", group = " Refactor" },
            { "<leader>re", desc = "Extract Function" },
            { "<leader>rf", desc = "Extract Function To File" },
            { "<leader>rv", desc = "Extract Variable" },
            { "<leader>rI", desc = "Inline Function" },
            { "<leader>ri", desc = "Inline Variable" },
            { "<leader>rb", group = "Extract Block" },
            { "<leader>rbb", desc = "Extract Block" },
            { "<leader>rbf", desc = "Extract Block To File" },
            
            -- Refactor mappings (visual mode)
            { mode = { "v" }, "<leader>r", group = " Refactor" },
            { mode = { "v" }, "<leader>re", desc = "Extract Function" },
            { mode = { "v" }, "<leader>rf", desc = "Extract Function To File" },
            { mode = { "v" }, "<leader>rv", desc = "Extract Variable" },
            { mode = { "v" }, "<leader>rI", desc = "Inline Function" },
            { mode = { "v" }, "<leader>ri", desc = "Inline Variable" },
            { mode = { "v" }, "<leader>rb", group = "Extract Block" },
            { mode = { "v" }, "<leader>rbb", desc = "Extract Block" },
            { mode = { "v" }, "<leader>rbf", desc = "Extract Block To File" },
            
            -- Buffer mappings
            { "<leader>b", group = " Buffer" },
            { "<leader>bn", "<cmd>bnext<cr>", desc = "Next Buffer" },
            { "<leader>bp", "<cmd>bprevious<cr>", desc = "Previous Buffer" },
            { "<leader>bd", "<cmd>bd<cr>", desc = "Delete Buffer" },
            
            -- Split and window mappings
            { "<leader>s", group = " Split" },
            { "<leader>sv", "<cmd>vsp<cr>", desc = "Vertical Split" },
            { "<leader>sh", "<cmd>sp<cr>", desc = "Horizontal Split" },
            { "<leader>sr", ":%s/\\<<C-r><C-w>\\>//g<Left><Left>", desc = "Search & Replace" },
            { "<leader>sp", "<cmd>set spell!<cr>", desc = "Toggle Spell Check" },
            
            -- Toggle mappings
            { "<leader>t", group = " Toggle" },
            { "<leader>tt", "<cmd>ToggleTerm<cr>", desc = "Terminal" },
            { "<leader>tl", "<cmd>set relativenumber!<cr>", desc = "Relative Numbers" },
            { "<leader>tw", "<cmd>set wrap!<cr>", desc = "Toggle Wrap Mode" },
            
            -- Window management
            { "<leader>wr", group = " Window Resize" },
            { "<leader>wr=", "<cmd>vertical resize +5<cr>", desc = "Increase Width" },
            { "<leader>wr-", "<cmd>vertical resize -5<cr>", desc = "Decrease Width" },
            
            -- Miscellaneous
            { "<leader>m", group = " Misc" },
            { "<leader>mm", "<cmd>lua require'mini.map'.toggle()<cr>", desc = "Toggle Mini Map" },
            { "<leader>mt", "<cmd>Twilight<cr>", desc = "Twilight" },
            { "<leader>ma", "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdown Preview" },
            
            -- Debug mappings
            { "<leader>e", group = " Debug" },
            { "<leader>eb", desc = "Toggle Breakpoint" },
            { "<leader>eB", desc = "Conditional Breakpoint" },
            { "<leader>eC", desc = "Clear All Breakpoints" },
            { "<leader>ed", desc = "Disconnect" },
            { "<leader>eh", desc = "Hover Variable" },
            { "<leader>es", desc = "Show Scopes" },
            { "<leader>ef", desc = "Show Frames" },
            { "<leader>er", desc = "Open REPL" },
            
            -- Kulala HTTP
            { "<leader>k", group = " Kulala HTTP" },
            { "<leader>ks", desc = "Execute Request" },
            { "<leader>ka", desc = "Execute All Requests" },
            { "<leader>kr", desc = "Replay Request" },
            { "<leader>kb", desc = "Show Response Body" },
            { "<leader>kh", desc = "Show Response Headers" },
            { "<leader>kS", desc = "Open Scratchpad" },
            { "<leader>ko", desc = "Open in New Buffer" },
            { "<leader>kt", desc = "Toggle View" },
            { "<leader>kf", desc = "Search Endpoints" },
            { "<leader>kc", desc = "Copy Command" },
            
            -- Config mappings
            { "<leader>v", group = " Config" },
            { "<leader>ve", "<cmd>e $MYVIMRC<cr>", desc = "Edit Config" },
            { "<leader>vs", "<cmd>source $MYVIMRC<cr>", desc = "Source Config" },
            
            -- Utils
            { "<leader>u", group = " Utils" },
            { "<leader>un", "<cmd>lua require('notify').dismiss({ silent = true, pending = true })<cr>", desc = "Dismiss Notifications" },
            
            -- Single key mappings
            { "<leader>y", "<cmd>lua require'yazi'.yazi()<cr>", desc = " Open Yazi" },
            { "<leader>q", "<cmd>q<cr>", desc = " Quit" },
            { "<leader>w", "<cmd>w<cr>", desc = " Save" },
            { "<leader><F5>", "<cmd>UndotreeToggle<cr>", desc = "Undo Tree" },
            { "<leader>/", desc = "Toggle Comment" },
            { "<leader>h", "<cmd>bprev<cr>", desc = "Previous Buffer" },
            { "<leader>l", "<cmd>bnext<cr>", desc = "Next Buffer" },
            { "<leader>p", '"+p', desc = "Paste from Clipboard" },
            { "<leader>P", '"+P', desc = "Paste Before from Clipboard" },
            { "<leader>Y", 'gg"+yG', desc = "Yank All to Clipboard" },
            { "<leader>nn", desc = "Lint and Format" },
            { "<leader>nc", desc = "Generate Documentation" },
            { "<leader>cd", "<cmd>Telescope zoxide list<cr>", desc = "Zoxide Jump" },
            { "<leader>rr", "<cmd>!!<cr>", desc = "Rerun Last Command" },
            { "<leader>qa", "<cmd>qa!<cr>", desc = "Quit All" },
            
            -- Visual mode specific
            { mode = { "v" }, "<leader>/", desc = "Toggle Comment" },
            { mode = { "v" }, "<leader>y", '"+y', desc = "Yank to Clipboard" },
        },
    })
    
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