# Boot and bootloader configuration
{ config, lib, pkgs, palette, colors, ... }:

let
  cfg = config.modules.boot;

  # Himal boot splash — same palette as the desktop, so the machine never
  # flashes a stock theme on the way up.
  himalPlymouth = pkgs.callPackage ../../packages/plymouth-himal {
    inherit palette colors;
  };
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

    kernelSeries = lib.mkOption {
      type = lib.types.enum [ "latest" "lts" ];
      default = "latest";
      description = ''
        Kernel series to track. "latest" follows the newest stable kernel
        (newer amdgpu + amd_pstate for the Zen 2 APUs); "lts" pins longterm.

        The work laptop (Lenovo IdeaPad 3 14ALC6, AMD Lucienne) hangs at S5
        poweroff: systemd runs to completion — "Reached target System Power
        Off", journald stops cleanly — and then the machine never cuts power,
        so it sits with the power LED lit until a forced shutdown. Reboot
        hangs the same way, which puts the fault after systemd hands off, in
        the driver-shutdown/ACPI window. Upstream this class of bug is
        reliably kernel-version-dependent (regresses on new kernels, LTS
        unaffected), so "lts" is the first bisect step. Move back to "latest"
        once a kernel ships the fix.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    # Both series are cached on cache.nixos.org, no local compile.
    boot.kernelPackages =
      if cfg.kernelSeries == "lts"
      then pkgs.linuxPackages
      else pkgs.linuxPackages_latest;

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
    boot.plymouth = {
      enable = cfg.enablePlymouth;
      theme = lib.mkIf cfg.enablePlymouth "himal";
      themePackages = lib.mkIf cfg.enablePlymouth [ himalPlymouth ];
    };
    boot.consoleLogLevel = lib.mkIf cfg.enablePlymouth 3;
    boot.initrd.verbose = lib.mkIf cfg.enablePlymouth false;
    # Only the console-silencing params belong under enablePlymouth. Keep the
    # conditional scoped to that list so anything added later (reboot=, acpi
    # quirks) can sit outside it and survive with plymouth off.
    boot.kernelParams =
      lib.optionals cfg.enablePlymouth [
        "quiet"
        "splash"
        "rd.systemd.show_status=false"
        "rd.udev.log_level=3"
        "udev.log_priority=3"
      ];
  };
}
