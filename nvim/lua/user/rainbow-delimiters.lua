-- Beautiful rainbow delimiters configuration
local M = {}

function M.setup()
    local ok, rainbow_delimiters = pcall(require, 'rainbow-delimiters')
    if not ok then
        vim.notify("rainbow-delimiters.nvim not found, skipping setup", vim.log.levels.WARN)
        return
    end
    
    require('rainbow-delimiters.setup').setup {
        strategy = {
            [''] = rainbow_delimiters.strategy['global'],
            vim = rainbow_delimiters.strategy['local'],
        },
        query = {
            [''] = 'rainbow-delimiters',
            lua = 'rainbow-blocks',
        },
        priority = {
            [''] = 110,
            lua = 210,
        },
        highlight = {
            'RainbowDelimiterRed',
            'RainbowDelimiterYellow',
            'RainbowDelimiterBlue',
            'RainbowDelimiterOrange',
            'RainbowDelimiterGreen',
            'RainbowDelimiterViolet',
            'RainbowDelimiterCyan',
        },
        blacklist = {'c', 'cpp'},
    }
    
    -- Custom highlight groups for rainbow delimiters
    local rainbow_highlights = {
        RainbowDelimiterRed = { fg = "#fb4934", bold = true },
        RainbowDelimiterYellow = { fg = "#fabd2f", bold = true },
        RainbowDelimiterBlue = { fg = "#83a598", bold = true },
        RainbowDelimiterOrange = { fg = "#fe8019", bold = true },
        RainbowDelimiterGreen = { fg = "#8ec07c", bold = true },
        RainbowDelimiterViolet = { fg = "#d3869b", bold = true },
        RainbowDelimiterCyan = { fg = "#8ec07c", bold = true },
    }
    
    for hl, col in pairs(rainbow_highlights) do
        vim.api.nvim_set_hl(0, hl, col)
    end
end

return M