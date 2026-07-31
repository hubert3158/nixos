# nietzsche — the Friedrich Nietzsche quote CLI.
#
# Reads lib/nietzsche.tsv (124 quotations: quote, source) and prints one at
# random. Same contract as ukhaan and the other lib/ data files: the table is
# the source of truth, this module is only a reader.
#
#   nietzsche             What does not kill me makes me stronger. — Twilight …
#   nietzsche quote       the quotation alone
#   nietzsche source      the work it comes from
#   nietzsche count       how many are in the table
#   nietzsche waybar      {"text":…,"tooltip":…}
#   nietzsche json        every field, for programmatic consumers
#   nietzsche notify      fire a desktop notification (SUPER+Y)
#
# Latin script throughout, so unlike ukhaan there is no terminal/GUI split:
# every mode prints the same text on every surface.
#
# Cost: one awk pass over 124 lines, only when asked. Nothing polls it.
{ config, lib, pkgs, ... }:

let
  cfg = config.modules.tools.nietzsche;

  table = builtins.readFile ../../../lib/nietzsche.tsv;

  nietzscheBin = pkgs.writeShellApplication {
    name = "nietzsche";
    runtimeInputs = [pkgs.coreutils pkgs.gawk pkgs.jq];
    text = ''
      table="$(cat <<'NIETZSCHE_TSV'
      ${table}
      NIETZSCHE_TSV
      )"

      # One awk pass: collect, then pick by index.
      #
      # The seed is passed in rather than left to a bare `srand()`, which seeds
      # from the clock in *whole seconds* — two presses of SUPER+Y inside the
      # same second would hand back the same quote. $RANDOM plus the pid
      # differs on every invocation.
      row="$(printf '%s\n' "$table" | awk -F'\t' -v seed="$RANDOM$$" '
        /^[[:space:]]*#/ || NF < 2 { next }
        { rows[++n] = $0 }
        END { if (n) { srand(seed); print rows[int(rand() * n) + 1] } }
      ')"

      if [ -z "$row" ]; then
        printf 'nietzsche: no quotes in the table\n' >&2
        exit 3
      fi

      IFS=$'\t' read -r quote source <<<"$row"

      line="$quote — $source"

      case "''${1:-line}" in
        line)     printf '%s\n' "$line" ;;
        quote)    printf '%s\n' "$quote" ;;
        source)   printf '%s\n' "$source" ;;
        count)    printf '%s\n' "$(printf '%s\n' "$table" | grep -cv '^[[:space:]]*#')" ;;
        waybar)
          jq -cn --arg text "$quote" --arg tooltip "$quote"$'\n\n'"— $source" \
            '{text: $text, tooltip: $tooltip}'
          ;;
        json)
          jq -n --arg quote "$quote" --arg source "$source" --arg line "$line" \
            '{quote: $quote, source: $source, line: $line}'
          ;;
        notify)
          if command -v notify-send >/dev/null 2>&1; then
            notify-send -a nietzsche "Friedrich Nietzsche" "$quote

      — $source"
          else
            printf '%s\n' "$line"
          fi
          ;;
        *)
          printf 'nietzsche: unknown mode %s\n' "$1" >&2
          printf 'usage: nietzsche [line|quote|source|count|waybar|json|notify]\n' >&2
          exit 2
          ;;
      esac
    '';
  };
in {
  options.modules.tools.nietzsche = {
    enable = lib.mkEnableOption "nietzsche — Friedrich Nietzsche quote CLI";

    package = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = nietzscheBin;
      description = "The generated nietzsche CLI";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [nietzscheBin];
  };
}
