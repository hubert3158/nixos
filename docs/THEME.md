# 「墨と波」 Ink & Wave — Design System

One visual identity across the whole machine: **Kanagawa (wave)** — the palette of
Hokusai's *Great Wave off Kanagawa*. Deep sumi-ink backgrounds, washed paper
foregrounds, and sparing mineral-pigment accents. Neovim and Helix already spoke
this language; the desktop now speaks it too.

Machine-readable twin: `lib/palette.nix`, wired into every NixOS and
home-manager module as the `palette` specialArg. **No module inlines hex** —
every themed `.nix` file takes `palette` and interpolates from it.

`lib/color.nix` (the `colors` specialArg) re-encodes those hexes for surfaces
that don't take `#RRGGBB`:

| Helper | Output | Used by |
|--------|--------|---------|
| `colors.hypr c` | `rgb(1F1F28)` | hyprlock |
| `colors.hyprA c "ee"` | `rgba(7E9CD8ee)` | hyprland / hyprlock |
| `colors.css c "0.92"` | `rgba(126, 156, 216, 0.92)` | wlogout, swayosd, GTK |
| `colors.fuzzel c "e6"` | `1f1f28e6` | fuzzel |
| `colors.ansiFg c` | `38;2;126;156;216` | fastfetch |
| `colors.norm c` | `0.494118, 0.611765, 0.847059` | plymouth script |

A third data file, `lib/sekki.nix`, holds the system's *living* clock — the 72
Japanese microseasons. See **七十二候** below.

`scripts/theme-lint.sh` enforces all of it: it scans every tracked `.css`,
`.conf`, `.nix` and `.lua` file (141 today) for `#RRGGBB`, `##RRGGBB`,
`rgb(...)` and `rgba(...)` literals and fails on anything not in
`lib/palette.nix`. Issue references like `rust-lang/rust#141402` are skipped;
add `# theme-lint: allow` to a line for a deliberate exception.

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
| GTK app UI      | Noto Sans 11 (`modules/home-manager/default.nix`) |
| CJK             | Noto Sans CJK JP (waybar 一二三 workspace numerals, 「」quotes) |
| Icons           | Nerd Font glyphs — waybar uses nf-md (`󰀀`-series) only |

CJK numerals are a recurring motif, not a one-off: waybar workspaces (一二三),
the Neovim statusline mode cap (常挿視行塊選換命端), markdown heading icons, and
the 「墨と波」 boot mark all use them.

JetBrainsMono Nerd Font stays installed as fallback and for anything that
renders wider glyph coverage. Maple Mono NF has **no CJK block** — kitty pins
the kana/kanji ranges to Noto Sans CJK JP via `symbol_map` (see
`terminals/kitty.nix`) so the fallback is deterministic rather than
per-glyph-whatever-fontconfig-picks.

## 七十二候 — the living clock

The Japanese almanac splits the year into 24 節気 (*sekki*, solar terms) and
each of those into three 候 (*kō*) of about five days. Every kō carries a name
for what the world is doing right now — 東風解凍 "east wind melts the ice",
腐草為蛍 "rotten grass becomes fireflies", 鶏始乳 "hens start laying eggs".

`lib/sekki.nix` is that table (pure data, same contract as `lib/palette.nix`).
`modules/home-manager/tools/sekki.nix` compiles it into one small CLI:

| Command | Output |
|---------|--------|
| `sekki` | `大暑 · 桐始結花 — paulownia trees produce seeds` |
| `sekki ko` / `kanji` / `season` | `桐始結花` / `夏` / `summer` |
| `sekki index` | `34/72` (numbered from 立春, as tradition does) |
| `sekki waybar` | `{"text":…,"tooltip":…,"class":"summer"}` |
| `sekki json` | every field — the machine-readable form Neovim reads |
| `sekki notify` | fires a desktop notification |

Consumers:

| Surface | How it shows up |
|---------|-----------------|
| Waybar | `custom/sekki` in the centre island, tinted by season (sakuraPink → springGreen → surimiOrange → springBlue); click for the full name |
| Neovim | `lualine_y`, fetched **asynchronously** by `lua/user/sekki.lua`; `:Sekki` prints the long form |
| fastfetch | a `kō` row inside the box |
| Hyprland | `SUPER+K` |

Cost: one `date` and one `awk` pass over 72 lines. Waybar polls hourly, Neovim
asks once off the main loop and again every four hours, nothing touches the
network. The point is that roughly every five days the machine quietly changes
its mind about what season it is, and says so in four places at once.

## Shape language

