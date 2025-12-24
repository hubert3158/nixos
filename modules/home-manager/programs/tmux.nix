# Tmux configuration
{ config, lib, pkgs, ... }:

let
  cfg = config.modules.programs.tmux;
in
{
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
        {
          plugin = catppuccin;
          extraConfig = ''
            # ╭──────────────────────────────────────────────────────────╮
            # │                    🎨 CATPPUCCIN MOCHA                   │
            # ╰──────────────────────────────────────────────────────────╯
            set -g @catppuccin_flavor 'mocha'

            # ── Window Styling ───────────────────────────────────────────
            set -g @catppuccin_window_status_style "rounded"
            set -g @catppuccin_window_number_position "left"

            # Default windows - subtle but visible
            set -g @catppuccin_window_default_fill "number"
            set -g @catppuccin_window_default_text " #W"

            # Current window - bold and highlighted
            set -g @catppuccin_window_current_fill "number"
            set -g @catppuccin_window_current_text " #W#{?window_zoomed_flag, 󰊓,}"

            # ── Status Bar Styling ───────────────────────────────────────
            set -g @catppuccin_status_left_separator  ""
            set -g @catppuccin_status_right_separator ""
            set -g @catppuccin_status_fill "icon"
            set -g @catppuccin_status_connect_separator "no"
            set -g @catppuccin_status_background "default"

            # ── Module Icons ─────────────────────────────────────────────
            set -g @catppuccin_directory_icon " "
            set -g @catppuccin_session_icon " "
            set -g @catppuccin_user_icon " "
            set -g @catppuccin_host_icon "󰒋 "
            set -g @catppuccin_date_time_icon "󰃰 "

            # ── Module Text ──────────────────────────────────────────────
            set -g @catppuccin_directory_text "#{b:pane_current_path}"
            set -g @catppuccin_date_time_text "%H:%M"

            # ── Status Bar Layout ────────────────────────────────────────
            set -g @catppuccin_status_modules_left "session"
            set -g @catppuccin_status_modules_right "directory date_time"

            # ── Pane Styling ─────────────────────────────────────────────
            set -g @catppuccin_pane_border_style "fg=#313244"
            set -g @catppuccin_pane_active_border_style "fg=#89b4fa"
          '';
        }
      ];

      extraConfig = ''
        set -g mouse ${if cfg.enableMouse then "on" else "off"}
        set-option -g allow-passthrough all

        # ── True Color Support ───────────────────────────────────────
        set -g default-terminal "tmux-256color"
        set -ag terminal-overrides ",xterm-256color:RGB"

        # ── Status Bar Position ──────────────────────────────────────
        set -g status-position top
        set -g status-justify left

        # ── Pane Borders ─────────────────────────────────────────────
        set -g pane-border-lines heavy
        set -g pane-border-style "fg=#313244"
        set -g pane-active-border-style "fg=#89b4fa"

        # ── Message Styling ──────────────────────────────────────────
        set -g message-style "fg=#cdd6f4,bg=#313244"
        set -g message-command-style "fg=#cdd6f4,bg=#313244"

        # ── Mode Styling (copy mode etc) ─────────────────────────────
        set -g mode-style "fg=#1e1e2e,bg=#f5c2e7"

        # ── Window Behavior ──────────────────────────────────────────
        set -g base-index 1
        set -g pane-base-index 1
        set -g renumber-windows on
        set -g automatic-rename off
        set -g allow-rename off
      '';
    };
  };
}
