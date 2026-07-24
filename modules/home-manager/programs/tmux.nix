# Tmux configuration — Kanagawa Ink & Wave statusline (docs/THEME.md)
{
  config,
  lib,
  pkgs,
  palette,
  ...
}: let
  cfg = config.modules.programs.tmux;
in {
  options.modules.programs.tmux = {
    enable = lib.mkEnableOption "Tmux terminal multiplexer";

    clock24 = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Use 24-hour clock";
    };

    enableMouse = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable mouse support";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.tmux = {
      enable = true;
      clock24 = cfg.clock24;
      plugins = with pkgs.tmuxPlugins; [
        sensible
        yank
        resurrect
      ];

      extraConfig = ''
        set -g mouse ${
          if cfg.enableMouse
          then "on"
          else "off"
        }
        set-option -g allow-passthrough all

        # ── True Color Support ───────────────────────────────────────
        set -g default-terminal "tmux-256color"
        set -ag terminal-overrides ",xterm-256color:RGB"

        # ╭──────────────────────────────────────────────────────────╮
        # │        Kanagawa Ink & Wave — hand-rolled powerline        │
        # │        colours from lib/palette.nix (docs/THEME.md)       │
        # ╰──────────────────────────────────────────────────────────╯
        set -g status-position top
        set -g status-justify left
        set -g status-style "bg=${palette.sumiInk0},fg=${palette.fujiWhite}"
        set -g status-left-length 40
        set -g status-right-length 80

        # session pill — crystalBlue cap
        set -g status-left "#[fg=${palette.sumiInk0},bg=${palette.crystalBlue},bold] 󰆍 #S #[fg=${palette.crystalBlue},bg=${palette.sumiInk0}]  "

        # windows — inactive ink, active waveBlue pill
        set -g window-status-format "#[fg=${palette.fujiGray},bg=${palette.sumiInk0}]  #I #W  "
        set -g window-status-current-format "#[fg=${palette.waveBlue2},bg=${palette.sumiInk0}]#[fg=${palette.fujiWhite},bg=${palette.waveBlue2},bold] #I #W#{?window_zoomed_flag, 󰊓,} #[fg=${palette.waveBlue2},bg=${palette.sumiInk0}]"
        set -g window-status-separator ""

        # right: cwd (oniViolet) · clock (springBlue) · 波 cap
        set -g status-right "#[fg=${palette.oniViolet}] #{b:pane_current_path} #[fg=${palette.sumiInk6}]│#[fg=${palette.springBlue}] 󰃰 %H:%M #[fg=${palette.crystalBlue},bg=${palette.sumiInk0}]#[fg=${palette.sumiInk0},bg=${palette.crystalBlue},bold] 波 #[default]"

        # ── Pane Borders ─────────────────────────────────────────────
        set -g pane-border-lines heavy
        set -g pane-border-style "fg=${palette.sumiInk4}"
        set -g pane-active-border-style "fg=${palette.crystalBlue}"

        # ── Message / Copy-mode Styling ──────────────────────────────
        set -g message-style "fg=${palette.fujiWhite},bg=${palette.waveBlue1}"
        set -g message-command-style "fg=${palette.fujiWhite},bg=${palette.waveBlue1}"
        set -g mode-style "fg=${palette.fujiWhite},bg=${palette.waveBlue2}"
        set -g clock-mode-colour "${palette.crystalBlue}"

        # ── Window Behavior ──────────────────────────────────────────
        set -g base-index 0
        set -g pane-base-index 0
        set -g renumber-windows on
        set -g automatic-rename off
        set -g allow-rename off
      '';
    };
  };
}
