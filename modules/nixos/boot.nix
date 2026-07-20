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
      # kptr_restrict=0 leaks kernel pointers (ASLR bypass aid) — only
      # enable on the machine that actually runs JProfiler.
      default = false;
      description = "Enable kernel settings for JProfiler (perf_event_paranoid, kptr_restrict)";
    };

    enablePlymouth = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Graphical boot splash instead of scrolling kernel text";
    };
  };

  config = lib.mkIf cfg.enable {
    # Latest stable kernel — newer amdgpu + amd_pstate for the Zen 2 APUs.
    # Cached on cache.nixos.org (verified before adding), no local compile.
    boot.kernelPackages = pkgs.linuxPackages_latest;

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

    # Silent boot with plymouth splash — text logs still reachable via ESC
    boot.plymouth.enable = cfg.enablePlymouth;
    boot.consoleLogLevel = lib.mkIf cfg.enablePlymouth 3;
    boot.initrd.verbose = lib.mkIf cfg.enablePlymouth false;
    boot.kernelParams = lib.mkIf cfg.enablePlymouth [
      "quiet"
      "splash"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];
  };
}
