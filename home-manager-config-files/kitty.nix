{ pkgs, ... }: {
  programs.kitty = {
    enable = true;
    font = {
      name = "FiraCode Nerd Font";
      size = 14;
      package = pkgs.nerd-fonts.fira-code;
    };
    settings = {
      scrollback_lines = 10000;
      enable_audio_bell = false;
      update_check_interval = 0;

      # Set Dracula background
      background = "#282a36";
      background_image = "~/nixos/images/kitty-wallpaper.jpg";
      background_image_layout = "cscaled";

      foreground = "#f8f8f2";
      selection_background = "#44475a";
      selection_foreground = "#f8f8f2";
      cursor = "#f8f8f0";
      cursor_text_color = "#282a36";

      # Color settings
      color0 = "#21222c";
      color1 = "#ff5555";
      color2 = "#50fa7b";
      color3 = "#f1fa8c";
      color4 = "#bd93f9";
      color5 = "#ff79c6";
      color6 = "#8be9fd";
      color7 = "#f8f8f2";
      color8 = "#6272a4";
      color9 = "#ff6e6e";
      color10 = "#69ff94";
      color11 = "#ffffa5";
      color12 = "#d6acff";
      color13 = "#ff92df";
      color14 = "#a4ffff";
      color15 = "#ffffff";
    };
    keybindings = {
      "ctrl+c" = "copy_or_interrupt";
    };
    shellIntegration = {
      mode = "default";
      enableZshIntegration = true;
    };
  };
}

