# Browser configuration
{ config, lib, pkgs, ... }:

let
  cfg = config.modules.programs.browsers;
in
{
  options.modules.programs.browsers = {
    enable = lib.mkEnableOption "browser configuration";

    enableQutebrowser = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Qutebrowser";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.qutebrowser = lib.mkIf cfg.enableQutebrowser {
      enable = true;
    };
  };
}
