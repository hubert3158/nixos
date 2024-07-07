# neovim.nix
{ pkgs, ... }:
{
  programs.neovim= {
    enable = true;
    extraLuaPackages = luaPkgs: with luaPkgs; [ luautf8 ];
    extraLuaConfig = ''
    '';
    extraConfig = ''
                set number
                set relativenumber		
    '' ;

    plugins = with pkgs.vimPlugins; [
      # { plugin = vim-startify;
      #   config = "let g:startify_change_to_vcs_root = 0";
      # }
      ];
      };
      }

