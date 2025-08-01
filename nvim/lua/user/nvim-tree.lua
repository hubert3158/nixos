-- Beautiful nvim-tree configuration
local M = {}

function M.setup()
    -- Disable netrw at the very start of your init.lua
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
    
    require("nvim-tree").setup({
        auto_reload_on_write = true,
        disable_netrw = false,
        hijack_cursor = true,
        hijack_netrw = true,
        hijack_unnamed_buffer_when_opening = false,
        sort_by = "name",
        root_dirs = {},
        prefer_startup_root = false,
        sync_root_with_cwd = true,
        reload_on_bufenter = false,
        respect_buf_cwd = false,
        on_attach = "default",
        select_prompts = false,
        view = {
            adaptive_size = false,
            centralize_selection = false,
            width = 35,
            side = "left",
            preserve_window_proportions = false,
            number = false,
            relativenumber = false,
            signcolumn = "yes",
            float = {
                enable = false,
                quit_on_focus_loss = true,
                open_win_config = {
                    relative = "editor",
                    border = "rounded",
                    width = 30,
                    height = 30,
                    row = 1,
                    col = 1,
                },
            },
        },
        renderer = {
            add_trailing = false,
            group_empty = false,
            highlight_git = true,
            full_name = false,
            highlight_opened_files = "name",
            highlight_modified = "name",
            root_folder_label = ":~:s?$?/..?",
            indent_width = 2,
            indent_markers = {
                enable = true,
                inline_arrows = true,
                icons = {
                    corner = "└",
                    edge = "│",
                    item = "│",
                    bottom = "─",
                    none = " ",
                },
            },
            icons = {
                webdev_colors = true,
                git_placement = "before",
                modified_placement = "after",
                padding = " ",
                symlink_arrow = " ➛ ",
                show = {
                    file = true,
                    folder = true,
                    folder_arrow = true,
                    git = true,
                    modified = true,
                },
                glyphs = {
                    default = "󰈚",
                    symlink = "",
                    bookmark = "",
                    modified = "●",
                    folder = {
                        arrow_closed = "",
                        arrow_open = "",
                        default = "",
                        open = "",
                        empty = "",
                        empty_open = "",
                        symlink = "",
                        symlink_open = "",
                    },
                    git = {
                        unstaged = "✗",
                        staged = "✓",
                        unmerged = "",
                        renamed = "➜",
                        untracked = "★",
                        deleted = "",
                        ignored = "◌",
                    },
                },
            },
            special_files = { "Cargo.toml", "Makefile", "README.md", "readme.md" },
            symlink_destination = true,
        },
        hijack_directories = {
            enable = true,
            auto_open = true,
        },
        update_focused_file = {
            enable = true,
            update_root = false,
            ignore_list = {},
        },
        system_open = {
            cmd = "",
            args = {},
        },
        diagnostics = {
            enable = true,
            show_on_dirs = true,
            show_on_open_dirs = true,
            debounce_delay = 50,
            severity = {
                min = vim.diagnostic.severity.HINT,
                max = vim.diagnostic.severity.ERROR,
            },
            icons = {
                hint = "",
                info = "",
                warning = "",
                error = "",
            },
        },
        filters = {
            dotfiles = false,
            git_clean = false,
            no_buffer = false,
            custom = {},
            exclude = {},
        },
        filesystem_watchers = {
            enable = true,
            debounce_delay = 50,
            ignore_dirs = {},
        },
        git = {
            enable = true,
            ignore = false,
            show_on_dirs = true,
            show_on_open_dirs = true,
            timeout = 400,
        },
        modified = {
            enable = true,
            show_on_dirs = true,
            show_on_open_dirs = true,
        },
        actions = {
            use_system_clipboard = true,
            change_dir = {
                enable = true,
                global = false,
                restrict_above_cwd = false,
            },
            expand_all = {
                max_folder_discovery = 300,
                exclude = {},
            },
            file_popup = {
                open_win_config = {
                    col = 1,
                    row = 1,
                    relative = "cursor",
                    border = "shadow",
                    style = "minimal",
                },
            },
            open_file = {
                quit_on_open = false,
                resize_window = true,
                window_picker = {
                    enable = true,
                    picker = "default",
                    chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
                    exclude = {
                        filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
                        buftype = { "nofile", "terminal", "help" },
                    },
                },
            },
            remove_file = {
                close_window = true,
            },
        },
        trash = {
            cmd = "gio trash",
        },
        live_filter = {
            prefix = "[FILTER]: ",
            always_show_folders = true,
        },
        tab = {
            sync = {
                open = false,
                close = false,
                ignore = {},
            },
        },
        notify = {
            threshold = vim.log.levels.INFO,
        },
        log = {
            enable = false,
            truncate = false,
            types = {
                all = false,
                config = false,
                copy_paste = false,
                dev = false,
                diagnostics = false,
                git = false,
                profile = false,
                watcher = false,
            },
        },
    })
    
    -- Custom highlight groups for nvim-tree
    local tree_highlights = {
        NvimTreeNormal = { bg = "#1d2021", fg = "#ebdbb2" },
        NvimTreeNormalNC = { bg = "#1d2021", fg = "#ebdbb2" },
        NvimTreeRootFolder = { fg = "#fabd2f", bold = true },
        NvimTreeGitDirty = { fg = "#fe8019" },
        NvimTreeGitNew = { fg = "#8ec07c" },
        NvimTreeGitDeleted = { fg = "#fb4934" },
        NvimTreeSpecialFile = { fg = "#fe8019", bold = true },
        NvimTreeIndentMarker = { fg = "#504945" },
        NvimTreeImageFile = { fg = "#d3869b" },
        NvimTreeSymlink = { fg = "#83a598" },
        NvimTreeFolderIcon = { fg = "#fabd2f" },
        NvimTreeFolderName = { fg = "#83a598" },
        NvimTreeOpenedFolderName = { fg = "#fabd2f", bold = true },
        NvimTreeEmptyFolderName = { fg = "#928374" },
        NvimTreeOpenedFile = { fg = "#fe8019", bold = true },
        NvimTreeModifiedFile = { fg = "#fabd2f" },
        NvimTreeExecFile = { fg = "#8ec07c", bold = true },
        NvimTreeOpenedHL = { fg = "#fe8019", bold = true },
    }
    
    for hl, col in pairs(tree_highlights) do
        vim.api.nvim_set_hl(0, hl, col)
    end
    
    -- Auto close nvim-tree when it's the last window
    vim.api.nvim_create_autocmd("QuitPre", {
        callback = function()
            local tree_wins = {}
            local floating_wins = {}
            local wins = vim.api.nvim_list_wins()
            for _, w in ipairs(wins) do
                local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w))
                if bufname:match("NvimTree_") ~= nil then
                    table.insert(tree_wins, w)
                end
                if vim.api.nvim_win_get_config(w).relative ~= '' then
                    table.insert(floating_wins, w)
                end
            end
            if 1 == #wins - #floating_wins - #tree_wins then
                for _, w in ipairs(tree_wins) do
                    vim.api.nvim_win_close(w, true)
                end
            end
        end
    })
end

return M