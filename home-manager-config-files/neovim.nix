{ config, pkgs, lib, ... }:
let
  toLua = str: "lua << EOF\n${str}\nEOF\n";
  toLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";
in
  {
    programs.neovim = {
      enable = true;

      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;

      extraLuaConfig = ''
      ${builtins.readFile ./nvim/options.lua}
      ${builtins.readFile ./nvim/keymaps.lua}
      '';

      plugins = with pkgs.vimPlugins; [

        
        {
          plugin = mason-nvim;
          config = toLuaFile ./nvim/plugin/mason.lua;
        }
        {
          plugin = nvim-lspconfig;
          config = toLuaFile ./nvim/plugin/lsp.lua;
        }

        {
          plugin = comment-nvim;
          config = toLua "require(\"Comment\").setup()";
        }
        {
          plugin = noice-nvim;
          config = toLua "require(\"noice\").setup()";
        }

        {
          plugin = gruvbox-nvim;
          config = "colorscheme gruvbox";
        }

        {
          plugin = todo-comments-nvim;
          config = toLua "require(\"todo-comments\").setup()";
        }
        
        
        nvim-cmp 
        {
          plugin = nvim-cmp;
          config = toLuaFile ./nvim/plugin/cmp.lua;
        }

        {
          plugin = telescope-nvim;
          config = toLuaFile ./nvim/plugin/telescope.lua;
        }

        {
          plugin = which-key-nvim ;
          config = toLuaFile ./nvim/plugin/which-key.lua;
        }
        {
          plugin = nvim-treesitter;
          config = toLuaFile ./nvim/plugin/treesitter.lua;
        }

        {
          plugin = surround-nvim;
          config = toLuaFile ./nvim/plugin/surround.lua;
        }

        vim-sneak
        

	# -- ensure_installed = { "c", "query", "lua", "java", "nix", "vimdoc", "luadoc", "vim", "markdown", "markdown_inline" },
          nvim-treesitter-parsers.vimdoc
          nvim-treesitter-parsers.vim
          nvim-treesitter-parsers.javascript
          nvim-treesitter-parsers.typescript
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

        {
          plugin = nvim-dap;
          config = toLuaFile ./nvim/plugin/dap.lua;
        }
        
        {
          plugin = nvim-jdtls;
          config = toLuaFile ./nvim/plugin/nvim-jdtls.lua;
        }
        nvim-dap-ui

        {
          plugin = dashboard-nvim;
          config = toLuaFile ./nvim/plugin/dashboard.lua;
        }

        vim-devicons
        nvim-web-devicons 

        nerdtree

        neodev-nvim

        nvim-notify

        telescope-fzf-native-nvim

        cmp_luasnip
        cmp-nvim-lsp

        luasnip
        friendly-snippets


        lualine-nvim
        nvim-web-devicons



        vim-nix
        vim-visual-multi


      # {
      #   plugin = vimPlugins.own-onedark-nvim;
      #   config = "colorscheme onedark";
      # }
    ];

  };

}

