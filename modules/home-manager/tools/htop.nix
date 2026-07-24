# Htop/Btop system monitor configuration — Ink & Wave (lib/palette.nix)
{ config, lib, pkgs, palette, ... }:

let
  cfg = config.modules.tools.htop;
in
{
  options.modules.tools.htop = {
    enable = lib.mkEnableOption "Htop system monitor";
  };

  config = lib.mkIf cfg.enable {
    programs.htop.enable = true;

    home.packages = with pkgs; [
      btop
    ];

    # Kanagawa Wave theme for btop (docs/THEME.md). btop.conf itself stays
    # unmanaged (btop rewrites it on exit) — pick the theme once in btop's
    # menu (ESC → Options → color theme → kanagawa) and it sticks.
    xdg.configFile."btop/themes/kanagawa.theme".text = ''
      # Kanagawa Wave — Ink & Wave design system
      theme[main_bg]="${palette.sumiInk3}"
      theme[main_fg]="${palette.fujiWhite}"
      theme[title]="${palette.fujiWhite}"
      theme[hi_fg]="${palette.crystalBlue}"
      theme[selected_bg]="${palette.waveBlue1}"
      theme[selected_fg]="${palette.carpYellow}"
      theme[inactive_fg]="${palette.sumiInk6}"
      theme[graph_text]="${palette.oldWhite}"
      theme[meter_bg]="${palette.sumiInk4}"
      theme[proc_misc]="${palette.waveAqua2}"
      theme[cpu_box]="${palette.sumiInk4}"
      theme[mem_box]="${palette.sumiInk4}"
      theme[net_box]="${palette.sumiInk4}"
      theme[proc_box]="${palette.sumiInk4}"
      theme[div_line]="${palette.sumiInk5}"
      theme[temp_start]="${palette.springGreen}"
      theme[temp_mid]="${palette.carpYellow}"
      theme[temp_end]="${palette.peachRed}"
      theme[cpu_start]="${palette.waveAqua2}"
      theme[cpu_mid]="${palette.springBlue}"
      theme[cpu_end]="${palette.crystalBlue}"
      theme[free_start]="${palette.waveBlue2}"
      theme[free_mid]="${palette.dragonBlue}"
      theme[free_end]="${palette.springBlue}"
      theme[cached_start]="${palette.oniViolet}"
      theme[cached_mid]="${palette.springViolet2}"
      theme[cached_end]="${palette.crystalBlue}"
      theme[available_start]="${palette.ansiYellow}"
      theme[available_mid]="${palette.carpYellow}"
      theme[available_end]="${palette.roninYellow}"
      theme[used_start]="${palette.ansiGreen}"
      theme[used_mid]="${palette.springGreen}"
      theme[used_end]="${palette.waveAqua2}"
      theme[download_start]="${palette.waveBlue1}"
      theme[download_mid]="${palette.waveBlue2}"
      theme[download_end]="${palette.springBlue}"
      theme[upload_start]="${palette.winterRed}"
      theme[upload_mid]="${palette.sakuraPink}"
      theme[upload_end]="${palette.waveRed}"
      theme[process_start]="${palette.springBlue}"
      theme[process_mid]="${palette.crystalBlue}"
      theme[process_end]="${palette.oniViolet}"
    '';
  };
}
