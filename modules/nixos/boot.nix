# Boot and bootloader configuration
{ config, lib, pkgs, ... }:

let
  cfg = config.modules.boot;
in
{
  options.modules.boot = {
    enable = lib.mkEnableOption "boot configuration";

    loader = lib.mkOption {
      type = lib.types.enum [ "systemd-boot" "grub" ];
      default = "systemd-boot";
      description = "Bootloader to use";
    };

    configurationLimit = lib.mkOption {
      type = lib.types.int;
      default = 20;
      description = "Maximum number of boot configurations to keep";
    };

    enableJProfiler = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable kernel settings for JProfiler (perf_event_paranoid, kptr_restrict)";
    };
  };

  config = lib.mkIf cfg.enable {
    boot.loader = lib.mkMerge [
      (lib.mkIf (cfg.loader == "systemd-boot") {
        systemd-boot.enable = true;
        systemd-boot.configurationLimit = cfg.configurationLimit;
        efi.canTouchEfiVariables = true;
      })

      (lib.mkIf (cfg.loader == "grub") {
        grub.enable = true;
        grub.efiSupport = true;
        efi.canTouchEfiVariables = true;
      })
    ];

    # Kernel settings for JProfiler
    boot.kernel.sysctl = lib.mkIf cfg.enableJProfiler {
      "kernel.perf_event_paranoid" = 1;
      "kernel.kptr_restrict" = 0;
    };
  };
}
