{
  programs.zellij = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      theme = "dracula";
      themes.dracula = {
        fg = "#f8f8f2";
        bg = "#282a36";
        red = "#ff5555";
        green = "#50fa7b";
        yellow = "#f1fa8c";
        blue = "#6272a4";
        magenta = "#ff79c6";
        orange = "#ffb86c";
        cyan = "#8be9fd";
        black = "#000000";
        white = "#ffffff";
      };
    };
  };
}

