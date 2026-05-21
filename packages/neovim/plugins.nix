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
    # noice setup lazy via lz.n on DeferredUIEnter (+ overrides for vim.lsp.util).
    noice-nvim
    {
      plugin = nvim-web-devicons;
      config = "lua << EOF\nrequire(\"nvim-web-devicons\").setup()\nEOF\n";
    }
    { plugin = nvim-notify; }
    {
      plugin = barbecue-nvim;
      config = "lua << EOF\nrequire(\"barbecue\").setup()\nEOF\n";
    }
    # indent-blankline / colorizer / smartcolumn — setup lazy via lz.n.
    indent-blankline-nvim
    nvim-colorizer-lua
    { plugin = smear-cursor-nvim; }
    twilight-nvim
    smartcolumn-nvim

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
    # gitsigns setup lazy via lz.n on BufReadPre/BufNewFile.
    gitsigns-nvim
    vim-fugitive
    lazygit-nvim
    # git-conflict setup runs lazily via nvim/lua/user/git-conflict.lua
    # (driven by lz.n on DeferredUIEnter). Inline setup() removed — was duplicate.
    git-conflict-nvim

    # ============================================================================
    # LSP & LANGUAGE SUPPORT
    # ============================================================================
    { plugin = nvim-lspconfig; }
    # mason-nvim removed — all LSPs and jdtls bundles now come from nixpkgs.
    {
      plugin = lazydev-nvim;
      config = "lua << EOF\nrequire(\"lazydev\").setup({})\nEOF\n";
    }
    # typescript-tools.nvim replaced by vtsls (registered via lsp.lua) —
    # plugin had breakage on nvim 0.12 vim.lsp.enable wire-up (issue #379).
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
    # nvim-comment removed — duplicate of comment-nvim.
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
    # auto-session is setup lazily via nvim/lua/user/auto-session.lua
    # (driven by lz.n). Inline setup() removed — was running twice.
    auto-session
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
