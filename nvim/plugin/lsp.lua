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
    root_dir = require("lspconfig").util.find_package_json_ancestor, -- Corrected
    cmd = { "npx", "eslint", "--stdio" }, -- Ensures ESLint uses local version
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
