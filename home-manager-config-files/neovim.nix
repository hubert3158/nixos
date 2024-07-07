{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;

    # Disable other configurations as they will be handled by init.lua
    extraConfig = ''
      luafile /home/hubert/nixos/nvim/init.lua
    '';
  };
}

