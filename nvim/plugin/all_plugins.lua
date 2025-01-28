local cmp = require('cmp')
local luasnip = require('luasnip')

require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

cmp.setup {
    native_menu = false,
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert {
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete {},
        ['<C-c>'] = cmp.mapping.close(),
        ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        },
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_locally_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' }),
    },
    sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = "supermaven" },

    },
}
local dap = require('dap')
local dapui = require('dapui')

dapui.setup()

dap.adapters.java = {
    type = 'server',
    host = '127.0.0.1',
    port = 5005,
    options = {
        timeout = 10000 -- Increase the timeout to 10 seconds
    }
}

dap.configurations.java = {
    {
        type = 'java',
        request = 'attach',
        name = "Attach to Java process",
        hostName = "127.0.0.1",
        port = 5005,
    },
}

dap.set_log_level('TRACE')

require("dashboard").setup()
local lspconfig = require 'lspconfig'


local on_attach = function(client, bufnr)
    local bufmap = function(keys, func)
        vim.keymap.set('n', keys, func, { buffer = bufnr })
    end


    -- Enable auto-formatting on save
    -- if client.server_capabilities.documentFormattingProvider then
    --     vim.api.nvim_command([[augroup Format]])
    --     vim.api.nvim_command([[autocmd! * <buffer>]])
    --     vim.api.nvim_command([[autocmd BufWritePre <buffer> lua vim.lsp.buf.format({ async = true })]])
    --     vim.api.nvim_command([[augroup END]])
    -- end
    --
    --
    --

    -- Additional key mappings for linting
    -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>l', '<cmd>EslintFixAll<CR>', { noremap = true, silent = true })
    -- bufmap('<leader>l', "<cmd>EslintFixAll<CR>")

    bufmap('<leader>r', vim.lsp.buf.rename)
    bufmap('<leader>a', vim.lsp.buf.code_action)

    bufmap('gd', vim.lsp.buf.definition)
    bufmap('gD', vim.lsp.buf.declaration)
    bufmap('gI', vim.lsp.buf.implementation)
    bufmap('gl', vim.lsp.buf.implementation)
    bufmap('<leader>D', vim.lsp.buf.type_definition)

    bufmap('gl', vim.diagnostic.open_float)                     -- Show diagnostics in a floating window
    bufmap('[d', vim.diagnostic.goto_prev)                      -- Go to the previous diagnostic
    bufmap(']d', vim.diagnostic.goto_next)                      -- Go to the next diagnostic
    bufmap('[e', function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR }) end)
    bufmap(']e', function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR }) end)

    bufmap('<leader>lq', vim.diagnostic.setloclist)             -- Show all diagnostics in the location list
    bufmap('<leader>lQ', vim.diagnostic.setqflist)              -- Show all diagnostics in the quickfix list
    bufmap('<leader>ld', function()                             -- Toggle virtual text on/off
        vim.diagnostic.config({ virtual_text = not vim.diagnostic.config().virtual_text })
    end)

    bufmap('gr', require('telescope.builtin').lsp_references)
    bufmap('gs', require('telescope.builtin').lsp_document_symbols)

    -- the following can be achieve by <leader>fs then chose the builtin you want
    -- bufmap('<leader>s', require('telescope.builtin').lsp_document_symbols)
    -- bufmap('<leader>S', require('telescope.builtin').lsp_dynamic_workspace_symbols)

    bufmap('K', vim.lsp.buf.hover)

    vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
        vim.lsp.buf.format()
    end, {})
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

require('neodev').setup()
require('lspconfig').lua_ls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    root_dir = function()
        return vim.loop.cwd()
    end,
    cmd = { "lua-language-server" },
    settings = {
        Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
        },
    }
}

require('lspconfig').nil_ls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
}
require("lspconfig").html.setup({
    on_attach = on_attach,
    capabilities = capabilities,
})
-- require("lspconfig").bashls.setup({
-- 	on_attach = on_attach,
-- 	capabilities = capabilities,
-- })

require("lspconfig").zls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
})

require("lspconfig").eslint.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    root_dir = require("lspconfig.util").find_package_json_ancestor(),
    -- settings = {
    --     eslint = {
    --         configFile = "/home/hubert/nixos/.eslint.config.json",
    --     },
    -- },
    cmd = { "eslint" },
})


require("lspconfig").sourcekit.setup({ -- c++
    on_attach = on_attach,
    capabilities = capabilities,
})


require 'lspconfig'.clangd.setup { -- c
    on_attach = on_attach,
    capabilities = capabilities,
}

-- lspconfig.ccls.setup {
--     root_dir = function(fname)
--         return lspconfig.util.root_pattern("compile_commands.json", "compile_flags.txt", ".git")(fname) or
--             lspconfig.util.path.dirname(fname)
--     end,
--     init_options = {
--         index = {
--             threads = 0,
--         },
--         clang = {
--             excludeArgs = { "-frounding-math" },
--         },
--     }
-- }



