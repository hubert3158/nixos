# FZF fuzzy finder configuration
{ config, lib, pkgs, ... }:

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
        "bg+" = "#223249";
        bg = "#1F1F28";
        spinner = "#7FB4CA";
        hl = "#E6C384";
        fg = "#DCD7BA";
        header = "#957FB8";
        info = "#658594";
        pointer = "#7E9CD8";
        marker = "#98BB6C";
        "fg+" = "#DCD7BA";
        prompt = "#7E9CD8";
        "hl+" = "#E6C384";
        border = "#54546D";
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
