{
  config,
  pkgs,
  ...
}: {
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set -g fish_greeting ""
      set -g fish_color_command brcyan
      set -g fish_color_error brred
      set -g fish_color_param white
      set -g fish_color_comment brblack
      set -g fish_color_operator brgreen
      set -g fish_color_quote yellow
      set -g fish_color_end brmagenta
      set -g fish_color_autosuggestion 555
      set -g fish_color_search_match --background=purple
      set -Ux EDITOR nvim
      set -Ux VISUAL nvim
      set -Ux PAGER less
      function fish_prompt
        set_color $fish_color_cwd
        echo -n (prompt_pwd)
        set_color normal
        echo -n ' ❯ '
      end
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
