# ukhaan — the Nepali proverb CLI.
#
# Reads lib/ukhaan.tsv (260 उखान टुक्का: devanagari, roman, meaning) and prints
# one at random. Same contract as the other lib/ data files: the table is the
# source of truth, this module is only a reader.
#
#   ukhaan                Aafnai aangan ko bhaisi dekhdaina — he cannot see …
#   ukhaan roman          the romanised proverb alone
#   ukhaan meaning        the meaning alone
#   ukhaan np             the proverb in Devanagari, for GUI surfaces
#   ukhaan waybar         {"text":…,"tooltip":…}
#   ukhaan json           every field, for programmatic consumers
#   ukhaan notify         fire a desktop notification (Devanagari + roman)
#
# The split follows the script rule in docs/THEME.md: `line`, `roman` and
# `meaning` are what terminals consume, so they are romanised; only `np`,
# `waybar` and `notify` carry Devanagari, and those land on surfaces where
# Pango shapes the script properly.
#
# Cost: one awk pass over 260 lines, only when asked. Nothing polls it.
{ config, lib, pkgs, ... }:

let
  cfg = config.modules.tools.ukhaan;

  table = builtins.readFile ../../../lib/ukhaan.tsv;

  ukhaanBin = pkgs.writeShellApplication {
    name = "ukhaan";
    runtimeInputs = [pkgs.coreutils pkgs.gawk pkgs.jq];
    text = ''
      table="$(cat <<'UKHAAN_TSV'
      ${table}
      UKHAAN_TSV
      )"

      # One awk pass: collect, then pick by index.
      #
      # The seed is passed in rather than left to a bare `srand()`, which seeds
      # from the clock in *whole seconds* — two presses of SUPER+U inside the
      # same second would hand back the same proverb. $RANDOM plus the pid
      # differs on every invocation.
      row="$(printf '%s\n' "$table" | awk -F'\t' -v seed="$RANDOM$$" '
        /^#/ || NF < 3 { next }
        { rows[++n] = $0 }
        END { if (n) { srand(seed); print rows[int(rand() * n) + 1] } }
      ')"

      if [ -z "$row" ]; then
        printf 'ukhaan: no proverbs in the table\n' >&2
        exit 3
      fi

      IFS=$'\t' read -r np roman meaning <<<"$row"

      line="$roman — $meaning"

      case "''${1:-line}" in
        line)     printf '%s\n' "$line" ;;
        roman)    printf '%s\n' "$roman" ;;
        meaning)  printf '%s\n' "$meaning" ;;
        np)       printf '%s\n' "$np" ;;
        count)    printf '%s\n' "$(printf '%s\n' "$table" | grep -cv '^#')" ;;
        waybar)
          jq -cn --arg text "$np" --arg tooltip "$roman"$'\n'"$meaning" \
            '{text: $text, tooltip: $tooltip}'
          ;;
        json)
          jq -n --arg np "$np" --arg roman "$roman" --arg meaning "$meaning" \
            --arg line "$line" \
            '{np: $np, roman: $roman, meaning: $meaning, line: $line}'
          ;;
        notify)
          if command -v notify-send >/dev/null 2>&1; then
            notify-send -a ukhaan "$np" "$roman

      $meaning"
          else
            printf '%s\n' "$line"
          fi
          ;;
        *)
          printf 'ukhaan: unknown mode %s\n' "$1" >&2
          printf 'usage: ukhaan [line|roman|meaning|np|count|waybar|json|notify]\n' >&2
          exit 2
          ;;
      esac
    '';
  };
in {
  options.modules.tools.ukhaan = {
    enable = lib.mkEnableOption "ukhaan — Nepali proverb CLI";

    package = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = ukhaanBin;
      description = "The generated ukhaan CLI";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ukhaanBin];
  };
}
