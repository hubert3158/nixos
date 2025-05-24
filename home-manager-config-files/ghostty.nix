{...}: {
  programs.ghostty = {
    enable = true;
    installVimSyntax = true;
    installBatSyntax = true;
    settings = {
      "copy-on-select" = true;
      "font-family" = "monofur nerd font";
      "font-size " = 18;
      "font-style" = "light";
      "font-feature" = "-calt,-liga,-dlig";
      "font-style-bold" = "false";
      "shell-integration" = "fish";
      "theme" = "Arthur";
      "background-opacity" = 0.5;
    };
  };
}
