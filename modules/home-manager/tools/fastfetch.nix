# Fastfetch — Kanagawa-tinted system fetch (Himal design system)
{ config, lib, pkgs, palette, colors, ... }:

let
  cfg = config.modules.tools.fastfetch;
  # fastfetch takes raw SGR parameters, not hex — lib/color.nix converts, so
  # these stay derived from lib/palette.nix instead of hand-typed triples
  crystalBlue = colors.ansiFg palette.crystalBlue;
  oniViolet = colors.ansiFg palette.oniViolet;
  springBlue = colors.ansiFg palette.springBlue;
  carpYellow = colors.ansiFg palette.carpYellow;
  springGreen = colors.ansiFg palette.springGreen;
  waveAqua = colors.ansiFg palette.waveAqua2;
  sakuraPink = colors.ansiFg palette.sakuraPink;
  fujiWhite = colors.ansiFg palette.fujiWhite;
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
            # Romanised, not ukalo: this box is drawn in a terminal and
            # every rule below it is 40 display columns. Devanagari is
            # single-width where the old CJK was double, so the frame would
            # come apart — and it inks a size small beside the Latin anyway.
            format = "{#${crystalBlue}}╭── u k a l o ─────────────────────────╮";
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
            format = "{#${crystalBlue}}├──────────────────────────────────────┤";
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
            format = "{#${crystalBlue}}├──────────────────────────────────────┤";
          }
          # Bikram Sambat — today's Bikram Sambat date (lib/patro.nix).
          # `patro` is a home.packages binary, so this resolves from PATH; the
          # module simply prints nothing on a machine that doesn't have it.
          {
            type = "command";
            key = "  󰸉 patro";
            keyColor = springGreen;
            text = "patro line 2>/dev/null";
          }
          {
            type = "custom";
            format = "{#${crystalBlue}}╰──────────────────────────────────────╯";
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
