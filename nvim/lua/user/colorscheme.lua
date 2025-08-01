-- Enhanced colorscheme configuration for a professional look
local M = {}

function M.setup()
    -- Configure gruvbox for maximum beauty
    vim.g.gruvbox_material_background = 'medium'
    vim.g.gruvbox_material_foreground = 'material'
    vim.g.gruvbox_material_enable_italic = 1
    vim.g.gruvbox_material_enable_bold = 1
    vim.g.gruvbox_material_diagnostic_text_highlight = 1
    vim.g.gruvbox_material_diagnostic_line_highlight = 1
    vim.g.gruvbox_material_diagnostic_virtual_text = 'colored'
    vim.g.gruvbox_material_current_word = 'grey background'
    vim.g.gruvbox_material_statusline_style = 'material'
    vim.g.gruvbox_material_lightline_disable_bold = 0

    -- Enable transparency for a modern look
    vim.g.gruvbox_material_transparent_background = 1
    
    -- Set colorscheme
    vim.cmd("colorscheme gruvbox")
    
    -- Custom highlight groups for enhanced aesthetics
    local function set_highlights()
        local highlights = {
            -- Make line numbers more subtle but visible
            LineNr = { fg = "#665c54", bg = "NONE" },
            CursorLineNr = { fg = "#fabd2f", bg = "NONE", bold = true },
            
            -- Enhanced cursor line
            CursorLine = { bg = "#32302f" },
            
            -- Better visual selection
            Visual = { bg = "#504945" },
            
            -- Enhanced search highlighting
            Search = { bg = "#fabd2f", fg = "#1d2021", bold = true },
            IncSearch = { bg = "#fe8019", fg = "#1d2021", bold = true },
            
            -- Better matching parentheses
            MatchParen = { bg = "#fb4934", fg = "#1d2021", bold = true },
            
            -- Enhanced comments with italic
            Comment = { fg = "#928374", italic = true },
            
            -- Better floating windows
            NormalFloat = { bg = "#32302f", fg = "#ebdbb2" },
            FloatBorder = { bg = "#32302f", fg = "#a89984" },
            
            -- Enhanced telescope
            TelescopeNormal = { bg = "#282828" },
            TelescopeBorder = { bg = "#282828", fg = "#a89984" },
            TelescopeTitle = { fg = "#fabd2f", bold = true },
            TelescopeSelection = { bg = "#504945", fg = "#ebdbb2", bold = true },
            TelescopeSelectionCaret = { fg = "#fe8019" },
            TelescopeMultiSelection = { fg = "#8ec07c" },
            TelescopeMatching = { fg = "#fabd2f", bold = true },
            
            -- Enhanced diagnostics
            DiagnosticError = { fg = "#fb4934" },
            DiagnosticWarn = { fg = "#fabd2f" },
            DiagnosticInfo = { fg = "#83a598" },
            DiagnosticHint = { fg = "#8ec07c" },
            
            -- Better fold colors
            Folded = { bg = "#3c3836", fg = "#a89984", italic = true },
            FoldColumn = { bg = "NONE", fg = "#665c54" },
            
            -- Enhanced tab line
            TabLineFill = { bg = "#1d2021" },
            TabLine = { bg = "#32302f", fg = "#a89984" },
            TabLineSel = { bg = "#504945", fg = "#ebdbb2", bold = true },
        }
        
        for group, opts in pairs(highlights) do
            vim.api.nvim_set_hl(0, group, opts)
        end
    end
    
    -- Apply highlights
    set_highlights()
    
    -- Create autocmd to reapply highlights when colorscheme changes
    vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "*",
        callback = set_highlights,
    })
end

return M