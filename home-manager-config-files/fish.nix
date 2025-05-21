{
  config,
  pkgs,
  ...
}: {
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set -g fish_greeting "brusssssskiii"
      set -Ux EDITOR nvim
      set -Ux VISUAL nvim
      set -Ux PAGER less

      # Enable Starship prompt
      starship init fish | source
    '';
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[✗](bold red)";
      };
    };
  };

  home.packages = with pkgs; [
    fish
    starship
  ];
}
