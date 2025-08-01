-- Beautiful bufferline configuration
local M = {}

function M.setup()
    require('bufferline').setup {
        options = {
            mode = "buffers",
            style_preset = require('bufferline').style_preset.minimal,
            themable = true,
            numbers = "none",
            close_command = "bdelete! %d",
            right_mouse_command = "bdelete! %d",
            left_mouse_command = "buffer %d",
            middle_mouse_command = nil,
            indicator = {
                icon = '▎',
                style = 'icon',
            },
            buffer_close_icon = '󰅖',
            modified_icon = '●',
            close_icon = '',
            left_trunc_marker = '',
            right_trunc_marker = '',
            max_name_length = 30,
            max_prefix_length = 30,
            truncate_names = true,
            tab_size = 21,
            diagnostics = "nvim_lsp",
            diagnostics_update_in_insert = false,
            diagnostics_indicator = function(count, level, diagnostics_dict, context)
                local icon = level:match("error") and " " or " "
                return " " .. icon .. count
            end,
            color_icons = true,
            show_buffer_icons = true,
            show_buffer_close_icons = true,
            show_close_icon = true,
            show_tab_indicators = true,
            show_duplicate_prefix = true,
            persist_buffer_sort = true,
            move_wraps_at_ends = false,
            separator_style = "slant",
            enforce_regular_tabs = false,
            always_show_bufferline = true,
            hover = {
                enabled = true,
                delay = 200,
                reveal = {'close'}
            },
            sort_by = 'insert_after_current',
            offsets = {
                {
                    filetype = "NvimTree",
                    text = "  File Explorer",
                    highlight = "Directory",
                    separator = true
                },
                {
                    filetype = "neo-tree",
                    text = "  File Explorer",
                    highlight = "Directory",
                    separator = true
                }
            },
            custom_filter = function(buf_number, buf_numbers)
                -- filter out filetypes you don't want to see
                if vim.bo[buf_number].filetype ~= "qf" and vim.bo[buf_number].filetype ~= "fugitive" then
                    return true
                end
            end,
        },
        highlights = {
            separator = {
                fg = '#32302f',
                bg = '#32302f',
            },
            separator_selected = {
                fg = '#32302f',
            },
            background = {
                fg = '#a89984',
                bg = '#32302f'
            },
            buffer_selected = {
                fg = '#fabd2f',
                bg = '#282828',
                bold = true,
                italic = false,
            },
            fill = {
                bg = '#1d2021',
            },
            indicator_selected = {
                fg = '#fabd2f',
                bg = '#282828'
            },
            modified = {
                fg = '#fe8019',
                bg = '#32302f'
            },
            modified_selected = {
                fg = '#fe8019',
                bg = '#282828'
            },
            duplicate_selected = {
                fg = '#ebdbb2',
                bg = '#282828',
                italic = true,
            },
            duplicate_visible = {
                fg = '#a89984',
                bg = '#32302f',
                italic = true,
            },
            duplicate = {
                fg = '#a89984',
                bg = '#32302f',
                italic = true,
            },
            close_button = {
                fg = '#a89984',
                bg = '#32302f'
            },
            close_button_visible = {
                fg = '#a89984',
                bg = '#32302f'
            },
            close_button_selected = {
                fg = '#fb4934',
                bg = '#282828'
            },
            tab_selected = {
                fg = '#fabd2f',
                bg = '#282828'
            },
            tab = {
                fg = '#a89984',
                bg = '#32302f'
            },
            tab_close = {
                fg = '#fb4934',
                bg = '#32302f'
            },
            diagnostic = {
                fg = '#a89984',
                bg = '#32302f'
            },
            diagnostic_selected = {
                fg = '#fb4934',
                bg = '#282828',
                bold = true,
                italic = false,
            },
            info = {
                fg = '#83a598',
                bg = '#32302f'
            },
            info_selected = {
                fg = '#83a598',
                bg = '#282828',
                bold = true,
                italic = false,
            },
            info_diagnostic = {
                fg = '#83a598',
                bg = '#32302f'
            },
            info_diagnostic_selected = {
                fg = '#83a598',
                bg = '#282828',
                bold = true,
                italic = false,
            },
            warning = {
                fg = '#fabd2f',
                bg = '#32302f'
            },
            warning_selected = {
                fg = '#fabd2f',
                bg = '#282828',
                bold = true,
                italic = false,
            },
            warning_diagnostic = {
                fg = '#fabd2f',
                bg = '#32302f'
            },
            warning_diagnostic_selected = {
                fg = '#fabd2f',
                bg = '#282828',
                bold = true,
                italic = false,
            },
            error = {
                fg = '#fb4934',
                bg = '#32302f'
            },
            error_selected = {
                fg = '#fb4934',
                bg = '#282828',
                bold = true,
                italic = false,
            },
            error_diagnostic = {
                fg = '#fb4934',
                bg = '#32302f'
            },
            error_diagnostic_selected = {
                fg = '#fb4934',
                bg = '#282828',
                bold = true,
                italic = false,
            },
        }
    }
end

return M