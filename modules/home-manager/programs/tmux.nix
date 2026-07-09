# Tmux configuration — Kanagawa Ink & Wave statusline (docs/THEME.md)
{
  config,
  lib,
  pkgs,
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
        # │        Kanagawa Ink & Wave — hand-rolled powerline       │
        # │  sumiInk0 16161D · waveBlue2 2D4F67 · crystalBlue 7E9CD8 │
        # ╰──────────────────────────────────────────────────────────╯
        set -g status-position top
        set -g status-justify left
        set -g status-style "bg=#16161D,fg=#DCD7BA"
        set -g status-left-length 40
        set -g status-right-length 80

        # session pill — crystalBlue cap
        set -g status-left "#[fg=#16161D,bg=#7E9CD8,bold] 󰆍 #S #[fg=#7E9CD8,bg=#16161D]  "

        # windows — inactive ink, active waveBlue pill
        set -g window-status-format "#[fg=#727169,bg=#16161D]  #I #W  "
        set -g window-status-current-format "#[fg=#2D4F67,bg=#16161D]#[fg=#DCD7BA,bg=#2D4F67,bold] #I #W#{?window_zoomed_flag, 󰊓,} #[fg=#2D4F67,bg=#16161D]"
        set -g window-status-separator ""

        # right: cwd (oniViolet) · clock (springBlue)
        set -g status-right "#[fg=#957FB8] #{b:pane_current_path} #[fg=#54546D]│#[fg=#7FB4CA] 󰃰 %H:%M #[fg=#7E9CD8,bg=#16161D]#[fg=#16161D,bg=#7E9CD8,bold] 波 #[default]"

        # ── Pane Borders ─────────────────────────────────────────────
        set -g pane-border-lines heavy
        set -g pane-border-style "fg=#2A2A37"
        set -g pane-active-border-style "fg=#7E9CD8"

        # ── Message / Copy-mode Styling ──────────────────────────────
        set -g message-style "fg=#DCD7BA,bg=#223249"
        set -g message-command-style "fg=#DCD7BA,bg=#223249"
        set -g mode-style "fg=#DCD7BA,bg=#2D4F67"
        set -g clock-mode-colour "#7E9CD8"

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
