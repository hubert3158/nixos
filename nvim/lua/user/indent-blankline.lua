-- Beautiful indent guides configuration
local M = {}

function M.setup()
    local highlight = {
        "RainbowRed",
        "RainbowYellow", 
        "RainbowBlue",
        "RainbowOrange",
        "RainbowGreen",
        "RainbowViolet",
        "RainbowCyan",
    }
    
    local hooks = require "ibl.hooks"
    -- create the highlight groups in the highlight setup hook, so they are reset
    -- every time the colorscheme changes
    hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#fb4934" })
        vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#fabd2f" })
        vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#83a598" })
        vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#fe8019" })
        vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#8ec07c" })
        vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#d3869b" })
        vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#8ec07c" })
    end)
    
    require("ibl").setup {
        indent = {
            highlight = highlight,
            char = "│",
            tab_char = "│",
        },
        whitespace = {
            highlight = highlight,
            remove_blankline_trail = false,
        },
        scope = {
            enabled = true,
            show_start = true,
            show_end = false,
            injected_languages = false,
            highlight = { "Function", "Label" },
            priority = 500,
            include = {
                node_type = {
                    ["*"] = { "*" },
                },
            },
            exclude = {
                language = {},
                node_type = {
                    ["*"] = {
                        "source_file",
                        "program",
                    },
                    lua = {
                        "chunk",
                    },
                    python = {
                        "module",
                    },
                },
            },
        },
        exclude = {
            filetypes = {
                "help",
                "alpha",
                "dashboard",
                "neo-tree",
                "NvimTree",
                "Trouble",
                "trouble",
                "lazy",
                "mason",
                "notify",
                "toggleterm",
                "lazyterm",
            },
            buftypes = {
                "terminal",
                "nofile",
                "quickfix",
                "prompt",
            },
        },
    }
    
    hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
end

return M