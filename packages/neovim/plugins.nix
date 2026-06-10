# Neovim plugins list
#
# Built on top of the kickstart-nix.nvim template:
#   https://github.com/nix-community/kickstart-nix.nvim
#
# `optional = true` puts a plugin in pack/*/opt — it is NOT sourced at
# startup; lz.n (nvim/plugin/lazy-load.lua) packadds it on its trigger.
# Every optional plugin here MUST have a matching lz.n spec whose name
# equals the plugin's pname (= pack directory name).
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
    # catppuccin setup lives in nvim/init.lua (single source of truth).
    catppuccin-nvim
    { plugin = lualine-nvim; optional = true; }
    bufferline-nvim
    { plugin = dashboard-nvim; }
    # noice setup lazy via lz.n on DeferredUIEnter (+ overrides for vim.lsp.util).
    { plugin = noice-nvim; optional = true; }
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
    { plugin = indent-blankline-nvim; optional = true; }
    { plugin = nvim-colorizer-lua; optional = true; }
    { plugin = smear-cursor-nvim; optional = true; }
    { plugin = twilight-nvim; optional = true; }
    { plugin = smartcolumn-nvim; optional = true; }

    # ============================================================================
    # FILE MANAGEMENT & NAVIGATION
    # ============================================================================
    # telescope + extensions load on DeferredUIEnter (user/telescope.lua
    # packadds the extensions before setup).
    { plugin = telescope-nvim; optional = true; }
    { plugin = telescope-symbols-nvim; optional = true; }
    { plugin = telescope-zoxide; optional = true; }
    { plugin = telescope-fzf-native-nvim; optional = true; }
    { plugin = telescope-frecency-nvim; optional = true; }
    { plugin = neo-tree-nvim; }
    {
      plugin = yazi-nvim;
      config = "lua << EOF\nrequire(\"yazi\").setup()\nEOF\n";
    }
    { plugin = harpoon2; optional = true; }
    {
      plugin = nvim-window-picker;
      config = "lua << EOF\nrequire(\"window-picker\").setup()\nEOF\n";
    }
    vim-tmux-navigator

    # ============================================================================
    # GIT INTEGRATION
    # ============================================================================
    # gitsigns setup lazy via lz.n on BufReadPre/BufNewFile.
    { plugin = gitsigns-nvim; optional = true; }
    vim-fugitive
    { plugin = lazygit-nvim; optional = true; }
    # git-conflict setup runs lazily via nvim/lua/user/git-conflict.lua
    # (driven by lz.n on DeferredUIEnter).
    { plugin = git-conflict-nvim; optional = true; }

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
    # blink-cmp must stay eager: plugin/lsp.lua derives LSP client
    # capabilities from it at startup.
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
    comment-box-nvim
    # refactoring.nvim removed: as of nixpkgs 2026-04 it depends on async.nvim,
    # which ships a top-level lua/async.lua that collides with promise-async
    # and breaks nvim-ufo's require('async'). LSP code actions cover most of
    # what refactoring.nvim offered. Re-evaluate once upstream resolves the
    # naming collision.
    vim-visual-multi
    { plugin = yanky-nvim; }
    { plugin = nvim-spectre; optional = true; }
    { plugin = venn-nvim; optional = true; }
    vim-easy-align

    # ============================================================================
    # FORMATTING & LINTING
    # ============================================================================
    { plugin = conform-nvim; optional = true; }
    { plugin = nvim-lint; optional = true; }

    # ============================================================================
    # DEBUGGING
    # ============================================================================
    { plugin = nvim-dap; optional = true; }
    { plugin = nvim-dap-ui; optional = true; }
    { plugin = debugprint-nvim; optional = true; }

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
    # auto-session stays eager — session restore must be configured before
    # VimEnter; init.lua requires user/auto-session.lua directly.
    auto-session
    { plugin = todo-comments-nvim; optional = true; }
    { plugin = neoscroll-nvim; optional = true; }
    {
      plugin = neogen;
      config = "lua << EOF\nrequire(\"neogen\").setup()\nEOF\n";
    }

    # ============================================================================
    # CODE FOLDING & STRUCTURE
    # ============================================================================
    { plugin = nvim-ufo; optional = true; }
    promise-async
    {
      plugin = aerial-nvim;
      config = "lua << EOF\nrequire(\"aerial\").setup()\nEOF\n";
    }

    # ============================================================================
    # AI & CODE ASSISTANCE
    # ============================================================================
    { plugin = codecompanion-nvim; optional = true; }

    # ============================================================================
    # DATABASE MANAGEMENT
    # ============================================================================
    vim-dadbod
    vim-dadbod-ui
    vim-dadbod-completion

    # ============================================================================
    # HTTP & API TESTING
    # ============================================================================
    { plugin = kulala-nvim; optional = true; }

    # ============================================================================
    # DOCUMENTATION & MARKDOWN
    # ============================================================================
    markdown-preview-nvim
    { plugin = render-markdown-nvim; optional = true; }

    # ============================================================================
    # SCREENSHOTS & SHARING
    # ============================================================================
    { plugin = codesnap-nvim; optional = true; }

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
    { plugin = mini-nvim; optional = true; }
  ];
}
