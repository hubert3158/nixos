# Kitty terminal configuration — Kanagawa Wave (Himal design system)
# Colours from lib/palette.nix; keep in lockstep with ghostty.nix / wezterm.nix
{ config, lib, pkgs, palette, ... }:

let
  cfg = config.modules.terminals.kitty;
in
{
  options.modules.terminals.kitty = {
    enable = lib.mkEnableOption "Kitty terminal";

    fontName = lib.mkOption {
      type = lib.types.str;
      default = "Maple Mono NF";
      description = "Font family";
    };

    fontSize = lib.mkOption {
      type = lib.types.number;
      default = 14;
      description = "Font size";
    };

    scrollbackLines = lib.mkOption {
      type = lib.types.int;
      default = 10000;
      description = "Number of scrollback lines";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.kitty = {
      enable = true;
      enableGitIntegration = true;

      font = {
        name = cfg.fontName;
        size = cfg.fontSize;
        package = pkgs.maple-mono.NF;
      };

      settings = {
        shell = "${pkgs.zsh}/bin/zsh --login";

        scrollback_lines = cfg.scrollbackLines;
        enable_audio_bell = false;
        update_check_interval = 0;

        # Disable the config-file watcher (kitten __watch_conf__). On kitty 0.47.1
        # with a home-manager-symlinked kitty.conf (-> /nix/store), the watcher
        # follows the symlink and recursively adds inotify watches under the nix
        # store, exhausting fs.inotify.max_user_watches (524288) within minutes of
        # boot. Every other watcher (vite dev server, IDEs) then fails with
        # ENOSPC. Auto-reload is useless under home-manager anyway: config changes
        # land as a new store path via `home-manager switch`, never as in-place
        # edits. Manual reload (ctrl+shift+f5) still works.
        auto_reload_config = -1;

        # ── Kanagawa Wave over a ghosted wallpaper texture ──
        # kitty paints the image wherever a cell's bg equals the default
        # background — which includes ALL of neovim — so the tint must be
        # near-total or code drowns in the artwork. 0.95 = faint ghost texture.
        background = palette.sumiInk3;
        background_image = "${config.home.homeDirectory}/nixos/images/walls/great-wave-ink.png";
        background_image_layout = "cscaled";
        background_tint = "0.95";

        foreground = palette.fujiWhite;
        selection_background = palette.waveBlue2;
        selection_foreground = palette.oldWhite;
        cursor = palette.oldWhite;
        cursor_text_color = palette.sumiInk3;

        # animated cursor smear — pure nerd candy
        cursor_trail = 3;
        cursor_trail_decay = "0.1 0.4";

        url_color = palette.springBlue;
        url_style = "curly";
        window_padding_width = 8;
        hide_window_decorations = "yes";
        # unfocused kitty splits fade slightly — pairs with the hyprland
        # terminal-depth windowrule for layered ink
        inactive_text_alpha = "0.85";

        # Ligatures stay on (Maple Mono's are the point of the font) but melt
        # away under the cursor, so `!=` is two editable characters again the
        # moment you land on it.
        disable_ligatures = "cursor";

        # A blinking cursor is a repaint of the whole cell twice a second,
        # forever, on a machine that renders a blurred bar above it. The
        # cursor_trail below already carries the motion.
        cursor_blink_interval = 0;

        # long jobs announce themselves when the window isn't focused
        notify_on_cmd_finish = "unfocused 15.0";

        # tab bar as a title bar — ink powerline, crystalBlue active tab
        tab_bar_edge = "top";
        tab_bar_style = "powerline";
        tab_powerline_style = "slanted";
        tab_bar_min_tabs = 2;
        tab_title_template = "{fmt.bold}{bell_symbol}{activity_symbol}{index}{fmt.nobold} {title[:20]}";
        active_tab_font_style = "bold";
        inactive_tab_font_style = "italic";
        active_tab_background = palette.crystalBlue;
        active_tab_foreground = palette.sumiInk0;
        inactive_tab_background = palette.sumiInk0;
        inactive_tab_foreground = palette.fujiGray;
        tab_bar_background = palette.sumiInk0;

        # 16-color palette — Kanagawa Wave (normal 0-7, bright 8-15)
        color0 = palette.sumiInk0;
        color8 = palette.fujiGray;
        color1 = palette.ansiRed;
        color9 = palette.samuraiRed;
        color2 = palette.ansiGreen;
        color10 = palette.springGreen;
        color3 = palette.ansiYellow;
        color11 = palette.carpYellow;
        color4 = palette.crystalBlue;
        color12 = palette.springBlue;
        color5 = palette.oniViolet;
        color13 = palette.springViolet1;
        color6 = palette.ansiCyan;
        color14 = palette.waveAqua2;
        color7 = palette.oldWhite;
        color15 = palette.fujiWhite;
        color16 = palette.surimiOrange;
        color17 = palette.peachRed;
      };

      # Directives that legitimately repeat can't live in `settings` (an attrset
      # can only hold one of each key).
      extraConfig = ''
        # ── typography ──
        # Maple Mono is drawn tight; 8% more leading turns a wall of code into
        # lines you can scan. The underline tweaks are for LSP undercurls —
        # at the default position they collide with descenders in this face.
        modify_font cell_height 108%
        modify_font underline_position 130%
        modify_font underline_thickness 120%

        # ── Devanagari ──
        # Safety net, not chrome. Maple Mono NF has *zero* coverage of
        # U+0900-097F (verified against its cmap), so without this every
        # Devanagari character in a terminal — a Nepali filename, a `patro`
        # invocation, a README — renders as tofu. Pin the block to Noto rather
        # than letting fontconfig pick a different fallback per glyph.
        #
        # The status chrome deliberately does *not* rely on this: Devanagari
        # numerals ink 2-4px shorter than Maple Mono's at the same size and
        # kitty cannot scale a fallback, so tmux and the Neovim statusline keep
        # Latin digits. Full Devanagari lives on the GUI surfaces, where Pango
        # shapes proportional text properly. See programs/tmux.nix.
        symbol_map U+0900-U+097F Noto Sans Devanagari
      '';

      keybindings = {
        "ctrl+c" = "copy_or_interrupt";
      };

      shellIntegration = {
        mode = "default";
        enableZshIntegration = true;
        enableBashIntegration = true;
      };
    };
  };
}
