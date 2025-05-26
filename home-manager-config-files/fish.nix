{
  config,
  pkgs,
  ...
}: {
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set -g fish_greeting ""
      set -Ux EDITOR nvim
      set -Ux VISUAL nvim
      set -Ux PAGER less

      # Enable Starship prompt
      starship init fish | source
    '';
  };

  home.packages = with pkgs; [
    fish
    starship
  ];
}
