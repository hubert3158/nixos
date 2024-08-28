{lib,config,...}:
{
  programs.feh.enable = true;

  xsession = {
    enable = true;
    windowManager.i3= {
      enable = true;
      config = {
        fonts = {
          names = [ "DejaVu Sans Mono" "FontAwesome5Free" ];
          style = "Bold Semi-Condensed";
          size = 11.0;
        };
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

 startup = [
   {
     command = "feh --bg-scale ~/nixos/images/wallpaper.png";
   }
   {
     command = "xrandr --output eDP-1 --off ";
   }
 ];
      };
    };
  };
}