require("lspconfig").ts_ls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { "typescript-language-server", "--stdio" },
})





-- require("lspconfig").jdtls.setup({
--     on_attach = on_attach,
--     capabilities = capabilities,
-- })


require 'lspconfig'.pyright.setup {
    on_attach = on_attach,
    capabilities = capabilities,
}

require 'lspconfig'.cssls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
}


-- local lombok_path = vim.fn.stdpath("data") .. "/lombok.jar"  -- Adjust the path if necessary
local lombok_path = "/home/hubert/nixos/dotfiles/lombok.jar"
require("lspconfig").jdtls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { "/etc/profiles/per-user/hubert/bin/jdtls" }, -- Update the path to your jdtls executable

    root_dir = function(fname)
        return require('lspconfig.util').root_pattern('pom.xml', 'build.gradle', '.git')(fname) or
            vim.loop.os_homedir()
    end,
    settings = {
        java = {
            signatureHelp = { enabled = true },
            contentProvider = { preferred = 'fernflower' },
            completion = {
                favoriteStaticMembers = {
                    "org.hamcrest.MatcherAssert.assertThat",
                    "org.hamcrest.Matchers.*",
                    "org.hamcrest.CoreMatchers.*",
                    "org.junit.jupiter.api.Assertions.*",
                    "java.util.Objects.requireNonNull",
                    "java.util.Objects.requireNonNullElse",
                }
            },
            project = {
                referencedLibraries = {
                    lombok_path,
                }
            },
        },
    },
    init_options = {
        bundles = {
            lombok_path,
            vim.fn.glob(
                '/nix/store/id0zrxghssr6mkzxaaphs9yy1sjn7f57-vscode-extension-vscjava-vscode-java-debug-0.55.2023121302/share/vscode/extensions/vscjava.vscode-java-debug/server/com.microsoft.java.debug.plugin-0.50.0.jar',
                true),
        }
    },
})

--
-- require('lspconfig').sonarlint_ls = {
--     default_config = {
--         cmd = { "sonarlint-ls" },
--         filetypes = { "javascript", "typescript", "python", "java", "php" }, -- Add more filetypes as needed
--         root_dir = require('lspconfig').util.root_pattern(".git", "sonar-project.properties", ".sonarlint"),
--         settings = {
--             -- Optional SonarLint-specific settings
--             -- sonarlint = {
--             --     rules = {
--             --         -- Add custom rules or rule settings here
--             --     },
--             -- },
--         },
--         init_options = {
--             -- Initialization options, if required
--         },
--     },
-- }
--
-- -- Finally, set it up like any other LSP server
-- require('lspconfig').sonarlint_ls.setup({
--     on_attach = on_attach,       -- Your custom on_attach function
--     capabilities = capabilities, -- Your custom capabilities
-- })






--
--
--

-- require("lspconfig").jdtls.setup({
--   on_attach = on_attach,
--   capabilities = capabilities,
--   cmd = { "/etc/profiles/per-user/hubert/bin/jdtls" }, -- Update the path to your jdtls executable
--   root_dir = function(fname)
--     return require('lspconfig.util').root_pattern('pom.xml', 'build.gradle', '.git')(fname) or vim.loop.os_homedir()
--   end,
--   settings = {
--     java = {
--       signatureHelp = { enabled = true },
--       contentProvider = { preferred = 'fernflower' },
--       completion = {
--         favoriteStaticMembers = {
--           "org.hamcrest.MatcherAssert.assertThat",
--           "org.hamcrest.Matchers.*",
--           "org.hamcrest.CoreMatchers.*",
--           "org.junit.jupiter.api.Assertions.*",
--           "java.util.Objects.requireNonNull",
--           "java.util.Objects.requireNonNullElse",
--         }
--       }
--     }
--   },
--   init_options = {
--     bundles = {
--       vim.fn.glob('/nix/store/id0zrxghssr6mkzxaaphs9yy1sjn7f57-vscode-extension-vscjava-vscode-java-debug-0.55.2023121302/share/vscode/extensions/vscjava.vscode-java-debug/server/com.microsoft.java.debug.plugin-0.50.0.jar', true),
--     }
--   },
-- })
-- require("mason").setup()

require("mini.pairs").setup({})
require("mini.surround").setup({})
require("mini.map").setup({
    integrations = {
        require("mini.map").gen_integration.builtin_search(),
        require("mini.map").gen_integration.gitsigns(),
        require("mini.map").gen_integration.diagnostic(),
    }

})
require("mini.indentscope").setup({})
require("mini.cursorword").setup({})
require("mini.ai").setup({})

