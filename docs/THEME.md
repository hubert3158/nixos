# 「墨と波」 Ink & Wave — Design System

One visual identity across the whole machine: **Kanagawa (wave)** — the palette of
Hokusai's *Great Wave off Kanagawa*. Deep sumi-ink backgrounds, washed paper
foregrounds, and sparing mineral-pigment accents. Neovim and Helix already spoke
this language; the desktop now speaks it too.

Machine-readable twin: `lib/palette.nix` (wired into every module as the
`palette` specialArg — use it for all new .nix theming instead of inlining hex).
`scripts/theme-lint.sh` checks the live-symlinked CSS surfaces against it.

## Palette (Kanagawa Wave)

### Ink layers (backgrounds, darkest → lightest)

| Name     | Hex       | Use |
|----------|-----------|-----|
| sumiInk0 | `#16161D` | deepest ink — shadows, bar islands, terminal bg tint |
| sumiInk1 | `#181820` | panel backgrounds |
| sumiInk2 | `#1A1A22` | notification / popup backgrounds |
| sumiInk3 | `#1F1F28` | THE background (editor, terminal) |
| sumiInk4 | `#2A2A37` | raised surfaces, borders-on-dark |
| sumiInk5 | `#363646` | hover surfaces |
| sumiInk6 | `#54546D` | muted borders, inactive elements |

### Paper (foregrounds)

| Name      | Hex       | Use |
|-----------|-----------|-----|
| fujiWhite | `#DCD7BA` | primary text |
| oldWhite  | `#C8C093` | secondary text |
| fujiGray  | `#727169` | muted / disabled text |

### Water (selection & depth)

| Name      | Hex       | Use |
|-----------|-----------|-----|
| waveBlue1 | `#223249` | selections, active-item backgrounds |
| waveBlue2 | `#2D4F67` | stronger selection, scrollbars |

### Pigments (accents — use sparingly)

| Name          | Hex       | Role |
|---------------|-----------|------|
| crystalBlue   | `#7E9CD8` | **primary accent** — focus, active workspace, links |
| springBlue    | `#7FB4CA` | secondary accent — info, clock |
| oniViolet     | `#957FB8` | gradient partner to crystalBlue |
| carpYellow    | `#E6C384` | gold highlight — matches, attention |
| springGreen   | `#98BB6C` | success, battery |
| waveAqua2     | `#7AA89F` | aqua — cpu, media, cava |
| sakuraPink    | `#D27E99` | pink accent — memory, hearts |
| surimiOrange  | `#FFA066` | orange — temperature, warnings-soft |
| roninYellow   | `#FF9E3B` | warning |
| waveRed       | `#E46876` | soft error, urgent |
| peachRed      | `#FF5D62` | error, critical, power |
| samuraiRed    | `#E82424` | maximum alarm (blink states) |
| springViolet1 | `#938AA9` | violet-gray — subtle chrome |
| springViolet2 | `#9CABCA` | violet-blue — htop accents |
| dragonBlue    | `#658594` | dimmed blue — idle states |
| lightBlue     | `#A3D4D5` | pale aqua — cava gradient top |

### Winter washes (diff/status backgrounds)

| Name        | Hex       | Use |
|-------------|-----------|-----|
| winterRed   | `#43242B` | diff removed (delta), htop critical bars |
| winterGreen | `#2B3328` | diff added (delta) |

## Component accent map

- **Focus/active** (hyprland border, waybar active ws, fuzzel border, lock ring):
  animated gradient `crystalBlue → oniViolet → springBlue`
- **Attention/matches** (fuzzel match, telescope match, starship git): carpYellow
- **Danger** (power button, critical temp/battery, failed units): peachRed
- **Media/audio** (mpris, cava, pulseaudio): waveAqua2

## Typography

| Role | Font |
|------|------|
| Terminal / code | **Maple Mono NF** (rounded, ligatures, cursive italics) |
| Bar / shell UI  | Maple Mono NF, fallback JetBrainsMono Nerd Font |
| CJK             | Noto Sans CJK JP (waybar 一二三 workspace numerals, 「」quotes) |
| Icons           | Nerd Font glyphs — waybar uses nf-md (`󰀀`-series) only |

JetBrainsMono Nerd Font stays installed as fallback and for anything that
renders wider glyph coverage.

## Shape language

- Corner radius: **12px** shell surfaces (waybar islands, fuzzel, swaync), 10px windows (hyprland `rounding`)
- Shell surfaces are **frosted glass**: `rgba(sumiInk1, ~0.85)` + hyprland layer blur
- Borders: 1px `rgba(sumiInk6, ~0.5)` on glass; gradient only on the focused window
- Motion: material-expressive beziers (see `dotfiles/hypr/hyprland.conf`), 200–400 ms

## Where each surface is themed

| Surface | File |
|---------|------|
| Hyprland | `dotfiles/hypr/hyprland.conf` (live-sourced) |
| Waybar | `home-manager-config-files/waybar/` (live symlink) |
| SwayNC | `home-manager-config-files/swaync/` (live symlink) |
| Fuzzel | `modules/home-manager/desktop/fuzzel.nix` |
| Wlogout | `modules/home-manager/desktop/wlogout.nix` |
| Hyprlock | `modules/home-manager/desktop/hyprlock.nix` |
| Wallpapers (swww) | `modules/home-manager/desktop/swww.nix` + `images/walls/` |
| Kitty / Ghostty / Wezterm | `modules/home-manager/terminals/*.nix` |
| Starship | `modules/home-manager/shell/starship.nix` |
| fastfetch / cava / fzf / bat | `modules/home-manager/tools/*.nix` |
| Neovim | `nvim/init.lua` (kanagawa overrides — the original source of truth) |
| Helix | `modules/home-manager/programs/helix.nix` |
| SDDM | `modules/nixos/desktop/sddm.nix` (astronaut / japanese_aesthetic) |
| Boot splash | `modules/nixos/boot.nix` (plymouth) |
