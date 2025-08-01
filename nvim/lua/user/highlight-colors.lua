-- Beautiful color highlighting configuration
local M = {}

function M.setup()
    local ok, highlight_colors = pcall(require, 'nvim-highlight-colors')
    if not ok then
        vim.notify("nvim-highlight-colors not found, skipping setup", vim.log.levels.WARN)
        return
    end
    
    highlight_colors.setup({
        render = 'background', -- or 'foreground' or 'first_column'
        enable_named_colors = true,
        enable_tailwind = true,
        custom_colors = {
            { label = '%-%-theme%-primary%-color', color = '#0f1419' },
            { label = '%-%-theme%-secondary%-color', color = '#5a5a5a' },
        }
    })
end

return M