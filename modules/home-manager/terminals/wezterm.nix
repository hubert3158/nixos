# Wezterm terminal configuration — Kanagawa Wave (Himal design system)
# Palette from lib/palette.nix; keep in lockstep with kitty.nix / ghostty.nix
{ config, lib, pkgs, palette, ... }:

let
  cfg = config.modules.terminals.wezterm;
in
{
  options.modules.terminals.wezterm = {
    enable = lib.mkEnableOption "Wezterm terminal";

    font = lib.mkOption {
      type = lib.types.str;
      default = "Maple Mono NF";
      description = "Font family";
    };

    fontSize = lib.mkOption {
      type = lib.types.number;
      # 14 everywhere — kitty and ghostty both run 14 (docs/THEME.md)
      default = 14.0;
      description = "Font size";
    };

    enableTmuxOnStart = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Start tmux session on terminal launch";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.wezterm = {
      enable = true;
      extraConfig = ''
        return {
          font = wezterm.font("${cfg.font}"),
          font_size = ${toString cfg.fontSize},
          hide_tab_bar_if_only_one_tab = true,
          ${lib.optionalString cfg.enableTmuxOnStart ''default_prog = { "zsh", "--login", "-c", "tmux attach -t dev || tmux new -s dev" },''}
          keys = {
            {key="n", mods="SHIFT|CTRL", action=wezterm.action.ToggleFullScreen},
          },
          -- exact Himal values (lib/palette.nix), not the drifted
          -- "Kanagawa (Gogh)" named scheme — mirrors kitty.nix
          colors = {
            foreground = "${palette.fujiWhite}",
            background = "${palette.sumiInk3}",
            cursor_bg = "${palette.oldWhite}",
            cursor_fg = "${palette.sumiInk3}",
            cursor_border = "${palette.oldWhite}",
            selection_bg = "${palette.waveBlue2}",
            selection_fg = "${palette.oldWhite}",
            scrollbar_thumb = "${palette.waveBlue2}",
            split = "${palette.sumiInk6}",
            ansi = {
              "${palette.sumiInk0}", "${palette.ansiRed}", "${palette.ansiGreen}", "${palette.ansiYellow}",
              "${palette.crystalBlue}", "${palette.oniViolet}", "${palette.ansiCyan}", "${palette.oldWhite}",
            },
            brights = {
              "${palette.fujiGray}", "${palette.samuraiRed}", "${palette.springGreen}", "${palette.carpYellow}",
              "${palette.springBlue}", "${palette.springViolet1}", "${palette.waveAqua2}", "${palette.fujiWhite}",
            },
            indexed = {
              [16] = "${palette.surimiOrange}",
              [17] = "${palette.peachRed}",
            },
          },
          window_background_image = '${config.home.homeDirectory}/nixos/images/walls/great-wave-ink.png',
          window_background_image_hsb = {
            -- ghost the wave into the ink so text stays readable;
            -- 0.06 matches kitty's background_tint = 0.95 (~5% image)
            brightness = 0.06,
            hue = 1.0,
            saturation = 0.9,
          },
        }
      '';
    };
  };
}
