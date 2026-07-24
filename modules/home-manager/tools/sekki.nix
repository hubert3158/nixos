# 七十二候 — the `sekki` CLI.
#
# Compiles lib/sekki.nix (72 microseasons) into a single dependency-light
# binary that every surface in the Ink & Wave system can ask "what season is it
# right now?". One source of truth, same contract as lib/palette.nix.
#
#   sekki                 大暑 · 桐始結花 — paulownia trees produce seeds
#   sekki ko              桐始結花
#   sekki kanji           夏
#   sekki season          summer
#   sekki tooltip         multi-line pango block
#   sekki waybar          {"text":…,"tooltip":…,"class":"summer"}
#   sekki json            every field, for programmatic consumers (neovim)
#   sekki notify          fire a desktop notification with the current kō
#
# Cost: one `date` + one `awk` over 72 lines. Nothing polls, nothing caches,
# nothing talks to the network. Waybar re-runs it hourly; neovim asks once,
# asynchronously, after the UI has already painted.
{ config, lib, pkgs, ... }:

let
  cfg = config.modules.tools.sekki;

  seasons = import ../../../lib/sekki.nix;

  # season → the kanji that names it (春夏秋冬)
  seasonKanji = {
    spring = "春";
    summer = "夏";
    autumn = "秋";
    winter = "冬";
  };

  # The table is stored in Gregorian order (Jan → Dec) so the CLI can pick a row
  # with one numeric comparison, but the traditional 候 numbering starts at
  # 立春 (Feb 4). Precompute the real ordinal here rather than making the shell
  # do modular arithmetic: 桐始結花 is 候 34, not 候 40.
  count = builtins.length seasons;
  risshun = builtins.length (builtins.filter (e: e.start < "0204") seasons);

  # "0723|桐始結花|kiri hajimete…|paulownia…|大暑|taisho|greater heat|summer|夏|34"
  table = lib.concatStringsSep "\n" (lib.imap0
    (i: e: lib.concatStringsSep "|" [
      e.start
      e.ko
      e.romaji
      e.en
      e.sekki
      e.sekkiRomaji
      e.sekkiEn
      e.season
      seasonKanji.${e.season}
      (toString (lib.mod (i - risshun + count) count + 1))
    ])
    seasons);

  sekkiBin = pkgs.writeShellApplication {
    name = "sekki";
    runtimeInputs = [ pkgs.coreutils pkgs.gawk pkgs.jq ];
    text = ''
      table="$(cat <<'SEKKI_TABLE'
      ${table}
      SEKKI_TABLE
      )"

      total="$(printf '%s\n' "$table" | wc -l | tr -d ' ')"
      today="$(date +%m%d)"

      # last row whose start is <= today; wraps to the final row in early
      # January (雪下出麦 runs Dec 31 → Jan 4, across the year boundary)
      sel="$(printf '%s\n' "$table" | awk -F'|' -v t="$today" '
        { rows[NR] = $0 }
        $1 + 0 <= t + 0 { hit = NR }
        END { print rows[(hit ? hit : NR)] }
      ')"

      IFS='|' read -r start ko romaji en sekki sekkiRomaji sekkiEn season kanji idx <<<"$sel"

      line="$sekki · $ko — $en"
      tooltip="<b>$ko</b>  $romaji
      $en

      $sekki $sekkiRomaji · $sekkiEn
      候 $idx / $total  ·  since ''${start:0:2}/''${start:2:2}"

      case "''${1:-line}" in
        line)     printf '%s\n' "$line" ;;
        ko)       printf '%s\n' "$ko" ;;
        romaji)   printf '%s\n' "$romaji" ;;
        en)       printf '%s\n' "$en" ;;
        sekki)    printf '%s\n' "$sekki" ;;
        season)   printf '%s\n' "$season" ;;
        kanji)    printf '%s\n' "$kanji" ;;
        index)    printf '%s/%s\n' "$idx" "$total" ;;
        tooltip)  printf '%s\n' "$tooltip" ;;
        waybar)
          jq -cn --arg text "$ko" --arg tooltip "$tooltip" --arg class "$season" \
            '{text: $text, tooltip: $tooltip, class: $class, alt: $class}'
          ;;
        json)
          jq -n \
            --arg ko "$ko" --arg romaji "$romaji" --arg en "$en" \
            --arg sekki "$sekki" --arg sekkiRomaji "$sekkiRomaji" \
            --arg sekkiEn "$sekkiEn" --arg season "$season" --arg kanji "$kanji" \
            --arg start "$start" --arg line "$line" \
            --argjson index "$idx" --argjson total "$total" \
            '{ko: $ko, romaji: $romaji, en: $en, sekki: $sekki,
              sekkiRomaji: $sekkiRomaji, sekkiEn: $sekkiEn, season: $season,
              kanji: $kanji, start: $start, index: $index, total: $total, line: $line}'
          ;;
        notify)
          if command -v notify-send >/dev/null 2>&1; then
            notify-send -a sekki "$kanji  $ko" "$romaji
      $en

      $sekki $sekkiRomaji · $sekkiEn — 候 $idx / $total"
          else
            printf '%s\n' "$line"
          fi
          ;;
        *)
          printf 'sekki: unknown mode %s\n' "$1" >&2
          printf 'usage: sekki [line|ko|romaji|en|sekki|season|kanji|index|tooltip|waybar|json|notify]\n' >&2
          exit 2
          ;;
      esac
    '';
  };
in
{
  options.modules.tools.sekki = {
    enable = lib.mkEnableOption "sekki — 七十二候 microseason CLI";

    # Exposed so other modules (and `nix build`) can reach the binary without
    # re-deriving it: e.g. fastfetch calls "${cfg.package}/bin/sekki".
    package = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = sekkiBin;
      description = "The generated sekki CLI";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ sekkiBin ];
  };
}
