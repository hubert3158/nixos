# Cava (standalone terminal visualizer) — Kanagawa gradient
# The waybar cava has its own config (home-manager-config-files/waybar/cava.conf);
# this themes the full-screen `cava` command.
{ config, lib, ... }:

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
      gradient_color_1 = '#2D4F67'
      gradient_color_2 = '#658594'
      gradient_color_3 = '#7E9CD8'
      gradient_color_4 = '#957FB8'
      gradient_color_5 = '#7FB4CA'
      gradient_color_6 = '#A3D4D5'

      [smoothing]
      noise_reduction = 77
    '';
  };
}
