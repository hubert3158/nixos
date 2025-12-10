# Bluetooth configuration
{ config, lib, pkgs, ... }:

let
  cfg = config.modules.hardware.bluetooth;
in
{
  options.modules.hardware.bluetooth = {
    enable = lib.mkEnableOption "Bluetooth support";
  };

  config = lib.mkIf cfg.enable {
    hardware.bluetooth.enable = true;
  };
}
