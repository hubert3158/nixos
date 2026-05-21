# Neovim plugins list
#
# Built on top of the kickstart-nix.nvim template:
#   https://github.com/nix-community/kickstart-nix.nvim
{ pkgs, inputs }:

let
  # Helper to create a plugin from a flake input
  mkNvimPlugin = src: pname:
    pkgs.vimUtils.buildVimPlugin {
      inherit pname src;
      version = src.lastModifiedDate;
    };

  in
{
  all-plugins = with pkgs.vimPlugins; [
    # ============================================================================
    # CORE DEPENDENCIES
    # ============================================================================
    plenary-nvim
    nui-nvim
    lz-n

    # ============================================================================
    # COLORSCHEME & UI
    # ============================================================================
    {
      plugin = catppuccin-nvim;
      config = "lua << EOF\nrequire(\"catppuccin\").setup({ flavour = \"mocha\" })\nEOF\ncolorscheme catppuccin\n";
    }
    { plugin = lualine-nvim; }
    bufferline-nvim
    { plugin = dashboard-nvim; }
    {
      plugin = noice-nvim;
      config = "lua << EOF\nrequire(\"noice\").setup()\nEOF\n";
    }
    {
      plugin = nvim-web-devicons;
      config = "lua << EOF\nrequire(\"nvim-web-devicons\").setup()\nEOF\n";
    }
    { plugin = nvim-notify; }
    {
      plugin = barbecue-nvim;
      config = "lua << EOF\nrequire(\"barbecue\").setup()\nEOF\n";
    }
    {
      plugin = indent-blankline-nvim;
      config = "lua << EOF\nrequire(\"ibl\").setup()\nEOF\n";
    }
    {
      plugin = nvim-colorizer-lua;
      config = "lua << EOF\nrequire(\"colorizer\").setup()\nEOF\n";
    }
    { plugin = smear-cursor-nvim; }
    twilight-nvim
    {
      plugin = smartcolumn-nvim;
      config = "lua << EOF\nrequire(\"smartcolumn\").setup()\nEOF\n";
    }

    # ============================================================================
    # FILE MANAGEMENT & NAVIGATION
    # ============================================================================
    { plugin = telescope-nvim; }
    telescope-symbols-nvim
    telescope-zoxide
    telescope-fzf-native-nvim
    telescope-frecency-nvim
    { plugin = neo-tree-nvim; }
    {
      plugin = yazi-nvim;
      config = "lua << EOF\nrequire(\"yazi\").setup()\nEOF\n";
    }
    harpoon2
    {
      plugin = nvim-window-picker;
      config = "lua << EOF\nrequire(\"window-picker\").setup()\nEOF\n";
    }
    vim-tmux-navigator

    # ============================================================================
    # GIT INTEGRATION
    # ============================================================================
    {
      plugin = gitsigns-nvim;
      config = "lua << EOF\nrequire(\"gitsigns\").setup({})\nEOF\n";
    }
    vim-fugitive
    lazygit-nvim
    {
      plugin = git-conflict-nvim;
      config = "lua << EOF\nrequire(\"git-conflict\").setup()\nEOF\n";
    }

    # ============================================================================
    # LSP & LANGUAGE SUPPORT
    # ============================================================================
    { plugin = nvim-lspconfig; }
    { plugin = mason-nvim; }
    {
      plugin = lazydev-nvim;
      config = "lua << EOF\nrequire(\"lazydev\").setup({})\nEOF\n";
    }
    {
      plugin = typescript-tools-nvim;
      config = ''
        lua << EOF
        require("typescript-tools").setup({
          -- Anchor tsserver to nearest tsconfig (avoids loading whole monorepo
          -- when nvim is opened at the workspace root).
          root_dir = require("lspconfig.util").root_pattern("tsconfig.json", "jsconfig.json"),
          single_file_support = false,
          settings = {
            tsserver_max_memory = 8192,
            code_lens = "off",
            disable_member_code_lens = true,
            complete_function_calls = false,
            expose_as_code_action = {},
            publish_diagnostic_on = "insert_leave",
            tsserver_file_preferences = {
              includeInlayParameterNameHints = "none",
              includeInlayFunctionParameterTypeHints = false,
              includeInlayVariableTypeHints = false,
              includeInlayPropertyDeclarationTypeHints = false,
              includeInlayFunctionLikeReturnTypeHints = false,
              includeInlayEnumMemberValueHints = false,
              -- Stops project-wide auto-import scan on every keystroke.
              includeCompletionsForModuleExports = false,
            },
          },
        })
        EOF
      '';
    }
    nvim-jdtls
    {
      plugin = fidget-nvim;
      config = "lua << EOF\nrequire(\"fidget\").setup()\nEOF\n";
    }
    nvim-navic

    # ============================================================================
    # AUTOCOMPLETION & SNIPPETS
    # ============================================================================
    blink-cmp
    luasnip
    friendly-snippets
    vim-snippets

    # ============================================================================
    # TREESITTER & SYNTAX HIGHLIGHTING
    # ============================================================================
    (nvim-treesitter.withPlugins (p: [
      p.vimdoc p.rust p.pug p.vim p.javascript p.typescript p.tsx
      p.csv p.json p.c p.query p.lua p.java p.nix p.luadoc
      p.markdown p.markdown_inline p.yuck p.zig p.http p.graphql p.yaml p.typst
    ]))
    nvim-ts-autotag
    nvim-ts-context-commentstring

    # ============================================================================
    # CODE EDITING & REFACTORING
    # ============================================================================
    {
      plugin = comment-nvim;
      config = "lua << EOF\nrequire(\"Comment\").setup()\nEOF\n";
    }
    nvim-comment
    comment-box-nvim
    # refactoring.nvim removed: as of nixpkgs 2026-04 it depends on async.nvim,
    # which ships a top-level lua/async.lua that collides with promise-async
    # and breaks nvim-ufo's require('async'). LSP code actions cover most of
    # what refactoring.nvim offered. Re-evaluate once upstream resolves the
    # naming collision.
    vim-visual-multi
    { plugin = yanky-nvim; }
    nvim-spectre
    venn-nvim
    vim-easy-align

    # ============================================================================
    # FORMATTING & LINTING
    # ============================================================================
    conform-nvim
    nvim-lint

    # ============================================================================
    # DEBUGGING
    # ============================================================================
    nvim-dap
    nvim-dap-ui
    debugprint-nvim

    # ============================================================================
    # UTILITIES & PRODUCTIVITY
    # ============================================================================
    { plugin = which-key-nvim; }
    {
      plugin = toggleterm-nvim;
      config = "lua << EOF\nrequire(\"toggleterm\").setup()\nEOF\n";
    }
    {
      plugin = trouble-nvim;
      config = "lua << EOF\nrequire(\"trouble\").setup()\nEOF\n";
    }
    undotree
    {
      plugin = auto-session;
      config = "lua << EOF\nrequire(\"auto-session\").setup()\nEOF\n";
    }
    todo-comments-nvim
    neoscroll-nvim
    {
      plugin = neogen;
      config = "lua << EOF\nrequire(\"neogen\").setup()\nEOF\n";
    }

    # ============================================================================
    # CODE FOLDING & STRUCTURE
    # ============================================================================
    nvim-ufo
    promise-async
    {
      plugin = aerial-nvim;
      config = "lua << EOF\nrequire(\"aerial\").setup()\nEOF\n";
    }

    # ============================================================================
    # AI & CODE ASSISTANCE
    # ============================================================================
    codecompanion-nvim

    # ============================================================================
    # DATABASE MANAGEMENT
    # ============================================================================
    vim-dadbod
    vim-dadbod-ui
    vim-dadbod-completion

    # ============================================================================
    # HTTP & API TESTING
    # ============================================================================
    kulala-nvim

    # ============================================================================
    # DOCUMENTATION & MARKDOWN
    # ============================================================================
    markdown-preview-nvim
    render-markdown-nvim

    # ============================================================================
    # SCREENSHOTS & SHARING
    # ============================================================================
    codesnap-nvim

    # ============================================================================
    # LANGUAGE-SPECIFIC PLUGINS
    # ============================================================================
    vim-pug
    vim-nix
    vim-slime
    typst-preview-nvim

    # ============================================================================
    # MINI PLUGINS COLLECTION
    # ============================================================================
    { plugin = mini-nvim; }
  ];
}
