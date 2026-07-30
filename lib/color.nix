# Colour helpers for the Himal palette (lib/palette.nix).
#
# lib/palette.nix stays pure data ("#RRGGBB" strings only) so scripts/theme-lint.sh
# can scrape it. Surfaces that need a different encoding — hyprland's rgb()/rgba(),
# GTK CSS rgba() with a float alpha, fastfetch's truecolor SGR escapes, fuzzel's
# bare RRGGBBAA — convert here instead of hand-inlining a second copy of the hex.
#
# Wired into every module as the `colors` specialArg (see flake.nix):
#   { palette, colors, ... }: colors.hypr palette.crystalBlue "ee"
{ lib }:

let
  hexDigits = {
    "0" = 0; "1" = 1; "2" = 2; "3" = 3; "4" = 4; "5" = 5; "6" = 6; "7" = 7;
    "8" = 8; "9" = 9; "a" = 10; "b" = 11; "c" = 12; "d" = 13; "e" = 14; "f" = 15;
  };

  hexToInt = s:
    lib.foldl' (acc: c: acc * 16 + hexDigits.${c}) 0
      (lib.stringToCharacters (lib.toLower s));
in
rec {
  # "#7E9CD8" -> "7E9CD8"   (already-bare input passes through unchanged)
  bare = c: lib.removePrefix "#" c;

  # "#7E9CD8" -> { r = 126; g = 156; b = 216; }
  rgbParts = c:
    let h = bare c; in {
      r = hexToInt (builtins.substring 0 2 h);
      g = hexToInt (builtins.substring 2 2 h);
      b = hexToInt (builtins.substring 4 2 h);
    };

  # hyprland / hyprlock colour literals.
  #   hypr  "#1F1F28"        -> "rgb(1F1F28)"
  #   hyprA "#7E9CD8" "ee"   -> "rgba(7E9CD8ee)"
  hypr = c: "rgb(${bare c})";
  hyprA = c: alphaHex: "rgba(${bare c}${alphaHex})";

  # GTK / web CSS with an alpha channel:
  #   css "#1F1F28" "0.92" -> "rgba(31, 31, 40, 0.92)"
  # Alpha is a STRING on purpose — Nix renders the float 0.92 as "0.920000",
  # which is valid CSS but noise in a generated stylesheet.
  css = c: a:
    let p = rgbParts c; in
    "rgba(${toString p.r}, ${toString p.g}, ${toString p.b}, ${a})";

  # fuzzel wants bare hex WITH an alpha byte: "1f1f28e6"
  fuzzel = c: alphaHex: lib.toLower "${bare c}${alphaHex}";

  # plymouth's script language takes normalized channel floats:
  #   norm "#16161D" -> "0.086275, 0.086275, 0.113725"
  norm = c:
    let p = rgbParts c; in
    "${toString (p.r / 255.0)}, ${toString (p.g / 255.0)}, ${toString (p.b / 255.0)}";

  # truecolor SGR parameters (fastfetch keyColor, raw escapes):
  #   ansiFg "#7E9CD8" -> "38;2;126;156;216"
  ansiFg = c: let p = rgbParts c; in "38;2;${toString p.r};${toString p.g};${toString p.b}";
  ansiBg = c: let p = rgbParts c; in "48;2;${toString p.r};${toString p.g};${toString p.b}";
}
