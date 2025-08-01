-- Mini.nvim configuration for additional aesthetic features
local M = {}

function M.setup()
    local function safe_require(module)
        local ok, result = pcall(require, module)
        if not ok then
            vim.notify("Module " .. module .. " not found, skipping setup", vim.log.levels.WARN)
            return nil
        end
        return result
    end
    
    -- Mini.animate for smooth animations
    local animate = safe_require('mini.animate')
    if animate then
        animate.setup({
            cursor = {
                enable = true,
                timing = function(_, n) return 150 / n end,
            },
            scroll = {
                enable = true,
                timing = function(_, n) return 200 / n end,
            },
            resize = {
                enable = false,
            },
            open = {
                enable = true,
                timing = function(_, n) return 200 / n end,
            },
            close = {
                enable = true,
                timing = function(_, n) return 200 / n end,
            },
        })
    end
    
    -- Mini.indentscope for animated indent scope
    local indentscope = safe_require('mini.indentscope')
    if indentscope then
        indentscope.setup({
            symbol = "│",
            options = { try_as_border = true },
            draw = {
                delay = 100,
                animation = indentscope.gen_animation.quadratic({
                    easing = 'out',
                    duration = 100,
                }),
            },
            mappings = {
                object_scope = 'ii',
                object_scope_with_border = 'ai',
                goto_top = '[i',
                goto_bottom = ']i',
            },
        })
    end
    
    -- Mini.cursorword for highlighting word under cursor
    local cursorword = safe_require('mini.cursorword')
    if cursorword then
        cursorword.setup({
            delay = 100,
        })
    end
    
    -- Mini.pairs for auto-pairing brackets
    local pairs = safe_require('mini.pairs')
    if pairs then
        pairs.setup({
            modes = { insert = true, command = false, terminal = false },
            skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
            skip_ts = { 'string' },
            skip_unbalanced = true,
            markdown = true,
        })
    end
    
    -- Mini.surround for surrounding text objects
    local surround = safe_require('mini.surround')
    if surround then
        surround.setup({
            mappings = {
                add = 'sa',
                delete = 'sd',
                find = 'sf',
                find_left = 'sF',
                highlight = 'sh',
                replace = 'sr',
                update_n_lines = 'sn',
            },
            n_lines = 20,
            respect_selection_type = false,
            search_method = 'cover',
            silent = false,
        })
    end
    
    -- Mini.map for code minimap
    local map = safe_require('mini.map')
    if map then
        map.setup({
            integrations = {
                map.gen_integration.builtin_search(),
                map.gen_integration.diff(),
                map.gen_integration.diagnostic({
                    error = 'DiagnosticFloatingError',
                    warn  = 'DiagnosticFloatingWarn',
                    info  = 'DiagnosticFloatingInfo',
                    hint  = 'DiagnosticFloatingHint',
                }),
            },
            symbols = {
                encode = map.gen_encode_symbols.dot('4x2'),
                scroll_line = '█',
                scroll_view = '┃',
            },
            window = {
                side = 'right',
                width = 20,
                winblend = 25,
                focusable = false,
                show_integration_count = true,
            },
        })
    end
    
    -- Mini.starter for a beautiful start screen
    local starter = safe_require('mini.starter')
    if starter then
        starter.setup({
            evaluate_single = true,
            header = table.concat({
                [[  ███╗   ██╗███████╗ ██████╗ ██╗   ██║██╗███╗   ███╗]],
                [[  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║]],
                [[  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║]],
                [[  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║]],
                [[  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║]],
                [[  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
                [[                                                    ]],
                [[       🚀 Welcome back! Ready to code? 🚀          ]],
            }, '\n'),
            items = {
                starter.sections.builtin_actions(),
                starter.sections.recent_files(10, false),
                starter.sections.recent_files(10, true),
            },
            content_hooks = {
                starter.gen_hook.adding_bullet(),
                starter.gen_hook.indexing('all', { 'Builtin actions' }),
                starter.gen_hook.padding(3, 2),
            },
            footer = function()
                local datetime = os.date("%Y-%m-%d %H:%M:%S")
                return "⚡ Neovim loaded successfully - " .. datetime
            end,
        })
    end
    
    -- Custom highlights for mini modules
    local mini_highlights = {
        MiniAnimateCursor = { reverse = true, nocombine = true },
        MiniCursorword = { bg = "#504945" },
        MiniCursorwordCurrent = { bg = "#504945" },
        MiniIndentscopeSymbol = { fg = "#fabd2f", bold = true },
        MiniIndentscopePrefix = { nocombine = true },
        MiniMapNormal = { bg = "#1d2021", fg = "#504945" },
        MiniMapSymbolCount = { fg = "#8ec07c", bold = true },
        MiniMapSymbolLine = { fg = "#83a598" },
        MiniMapSymbolView = { fg = "#fabd2f", bold = true },
        MiniStarterCurrent = { fg = "#fabd2f", bold = true },
        MiniStarterFooter = { fg = "#8ec07c", italic = true },
        MiniStarterHeader = { fg = "#fe8019", bold = true },
        MiniStarterInactive = { fg = "#928374" },
        MiniStarterItem = { fg = "#ebdbb2" },
        MiniStarterItemBullet = { fg = "#83a598" },
        MiniStarterItemPrefix = { fg = "#fabd2f" },
        MiniStarterSection = { fg = "#d3869b", bold = true },
        MiniStarterQuery = { fg = "#8ec07c" },
    }
    
    for hl, col in pairs(mini_highlights) do
        vim.api.nvim_set_hl(0, hl, col)
    end
    
    -- Disable indentscope for certain filetypes
    vim.api.nvim_create_autocmd('FileType', {
        pattern = {
            'help', 'alpha', 'dashboard', 'neo-tree', 'NvimTree', 'Trouble', 'trouble',
            'lazy', 'mason', 'notify', 'toggleterm', 'lazyterm', 'ministarter'
        },
        callback = function()
            vim.b.miniindentscope_disable = true
        end,
    })
end

return M