-- Professional telescope configuration with beautiful styling
local M = {}

function M.setup()
    local telescope = require('telescope')
    local actions = require('telescope.actions')
    local action_state = require('telescope.actions.state')
    
    telescope.setup {
        defaults = {
            prompt_prefix = "   ",
            selection_caret = "  ",
            entry_prefix = "  ",
            initial_mode = "insert",
            selection_strategy = "reset",
            sorting_strategy = "ascending",
            layout_strategy = "horizontal",
            layout_config = {
                horizontal = {
                    prompt_position = "top",
                    preview_width = 0.55,
                    results_width = 0.8,
                },
                vertical = {
                    mirror = false,
                },
                width = 0.87,
                height = 0.80,
                preview_cutoff = 120,
            },
            file_sorter = require("telescope.sorters").get_fuzzy_file,
            file_ignore_patterns = { "node_modules", ".git/", "dist/", "build/" },
            generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
            path_display = { "truncate" },
            winblend = 0,
            border = {},
            borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
            color_devicons = true,
            set_env = { ["COLORTERM"] = "truecolor" },
            file_previewer = require("telescope.previewers").vim_buffer_cat.new,
            grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
            qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
            buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
            vimgrep_arguments = {
                "rg",
                "--color=never",
                "--no-heading",
                "--with-filename",
                "--line-number",
                "--column",
                "--smart-case",
                "--hidden",
                "--glob=!.git/",
            },
            mappings = {
                i = {
                    ["<C-n>"] = actions.cycle_history_next,
                    ["<C-p>"] = actions.cycle_history_prev,
                    ["<C-j>"] = actions.move_selection_next,
                    ["<C-k>"] = actions.move_selection_previous,
                    ["<C-c>"] = actions.close,
                    ["<Down>"] = actions.move_selection_next,
                    ["<Up>"] = actions.move_selection_previous,
                    ["<CR>"] = actions.select_default,
                    ["<C-x>"] = actions.select_horizontal,
                    ["<C-v>"] = actions.select_vertical,
                    ["<C-t>"] = actions.select_tab,
                    ["<C-u>"] = actions.preview_scrolling_up,
                    ["<C-d>"] = actions.preview_scrolling_down,
                    ["<PageUp>"] = actions.results_scrolling_up,
                    ["<PageDown>"] = actions.results_scrolling_down,
                    ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
                    ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
                    ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
                    ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                    ["<C-l>"] = actions.complete_tag,
                    ["<C-_>"] = actions.which_key,
                },
                n = {
                    ["<esc>"] = actions.close,
                    ["<CR>"] = actions.select_default,
                    ["<C-x>"] = actions.select_horizontal,
                    ["<C-v>"] = actions.select_vertical,
                    ["<C-t>"] = actions.select_tab,
                    ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
                    ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
                    ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
                    ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                    ["j"] = actions.move_selection_next,
                    ["k"] = actions.move_selection_previous,
                    ["H"] = actions.move_to_top,
                    ["M"] = actions.move_to_middle,
                    ["L"] = actions.move_to_bottom,
                    ["<Down>"] = actions.move_selection_next,
                    ["<Up>"] = actions.move_selection_previous,
                    ["gg"] = actions.move_to_top,
                    ["G"] = actions.move_to_bottom,
                    ["<C-u>"] = actions.preview_scrolling_up,
                    ["<C-d>"] = actions.preview_scrolling_down,
                    ["<PageUp>"] = actions.results_scrolling_up,
                    ["<PageDown>"] = actions.results_scrolling_down,
                    ["?"] = actions.which_key,
                },
            },
        },
        pickers = {
            find_files = {
                find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
                layout_config = {
                    height = 0.70,
                },
            },
            live_grep = {
                only_sort_text = true,
                layout_config = {
                    horizontal = {
                        width = 0.9,
                        preview_width = 0.6,
                    },
                },
            },
            grep_string = {
                only_sort_text = true,
                layout_config = {
                    horizontal = {
                        width = 0.9,
                        preview_width = 0.6,
                    },
                },
            },
            buffers = {
                show_all_buffers = true,
                sort_lastused = true,
                previewer = false,
                layout_config = {
                    width = 0.5,
                    height = 0.4,
                },
                mappings = {
                    i = {
                        ["<c-d>"] = actions.delete_buffer,
                    },
                    n = {
                        ["dd"] = actions.delete_buffer,
                    },
                },
            },
            planets = {
                show_pluto = true,
                show_moon = true,
            },
            git_files = {
                hidden = true,
                show_untracked = true,
            },
            colorscheme = {
                enable_preview = true,
            },
        },
        extensions = {
            fzf = {
                fuzzy = true,
                override_generic_sorter = true,
                override_file_sorter = true,
                case_mode = "smart_case",
            },
            ["zoxide"] = {
                prompt_title = "[ Zoxide List ]",
                mappings = {
                    default = {
                        after_action = function(selection)
                            print("Update to (" .. selection.z_score .. ") " .. selection.path)
                        end
                    },
                    ["<C-s>"] = {
                        before_action = function(selection) print("before C-s") end,
                        action = function(selection)
                            vim.cmd.edit(selection.path)
                        end
                    },
                    ["<C-q>"] = { action = actions.send_selected_to_qflist + actions.open_qflist },
                }
            }
        },
    }
    
    -- Load extensions
    telescope.load_extension('fzf')
    telescope.load_extension('zoxide')
    
    -- Custom highlights for telescope
    local TelescopeColor = {
        TelescopeMatching = { fg = "#fabd2f", bold = true },
        TelescopeSelection = { fg = "#ebdbb2", bg = "#504945", bold = true },
        TelescopePromptPrefix = { fg = "#fe8019", bold = true },
        TelescopePromptNormal = { bg = "#3c3836" },
        TelescopeResultsNormal = { bg = "#282828" },
        TelescopePreviewNormal = { bg = "#1d2021" },
        TelescopePromptBorder = { bg = "#3c3836", fg = "#a89984" },
        TelescopeResultsBorder = { bg = "#282828", fg = "#a89984" },
        TelescopePreviewBorder = { bg = "#1d2021", fg = "#a89984" },
        TelescopePromptTitle = { bg = "#fe8019", fg = "#1d2021", bold = true },
        TelescopeResultsTitle = { fg = "#8ec07c", bold = true },
        TelescopePreviewTitle = { bg = "#8ec07c", fg = "#1d2021", bold = true },
    }
    
    for hl, col in pairs(TelescopeColor) do
        vim.api.nvim_set_hl(0, hl, col)
    end
end

return M