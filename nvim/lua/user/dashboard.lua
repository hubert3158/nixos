-- Stunning dashboard configuration
local M = {}

function M.setup()
    local ok, dashboard = pcall(require, 'dashboard')
    if not ok then
        vim.notify("dashboard.nvim not found, skipping setup", vim.log.levels.WARN)
        return
    end
    
    -- ASCII art header
    local header = {
        "                                                     ",
        "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
        "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
        "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
        "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
        "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
        "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
        "                                                     ",
        "    🚀 Welcome back! Ready to write some code? 🚀    ",
        "                                                     ",
    }
    
    dashboard.setup({
        theme = 'doom',
        config = {
            header = header,
            center = {
                {
                    icon = '  ',
                    icon_hl = 'Title',
                    desc = 'Find File                            ',
                    desc_hl = 'String',
                    key = 'f',
                    keymap = 'SPC f f',
                    key_hl = 'Number',
                    action = 'Telescope find_files'
                },
                {
                    icon = '  ',
                    icon_hl = 'Title',
                    desc = 'Recent Files                         ',
                    desc_hl = 'String',
                    key = 'r',
                    keymap = 'SPC f o',
                    key_hl = 'Number',
                    action = 'Telescope oldfiles'
                },
                {
                    icon = '  ',
                    icon_hl = 'Title',
                    desc = 'Find Text                            ',
                    desc_hl = 'String',
                    key = 'g',
                    keymap = 'SPC f g',
                    key_hl = 'Number',
                    action = 'Telescope live_grep'
                },
                {
                    icon = '  ',
                    icon_hl = 'Title',
                    desc = 'File Explorer                        ',
                    desc_hl = 'String',
                    key = 'e',
                    keymap = 'SPC n t',
                    key_hl = 'Number',
                    action = 'NvimTreeToggle'
                },
                {
                    icon = '  ',
                    icon_hl = 'Title',
                    desc = 'Configuration                        ',
                    desc_hl = 'String',
                    key = 'c',
                    keymap = 'SPC v e',
                    key_hl = 'Number',
                    action = 'edit $MYVIMRC'
                },
                {
                    icon = '  ',
                    icon_hl = 'Title',
                    desc = 'Sessions                             ',
                    desc_hl = 'String',
                    key = 's',
                    keymap = ':SessionRestore',
                    key_hl = 'Number',
                    action = 'SessionRestore'
                },
                {
                    icon = '  ',
                    icon_hl = 'Title',
                    desc = 'LazyGit                              ',
                    desc_hl = 'String',
                    key = 'l',
                    keymap = 'SPC g g',
                    key_hl = 'Number',
                    action = 'LazyGit'
                },
                {
                    icon = '  ',
                    icon_hl = 'Title',
                    desc = 'Quit                                 ',
                    desc_hl = 'String',
                    key = 'q',
                    keymap = 'SPC q a',
                    key_hl = 'Number',
                    action = 'qa'
                },
            },
            footer = function()
                local stats = require("lazy").stats()
                local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
                return { 
                    "",
                    "⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms",
                    "",
                    "💻 Happy coding! " .. os.date("%Y-%m-%d %H:%M:%S")
                }
            end,
        }
    })
    
    -- Custom highlight groups for dashboard
    vim.api.nvim_set_hl(0, 'DashboardHeader', { fg = '#fabd2f', bold = true })
    vim.api.nvim_set_hl(0, 'DashboardCenter', { fg = '#ebdbb2' })
    vim.api.nvim_set_hl(0, 'DashboardShortcut', { fg = '#fe8019', bold = true })
    vim.api.nvim_set_hl(0, 'DashboardFooter', { fg = '#8ec07c', italic = true })
    
    -- Hide tabline and statusline on dashboard
    vim.api.nvim_create_autocmd('FileType', {
        pattern = 'dashboard',
        callback = function()
            vim.opt_local.laststatus = 0
            vim.opt_local.showtabline = 0
        end,
    })
    
    vim.api.nvim_create_autocmd('BufLeave', {
        pattern = 'dashboard',
        callback = function()
            vim.opt_local.laststatus = 3
            vim.opt_local.showtabline = 2
        end,
    })
end

return M