require("notify").setup({
  keys = {
    {
      "<leader>un",
      function()
        require("notify").dismiss({ silent = true, pending = true })
      end,
      desc = "Dismiss All Notifications",
    },
  },
  opts = {
    stages = "static",
    timeout = 3000,
    max_height = function()
      return math.floor(vim.o.lines * 0.75)
    end,
    max_width = function()
      return math.floor(vim.o.columns * 0.75)
    end,
    on_open = function(win)
      vim.api.nvim_win_set_config(win, { zindex = 100 })
    end,
  },
  init = function()
    -- when noice is not enabled, install notify on VeryLazy
  end,
})
-- Lualine
require("lualine").setup({
    icons_enabled = true,
    -- theme = 'onedark',
})

-- Colorscheme
vim.cmd("colorscheme gruvbox")

-- Comment
require("Comment").setup()


-- require("nvim-notify").setup({})
-- require("notify").setup()
-- require("notify")("My super important message")
-- require("notify")("hey there")
-- require("notify")("check out LudoPinelli/comment-box.nvim  <>cbccbox")
-- require("notify")("install lazy git")
-- vim.notify = require('notify')
-- vim.notify("This is an error message", "error")
--
-- require("notify").setup({
--   keys = {
--     {
--       "<leader>un",
--       function()
--         require("notify").dismiss({ silent = true, pending = true })
--       end,
--       desc = "Dismiss All Notifications",
--     },
--   },
--   opts = {
--     stages = "static",
--     timeout = 3000,
--     max_height = function()
--       return math.floor(vim.o.lines * 0.75)
--     end,
--     max_width = function()
--       return math.floor(vim.o.columns * 0.75)
--     end,
--     on_open = function(win)
--       vim.api.nvim_win_set_config(win, { zindex = 100 })
--     end,
--   },
--   init = function()
--     -- when noice is not enabled, install notify on VeryLazy
--   end,
-- })
require('telescope').setup({
	extensions = {
    	fzf = {
      	fuzzy = true,                    -- false will only do exact matching
      	override_generic_sorter = true,  -- override the generic sorter
      	override_file_sorter = true,     -- override the file sorter
      	case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                       -- the default case_mode is "smart_case"
    	}
  	}
})

 require('telescope').load_extension('fzf')
-- local parser_install_dir = vim.fn.expand('/home/hubert/temp')

require('nvim-treesitter.configs').setup {
	-- ensure_installed = { "c", "query", "lua", "java", "nix", "vimdoc", "luadoc", "vim", "markdown", "markdown_inline" },
	-- This is not needed / causes problems

	auto_install = false,

	highlight = {
		enable = true,
		-- disable = { "c", "rust","vimdoc" },
	},
	indent = { enable = true },
     textobjects = {
    select = {
      enable = true,

      -- Automatically jump forward to textobj, similar to targets.vim
      lookahead = true,

      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        -- You can optionally set descriptions to the mappings (used in the desc parameter of
        -- nvim_buf_set_keymap) which plugins like which-key display
        ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
        -- You can also use captures from other query groups like `locals.scm`
        ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
      },
      -- You can choose the select mode (default is charwise 'v')
      --
      -- Can also be a function which gets passed a table with the keys
      -- * query_string: eg '@function.inner'
      -- * method: eg 'v' or 'o'
      -- and should return the mode ('v', 'V', or '<c-v>') or a table
      -- mapping query_strings to modes.
      selection_modes = {
        ['@parameter.outer'] = 'v', -- charwise
        ['@function.outer'] = 'V', -- linewise
        ['@class.outer'] = '<c-v>', -- blockwise
      },
      -- If you set this to `true` (default is `false`) then any textobject is
      -- extended to include preceding or succeeding whitespace. Succeeding
      -- whitespace has priority in order to act similarly to eg the built-in
      -- `ap`.
      --
      -- Can also be a function which gets passed a table with the keys
      -- * query_string: eg '@function.inner'
      -- * selection_mode: eg 'v'
      -- and should return true or false
      include_surrounding_whitespace = true,
    },
  },
}


require('nvim-ts-autotag').setup({
  opts = {
    -- Defaults
    enable_close = true, -- Auto close tags
    enable_rename = true, -- Auto rename pairs of tags
    enable_close_on_slash = false -- Auto close on trailing </
  },
  -- Also override individual filetype configs, these take priority.
  -- Empty by default, useful if one of the "opts" global settings
  -- doesn't work well in a specific filetype
  per_filetype = {
    ["html"] = {
      enable_close = false
    }
  }
})
require("which-key").setup ({
event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  }
})
require("yanky").setup({
    highlight = {
        on_put = true,
        on_yank = true,
        timer = 200,
    },
})
