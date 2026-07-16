# 「墨と波」 Ink & Wave — Kanagawa Wave palette
#
# Machine-readable source of truth. docs/THEME.md is the human-readable
# companion — keep the two in sync (scripts/theme-lint.sh checks the
# live-symlinked CSS surfaces against this file).
#
# Wired into every home-manager/NixOS module via specialArgs as `palette`:
#   { config, lib, pkgs, palette, ... }: { ... palette.crystalBlue ... }
# Migrate hand-inlined hexes here incrementally; new code must use it.
{
  # Ink layers (backgrounds, darkest → lightest)
  sumiInk0 = "#16161D"; # deepest ink — shadows, bar islands, terminal bg tint
  sumiInk1 = "#181820"; # panel backgrounds
  sumiInk2 = "#1A1A22"; # notification / popup backgrounds
  sumiInk3 = "#1F1F28"; # THE background (editor, terminal)
  sumiInk4 = "#2A2A37"; # raised surfaces, borders-on-dark
  sumiInk5 = "#363646"; # hover surfaces
  sumiInk6 = "#54546D"; # muted borders, inactive elements

  # Paper (foregrounds)
  fujiWhite = "#DCD7BA"; # primary text
  oldWhite = "#C8C093"; # secondary text
  fujiGray = "#727169"; # muted / disabled text

  # Water (selection & depth)
  waveBlue1 = "#223249"; # selections, active-item backgrounds
  waveBlue2 = "#2D4F67"; # stronger selection, scrollbars

  # Pigments (accents — use sparingly)
  crystalBlue = "#7E9CD8"; # primary accent — focus, active workspace, links
  springBlue = "#7FB4CA"; # secondary accent — info, clock
  oniViolet = "#957FB8"; # gradient partner to crystalBlue
  carpYellow = "#E6C384"; # gold highlight — matches, attention
  springGreen = "#98BB6C"; # success, battery
  waveAqua2 = "#7AA89F"; # aqua — cpu, media, cava
  sakuraPink = "#D27E99"; # pink accent — memory, hearts
  surimiOrange = "#FFA066"; # orange — temperature, warnings-soft
  roninYellow = "#FF9E3B"; # warning
  waveRed = "#E46876"; # soft error, urgent
  peachRed = "#FF5D62"; # error, critical, power
  samuraiRed = "#E82424"; # maximum alarm (blink states)
  springViolet1 = "#938AA9"; # violet-gray — subtle chrome
  springViolet2 = "#9CABCA"; # violet-blue — htop accents
  dragonBlue = "#658594"; # dimmed blue — idle states
  lightBlue = "#A3D4D5"; # pale aqua — cava gradient top

  # ANSI-normal variants (terminal color1-6 — dimmer than the pigments above)
  ansiRed = "#C34043";
  ansiGreen = "#76946A";
  ansiYellow = "#C0A36E";
  ansiCyan = "#6A9589";

  # Winter washes (diff/status backgrounds)
  winterRed = "#43242B"; # diff removed, htop critical bars
  winterGreen = "#2B3328"; # diff added
}
