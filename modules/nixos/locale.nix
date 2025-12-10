# Locale and timezone configuration
{ config, lib, pkgs, ... }:

let
  cfg = config.modules.locale;
in
{
  options.modules.locale = {
    enable = lib.mkEnableOption "locale configuration";

    timeZone = lib.mkOption {
      type = lib.types.str;
      default = "America/New_York";
      description = "System timezone";
    };

    defaultLocale = lib.mkOption {
      type = lib.types.str;
      default = "en_US.UTF-8";
      description = "Default system locale";
    };
  };

  config = lib.mkIf cfg.enable {
    time.timeZone = cfg.timeZone;

    i18n.defaultLocale = cfg.defaultLocale;

    i18n.extraLocaleSettings = {
      LC_ADDRESS = cfg.defaultLocale;
      LC_IDENTIFICATION = cfg.defaultLocale;
      LC_MEASUREMENT = cfg.defaultLocale;
      LC_MONETARY = cfg.defaultLocale;
      LC_NAME = cfg.defaultLocale;
      LC_NUMERIC = cfg.defaultLocale;
      LC_PAPER = cfg.defaultLocale;
      LC_TELEPHONE = cfg.defaultLocale;
      LC_TIME = cfg.defaultLocale;
    };
  };
}
