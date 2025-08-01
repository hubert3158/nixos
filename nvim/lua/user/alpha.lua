-- Beautiful Alpha dashboard configuration
local M = {}

function M.setup()
    local ok, alpha = pcall(require, 'alpha')
    if not ok then
        vim.notify("alpha.nvim not found, skipping setup", vim.log.levels.WARN)
        return
    end
    
    local dashboard = require('alpha.themes.dashboard')
    
    -- Custom ASCII art header
    dashboard.section.header.val = {
        [[                                                     ]],
        [[  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ]],
        [[  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ]],
        [[  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ]],
        [[  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ]],
        [[  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ]],
        [[  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ]],
        [[                                                     ]],
        [[    🚀 Welcome back! Ready to write some code? 🚀    ]],
        [[                                                     ]],
    }
    
    -- Menu buttons
    dashboard.section.buttons.val = {
        dashboard.button("f", "  Find File", ":Telescope find_files <CR>"),
        dashboard.button("r", "  Recent Files", ":Telescope oldfiles <CR>"),
        dashboard.button("g", "  Find Text", ":Telescope live_grep <CR>"),
        dashboard.button("c", "  Configuration", ":e $MYVIMRC <CR>"),
        dashboard.button("p", "  Projects", ":Telescope zoxide list <CR>"),
        dashboard.button("s", "  Restore Session", ":SessionRestore <CR>"),
        dashboard.button("l", "  LazyGit", ":LazyGit <CR>"),
        dashboard.button("q", "  Quit", ":qa <CR>"),
    }
    
    -- Footer
    local function footer()
        local datetime = os.date("  %d-%m-%Y   %H:%M:%S")
        local version = vim.version()
        local nvim_version_info = "   v" .. version.major .. "." .. version.minor .. "." .. version.patch
        
        return datetime .. "   " .. nvim_version_info
    end
    
    dashboard.section.footer.val = footer()
    
    -- Layout
    dashboard.config.layout = {
        { type = "padding", val = 2 },
        dashboard.section.header,
        { type = "padding", val = 2 },
        dashboard.section.buttons,
        { type = "padding", val = 1 },
        dashboard.section.footer,
    }
    
    -- Disable folding on alpha buffer
    vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
    
    -- Setup alpha
    alpha.setup(dashboard.config)
    
    -- Custom highlights for alpha
    local alpha_highlights = {
        AlphaHeader = { fg = "#fabd2f", bold = true },
        AlphaButtons = { fg = "#83a598" },
        AlphaShortcut = { fg = "#fe8019", bold = true },
        AlphaFooter = { fg = "#8ec07c", italic = true },
    }
    
    for hl, col in pairs(alpha_highlights) do
        vim.api.nvim_set_hl(0, hl, col)
    end
    
    -- Hide tabline and statusline on alpha
    vim.api.nvim_create_autocmd("User", {
        pattern = "AlphaReady",
        desc = "disable status and tabline for alpha",
        callback = function()
            vim.go.laststatus = 0
            vim.opt.showtabline = 0
        end,
    })
    
    vim.api.nvim_create_autocmd("BufUnload", {
        buffer = 0,
        desc = "enable status and tabline after alpha",
        callback = function()
            vim.go.laststatus = 3
            vim.opt.showtabline = 2
        end,
    })
end

return M