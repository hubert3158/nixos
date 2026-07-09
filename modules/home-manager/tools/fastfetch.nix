# Fastfetch — Kanagawa-tinted system fetch (Ink & Wave design system)
{ config, lib, pkgs, ... }:

let
  cfg = config.modules.tools.fastfetch;
  # kanagawa truecolor escapes
  crystalBlue = "38;2;126;156;216";
  oniViolet = "38;2;149;127;184";
  springBlue = "38;2;127;180;202";
  carpYellow = "38;2;230;195;132";
  springGreen = "38;2;152;187;108";
  waveAqua = "38;2;122;168;159";
  sakuraPink = "38;2;210;126;153";
  fujiWhite = "38;2;220;215;186";
in
{
  options.modules.tools.fastfetch = {
    enable = lib.mkEnableOption "Fastfetch system information";
  };

  config = lib.mkIf cfg.enable {
    programs.fastfetch = {
      enable = true;
      settings = {
        logo = {
          source = "nixos";
          padding = {
            top = 1;
            right = 4;
          };
          color = {
            "1" = crystalBlue;
            "2" = oniViolet;
          };
        };

        display = {
          separator = "  ";
          color = {
            keys = crystalBlue;
            output = fujiWhite;
          };
        };

        modules = [
          "break"
          {
            type = "custom";
            format = "{#38;2;126;156;216}╭── 「 波 に 乗 れ 」──────────────────╮";
          }
          {
            type = "title";
            key = "  󰧱 ";
            format = "{user-name}@{host-name}";
          }
          {
            type = "os";
            key = "  󱄅 os";
            keyColor = crystalBlue;
          }
          {
            type = "kernel";
            key = "   kernel";
            keyColor = oniViolet;
          }
          {
            type = "wm";
            key = "   wm";
            keyColor = springBlue;
          }
          {
            type = "shell";
            key = "   shell";
            keyColor = springGreen;
          }
          {
            type = "terminal";
            key = "   term";
            keyColor = waveAqua;
          }
          {
            type = "packages";
            key = "  󰏖 pkgs";
            keyColor = carpYellow;
          }
          {
            type = "uptime";
            key = "  󰅐 uptime";
            keyColor = sakuraPink;
          }
          {
            type = "custom";
            format = "{#38;2;126;156;216}├──────────────────────────────────────┤";
          }
          {
            type = "cpu";
            key = "  󰻠 cpu";
            keyColor = springBlue;
          }
          {
            type = "gpu";
            key = "  󰢮 gpu";
            keyColor = oniViolet;
          }
          {
            type = "memory";
            key = "  󰍛 memory";
            keyColor = sakuraPink;
          }
          {
            type = "disk";
            key = "  󰋊 disk";
            keyColor = carpYellow;
          }
          {
            type = "display";
            key = "  󰍹 display";
            keyColor = waveAqua;
          }
          {
            type = "custom";
            format = "{#38;2;126;156;216}╰──────────────────────────────────────╯";
          }
          "break"
          {
            type = "colors";
            paddingLeft = 4;
            symbol = "circle";
          }
        ];
      };
    };
  };
}
