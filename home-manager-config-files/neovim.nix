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
  telescopeConfig = builtins.readFile ./neovim_config/telescope-config.lua;


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

  # treesitterNvim = buildVimPlugin {
  #   pname = "nvim-treesitter";
  #   version = "scm";
  #   src = fetchFromGitHub {
  #     owner = "nvim-treesitter";
  #     repo = "nvim-treesitter";
  #     rev = "master";
  #     sha256 = "sha256-0000000000000000000000000000000000000000000000000000"; # Replace with actual hash
  #   };
  # };

in
{
  programs.neovim = {
    enable = true;

    extraConfig = ''
      set number
      set relativenumber

    '';

    plugins = [
      pkgs.vimPlugins.vim-airline
      pkgs.vimPlugins.vim-fugitive
      telescopeNvim
      plenary
      # treesitterNvim
    ];
  };

  home.file.".config/nvim/lua/telescope-config.lua".text = telescopeConfig;

}

