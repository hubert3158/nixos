{lib,config,pkgs,...}:
{
  xsession = {
    enable = true;
    windowManager.i3= {
      enable = true;
      config = {
        modifier = "Mod4";
        terminal = "kitty";
        keybindings = let
  modifier = config.xsession.windowManager.i3.config.modifier;
in lib.mkOptionDefault {
  "${modifier}+q" = "exec kitty";
  "${modifier}+c" = "kill";
  "${modifier}+r" = "exec rofi -show drun";
  "${modifier}+t" = "layout tabbed";
  # "${modifier}+shift + r" = "mode resize"; wrong syntax
   # "${modifier}+mod1+R" = "restart";
};
      };
  };
};
}
