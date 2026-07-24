# Cava (standalone terminal visualizer) — Kanagawa gradient
# The waybar cava has its own config (home-manager-config-files/waybar/cava.conf);
# this themes the full-screen `cava` command.
{ config, lib, palette, ... }:

let
  cfg = config.modules.tools.cava;
in
{
  options.modules.tools.cava = {
    enable = lib.mkEnableOption "Cava terminal audio visualizer config";
  };

  config = lib.mkIf cfg.enable {
    xdg.configFile."cava/config".text = ''
      [general]
      framerate = 60
      bars = 0
      bar_width = 2
      bar_spacing = 1

      [input]
      method = pipewire
      source = auto

      [output]
      method = ncurses
      channels = stereo

      [color]
      ; kanagawa: crystalBlue → oniViolet → springBlue → waveAqua wash
      gradient = 1
      gradient_count = 6
      gradient_color_1 = '${palette.waveBlue2}'
      gradient_color_2 = '${palette.dragonBlue}'
      gradient_color_3 = '${palette.crystalBlue}'
      gradient_color_4 = '${palette.oniViolet}'
      gradient_color_5 = '${palette.springBlue}'
      gradient_color_6 = '${palette.lightBlue}'

      [smoothing]
      noise_reduction = 77
    '';
  };
}
