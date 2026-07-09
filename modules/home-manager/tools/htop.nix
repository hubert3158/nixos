# Htop/Btop system monitor configuration
{ config, lib, pkgs, ... }:

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
      theme[main_bg]="#1F1F28"
      theme[main_fg]="#DCD7BA"
      theme[title]="#DCD7BA"
      theme[hi_fg]="#7E9CD8"
      theme[selected_bg]="#223249"
      theme[selected_fg]="#E6C384"
      theme[inactive_fg]="#54546D"
      theme[graph_text]="#C8C093"
      theme[meter_bg]="#2A2A37"
      theme[proc_misc]="#7AA89F"
      theme[cpu_box]="#2A2A37"
      theme[mem_box]="#2A2A37"
      theme[net_box]="#2A2A37"
      theme[proc_box]="#2A2A37"
      theme[div_line]="#363646"
      theme[temp_start]="#98BB6C"
      theme[temp_mid]="#E6C384"
      theme[temp_end]="#FF5D62"
      theme[cpu_start]="#7AA89F"
      theme[cpu_mid]="#7FB4CA"
      theme[cpu_end]="#7E9CD8"
      theme[free_start]="#2D4F67"
      theme[free_mid]="#658594"
      theme[free_end]="#7FB4CA"
      theme[cached_start]="#957FB8"
      theme[cached_mid]="#9CABCA"
      theme[cached_end]="#7E9CD8"
      theme[available_start]="#C0A36E"
      theme[available_mid]="#E6C384"
      theme[available_end]="#FF9E3B"
      theme[used_start]="#76946A"
      theme[used_mid]="#98BB6C"
      theme[used_end]="#7AA89F"
      theme[download_start]="#223249"
      theme[download_mid]="#2D4F67"
      theme[download_end]="#7FB4CA"
      theme[upload_start]="#43242B"
      theme[upload_mid]="#D27E99"
      theme[upload_end]="#E46876"
      theme[process_start]="#7FB4CA"
      theme[process_mid]="#7E9CD8"
      theme[process_end]="#957FB8"
    '';
  };
}
