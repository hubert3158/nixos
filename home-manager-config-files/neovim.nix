{ config, pkgs, lib, ... }:

let
  buildVimPlugin = pkgs.vimUtils.buildVimPlugin;
  fetchFromGitHub = pkgs.fetchFromGitHub;

  # Define the custom plugins
  telescopeNvim = buildVimPlugin {
    pname = "telescope-nvim";
    version = "scm";
    src = fetchFromGitHub {
      owner = "nvim-telescope";
      repo = "telescope.nvim";
      rev = "master";
      sha256 = "sha256-U6fgii9FlJy+bHAtYVnZEOyiUAqlBHTvMFc4mo+xS/s=";
    };
  };

  plenary = buildVimPlugin {
    pname = "plenary";
    version = "scm";
    src = fetchFromGitHub {
      owner = "nvim-lua";
      repo = "plenary.nvim";
      rev = "master";
      sha256 = "sha256-5Jf2mWFVDofXBcXLbMa417mqlEPWLA+cQIZH/vNEV1g";
    };
  };

in
{
  programs.neovim = {
    enable = true;

    extraConfig = ''
      set number
      set relativenumber

      lua << EOF
      require('telescope').setup{
        defaults = {
          -- Your configuration comes here
          -- It is passed to the configuration and set up here
        }
      }
      EOF
    '';

    plugins = with pkgs.vimPlugins; [
      vim-airline
      vim-fugitive
      telescopeNvim
      plenary
    ];
  };

}

