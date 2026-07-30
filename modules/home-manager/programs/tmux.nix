# Tmux configuration — Himal statusline, Kanagawa Wave palette (docs/THEME.md)
{
  config,
  lib,
  pkgs,
  palette,
  ...
}: let
  cfg = config.modules.programs.tmux;

  # Re-clamp every window's panes to that window's own size.
  #
  # tmux-resurrect restores layouts by replaying the saved layout string
  # verbatim (restore.sh: `tmux select-layout -t "$sess:$win" "$layout"`).
  # select-layout does NOT clamp to the current window, so a layout saved at
  # an older terminal geometry sizes the pane larger than the window that
  # contains it — e.g. a saved `173x41` layout inside a `169x35` window. The
  # pane's pty is then told it has 41 rows (`stty size` reports 41) while tmux
  # only paints 35, so the bottom ~6 lines and the cursor render below the
  # visible area, in nvim and in the bare shell alike.
  #
  # Our saves are full of 173x41 layouts: that was kitty's grid on this
  # 1920x1080 monitor *before* `modify_font cell_height 108%` landed in
  # kitty.nix (cell height 25.6 -> 27.6, so 41 rows no longer fit in 1080px).
  # Any font-size, monitor or machine change produces the same stale-geometry
  # mismatch, which is why it only bit sometimes.
  #
  # Re-issuing the window's own size forces a relayout that clamps the panes;
  # unsetting the window-level `window-size` afterwards drops the `manual`
  # flag that `resize-window -x/-y` sets, so automatic resizing resumes.
  reclampPanes = pkgs.writeShellScript "tmux-reclamp-panes" ''
    tmux list-windows -a -F '#{window_id} #{window_width} #{window_height}' |
    while read -r target width height; do
      tmux resize-window -t "$target" -x "$width" -y "$height" 2>/dev/null || continue
      tmux set-window-option -t "$target" -u window-size 2>/dev/null || true
    done
  '';

  # ╭────────────────────────────────────────────────────────────────────╮
  # │  Himal statusline construction (docs/THEME.md)                     │
  # ╰────────────────────────────────────────────────────────────────────╯
  p = palette;

  # Style helpers. One attribute per `#[...]` block on purpose: a style
  # written `#[fg=x,bg=y]` carries literal commas, and a literal comma inside
  # a `#{?cond,a,b}` conditional has to be escaped as `#,`. Splitting the
  # blocks means every branch below stays copy-pasteable.
  fg = c: "#[fg=${c}]";
  bg = c: "#[bg=${c}]";
  bold = "#[bold]";
  nobold = "#[nobold]";

  # Slanted powerline caps — U+E0BA / U+E0BC, the same pair kitty draws for
  # `tab_powerline_style slanted`, so a tmux pill and a kitty tab are cut at
  # the same angle. Verified present in Maple Mono NF.
  #
  # Spelled as escapes rather than pasted literally: these live in the Unicode
  # private use area, and a bare U+E0BA does not survive every editor, patch
  # pipeline and terminal round-trip on the way into this file. Nix has no
  # \u escape, so JSON supplies one.
  glyph = cp: builtins.fromJSON ''"\u${cp}"'';
  slantIn = glyph "e0ba";
  slantOut = glyph "e0bc";

  # A slanted pill: bar ink → accent → bar ink.
  pill = colour: body:
    "${fg colour}${bg p.sumiInk0}${slantIn}"
    + "${fg p.sumiInk0}${bg colour}${bold}${body}${nobold}"
    + "${fg colour}${bg p.sumiInk0}${slantOut}";

  # The session pill is tmux's mode cap, borrowing Neovim's grammar from
  # lua/user/visual-enhancements.lua: one short label, one pigment, and *only*
  # that cap changes colour, so entering copy mode reads as one dot of colour
  # moving rather than the whole bar repainting.
  modeCap =
    "#{?client_prefix,"
    + pill p.carpYellow " CMD #S "
    + ",#{?pane_in_mode,"
    + pill p.oniViolet " VIS #S "
    + ","
    + pill p.crystalBlue " NOR #S "
    + "}}";

  # Window numbers stay in the terminal's own face.
  #
  # Devanagari numerals were tried here — waybar wears 123 and the motif ought
  # to carry down. Measured at kitty's 19px rendering size, Maple Mono NF's '0'
  # inks 11x14 px; the best-matching Devanagari '0' available (Annapurna SIL
  # Bold) inks 11x12, Noto Sans Devanagari 10x11, FreeSerif 10x8. Devanagari
  # digits are drawn to a shorter body than Latin cap-height by design, and no
  # face closes that gap. They land on the grid correctly — every numeral gets
  # exactly one cell — but they read a size small next to the window names
  # beside them, and kitty has no per-fallback scale knob (`modify_font` is
  # global, `symbol_map` takes only a family).
  #
  # So the grid keeps one script and stays optically uniform. The Devanagari
  # lives on the GUI surfaces (waybar, hyprlock, notifications, plymouth),
  # where Pango shapes proportional text and there is no Latin cell to be
  # measured against.
  numIndex = "#{window_index}";

  # Per-window state glyphs (nf-md, matching waybar's icon rule).
  winFlags =
    "#{?window_zoomed_flag, 󰊓,}"
    + "#{?pane_synchronized, 󰓦,}"
    + "#{?window_bell_flag, 󰂚,}";

  # Bikram Sambat segment, ritu-tinted exactly like waybar's `custom/patro`.
  # `patro` itself is one `date` plus one awk pass, but the status line is
  # re-expanded on a timer, so the result is cached for an hour — the segment
  # only ever changes at midnight. tmux runs `#()` off the main loop, so even
  # a cache miss never blocks a redraw.
  #
  # `patro term` is the monospace-safe form ("Saun 14"): Nepali month name,
  # Latin digits, per the script rule at the top of docs/THEME.md.
  patroSegment = pkgs.writeShellScript "tmux-patro-segment" ''
    cache="''${XDG_RUNTIME_DIR:-/tmp}/tmux-patro-segment"
    if [ ! -s "$cache" ] || [ -n "$(find "$cache" -mmin +60 2>/dev/null)" ]; then
      if command -v patro >/dev/null 2>&1; then
        case "$(patro season)" in
          basanta) tint='${p.sakuraPink}' ;;
          grishma) tint='${p.springGreen}' ;;
          barsha)  tint='${p.springBlue}' ;;
          sharad)  tint='${p.surimiOrange}' ;;
          hemanta) tint='${p.springViolet1}' ;;
          *)       tint='${p.lightBlue}' ;;
        esac
        printf '#[fg=%s]%s' "$tint" "$(patro term)" >"$cache"
      else
        : >"$cache"
      fi
    fi
    cat "$cache"
  '';

  # Hairline separator — U+258F, the same glyph ibl draws for indent guides.
  rule = "${fg p.sumiInk6}▏";

  # Two collapse points. Kitty on this machine swings between 82 columns
  # (tiled) and 169 (maximised) many times a day, and a bar sized for the wide
  # case silently truncates its own clock at the narrow one. Pure format
  # arithmetic — evaluated in tmux, no shell, no cost.
  #
  # The `e|` prefix matters: bare `#{>=:a,b}` compares as *strings*, so
  # "82" >= "110" is true and the bar never collapses. Only `#{e|>=:a,b}`
  # compares numerically.
  atLeast = cols: wide: narrow:
    "#{?#{e|>=:#{client_width},${toString cols}},${wide},${narrow}}";

  # ≥150: cwd and the Bikram Sambat date ride along. Below that the right
  # island is clock and cap only. The threshold is deliberately generous —
  # with `status-justify absolute-centre` the window list is centred against
  # the *full* bar, so a right island sized to the leftover space still
  # collides with it and gets trimmed from the left.
  statusRight =
    atLeast 150
    ("${fg p.springViolet1}󰉋 #{b:pane_current_path} ${rule} #(${patroSegment}) ${rule}")
    ""
    + "${fg p.springBlue} 󰃰 %H:%M "
    + pill p.crystalBlue " 󰋯 ";

  # ≥110: inactive windows carry their names. Below that the bar compresses to
  # a row of numerals with one named island — the active window.
  windowFormat =
    fg p.fujiGray
    + atLeast 110 "  ${numIndex} #W${winFlags}  " " ${numIndex}${winFlags} ";
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

        # ── Pane/window size desync guard (see reclampPanes above) ───
        # A restored layout can be larger than the window holding it, which
        # pushes the cursor and the last few lines below the visible area.
        # Repair after every resurrect restore, on every client attach (covers
        # attaching from a terminal with different font metrics), and on
        # demand via prefix + R.
        set -g @resurrect-hook-post-restore-all '${reclampPanes}'
        set-hook -g client-attached 'run-shell -b ${reclampPanes}'
        bind R run-shell -b '${reclampPanes}' \; display-message "panes re-clamped"

        # ── True Color Support ───────────────────────────────────────
        set -g default-terminal "tmux-256color"
        set -ag terminal-overrides ",xterm-256color:RGB"

        # ╭──────────────────────────────────────────────────────────╮
        # │        Kanagawa Wave — Himal — hand-rolled powerline        │
        # │        colours from lib/palette.nix (docs/THEME.md)       │
        # ╰──────────────────────────────────────────────────────────╯
        # Three islands, same layout grammar as waybar: session cap on the
        # left, windows dead centre, ambient readouts on the right.
        set -g status-position top
        set -g status-justify absolute-centre
        set -g status-style "bg=${p.sumiInk0},fg=${p.fujiWhite}"
        set -g status-left-length 32
        set -g status-right-length 64

        # Idle cost is the whole design constraint (docs/THEME.md, performance
        # rules). Everything on this bar is a tmux format except one cached
        # `#()`, so a refresh is a handful of string compares. 30s keeps a
        # HH:MM clock honest at a quarter of tmux-sensible's 5s default.
        set -g status-interval 30

        # Bells are rare and worth a redraw; activity is not — monitor-activity
        # repaints the bar every time any background window writes a byte.
        set -g monitor-bell on
        set -g monitor-activity off

        # session pill — doubles as the mode cap (NOR / CMD / VIS)
        set -g status-left "${modeCap}"

        # windows — inactive ink, active waveBlue island, Devanagari numerals
        set -g window-status-format "${windowFormat}"
        set -g window-status-current-format "${fg p.waveBlue2}${bg p.sumiInk0}${slantIn}${bg p.waveBlue2}${fg p.crystalBlue}${bold} ${numIndex} ${fg p.fujiWhite}#W${winFlags} ${nobold}${fg p.waveBlue2}${bg p.sumiInk0}${slantOut}"
        set -g window-status-separator ""
        set -g window-status-bell-style "fg=${p.carpYellow},bg=${p.sumiInk0}"

        # right: cwd · Bikram Sambat · clock · Himal cap (first two drop under 150 cols)
        set -g status-right "${statusRight}"

        # ── Pane Borders ─────────────────────────────────────────────
        set -g pane-border-lines heavy
        set -g pane-border-indicators both
        set -g pane-border-style "fg=${p.sumiInk4}"
        set -g pane-active-border-style "fg=${p.crystalBlue}"
        set -g display-panes-colour "${p.sumiInk6}"
        set -g display-panes-active-colour "${p.crystalBlue}"

        # ── Message / Copy-mode Styling ──────────────────────────────
        set -g message-style "fg=${p.fujiWhite},bg=${p.waveBlue1}"
        set -g message-command-style "fg=${p.fujiWhite},bg=${p.waveBlue1}"
        set -g mode-style "fg=${p.fujiWhite},bg=${p.waveBlue2}"
        set -g clock-mode-colour "${p.crystalBlue}"

        # search hits wear the system's "attention" pigment (docs/THEME.md)
        set -g copy-mode-match-style "fg=${p.sumiInk0},bg=${p.carpYellow}"
        set -g copy-mode-current-match-style "fg=${p.sumiInk0},bg=${p.surimiOrange}"
        set -g copy-mode-mark-style "fg=${p.sumiInk0},bg=${p.sakuraPink}"

        # ── Menus & Popups ───────────────────────────────────────────
        # rounded borders echo the shell's 12px popup radius
        set -g menu-style "fg=${p.fujiWhite},bg=${p.sumiInk2}"
        set -g menu-selected-style "fg=${p.sumiInk0},bg=${p.crystalBlue}"
        set -g menu-border-style "fg=${p.sumiInk6}"
        set -g menu-border-lines rounded
        set -g popup-style "fg=${p.fujiWhite},bg=${p.sumiInk2}"
        set -g popup-border-style "fg=${p.sumiInk6}"
        set -g popup-border-lines rounded

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
