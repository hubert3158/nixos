-- Beautiful satellite scrollbar configuration
local M = {}

function M.setup()
    local ok, satellite = pcall(require, 'satellite')
    if not ok then
        vim.notify("satellite.nvim not found, skipping setup", vim.log.levels.WARN)
        return
    end
    
    satellite.setup({
        current_only = false,
        winblend = 50,
        zindex = 40,
        excluded_filetypes = {
            'prompt',
            'TelescopePrompt',
            'noice',
            'notify',
            'neo-tree',
            'dashboard',
            'alpha',
            'lazy',
            'mason',
            'toggleterm',
            'NvimTree',
            'trouble',
        },
        width = 2,
        handlers = {
            cursor = {
                enable = true,
                symbols = { '⎺', '⎻', '⎼', '⎽' }
            },
            search = {
                enable = true,
                signs = { '-', '=' },
                priority = 1,
            },
            diagnostic = {
                enable = true,
                signs = {'-', '='},
                min_severity = vim.diagnostic.severity.HINT,
            },
            gitsigns = {
                enable = true,
                signs = { -- can only be a single character (multibyte is okay)
                    add = "│",
                    change = "│",
                    delete = "-",
                },
            },
            marks = {
                enable = true,
                key = 'm',
                show_builtins = false, -- shows the builtin marks like [ ] < >
            },
            quickfix = {
                signs = { '-', '=' },
                enable = true,
            }
        },
    })
    
    -- Custom highlights for satellite
    local satellite_highlights = {
        SatelliteBar = { bg = "#504945" },
        SatelliteCursor = { fg = "#fabd2f", bold = true },
        SatelliteSearch = { fg = "#fabd2f" },
        SatelliteQuickfix = { fg = "#83a598" },
        SatelliteMark = { fg = "#d3869b" },
        SatelliteGitSignsAdd = { fg = "#8ec07c" },
        SatelliteGitSignsChange = { fg = "#fabd2f" },
        SatelliteGitSignsDelete = { fg = "#fb4934" },
        SatelliteDiagnosticError = { fg = "#fb4934" },
        SatelliteDiagnosticWarn = { fg = "#fabd2f" },
        SatelliteDiagnosticInfo = { fg = "#83a598" },
        SatelliteDiagnosticHint = { fg = "#8ec07c" },
    }
    
    for hl, col in pairs(satellite_highlights) do
        vim.api.nvim_set_hl(0, hl, col)
    end
end

return M