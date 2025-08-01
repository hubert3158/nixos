-- Beautiful notification configuration
local M = {}

function M.setup()
    require("notify").setup({
        background_colour = "#1d2021",
        fps = 30,
        icons = {
            DEBUG = "",
            ERROR = "",
            INFO = "",
            TRACE = "✎",
            WARN = ""
        },
        level = 2,
        minimum_width = 50,
        render = "wrapped-compact",
        stages = "fade_in_slide_out",
        time_formats = {
            notification = "%T",
            notification_history = "%FT%T"
        },
        timeout = 3000,
        top_down = true,
        max_height = function()
            return math.floor(vim.o.lines * 0.75)
        end,
        max_width = function()
            return math.floor(vim.o.columns * 0.75)
        end,
        on_open = function(win)
            vim.api.nvim_win_set_config(win, { zindex = 100 })
        end,
    })
    
    -- Custom highlights for notifications
    local notify_highlights = {
        NotifyERRORBorder = { fg = "#fb4934" },
        NotifyWARNBorder = { fg = "#fabd2f" },
        NotifyINFOBorder = { fg = "#83a598" },
        NotifyDEBUGBorder = { fg = "#8ec07c" },
        NotifyTRACEBorder = { fg = "#d3869b" },
        NotifyERRORIcon = { fg = "#fb4934" },
        NotifyWARNIcon = { fg = "#fabd2f" },
        NotifyINFOIcon = { fg = "#83a598" },
        NotifyDEBUGIcon = { fg = "#8ec07c" },
        NotifyTRACEIcon = { fg = "#d3869b" },
        NotifyERRORTitle = { fg = "#fb4934", bold = true },
        NotifyWARNTitle = { fg = "#fabd2f", bold = true },
        NotifyINFOTitle = { fg = "#83a598", bold = true },
        NotifyDEBUGTitle = { fg = "#8ec07c", bold = true },
        NotifyTRACETitle = { fg = "#d3869b", bold = true },
        NotifyERRORBody = { fg = "#ebdbb2", bg = "#32302f" },
        NotifyWARNBody = { fg = "#ebdbb2", bg = "#32302f" },
        NotifyINFOBody = { fg = "#ebdbb2", bg = "#32302f" },
        NotifyDEBUGBody = { fg = "#ebdbb2", bg = "#32302f" },
        NotifyTRACEBody = { fg = "#ebdbb2", bg = "#32302f" },
    }
    
    for hl, col in pairs(notify_highlights) do
        vim.api.nvim_set_hl(0, hl, col)
    end
    
    -- Set notify as default notification handler
    vim.notify = require("notify")
end

return M