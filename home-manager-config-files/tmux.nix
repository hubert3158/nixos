# neovim.nix
{pkgs, ...}: {
  programs.tmux = {
    enable = true;
    clock24 = true;
    plugins = with pkgs.tmuxPlugins; [
      sensible
      yank
      resurrect
      {
        plugin = catppuccin;
        extraConfig = ''
        '';
      }
    ];

    extraConfig = ''
      set -g mouse on
      set-option -g allow-passthrough all

    '';
  };
}
