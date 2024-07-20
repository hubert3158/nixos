{
  programs.alacritty = {
    enable = true;
    settings = {
      window.dimensions = {
        lines = 3;
        columns = 200;
      };


      import = ["nixos/home-manager-config-files/alacritty/alacritty-theme/themes/gruvbox_material_hard_dark.toml"];

      keyboard.bindings = [
        {
          key = "K";
          mods = "Control";
          chars = "\\u000c"; 
        }
      ];
      colors.cursor = {
        text = "#ff00ff";
        cursor= "#82b8c8";
      };

      selection.save_to_clipboard = true;

      font.size = 14;

    };
  };
}

