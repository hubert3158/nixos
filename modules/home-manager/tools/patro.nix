# patro — the Bikram Sambat calendar CLI.
#
# Compiles lib/patro.nix (the Bikram Sambat table) into a single
# dependency-light binary that every surface in the Himal system can ask "what
# is today's date, really?". One source of truth, same contract as
# lib/palette.nix.
#
#   patro                 Saun 14, 2083 · barsha — monsoon   (terminal-safe)
#   patro date            the same date in Devanagari, for GUI surfaces
#   patro roman           Saun 14, 2083
#   patro term            Saun 14                              (statusline form)
#   patro ritu            the season in Devanagari, for GUI surfaces
#   patro season          barsha             (the CSS class waybar styles on)
#   patro en              monsoon
#   patro tooltip         multi-line pango block
#   patro waybar          {"text":…,"tooltip":…,"class":"barsha"}
#   patro json            every field, for programmatic consumers (neovim)
#   patro notify          fire a desktop notification with today's date
#
# The split between `line`/`roman`/`term` and `date`/`ritu`/`tooltip` is the
# script rule from docs/THEME.md, and it is not cosmetic. Devanagari is a
# complex script: pre-base vowel signs reorder and conjuncts fuse, which needs
# shaping a fixed terminal grid cannot do — a word comes out visibly mangled,
# one codepoint per cell. So every mode a *terminal* consumes (`line` feeds
# fastfetch, `term` feeds tmux and the Neovim statusline, `:Patro` prints
# `roman`) is romanised, and only the modes GUI surfaces consume — `date`,
# `ritu`, `tooltip`, `waybar`, `notify` — carry Devanagari, where Pango and Qt
# shape it correctly.
#
# Cost: one `date` + one `awk` over 126 lines. Nothing polls, nothing caches,
# nothing talks to the network. Waybar re-runs it hourly; neovim asks once,
# asynchronously, after the UI has already painted.
{ config, lib, pkgs, ... }:

