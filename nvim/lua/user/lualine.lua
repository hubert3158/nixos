-- Professional and beautiful lualine configuration
local M = {}

function M.setup()
    require('lualine').setup {
        options = {
            icons_enabled = true,
            theme = 'gruvbox-material',
            component_separators = { left = '', right = '' },
            section_separators = { left = '', right = '' },
            disabled_filetypes = {
                statusline = {'dashboard', 'alpha', 'ministarter'},
                winbar = {},
            },
            ignore_focus = {},
            always_divide_middle = true,
            globalstatus = true,
            refresh = {
                statusline = 1000,
                tabline = 1000,
                winbar = 1000,
            }
        },
        sections = {
            lualine_a = {
                {
                    'mode',
                    fmt = function(str)
                        local mode_map = {
                            ['NORMAL'] = '  NORMAL',
                            ['INSERT'] = '  INSERT', 
                            ['VISUAL'] = '  VISUAL',
                            ['V-LINE'] = '  V-LINE',
                            ['V-BLOCK'] = '  V-BLOCK',
                            ['COMMAND'] = '  COMMAND',
                            ['REPLACE'] = '  REPLACE',
                            ['SELECT'] = '  SELECT',
                            ['TERMINAL'] = '  TERMINAL',
                        }
                        return mode_map[str] or str
                    end
                }
            },
            lualine_b = {
                {
                    'branch',
                    icon = '',
                    color = { fg = '#fabd2f', gui = 'bold' }
                },
                {
                    'diff',
                    symbols = { added = ' ', modified = ' ', removed = ' ' },
                    diff_color = {
                        added = { fg = '#8ec07c' },
                        modified = { fg = '#fabd2f' },
                        removed = { fg = '#fb4934' }
                    },
                },
            },
            lualine_c = {
                {
                    'filename',
                    file_status = true,
                    newfile_status = false,
                    path = 1, -- Show relative path
                    symbols = {
                        modified = ' ●',
                        readonly = ' ',
                        unnamed = '[No Name]',
                        newfile = ' [New]',
                    },
                    color = { fg = '#ebdbb2', gui = 'bold' }
                },
                {
                    'diagnostics',
                    sources = { 'nvim_diagnostic' },
                    sections = { 'error', 'warn', 'info', 'hint' },
                    symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' },
                    colored = true,
                    update_in_insert = false,
                    always_visible = false,
                },
            },
            lualine_x = {
                {
                    function()
                        local clients = vim.lsp.get_active_clients({ bufnr = 0 })
                        if #clients == 0 then return '' end
                        local names = {}
                        for _, client in ipairs(clients) do
                            table.insert(names, client.name)
                        end
                        return ' ' .. table.concat(names, ', ')
                    end,
                    color = { fg = '#8ec07c', gui = 'bold' }
                },
                {
                    'encoding',
                    fmt = string.upper,
                    color = { fg = '#a89984' }
                },
                {
                    'fileformat',
                    symbols = {
                        unix = ' LF',
                        dos = ' CRLF',
                        mac = ' CR',
                    },
                    color = { fg = '#a89984' }
                },
                {
                    'filetype',
                    colored = true,
                    icon_only = false,
                    icon = { align = 'right' },
                    color = { fg = '#83a598', gui = 'bold' }
                },
            },
            lualine_y = {
                {
                    'progress',
                    color = { fg = '#fabd2f', gui = 'bold' }
                },
                {
                    function()
                        local current_line = vim.fn.line('.')
                        local total_lines = vim.fn.line('$')
                        local chars = { '▁', '▂', '▃', '▄', '▅', '▆', '▇', '█' }
                        local line_ratio = current_line / total_lines
                        local index = math.ceil(line_ratio * #chars)
                        return chars[index]
                    end,
                    color = { fg = '#fe8019', gui = 'bold' }
                }
            },
            lualine_z = {
                {
                    'location',
                    icon = '',
                    color = { fg = '#ebdbb2', gui = 'bold' }
                }
            }
        },
        inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = { 'filename' },
            lualine_x = { 'location' },
            lualine_y = {},
            lualine_z = {}
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = { 'nvim-tree', 'toggleterm', 'trouble' }
    }
end

return M