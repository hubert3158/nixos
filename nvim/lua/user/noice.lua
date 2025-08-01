-- Beautiful noice configuration for enhanced UI
local M = {}

function M.setup()
    require("noice").setup({
        lsp = {
            override = {
                ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                ["vim.lsp.util.stylize_markdown"] = true,
                ["cmp.entry.get_documentation"] = true,
            },
        },
        routes = {
            {
                filter = {
                    event = "msg_show",
                    any = {
                        { find = "%d+L, %d+B" },
                        { find = "; after #%d+" },
                        { find = "; before #%d+" },
                    },
                },
                view = "mini",
            },
        },
        presets = {
            bottom_search = true,
            command_palette = true,
            long_message_to_split = true,
            inc_rename = false,
            lsp_doc_border = false,
        },
        messages = {
            enabled = true,
            view = "notify",
            view_error = "notify",
            view_warn = "notify",
            view_history = "messages",
            view_search = "virtualtext",
        },
        popupmenu = {
            enabled = true,
            backend = "nui",
            kind_icons = {},
        },
        redirect = {
            view = "popup",
            filter = { event = "msg_show" },
        },
        commands = {
            history = {
                view = "split",
                opts = { enter = true, format = "details" },
                filter = {
                    any = {
                        { event = "notify" },
                        { error = true },
                        { warning = true },
                        { event = "msg_show", kind = { "" } },
                        { event = "lsp", kind = "message" },
                    },
                },
            },
            last = {
                view = "popup",
                opts = { enter = true, format = "details" },
                filter = {
                    any = {
                        { event = "notify" },
                        { error = true },
                        { warning = true },
                        { event = "msg_show", kind = { "" } },
                        { event = "lsp", kind = "message" },
                    },
                },
                filter_opts = { count = 1 },
            },
            errors = {
                view = "popup",
                opts = { enter = true, format = "details" },
                filter = { error = true },
                filter_opts = { reverse = true },
            },
        },
        notify = {
            enabled = true,
            view = "notify",
        },
        health = {
            checker = false,
        },
        smart_move = {
            enabled = true,
            excluded_filetypes = { "cmp_menu", "cmp_docs", "notify" },
        },
        throttle = 1000 / 30,
        views = {
            cmdline_popup = {
                position = {
                    row = 5,
                    col = "50%",
                },
                size = {
                    width = 60,
                    height = "auto",
                },
                border = {
                    style = "rounded",
                    padding = { 0, 1 },
                },
                filter_options = {},
                win_options = {
                    winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
                },
            },
            popupmenu = {
                relative = "editor",
                position = {
                    row = 8,
                    col = "50%",
                },
                size = {
                    width = 60,
                    height = 10,
                },
                border = {
                    style = "rounded",
                    padding = { 0, 1 },
                },
                win_options = {
                    winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
                },
            },
            mini = {
                backend = "mini",
                relative = "editor",
                align = "message-right",
                timeout = 2000,
                reverse = true,
                focusable = false,
                position = {
                    row = -2,
                    col = "100%",
                    -- col = 0,
                },
                size = "auto",
                border = {
                    style = "none",
                },
                zindex = 60,
                win_options = {
                    winblend = 30,
                    winhighlight = {
                        Normal = "NoiceMini",
                        IncSearch = "",
                        CurSearch = "",
                        Search = "",
                    },
                },
            },
        },
        format = {
            level = {
                icons = {
                    error = "✖",
                    warn = "▼",
                    info = "●",
                    debug = "⚬",
                    trace = "✚",
                },
            },
        },
    })
    
    -- Custom highlights for noice
    local noice_highlights = {
        NoiceFormatProgressTodo = { fg = "#504945", bg = "NONE" },
        NoiceFormatProgressDone = { fg = "#8ec07c", bg = "NONE" },
        NoiceLspProgressTitle = { fg = "#fabd2f", bold = true },
        NoiceLspProgressClient = { fg = "#83a598" },
        NoiceMini = { bg = "#32302f", fg = "#ebdbb2" },
        NoicePopup = { bg = "#32302f", fg = "#ebdbb2" },
        NoicePopupBorder = { bg = "#32302f", fg = "#a89984" },
        NoiceCmdlinePopup = { bg = "#3c3836", fg = "#ebdbb2" },
        NoiceCmdlinePopupBorder = { bg = "#3c3836", fg = "#a89984" },
        NoiceCmdlineIcon = { fg = "#fabd2f" },
        NoiceCmdlinePrompt = { fg = "#fe8019", bold = true },
        NoiceConfirm = { bg = "#3c3836", fg = "#ebdbb2" },
        NoiceConfirmBorder = { bg = "#3c3836", fg = "#a89984" },
    }
    
    for hl, col in pairs(noice_highlights) do
        vim.api.nvim_set_hl(0, hl, col)
    end
end

return M