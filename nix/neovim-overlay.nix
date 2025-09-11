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

  eldritch-nvim = mkNvimPlugin inputs.eldritch-nvim "eldritch-nvim";

  # Make sure we use the pinned nixpkgs instance for wrapNeovimUnstable,
  # otherwise it could have an incompatible signature when applying this overlay.
  pkgs-wrapNeovim = inputs.nixpkgs.legacyPackages.${pkgs.system};

  # This is the helper function that builds the Neovim derivation.
  mkNeovim = pkgs.callPackage ./mkNeovim.nix {inherit pkgs-wrapNeovim;};

  # Replace plugins with user's custom plugins and configuration.
  all-plugins = with pkgs.vimPlugins; [
    # Core dependencies
    plenary-nvim # Lua utility library used by many plugins
    nui-nvim # UI components library

    # ============================================================================
    # COLORSCHEME & UI
    # ============================================================================
    {
      plugin = eldritch-nvim; # Eldritch colorscheme
      config = "lua << EOF\nrequire(\"eldritch\").setup()\nEOF\ncolorscheme eldritch\n";
    }
    {
      plugin = lualine-nvim; # Statusline
    }
    bufferline-nvim # Buffer tabs
    {
      plugin = dashboard-nvim; # Start screen
    }
    {
      plugin = noice-nvim; # Better UI for messages, cmdline and popupmenu
      config = "lua << EOF\nrequire(\"noice\").setup()\nEOF\n";
    }
    {
      plugin =
        nvim-web-devicons
        # Icon support for file types
        ; # Better UI for messages, cmdline and popupmenu
      config = "lua << EOF\nrequire(\"nvim-web-devicons\").setup()\nEOF\n";
    }

    {
      plugin = nvim-notify; # Notification manager
    }
    {
      plugin = barbecue-nvim; # Breadcrumbs winbar
      config = "lua << EOF\nrequire(\"barbecue\").setup()\nEOF\n";
    }
    {
      plugin = indent-blankline-nvim; # Indentation guides
      config = "lua << EOF\nrequire(\"ibl\").setup()\nEOF\n";
    }
    {
      plugin = nvim-colorizer-lua; # Color highlighter
      config = "lua << EOF\nrequire(\"colorizer\").setup()\nEOF\n";
    }
    {
      plugin = smear-cursor-nvim; # Smooth cursor animation
      config = "lua << EOF\nrequire(\"smear_cursor\").setup()\nEOF\n";
    }
    twilight-nvim # Dim inactive portions of code
    {
      plugin = smartcolumn-nvim; # Dynamic color column
      config = "lua << EOF\nrequire(\"smartcolumn\").setup()\nEOF\n";
    }

    # ============================================================================
    # FILE MANAGEMENT & NAVIGATION
    # ============================================================================
    {
      plugin = telescope-nvim; # Fuzzy finder
    }
    telescope-symbols-nvim # Symbol picker for telescope
    telescope-zoxide # Zoxide integration for telescope
    telescope-fzf-native-nvim # Native FZF sorter for telescope
    {
      plugin = neo-tree-nvim; # File explorer
    }
    {
      plugin = yazi-nvim; # File manager integration
      config = "lua << EOF\nrequire(\"yazi\").setup()\nEOF\n";
    }
    harpoon2 # Quick file navigation
    {
      plugin = nvim-window-picker; # Window picker for splits
      config = "lua << EOF\nrequire(\"window-picker\").setup()\nEOF\n";
    }
    vim-tmux-navigator # Seamless tmux/vim navigation

    # ============================================================================
    # GIT INTEGRATION
    # ============================================================================
    {
      plugin = gitsigns-nvim; # Git decorations
      config = "lua << EOF\nrequire(\"gitsigns\").setup({})\nEOF\n";
    }
    fugitive # Git wrapper
    lazygit-nvim # LazyGit integration
    {
      plugin = git-conflict-nvim; # Git conflict resolution
      config = "lua << EOF\nrequire(\"git-conflict\").setup()\nEOF\n";
    }

    # ============================================================================
    # LSP & LANGUAGE SUPPORT
    # ============================================================================
    {
      plugin = nvim-lspconfig; # LSP configuration
    }
    {
      plugin = mason-nvim; # LSP/DAP/linter/formatter installer
    }
    {
      plugin = lazydev-nvim; # Lua development for Neovim
      config = "lua << EOF\nrequire(\"lazydev\").setup({})\nEOF\n";
    }
    {
      plugin = typescript-tools-nvim; # Enhanced TypeScript support
      config = "lua << EOF\nrequire(\"typescript-tools\").setup({})\nEOF\n";
    }
    { plugin = nvim-java; } # Java language support
    {
      plugin = fidget-nvim; # LSP progress indicator
      config = "lua << EOF\nrequire(\"fidget\").setup()\nEOF\n";
    }
    nvim-navic # LSP-based breadcrumbs

    # ============================================================================
    # AUTOCOMPLETION & SNIPPETS
    # ============================================================================
    blink-cmp # Completion engine
    luasnip # Snippet engine
    friendly-snippets # Collection of snippets
    vim-snippets # More snippet collections

    # ============================================================================
    # TREESITTER & SYNTAX HIGHLIGHTING
    # ============================================================================
    nvim-treesitter # Syntax highlighting
    nvim-treesitter-textobjects # Text objects based on syntax
    nvim-ts-autotag # Auto-close/rename HTML tags
    nvim-ts-context-commentstring # Context-aware commenting

    # Treesitter parsers for various languages
    nvim-treesitter-parsers.vimdoc
    nvim-treesitter-parsers.rust
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
    nvim-treesitter-parsers.http
    nvim-treesitter-parsers.graphql
    nvim-treesitter-parsers.yaml

    # ============================================================================
    # CODE EDITING & REFACTORING
    # ============================================================================
    {
      plugin = comment-nvim; # Smart commenting
      config = "lua << EOF\nrequire(\"Comment\").setup()\nEOF\n";
    }
    nvim-comment # Additional commenting support
    comment-box-nvim # Fancy comment boxes
    {
      plugin = refactoring-nvim; # Code refactoring tools
      config = "lua << EOF\nrequire(\"refactoring\").setup({})\nEOF\n";
    }
    vim-visual-multi # Multiple cursors
    {
      plugin = yanky-nvim; # Enhanced yank/paste
    }
    {
      plugin = nvim-spectre; # Find and replace
      config = "lua << EOF\nrequire(\"spectre\").setup()\nEOF\n";
    }

    # ============================================================================
    # FORMATTING & LINTING
    # ============================================================================
    conform-nvim # Formatter runner
    nvim-lint # Linting engine

    # ============================================================================
    # DEBUGGING
    # ============================================================================
    nvim-dap # Debug adapter protocol
    nvim-dap-ui # Debug UI
    debugprint-nvim # Debug print statements

    # ============================================================================
    # UTILITIES & PRODUCTIVITY
    # ============================================================================
    {
      plugin = which-key-nvim; # Keybinding helper
    }
    {
      plugin = toggleterm-nvim; # Terminal manager
      config = "lua << EOF\nrequire(\"toggleterm\").setup()\nEOF\n";
    }
    {
      plugin = trouble-nvim; # Diagnostics list
      config = "lua << EOF\nrequire(\"trouble\").setup()\nEOF\n";
    }
    undotree # Undo history visualizer
    {
      plugin = auto-session; # Session management
      config = "lua << EOF\nrequire(\"auto-session\").setup()\nEOF\n";
    }
    todo-comments-nvim # Highlight TODO comments
    neoscroll-nvim # Smooth scrolling
    {
      plugin = neogen; # Documentation generator
      config = "lua << EOF\nrequire(\"neogen\").setup()\nEOF\n";
    }

    # ============================================================================
    # CODE FOLDING & STRUCTURE
    # ============================================================================
    nvim-ufo # Enhanced folding
    promise-async # Async utilities for ufo
    {
      plugin = aerial-nvim; # Code outline
      config = "lua << EOF\nrequire(\"aerial\").setup()\nEOF\n";
    }

    # ============================================================================
    # AI & CODE ASSISTANCE
    # ============================================================================
    codecompanion-nvim # AI coding assistant
    copilot-vim # GitHub Copilot
    # {
    #   plugin = supermaven-nvim;               # Alternative AI assistant
    #   config = "lua << EOF\nrequire(\"supermaven-nvim\").setup({})\nEOF\n";
    # }

    # ============================================================================
    # DATABASE MANAGEMENT
    # ============================================================================
    vim-dadbod # Database interface
    vim-dadbod-ui # Database UI
    vim-dadbod-completion # Database completion

    # ============================================================================
    # HTTP & API TESTING
    # ============================================================================
    kulala-nvim # HTTP client

    # ============================================================================
    # DOCUMENTATION & MARKDOWN
    # ============================================================================
    render-markdown-nvim # Markdown rendering in buffer

    # ============================================================================
    # SCREENSHOTS & SHARING
    # ============================================================================
    codesnap-nvim # Code screenshots

    # ============================================================================
    # LANGUAGE-SPECIFIC PLUGINS
    # ============================================================================
    vim-pug # Pug template support
    vim-nix # Nix language support
    vim-slime # REPL integration

    # ============================================================================
    # MINI PLUGINS COLLECTION
    # ============================================================================
    {
      plugin = mini-nvim; # Collection of minimal plugins
    }
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
