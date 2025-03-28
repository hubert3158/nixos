-- ~/.config/nvim/lua/plugins/treesitter.lua (or wherever you configure plugins)

return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate', -- Recommended to keep parsers updated
  config = function()
    require('nvim-treesitter.configs').setup {
      -- A list of parser names, or "all"
      -- *** Add the languages you commonly use here ***
      ensure_installed = {
        "bash",
        "c",
        "cpp",
        "css",
        "diff",
        "go",
        "html",
        "java",
        "javascript",
        "json",
        "lua",
        "luadoc",
        "luap", -- Lua patterns
        "markdown",
        "markdown_inline",
        "nix",
        "python",
        "query", -- Treesitter's own query language
        "regex",
        "rust",
        "toml",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
      },

      -- Install parsers synchronously (only applied to `ensure_installed`)
      sync_install = false,

      -- Automatically install missing parsers when entering buffer
      -- Recommendation: set to true for convenience
      auto_install = true,

      -- List of parsers to ignore installing (or "all")
      -- ignore_install = { "javascript" },

      highlight = {
        -- `false` will disable the whole extension
        enable = true,

        -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
        -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is the name of the parser)
        -- disable = { "c", "rust" },
        -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
        -- disable = function(lang, buf)
        --     local max_filesize = 100 * 1024 -- 100 KB
        --     local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        --     if ok and stats and stats.size > max_filesize then
        --         return true
        --     end
        -- end,

        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
      },

      indent = {
        enable = true,
        -- disable = { "yaml" }
      },

      textobjects = {
        select = {
          enable = true,
          lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ["af"] = { query = "@function.outer", desc = "Select outer function" },
            ["if"] = { query = "@function.inner", desc = "Select inner function" },
            ["ac"] = { query = "@class.outer", desc = "Select outer class" },
            ["ic"] = { query = "@class.inner", desc = "Select inner class" },
            -- You can also use captures from other query groups like `locals.scm`
            ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
            -- Simpler mappings (similar to default):
            ["a="] = { query = "@assignment.outer", desc = "Select outer part of an assignment" },
            ["i="] = { query = "@assignment.inner", desc = "Select inner part of an assignment" },
            ["al"] = { query = "@loop.outer", desc = "Select outer part of a loop" },
            ["il"] = { query = "@loop.inner", desc = "Select inner part of a loop" },
            ["a:"] = { query = "@parameter.outer", desc = "Select outer part of parameter/argument" },
            ["i:"] = { query = "@parameter.inner", desc = "Select inner part of parameter/argument" },
            -- Add more keymaps based on available captures in parsers' textobjects.scm files
          },
          selection_modes = {
            ['@parameter.outer'] = 'v', -- charwise
            ['@function.outer'] = 'V', -- linewise
            ['@class.outer'] = 'V', -- linewise (often more useful than blockwise for classes)
            -- Add other specific modes if needed
          },
          -- If you set this to `true` methods like `am` and `im` will act like the Vim originals behavior
          include_surrounding_whitespace = true,
        },
        -- You can also configure swap / move / etc.
        -- move = { ... }
        -- swap = { ... }
      },

      -- Other modules (disabled by default)
      -- incremental_selection = { enable = true },
      -- refactor = { ... }
      -- navigation = { ... }
      -- etc.
    }

    -- Folding configuration (outside the setup table)
    -- Uses Treesitter to determine fold regions
    vim.opt.foldmethod = 'expr'
    vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
    vim.opt.foldlevel = 99      -- Default fold level (e.g., 0 means all folded, 99 means all open)
    vim.opt.foldlevelstart = 99 -- Fold level for new buffers (start with folds open)
    vim.opt.foldenable = true   -- Enable folding overall
  end,
}
