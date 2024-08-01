{config, ... }:
{
  programs.ranger = {
  enable = true;
  extraConfig = ''
    set colorscheme solarized
  '';
     rifle = [
      {
        command = "${config.home.profileDirectory}/bin/nvim -- \"$@\"";
        condition = "mime ^text";
      }
      {
        command = "${config.home.profileDirectory}/bin/swayimg -- \"$@\"";
        condition = "mime ^image";
      }
      {
        command = "${config.home.profileDirectory}/bin/microsoft-edge-stable -- \"$@\"";
        condition = "mime ^pdf";
      }
    ];
};
}
