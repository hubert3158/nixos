# awww (swww successor) — animated wallpaper daemon + `wallpaper` CLI
# Replaces hyprpaper: same static image support, plus animated transitions.
#
#   wallpaper           → restore last wallpaper (used by hyprland exec-once)
#   wallpaper next      → cycle to next wall with a random cinematic transition
#   wallpaper random    → jump to a random wall
#   wallpaper <file>    → set a specific image
#
# Walls live in images/walls/ (git-tracked, synced to both machines).
{ config, lib, pkgs, ... }:

let
  cfg = config.modules.desktop.swww;

  wallpaperBin = pkgs.writeShellApplication {
    name = "wallpaper";
    runtimeInputs = [ pkgs.awww pkgs.coreutils pkgs.findutils ];
    text = ''
      dir="${cfg.wallpaperDir}"
      state="''${XDG_CACHE_HOME:-$HOME/.cache}/current-wallpaper"

      mapfile -t walls < <(find -L "$dir" -type f \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.webp' \) | sort)
      [ "''${#walls[@]}" -gt 0 ] || { echo "no wallpapers in $dir" >&2; exit 1; }

      current=""
      [ -f "$state" ] && current="$(cat "$state")"

      case "''${1:-restore}" in
        restore)
          target="$current"
          [ -f "$target" ] || target="${cfg.defaultWallpaper}"
          ;;
        next)
          target="''${walls[0]}"
          for i in "''${!walls[@]}"; do
            if [ "''${walls[$i]}" = "$current" ]; then
              target="''${walls[$(( (i + 1) % ''${#walls[@]} ))]}"
              break
            fi
          done
          ;;
        random)
          target="$(printf '%s\n' "''${walls[@]}" | shuf -n1)"
          ;;
        *)
          target="$1"
          ;;
      esac

      # cinematic transition: grow from the cursor when possible
      pos="center"
      if command -v hyprctl >/dev/null 2>&1; then
        p="$(hyprctl cursorpos 2>/dev/null | tr -d ' ')" && [ -n "$p" ] && pos="$p"
      fi
      transitions=(grow wave outer center)
      t="''${transitions[$RANDOM % ''${#transitions[@]}]}"

      awww img "$target" \
        --transition-type "$t" \
        --transition-pos "$pos" \
        --transition-fps 144 \
        --transition-duration 1.2 \
        --transition-bezier .43,1.19,1,.4

      echo "$target" > "$state"
    '';
  };
in
{
  options.modules.desktop.swww = {
    enable = lib.mkEnableOption "awww wallpaper daemon with animated transitions";

    wallpaperDir = lib.mkOption {
      type = lib.types.str;
      default = "${config.home.homeDirectory}/nixos/images/walls";
      description = "Directory of wallpapers to cycle through";
    };

    defaultWallpaper = lib.mkOption {
      type = lib.types.str;
      default = "${config.home.homeDirectory}/nixos/images/walls/great-wave-ink.png";
      description = "Wallpaper used when no previous state exists";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.awww wallpaperBin ];

    systemd.user.services.awww-daemon = {
      Unit = {
        Description = "awww wallpaper daemon";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${pkgs.awww}/bin/awww-daemon";
        # restore the last wallpaper once the daemon socket is up
        # (short retry — the socket appears a beat after the process starts)
        ExecStartPost = "${pkgs.bash}/bin/bash -c 'for i in 1 2 3 4 5; do ${wallpaperBin}/bin/wallpaper restore && exit 0; sleep 1; done; exit 1'";
        Restart = "on-failure";
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
}
