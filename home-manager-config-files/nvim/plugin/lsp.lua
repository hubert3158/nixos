local on_attach = function(client, bufnr)
    local bufmap = function(keys, func)
        vim.keymap.set('n', keys, func, { buffer = bufnr })
    end

    -- Enable auto-formatting on save
    if client.server_capabilities.documentFormattingProvider then
        vim.api.nvim_command([[augroup Format]])
        vim.api.nvim_command([[autocmd! * <buffer>]])
        vim.api.nvim_command([[autocmd BufWritePre <buffer> lua vim.lsp.buf.format({ async = true })]])
        vim.api.nvim_command([[augroup END]])
    end

    -- Additional key mappings for linting
    -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>l', '<cmd>EslintFixAll<CR>', { noremap = true, silent = true })
    -- bufmap('<leader>l', "<cmd>EslintFixAll<CR>")

    bufmap('<leader>r', vim.lsp.buf.rename)
    bufmap('<leader>a', vim.lsp.buf.code_action)

    bufmap('gd', vim.lsp.buf.definition)
    bufmap('gD', vim.lsp.buf.declaration)
    bufmap('gI', vim.lsp.buf.implementation)
    bufmap('<leader>D', vim.lsp.buf.type_definition)

    bufmap('gr', require('telescope.builtin').lsp_references)

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
    --         configFile = "/home/hubert/node/eslint.config.js",
    --     },
    -- },
    -- cmd = { "/nix/store/yk4zgr1h15kbxbi0vn233a1d8zi5618w-eslint-9.5.0/bin/eslint" },
})


require("lspconfig").sourcekit.setup({ -- c++
    on_attach = on_attach,
    capabilities = capabilities,
})

require("lspconfig").tsserver.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { "/nix/store/18j7h4bc8i4hbq1l9i6qp60w87rikm7x-typescript-language-server-4.3.3/bin/typescript-language-server", "--stdio" }, -- Update the path to your jdtls executable
})



-- local lombok_path = vim.fn.stdpath("data") .. "/lombok.jar"  -- Adjust the path if necessary
local lombok_path = "/home/hubert/nixos/dotfiles/lombok.jar"


-- require("lspconfig").jdtls.setup({
--     on_attach = on_attach,
--     capabilities = capabilities,
-- })




require("lspconfig").jdtls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { "/etc/profiles/per-user/hubert/bin/jdtls" }, -- Update the path to your jdtls executable
    root_dir = function(fname)
        return require('lspconfig.util').root_pattern('pom.xml', 'build.gradle', '.git')(fname) or vim.loop.os_homedir()
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
