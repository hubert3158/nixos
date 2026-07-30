# FZF fuzzy finder — Himal (lib/palette.nix, docs/THEME.md)
{ config, lib, pkgs, palette, ... }:

let
  cfg = config.modules.tools.fzf;
in
{
  options.modules.tools.fzf = {
    enable = lib.mkEnableOption "FZF fuzzy finder";
  };

  config = lib.mkIf cfg.enable {
    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
      # Kanagawa Wave (docs/THEME.md) — rounded frosted look
      colors = {
        "bg+" = palette.waveBlue1;
        bg = palette.sumiInk3;
        spinner = palette.springBlue;
        hl = palette.carpYellow;
        fg = palette.fujiWhite;
        header = palette.oniViolet;
        info = palette.dragonBlue;
        pointer = palette.crystalBlue;
        marker = palette.springGreen;
        "fg+" = palette.fujiWhite;
        prompt = palette.crystalBlue;
        "hl+" = palette.carpYellow;
        border = palette.sumiInk6;
      };
      defaultOptions = [
        "--border=rounded"
        "--prompt='❯ '"
        "--pointer='▍'"
        "--marker='󰁕 '"
        "--separator='─'"
        "--info=inline-right"
      ];
    };
  };
}
