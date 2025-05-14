# This overlay, when applied to nixpkgs, adds the final neovim derivation to nixpkgs.
{inputs}: final: prev:
with final.pkgs.lib; let
  pkgs = final;

  # Use this to create a plugin from a flake input
  mkNvimPlugin = src: pname:
    pkgs.vimUtils.buildVimPlugin {
      inherit pname src;
      version = src.lastModifiedDate;
    };

  # Make sure we use the pinned nixpkgs instance for wrapNeovimUnstable,
  # otherwise it could have an incompatible signature when applying this overlay.
  pkgs-wrapNeovim = inputs.nixpkgs.legacyPackages.${pkgs.system};

  # This is the helper function that builds the Neovim derivation.
  mkNeovim = pkgs.callPackage ./mkNeovim.nix {inherit pkgs-wrapNeovim;};

  # Replace plugins with user's custom plugins and configuration.
  all-plugins = with pkgs.vimPlugins; [
    telescope-zoxide
    nvim-comment
    comment-box-nvim
    vim-pug
    vim-tmux-navigator
    undotree
    lazygit-nvim
    plenary-nvim
    harpoon2

    vim-dadbod
    vim-dadbod-ui
    vim-dadbod-completion

    nvim-ufo
    # neoformat # replaced with conform
    kulala-nvim
    markdown-preview-nvim

    # Custom plugin configurations
    {
      plugin = lazydev-nvim;
      config = "lua << EOF\nrequire(\"lazydev\").setup({})\nEOF\n";
    }
    # {
    #   plugin = supermaven-nvim;
    #   config = "lua << EOF\nrequire(\"supermaven-nvim\").setup({})\nEOF\n";
    # }
    {
      plugin = refactoring-nvim;
      config = "lua << EOF\nrequire(\"refactoring\").setup({})\nEOF\n";
    }
    {
      plugin = yazi-nvim;
      config = "lua << EOF\nrequire(\"yazi\").setup()\nEOF\n";
    }
    {
      plugin = neogen;
      config = "lua << EOF\nrequire(\"neogen\").setup()\nEOF\n";
    }
    {
      plugin = trouble-nvim;
      config = "lua << EOF\nrequire(\"trouble\").setup()\nEOF\n";
    }
    {
      plugin = nvim-colorizer-lua;
      config = "lua << EOF\nrequire(\"colorizer\").setup()\nEOF\n";
    }
    {
      plugin = smear-cursor-nvim;
      config = "lua << EOF\nrequire(\"smear_cursor\").setup()\nEOF\n";
    }

    twilight-nvim
    nvim-ts-autotag
    {
      plugin = smartcolumn-nvim;
      config = "lua << EOF\nrequire(\"smartcolumn\").setup()\nEOF\n";
    }
    {
      plugin = yanky-nvim;
    }
    {
      plugin = mini-nvim;
    }
    {
      plugin = mason-nvim;
    }
    {
      plugin = nvim-lspconfig;
    }
    {
      plugin = comment-nvim;
      config = "lua << EOF\nrequire(\"Comment\").setup()\nEOF\n";
    }
    {
      plugin = noice-nvim;
      config = "lua << EOF\nrequire(\"noice\").setup()\nEOF\n";
    }
    {
      plugin = gruvbox-nvim;
      config = "colorscheme gruvbox";
    }
    {
      plugin = todo-comments-nvim;
      config = "lua << EOF\nrequire(\"todo-comments\").setup()\nEOF\n";
    }

    cmp_luasnip
    luasnip
    friendly-snippets
    vim-snippets

    blink-cmp
    codesnap-nvim
    codecompanion-nvim
    copilot-vim
    nvim-cmp
    cmp-nvim-lsp
    {
      plugin = telescope-nvim;
    }
    telescope-symbols-nvim
    {
      plugin = which-key-nvim;
    }

    nvim-treesitter
    nvim-treesitter-textobjects
    nvim-treesitter-parsers.vimdoc
    nvim-treesitter-parsers.pug
    nvim-treesitter-parsers.vim
    nvim-treesitter-parsers.javascript
    nvim-treesitter-parsers.typescript
    nvim-treesitter-parsers.tsx
    nvim-treesitter-parsers.csv
    nvim-treesitter-parsers.json
    nvim-treesitter-parsers.jsonc
    nvim-treesitter-parsers.c
    nvim-treesitter-parsers.query
    nvim-treesitter-parsers.lua
    nvim-treesitter-parsers.java
    nvim-treesitter-parsers.nix
    nvim-treesitter-parsers.luadoc
    nvim-treesitter-parsers.markdown
    nvim-treesitter-parsers.markdown_inline
    nvim-treesitter-parsers.yuck
    nvim-treesitter-parsers.zig
    nvim-treesitter-parsers.yaml
    nvim-dap
    nvim-jdtls
    nvim-dap-ui
    dashboard-nvim
    vim-devicons
    nvim-web-devicons
    nerdtree
    nvim-notify
    telescope-fzf-native-nvim
    friendly-snippets
    lualine-nvim
    vim-nix
    vim-visual-multi
    nvim-lint
    conform-nvim
    neoscroll-nvim
  ];

  extraPackages = with pkgs; [
    lua-language-server
    nil # nix LSP
  ];
in {
  # This is the neovim derivation
  nvim-pkg = mkNeovim {
    plugins = all-plugins;
    inherit extraPackages;
  };

  # This can be symlinked in the devShell's shellHook
  nvim-luarc-json = final.mk-luarc-json {
    plugins = all-plugins;
  };
}