let
  cfg = config.modules.tools.patro;

  patro = import ../../../lib/patro.nix;

  inherit (patro) epochAD;

  # "1975 31 31 32 32 31 30 30 29 30 29 30 30" — one row per BS year, already
  # in ascending order so the walk below is a single forward pass.
  calTable = lib.concatStringsSep "\n" (
    map
    (y: "${y} ${lib.concatMapStringsSep " " toString patro.yearMonthDays.${y}}")
    (builtins.sort (a: b: a < b) (builtins.attrNames patro.yearMonthDays))
  );

  # month index (1-12) → "np|romaji|en" for the ritu covering it
  ritu = lib.concatStringsSep "\n" (lib.concatMap
    (s: map (m: "${toString m}|${s.np}|${s.romaji}|${s.en}") s.months)
    patro.seasons);

  monthsNp = lib.concatStringsSep " " patro.months;
  monthsRoman = lib.concatStringsSep " " patro.monthsRoman;
  digits = lib.concatStringsSep " " patro.digits;

  patroBin = pkgs.writeShellApplication {
    name = "patro";
    runtimeInputs = [pkgs.coreutils pkgs.gawk pkgs.jq];
    text = ''
      cal="$(cat <<'PATRO_CAL'
      ${calTable}
      PATRO_CAL
      )"

      ritu="$(cat <<'PATRO_RITU'
      ${ritu}
      PATRO_RITU
      )"

      # Whole-day difference from the BS epoch. Both dates are parsed as UTC
      # midnight so the subtraction can never be knocked off by an hour by DST
      # or by the machine sitting outside Nepal's +05:45.
      epoch_day=$(( $(date -u -d '${toString epochAD.year}-${toString epochAD.month}-${toString epochAD.day}' +%s) / 86400 ))
      today_day=$(( $(date -u -d "$(date +%Y-%m-%d)" +%s) / 86400 ))
      elapsed=$(( today_day - epoch_day ))

      if [ "$elapsed" -lt 0 ]; then
        printf 'patro: today is before the table epoch (BS ${toString patro.minYear})\n' >&2
        exit 3
      fi

      # Walk years, then months. 126 rows worst case.
      read -r by bm bd <<<"$(printf '%s\n' "$cal" | awk -v left="$elapsed" '
        {
          total = 0
          for (i = 2; i <= 13; i++) total += $i
          if (left >= total) { left -= total; next }
          for (i = 2; i <= 13; i++) {
            if (left < $i) { print $1, i - 1, left + 1; found = 1; exit }
            left -= $i
          }
        }
        END { if (!found) print "" }
      ')"

      if [ -z "''${by:-}" ]; then
        printf 'patro: today is past the end of the table (BS ${toString patro.maxYear})\n' >&2
        exit 3
      fi

      # Devanagari numerals. Digits are single codepoints, so this is a plain
      # per-character swap with no shaping involved.
      np() {
        printf '%s' "$1" | awk '
          BEGIN { split("${digits}", D, " ") }
          {
            out = ""
            for (i = 1; i <= length($0); i++) {
              c = substr($0, i, 1)
              out = out (c ~ /^[0-9]$/ ? D[c + 1] : c)
            }
            print out
          }'
      }

      IFS=' ' read -r -a months_np <<<"${monthsNp}"
      IFS=' ' read -r -a months_ro <<<"${monthsRoman}"
      month_np="''${months_np[$((bm - 1))]}"
      month_ro="''${months_ro[$((bm - 1))]}"

      IFS='|' read -r _ ritu_np ritu_ro ritu_en <<<"$(printf '%s\n' "$ritu" | awk -F'|' -v m="$bm" '$1 == m { print; exit }')"

      day_np="$(np "$bd")"
      year_np="$(np "$by")"

      date_np="$month_np $day_np, $year_np"
      date_ro="$month_ro $bd, $by"
      # `term` is the monospace-safe form: Nepali month name, Latin digits.
      # Devanagari numerals sit on the grid correctly but ink ~2-4px shorter
      # than Maple Mono's digits at the same size (measured; see the note in
      # programs/tmux.nix), so a terminal keeps one script and stays uniform.
      date_term="$month_ro $bd"
      # Terminal-facing: fastfetch prints this inside its box.
      line="$date_ro · $ritu_ro — $ritu_en"

      tooltip="<b>$date_np</b>
      $date_ro

      $ritu_np $ritu_ro · $ritu_en
      विक्रम सम्वत् · $(date +'%A, %d %B %Y')"

      case "''${1:-line}" in
        line)     printf '%s\n' "$line" ;;
        date)     printf '%s\n' "$date_np" ;;
        roman)    printf '%s\n' "$date_ro" ;;
        term)     printf '%s\n' "$date_term" ;;
        ritu)     printf '%s\n' "$ritu_np" ;;
        season)   printf '%s\n' "$ritu_ro" ;;
        en)       printf '%s\n' "$ritu_en" ;;
        year)     printf '%s\n' "$by" ;;
        month)    printf '%s\n' "$bm" ;;
        day)      printf '%s\n' "$bd" ;;
        tooltip)  printf '%s\n' "$tooltip" ;;
        waybar)
          jq -cn --arg text "$date_np" --arg tooltip "$tooltip" --arg class "$ritu_ro" \
            '{text: $text, tooltip: $tooltip, class: $class, alt: $class}'
          ;;
        json)
          jq -n \
            --arg dateNp "$date_np" --arg dateRoman "$date_ro" --arg term "$date_term" \
            --arg ritu "$ritu_np" --arg season "$ritu_ro" --arg en "$ritu_en" \
            --arg monthNp "$month_np" --arg monthRoman "$month_ro" --arg line "$line" \
            --argjson year "$by" --argjson month "$bm" --argjson day "$bd" \
            '{dateNp: $dateNp, dateRoman: $dateRoman, term: $term, ritu: $ritu,
              season: $season, en: $en, monthNp: $monthNp, monthRoman: $monthRoman,
              year: $year, month: $month, day: $day, line: $line}'
          ;;
        notify)
          if command -v notify-send >/dev/null 2>&1; then
            notify-send -a patro "$ritu_np  $date_np" "$date_ro

      $ritu_np $ritu_ro · $ritu_en
      $(date +'%A, %d %B %Y')"
          else
            printf '%s\n' "$line"
          fi
          ;;
        *)
          printf 'patro: unknown mode %s\n' "$1" >&2
          printf 'usage: patro [line|date|roman|term|ritu|season|en|year|month|day|tooltip|waybar|json|notify]\n' >&2
          exit 2
          ;;
      esac
    '';
  };
in {
  options.modules.tools.patro = {
    enable = lib.mkEnableOption "patro — Bikram Sambat calendar CLI";

    # Exposed so other modules (and `nix build`) can reach the binary without
    # re-deriving it: e.g. fastfetch calls "${cfg.package}/bin/patro".
    package = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = patroBin;
      description = "The generated patro CLI";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [patroBin];
  };
}