- Corner radius: **14px** shell islands (waybar), 12px popups (fuzzel, swaync, tooltips), 9px individual bar pills, 10px windows (hyprland `rounding`)
- Shell surfaces are **frosted glass**: `rgba(sumiInk1, ~0.9)` + a 7%-tall lit
  edge along the top + hyprland layer blur
- Borders: 1px `rgba(sumiInk6, ~0.5)` on glass; gradient only on the focused window
- Motion: material-expressive beziers (see `dotfiles/hypr/hyprland.conf`), 200–400 ms

### Border language

Which gradient a window wears tells you what kind of window it is:

| State | Border |
|-------|--------|
| focused, tiled | crystalBlue → oniViolet → springBlue, 45° |
| focused, floating | oniViolet → springBlue |
| maximized (fullscreen 1) | peachRed → waveRed |
| grouped (tabs) | crystalBlue → oniViolet, groupbar tabs in the same sweep |
| group locked | carpYellow → surimiOrange |
| unfocused | none — inactive borders are fully transparent |

On focus the gradient angle sweeps once (`animation = borderangle, …, once`).
It is deliberately **not** `loop`: a looping borderangle repaints the border
every frame for as long as the window is focused, which on the Vega 7 iGPU is a
permanent tax for an effect nobody is looking at.

### Performance rules

The look is expensive-looking, not expensive. The constraints that keep it that
way, in one place:

- **No idle animations anywhere.** Waybar transitions fire on hover and state
  change only; hyprland's borderangle runs `once`; terminal cursors don't blink.
  Anything that repaints at 60 fps while you aren't looking at it is cut.
- **`xray 1` on blurred shell layers** (waybar, fuzzel, swayosd). The blur then
  samples the wallpaper only instead of the live window stack, so scrolling a
  terminal doesn't force the bar to re-blur — cheaper *and* calmer.
- **Blur stays at size 6 / 2 passes**; 3 passes at size 8 dropped frames.
- **`special = false`** in the blur block — blurring the scratchpad backdrop
  caused fullscreen jitter.
- **No screen shader.** `vibrance.frag` is a full-screen per-pixel pass every
  frame; it stays commented out in `hyprland.conf`.
- **Neovim's seasonal segment is async.** No subprocess ever runs on the startup
  path for a decoration.

### 禅 zen mode

`SUPER+Z` (`dotfiles/hypr/scripts/zen.sh`) toggles between "workstation" and
"reading room": the bar folds away (waybar `SIGUSR1`), gaps open into wide paper
margins, the border thins to a hairline. It writes hyprctl keywords both ways
rather than reloading, so it is instant and costs nothing while idle. **The
"off" values in that script must match the `general`/`decoration` blocks in
`hyprland.conf`** — hyprctl has no "unset".

## Where each surface is themed

| Surface | File |
|---------|------|
| Hyprland | `dotfiles/hypr/hyprland.conf` (live-sourced), `dotfiles/hypr/scripts/` |
| Waybar | `home-manager-config-files/waybar/` (live symlink) |
| 七十二候 clock | `lib/sekki.nix` + `modules/home-manager/tools/sekki.nix` |
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
| SDDM | `modules/nixos/desktop/sddm.nix` (astronaut / japanese_aesthetic, chrome recoloured via `themeConfig`) |
| Boot splash | `packages/plymouth-ink-wave/` (custom script theme), enabled in `modules/nixos/boot.nix` |

### Neovim: who draws what

Two plugins can draw the same chrome; the split is deliberate.

| Surface | Owner | Notes |
|---------|-------|-------|
| Indent guides (every level) | `ibl` | flat `sumiInk4`, `▏`, static |
| Current scope | `mini.indentscope` | `crystalBlue`, animated; `ibl`'s own scope is **off** |
| Colour column | `smartcolumn.nvim` | not set statically in `options.lua` |
| Markdown colours | `nvim/init.lua` | shape lives in `lua/user/render-markdown.lua` |
| Statusline | `lua/user/visual-enhancements.lua` | hand-rolled kanagawa theme, **not** lualine's bundled one |

The statusline theme is written out longhand (palette hexes duplicated in the
file, which theme-lint checks) rather than read from the kanagawa plugin's
internals, so it can't break on a plugin bump. Only the mode cap changes colour
between modes — crystalBlue 常 / springGreen 挿 / oniViolet 視 / carpYellow 命 /
peachRed 換 / waveAqua 端 — so a mode change reads as one dot of colour moving,
not the whole bar repainting.

Markdown headings use a descending ink ramp — `waveBlue1 → sumiInk5 →
sumiInk4 → sumiInk2 → none`. The plugin's defaults link heading backgrounds to
the `Diff*` groups, which under kanagawa renders a document as a merge
conflict; the overrides in `init.lua` replace that.
