{
  pkgs,
  config,
  ...
}: {
  programs.kitty = {
    enable = true;
    package = pkgs.kitty.overrideAttrs (_: {
      doCheck = false;
      doInstallCheck = false;
      checkInputs = [];
    });
    enableGitIntegration = true;

    font = {
      name = "Monofur Nerd Font";
      size = 18;
      package = pkgs.nerd-fonts.monofur;
    };

    settings = {
      shell = "${pkgs.zsh}/bin/zsh --login";

      scrollback_lines = 10000;
      enable_audio_bell = false;
      update_check_interval = 0;

      background = "#282a36";
      background_image = "${config.home.homeDirectory}/nixos/images/kitty-wallpaper.jpg";
      background_image_layout = "cscaled";

      foreground = "#f8f8f2";
      selection_background = "#44475a";
      selection_foreground = "#f8f8f2";
      cursor = "#f8f8f0";
      cursor_text_color = "#282a36";
    };

    keybindings = {
      "ctrl+c" = "copy_or_interrupt";
    };

    shellIntegration = {
      mode = "default";
      enableZshIntegration = true;
      # enableFishIntegration = true;
      enableBashIntegration = true;
    };
  };
}
