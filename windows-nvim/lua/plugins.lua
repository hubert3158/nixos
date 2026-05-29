-- ============================================================================
-- lazy.nvim plugin specification (Windows port of the NixOS kickstart-nix setup)
-- ----------------------------------------------------------------------------
-- On NixOS these plugins were supplied by Nix (packages/neovim/plugins.nix) and
-- only *lazy-loaded* by lz.n. On Windows there is no Nix, so lazy.nvim is now
-- responsible for BOTH installing and lazy-loading every plugin.
--
-- Conventions used below:
--   * Plugins whose config lives in `plugin/*.lua` (telescope, lsp, cmp,
--     treesitter, mini, dap, dashboard, which-key, yanky, notify, ts-autotag)
--     are listed with NO `config` here and loaded eagerly, because those files
--     are auto-sourced at startup and call `.setup()` themselves.
--   * Plugins that had an inline `config` in plugins.nix get an equivalent
--     `config`/`opts` here.
--   * Plugins that lz.n lazy-loaded (see old plugin/lazy-load.lua) keep the same
--     event/cmd/keys/ft triggers and call their `lua/user/<name>.lua` module.
-- ============================================================================

return {
  -- ==========================================================================
  -- CORE DEPENDENCIES
  -- ==========================================================================
  { "nvim-lua/plenary.nvim", lazy = true },
  { "MunifTanjim/nui.nvim", lazy = true },
  { "nvim-neotest/nvim-nio", lazy = true }, -- required by nvim-dap-ui

  -- ==========================================================================
  -- COLORSCHEME & UI
  -- ==========================================================================
  -- catppuccin is set up + activated inside init.lua, so just install it early.
  { "catppuccin/nvim", name = "catppuccin", lazy = false, priority = 1000 },

  -- lualine: configured by lua/user/visual-enhancements.lua (was lz.n DeferredUIEnter)
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons", "catppuccin/nvim" },
    config = function()
      require("user.visual-enhancements").setup()
    end,
  },
  { "akinsho/bufferline.nvim", event = "VeryLazy", dependencies = { "nvim-tree/nvim-web-devicons" } },
  { "nvimdev/dashboard-nvim", lazy = false, dependencies = { "nvim-tree/nvim-web-devicons" } }, -- config: plugin/dashboard.lua
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
    config = function()
      require("noice").setup()
    end,
  },
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
    config = function()
      require("nvim-web-devicons").setup()
    end,
  },
  { "rcarriga/nvim-notify", lazy = true }, -- configured in init.lua + plugin/notify.lua
  {
    "utilyre/barbecue.nvim",
    event = "VeryLazy",
    dependencies = { "SmiteshP/nvim-navic", "nvim-tree/nvim-web-devicons" },
    config = function()
      require("barbecue").setup()
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("ibl").setup()
    end,
  },
  {
    "norcalli/nvim-colorizer.lua",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("colorizer").setup()
    end,
  },
  -- smear-cursor: configured by lua/user/smear-cursor.lua (was lz.n DeferredUIEnter)
  {
    "sphamba/smear-cursor.nvim",
    event = "VeryLazy",
    config = function()
      require("user.smear-cursor")
    end,
  },
  {
    "folke/twilight.nvim",
    cmd = "Twilight",
    config = function()
      require("user.twilight")
    end,
  },
  {
    "m4xshen/smartcolumn.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("smartcolumn").setup()
    end,
  },

  -- ==========================================================================
  -- FILE MANAGEMENT & NAVIGATION
  -- ==========================================================================
  -- telescope + extensions: configured by plugin/telescope.lua
  {
    "nvim-telescope/telescope.nvim",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "nvim-telescope/telescope-symbols.nvim",
      "jvgrootveld/telescope-zoxide",
      "nvim-telescope/telescope-frecency.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        -- Build the native lib directly with gcc (confirmed present). This avoids
        -- cmake's build-tool detection, which on a scoop/MinGW setup can't find
        -- mingw32-make. fzf-native is a single C file; -static-libgcc keeps the
        -- resulting DLL free of external mingw runtime dependencies.
        build = function(plugin)
          vim.fn.mkdir(plugin.dir .. "/build", "p")
          local r = vim.system({
            "gcc", "-O3", "-Wall", "-fpic", "-std=gnu99",
            "-shared", "-static-libgcc",
            "src/fzf.c", "-o", "build/libfzf.dll",
          }, { cwd = plugin.dir, text = true }):wait()
          if r.code ~= 0 then
            error("fzf-native build failed:\n" .. (r.stdout or "") .. "\n" .. (r.stderr or ""))
          end
        end,
      },
    },
  },
  -- neo-tree: configured by lua/user/neo-tree.lua (loaded from init.lua)
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    lazy = true,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
      "s1n7ax/nvim-window-picker",
    },
  },
  {
    "mikavilpas/yazi.nvim",
    keys = { { "<leader>y", desc = "Open Yazi" } },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("yazi").setup()
    end,
  },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    keys = {
      { "<leader>ha", desc = "Harpoon add" },
      { "<leader>hh", desc = "Harpoon menu" },
    },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("user.harpoon")
    end,
  },
  {
    "s1n7ax/nvim-window-picker",
    lazy = true,
    config = function()
      require("window-picker").setup()
    end,
  },
  { "christoomey/vim-tmux-navigator", event = "VeryLazy" }, -- tmux-only; harmless on Windows

  -- ==========================================================================
  -- GIT INTEGRATION
  -- ==========================================================================
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("gitsigns").setup({})
    end,
  },
  { "tpope/vim-fugitive", cmd = { "Git", "G" } },
  {
    "kdheepak/lazygit.nvim",
    cmd = { "LazyGit", "LazyGitConfig", "LazyGitCurrentFile", "LazyGitFilter", "LazyGitFilterCurrentFile" },
    keys = { { "<leader>gg", function() require("lazygit").lazygit() end, desc = "LazyGit" } },
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  {
    "akinsho/git-conflict.nvim",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("user.git-conflict")
    end,
  },

  -- ==========================================================================
  -- LSP & LANGUAGE SUPPORT
  -- ==========================================================================
  -- nvim-lspconfig + jdtls: configured by plugin/lsp.lua
  { "neovim/nvim-lspconfig", event = { "BufReadPre", "BufNewFile" } },
  { "mfussenegger/nvim-jdtls", ft = "java" },
  { "williamboman/mason.nvim", build = ":MasonUpdate", lazy = false }, -- setup: lua/user/mason.lua
  {
    "folke/lazydev.nvim",
    ft = "lua",
    config = function()
      require("lazydev").setup({})
    end,
  },
  {
    "pmizio/typescript-tools.nvim",
    ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    config = function()
      require("typescript-tools").setup({})
    end,
  },
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    config = function()
      require("fidget").setup()
    end,
  },
  { "SmiteshP/nvim-navic", lazy = true },

  -- ==========================================================================
  -- AUTOCOMPLETION & SNIPPETS
  -- ==========================================================================
  -- blink.cmp: configured by plugin/cmp.lua. version pulls a PREBUILT fuzzy
  -- binary so no Rust toolchain is required on Windows.
  {
    "saghen/blink.cmp",
    version = "1.*",
    lazy = false,
    dependencies = { "L3MON4D3/LuaSnip", "rafamadriz/friendly-snippets" },
  },
  { "L3MON4D3/LuaSnip", lazy = true }, -- jsregexp build skipped (optional on Windows)
  { "rafamadriz/friendly-snippets", lazy = true },
  { "honza/vim-snippets", lazy = true },

  -- ==========================================================================
  -- TREESITTER & SYNTAX HIGHLIGHTING
  -- ==========================================================================
  -- On NixOS parsers were prebuilt by Nix. On Windows nvim-treesitter compiles
  -- them on demand (needs a C compiler -- `zig` or `gcc`, see the install guide).
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main", -- the rewrite; the old "master" branch breaks on Neovim 0.12+
    lazy = false,
    build = ":TSUpdate",
    config = function()
      -- The tree-sitter CLI defaults to MSVC (cl.exe) on Windows; point it at gcc.
      if vim.fn.has("win32") == 1 and (vim.env.CC == nil or vim.env.CC == "") then
        vim.env.CC = "gcc"
      end
      pcall(function()
        require("nvim-treesitter").install({
          "vimdoc", "rust", "pug", "vim", "javascript", "typescript", "tsx",
          "csv", "json", "c", "query", "lua", "java", "nix", "luadoc",
          "yuck", "zig", "http", "graphql", "yaml", "typst",
          -- markdown/markdown_inline are bundled with Neovim 0.11+
        })
      end)
      -- main branch is opt-in: start Treesitter (highlight + folds) per buffer.
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(ev)
          pcall(vim.treesitter.start, ev.buf)
        end,
      })
    end,
  },
  { "windwp/nvim-ts-autotag", event = { "BufReadPost", "BufNewFile" } }, -- config: plugin/tsAutotag.lua
  { "JoosepAlviste/nvim-ts-context-commentstring", lazy = true },

  -- ==========================================================================
  -- CODE EDITING & REFACTORING
  -- ==========================================================================
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    config = function()
      require("Comment").setup()
    end,
  },
  { "terrortylor/nvim-comment", lazy = true },
  { "LudoPinelli/comment-box.nvim", cmd = { "CBccbox", "CBllbox", "CBd" }, event = "VeryLazy" },
  {
    "ThePrimeagen/refactoring.nvim",
    keys = {
      { "<leader>re", mode = { "n", "x" }, desc = "Extract Function" },
      { "<leader>rf", mode = { "n", "x" }, desc = "Extract Function To File" },
      { "<leader>rv", mode = { "n", "x" }, desc = "Extract Variable" },
      { "<leader>rI", mode = { "n", "x" }, desc = "Inline Function" },
      { "<leader>ri", mode = { "n", "x" }, desc = "Inline Variable" },
      { "<leader>rbb", mode = { "n", "x" }, desc = "Extract Block" },
      { "<leader>rbf", mode = { "n", "x" }, desc = "Extract Block To File" },
    },
    dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("refactoring").setup({})
    end,
  },
  { "mg979/vim-visual-multi", event = "VeryLazy" },
  { "gbprod/yanky.nvim", event = "VeryLazy" }, -- config: plugin/yanky.lua
  {
    "nvim-pack/nvim-spectre",
    cmd = "Spectre",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("user.spectre")
    end,
  },
  { "jbyuki/venn.nvim", cmd = { "VBox", "VBoxD", "VBoxH", "VBoxO" }, config = function() require("user.venn-easyalign") end },
  { "junegunn/vim-easy-align", event = "VeryLazy" },

  -- ==========================================================================
  -- FORMATTING & LINTING
  -- ==========================================================================
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    config = function()
      require("user.conform")
    end,
  },
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("user.nvimLint")
    end,
  },

  -- ==========================================================================
  -- DEBUGGING
  -- ==========================================================================
  { "mfussenegger/nvim-dap", lazy = false }, -- config: plugin/dap.lua
  {
    "rcarriga/nvim-dap-ui",
    lazy = false,
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
  },
  {
    "andrewferrier/debugprint.nvim",
    keys = { { "<leader>dp", desc = "Debug print" } },
    config = function()
      require("user.debugprint")
    end,
  },

  -- ==========================================================================
  -- UTILITIES & PRODUCTIVITY
  -- ==========================================================================
  { "folke/which-key.nvim", event = "VeryLazy" }, -- config: plugin/which-key.lua
  {
    "akinsho/toggleterm.nvim",
    cmd = "ToggleTerm",
    keys = { { "<leader>tt", desc = "Toggle Terminal" } },
    config = function()
      require("toggleterm").setup()
    end,
  },
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    config = function()
      require("trouble").setup()
    end,
  },
  { "mbbill/undotree", cmd = { "UndotreeToggle", "UndotreeShow" } },
  {
    "rmagatti/auto-session",
    lazy = false,
    config = function()
      require("user.auto-session")
    end,
  },
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("user.todo-comments")
    end,
  },
  {
    "karb94/neoscroll.nvim",
    keys = { "<C-u>", "<C-d>", "<C-b>", "<C-f>" },
    config = function()
      require("user.neoscroll")
    end,
  },
  {
    "danymat/neogen",
    keys = { { "<leader>nc", desc = "Comment Documentation Generation" } },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("neogen").setup()
    end,
  },

  -- ==========================================================================
  -- CODE FOLDING & STRUCTURE
  -- ==========================================================================
  {
    "kevinhwang91/nvim-ufo",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "kevinhwang91/promise-async" },
    config = function()
      require("user.nvimUfo")
    end,
  },
  {
    "stevearc/aerial.nvim",
    cmd = { "AerialToggle", "AerialOpen", "AerialNext", "AerialPrev" },
    keys = { { "<leader>a", desc = "Toggle Aerial Code Outline" } },
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    config = function()
      require("aerial").setup()
    end,
  },

  -- ==========================================================================
  -- AI & CODE ASSISTANCE
  -- ==========================================================================
  {
    "olimorris/codecompanion.nvim",
    cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions" },
    keys = {
      { "<leader>cc", desc = "Open chat" },
      { "<leader>ca", desc = "Actions" },
      { "<leader>ct", desc = "Toggle chat" },
      { "<leader>ci", desc = "Inline assistant" },
      { "<leader>cb", desc = "Add buffer to chat" },
      { "<leader>cv", mode = "v", desc = "Add selection to chat" },
      { "<leader>cs", desc = "Stop request" },
      { "<leader>ce", mode = "v", desc = "Explain code" },
      { "<leader>cr", mode = "v", desc = "Review code" },
      { "<leader>cx", mode = "v", desc = "Fix code" },
    },
    dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("user.codeCompanion")
    end,
  },

  -- ==========================================================================
  -- DATABASE MANAGEMENT
  -- ==========================================================================
  { "tpope/vim-dadbod", cmd = { "DB", "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" } },
  {
    "kristijanhusak/vim-dadbod-ui",
    cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
    dependencies = { "tpope/vim-dadbod" },
  },
  { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" } },

  -- ==========================================================================
  -- HTTP & API TESTING
  -- ==========================================================================
  -- kulala: configured by lua/user/kulala.lua (was lz.n ft=http)
  {
    "mistweaverco/kulala.nvim",
    ft = "http",
    config = function()
      require("user.kulala")
    end,
  },

  -- ==========================================================================
  -- DOCUMENTATION & MARKDOWN
  -- ==========================================================================
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "codecompanion" },
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    config = function()
      require("render-markdown").setup({})
    end,
  },

  -- ==========================================================================
  -- SCREENSHOTS & SHARING
  -- ==========================================================================
  -- codesnap requires a Rust toolchain to build its image generator.
  -- If you don't have Rust/cargo, this plugin will fail to build -- it's safe
  -- to remove this block. With Rust installed, `make` is also required on PATH.
  {
    "mistricky/codesnap.nvim",
    build = "make build_generator",
    cmd = { "CodeSnap", "CodeSnapSave" },
    config = function()
      require("user.codeSnap")
    end,
  },

  -- ==========================================================================
  -- LANGUAGE-SPECIFIC PLUGINS
  -- ==========================================================================
  { "digitaltoad/vim-pug", ft = { "pug", "jade" } },
  { "LnL7/vim-nix", ft = "nix" },
  { "jpalardy/vim-slime", event = "VeryLazy" }, -- tmux target; adjust g.slime_target on Windows
  { "chomosuke/typst-preview.nvim", ft = "typst", cmd = { "TypstPreview", "TypstPreviewToggle" } },

  -- ==========================================================================
  -- MINI PLUGINS COLLECTION
  -- ==========================================================================
  { "echasnovski/mini.nvim", lazy = false }, -- config: plugin/mini.lua
}
