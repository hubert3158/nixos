# Himal Himal — Design System

One visual identity across the whole machine. The palette is **Kanagawa
(wave)** — deep sumi-ink backgrounds, washed paper foregrounds, sparing
mineral-pigment accents. That name stays: it is upstream, shared with Neovim,
kitty and Helix, and renaming a colour scheme only breaks the ability to look
it up.

The *identity* on top of it is Himal — himal, the snow mountains. Deep ink
below, thin cold light above, and a script that belongs to the person using
the machine. Nepali is the system language wherever the system speaks.

**The script rule, which every surface below follows:** Nepali *language*
everywhere, Devanagari *script* only where text is shaped proportionally —
waybar, hyprlock, notifications, SDDM, the boot splash. Terminal grids
(tmux, the Neovim statusline, fastfetch) use romanised Nepali and Latin
digits. This is measured, not aesthetic: at kitty's 19px rendering size Maple
Mono NF's `0` inks 11×14 px, while Devanagari `0` inks 11×12 in the best
available face (Annapurna SIL Bold), 10×11 in Noto Sans Devanagari and 10×8 in
FreeSerif. Devanagari numerals are drawn to a shorter body than Latin
cap-height by design; they land on the grid correctly but read a size small
next to Latin, and kitty has no per-fallback scale knob (`modify_font` is
global, `symbol_map` takes only a family).

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

A third data file, `lib/patro.nix`, holds the system's calendar — Bikram
Sambat, the one Nepal actually runs on. See **Bikram Sambat** below.

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
| Devanagari      | Noto Sans Devanagari (waybar 123 workspace numerals, the date) |
| Icons           | Nerd Font glyphs — waybar uses nf-md (`󰀀`-series) only |

Devanagari numerals are the motif on the GUI surfaces: waybar workspaces
(123) and the Bikram Sambat date. The Neovim statusline mode cap and the tmux
session pill use three-letter Latin tags (`NOR INS VIS CMD …`) instead, per the
script rule above.

JetBrainsMono Nerd Font stays installed as fallback and for anything that
renders wider glyph coverage. Maple Mono NF has **no Devanagari block at all**
(verified against its cmap: 0 of 128 codepoints in U+0900-097F) — kitty pins
that range to Noto Sans Devanagari via `symbol_map` (see `terminals/kitty.nix`)
so a Nepali filename or README renders rather than turning into tofu. The
status chrome deliberately does not depend on that fallback.

## Bikram Sambat — the calendar

Nepal runs on Bikram Sambat, roughly 56–57 years ahead of Gregorian, with a new
year at Baisakh 1 in mid-April. BS month lengths are **not** formulaic: they
follow solar longitude, vary between 29 and 32 days, and differ year to year.
The only correct implementation is a published table, so `lib/patro.nix` *is*
that table — BS 1975–2100, extracted verbatim from the `nepali-datetime`
package (PyPI, MIT), which carries the standard panchanga data. Epoch: BS
1975-01-01 = AD 1918-04-13. **Do not hand-edit month lengths.**

`modules/home-manager/tools/patro.nix` compiles it into one small CLI:

| Command | Output |
|---------|--------|
| `patro` | `Saun 14, 2083 · barsha — monsoon` |
| `patro date` / `roman` / `term` | `Saun 14, 2083` / `Saun 14, 2083` / `Saun 14` |
| `patro ritu` / `season` / `en` | `barsha` / `barsha` / `monsoon` |
| `patro waybar` | `{"text":…,"tooltip":…,"class":"barsha"}` |
| `patro json` | every field — the machine-readable form Neovim reads |
| `patro notify` | fires a desktop notification |

`term` is the monospace-safe form: Nepali month name, Latin digits, per the
script rule at the top of this file.

The year is also divided into six **ritu**, two BS months each, and the ritu
drives an accent colour the way the old microseasons did:

| ritu | Months | Accent |
|-----|--------|--------|
| basanta basanta (spring) | Chait, Baisakh | sakuraPink |
| grishma grishma (summer) | Jestha, Asar | springGreen |
| barsha barsha (monsoon) | Saun, Bhadau | springBlue |
| sharad sharad (autumn) | Asoj, Kattik | surimiOrange |
| hemanta hemanta (pre-winter) | Mangsir, Pus | springViolet1 |
| shishir shishir (winter) | Magh, Fagun | lightBlue |

Consumers:

| Surface | How it shows up |
|---------|-----------------|
| Waybar | `custom/patro` in the centre island, full Devanagari, tinted by ritu; click for the tooltip |
| Neovim | `lualine_y`, fetched **asynchronously** by `lua/user/patro.lua`; `:Patro` prints the long form |
| tmux | right island, `patro term`, cached for an hour |
| fastfetch | a `patro` row inside the box |
| Hyprland | `SUPER+K` |

Cost: one `date` and one `awk` pass over 126 lines. Waybar polls hourly, tmux
reads an hourly cache, Neovim asks once off the main loop and again every four
hours, nothing touches the network.

Conversion is verified, not assumed: 479 dates spanning AD 1919–2043 — random
samples plus every month boundary and every Nepali New Year for BS 2075–2090 —
were checked against `nepali-datetime`, with zero mismatches.

## ukhaan — the proverbs

`lib/ukhaan.tsv` holds 260 Nepali proverbs (उखान टुक्का) as
`devanagari<TAB>roman<TAB>meaning`. Sourced from
[chapainaashish/nepali-ukhaan](https://github.com/chapainaashish/nepali-ukhaan)
(MIT, © 2023 Aashish Chapain), parsed from that repo's README table. 238 of the
260 carry an English gloss; the remaining 22 explain in romanised Nepali, which
is upstream's doing and left as-is.

TSV rather than `.nix` because two languages read it: the `ukhaan` CLI
(`modules/home-manager/tools/ukhaan.nix`) embeds it for awk, and the Neovim
dashboard reads it directly. A `.nix` list would need a second generated Lua
copy; splitting on a tab needs neither.

| Command | Output |
|---------|--------|
| `ukhaan` | `Andho lai ainaa ko khoji — …` (roman + meaning) |
| `ukhaan roman` / `meaning` | either column alone |
| `ukhaan np` | the proverb in Devanagari, for GUI surfaces |
| `ukhaan count` | how many are in the table |
| `ukhaan waybar` / `json` / `notify` | as the other CLIs |

Consumers: the Neovim dashboard footer (one file read at first paint, no
subprocess) and `SUPER+U`, which fires a notification. The awk pick is seeded
from `$RANDOM$$` rather than a bare `srand()` — that seeds from whole seconds,
so two presses inside one second would return the same proverb.

Adding proverbs means adding TSV rows; nothing else needs touching. Send
corrections upstream too.

## nietzsche — the quotations

`lib/nietzsche.tsv` holds 124 Nietzsche quotations as `quote<TAB>source`, drawn
from the standard public-domain / Kaufmann–Hollingdale translations. The source
column names the work and, where it is certain, the section. Quotes that could
not be traced to a work were deliberately left out — most of the Nietzsche in
circulation online is apocryphal.

Latin script throughout, so unlike `ukhaan` there is no terminal/GUI split; the
same text goes to every surface.

| Command | Output |
|---------|--------|
| `nietzsche` | `What does not kill me makes me stronger. — Twilight of the Idols, …` |
| `nietzsche quote` / `source` | either column alone |
| `nietzsche count` | how many are in the table |
| `nietzsche waybar` / `json` / `notify` | as the other CLIs |

Consumer: `SUPER+Y`, which fires a notification — the mirror of `SUPER+U` for
proverbs. Same `$RANDOM$$` seeding as `ukhaan`, for the same reason.

Adding quotations means adding TSV rows; nothing else needs touching.

## Shape language

- Corner radius: **14px** shell islands (waybar), 12px popups (fuzzel, swaync, tooltips), 9px individual bar pills, 10px windows (hyprland `rounding`)
- Shell surfaces are **frosted glass**: `rgba(sumiInk1, ~0.9)` + a 7%-tall lit
  edge along the top + hyprland layer blur
- Borders: 1px `rgba(sumiInk6, ~0.5)` on glass; gradient only on the focused window
- Motion: material-expressive beziers (see `dotfiles/hypr/hyprland.lua`), 200–400 ms

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

On focus the gradient angle sweeps once (`hl.animation({ leaf = "borderangle", …, style = "once" })`).
It is deliberately **not** `loop`: a looping borderangle repaints the border
every frame for as long as the window is focused, which on the Vega 7 iGPU is a
permanent tax for an effect nobody is looking at.

### Performance rules

The look is expensive-looking, not expensive. The constraints that keep it that
way, in one place:

- **No idle animations anywhere.** Waybar transitions fire on hover and state
  change only; hyprland's borderangle runs `once`; terminal cursors don't blink.
  Anything that repaints at 60 fps while you aren't looking at it is cut.
- **`xray = true` on blurred shell layers** (waybar, fuzzel, swayosd). The blur then
  samples the wallpaper only instead of the live window stack, so scrolling a
  terminal doesn't force the bar to re-blur — cheaper *and* calmer.
- **Blur stays at size 6 / 2 passes**; 3 passes at size 8 dropped frames.
- **`special = false`** in the blur block — blurring the scratchpad backdrop
  caused fullscreen jitter.
- **No screen shader.** `vibrance.frag` is a full-screen per-pixel pass every
  frame; it stays commented out in `hyprland.lua`.
- **Neovim's seasonal segment is async.** No subprocess ever runs on the startup
  path for a decoration.

### dhyan dhyan mode

`SUPER+Z` (`dotfiles/hypr/scripts/zen.sh`) toggles between "workstation" and
"reading room": the bar folds away (waybar `SIGUSR1`), gaps open into wide paper
margins, the border thins to a hairline. It pushes both states through
`hyprctl eval` + `hl.config()` rather than reloading, so it is instant and costs
nothing while idle. **The "off" values in that script must match the
`general`/`decoration` blocks in `hyprland.lua`** — there is no "unset".

### Hyprland config format: Lua, not `.conf`

Hyprland 0.56 deprecated the hyprlang `.conf` format and removes it in 0.57, so
the whole config is Lua (`hl.*` calls). Home Manager writes
`~/.config/hypr/hyprland.lua` with `configType = "lua"`; that file
`require()`s `dotfiles/hypr/hyprland.lua` by absolute path, which puts the
dotfile under Hyprland's inotify watcher — saving it still reloads live, no
rebuild. (`dofile()` would *not* be watched.)

The translation is mostly mechanical, but three things bite anything that talks
to a running Hyprland:

| Old (hyprlang) | New (Lua) |
|----------------|-----------|
| `hyprctl keyword general:gaps_in 6` | `hyprctl eval 'hl.config({ general = { gaps_in = 6 } })'` |
| `hyprctl dispatch exit` | `hyprctl dispatch 'hl.dsp.exit()'` |
| `plugin:dynamic-cursors:mode` | `plugin.dynamic_cursors.mode` (`:` → `.`, `-` → `_`) |

`hyprctl keyword` is refused outright under the Lua manager ("keyword can't
work with non-legacy parsers. Use eval."), and `hyprctl dispatch` is now just a
wrapper for `hl.dispatch(...)` — it takes a Lua dispatcher, not a keyword. Every
caller in this repo (zen.sh, wlogout, hypridle, waybar scroll + power menu) was
updated; new ones must use the right-hand column.

Plugin config values only exist once the plugin is loaded, which happens after
the first config pass, so plugin blocks are guarded with
`if hl.get_config("plugin.<ns>.<key>") ~= nil then` — that keeps the first pass
free of "unknown config key" errors instead of flashing them on every start.

## Where each surface is themed

| Surface | File |
|---------|------|
| Hyprland | `dotfiles/hypr/hyprland.lua` (live-`require`d), `dotfiles/hypr/scripts/` |
| Waybar | `home-manager-config-files/waybar/` (live symlink) |
| Bikram Sambat calendar | `lib/patro.nix` + `modules/home-manager/tools/patro.nix` |
| ukhaan proverbs | `lib/ukhaan.tsv` + `modules/home-manager/tools/ukhaan.nix` |
| Nietzsche quotes | `lib/nietzsche.tsv` + `modules/home-manager/tools/nietzsche.nix` |
| SwayNC | `home-manager-config-files/swaync/` (live symlink) |
| Fuzzel | `modules/home-manager/desktop/fuzzel.nix` |
| Wlogout | `modules/home-manager/desktop/wlogout.nix` |
| Hyprlock | `modules/home-manager/desktop/hyprlock.nix` |
| Wallpapers (swww) | `modules/home-manager/desktop/swww.nix` + `images/walls/` |
| Kitty / Ghostty / Wezterm | `modules/home-manager/terminals/*.nix` |
| Tmux | `modules/home-manager/programs/tmux.nix` |
| Starship | `modules/home-manager/shell/starship.nix` |
| fastfetch / cava / fzf / bat | `modules/home-manager/tools/*.nix` |
| Neovim | `nvim/init.lua` (kanagawa overrides — the original source of truth) |
| Helix | `modules/home-manager/programs/helix.nix` |
| SDDM | `modules/nixos/desktop/sddm.nix` (astronaut / japanese_aesthetic, chrome recoloured via `themeConfig`) |
| Boot splash | `packages/plymouth-himal/` (custom script theme), enabled in `modules/nixos/boot.nix` |

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
between modes — crystalBlue `NOR` / springGreen `INS` / oniViolet `VIS` /
carpYellow `CMD` / peachRed `REP` / waveAqua `TRM` — so a mode change reads as
one dot of colour moving,
not the whole bar repainting.

Markdown headings use a descending ink ramp — `waveBlue1 → sumiInk5 →
sumiInk4 → sumiInk2 → none`. The plugin's defaults link heading backgrounds to
the `Diff*` groups, which under kanagawa renders a document as a merge
conflict; the overrides in `init.lua` replace that.

### Tmux: the same bar, one layer down

`modules/home-manager/programs/tmux.nix` borrows three motifs wholesale rather
than inventing a fourth vocabulary:

- **The session pill is a mode cap.** Same grammar as Neovim's, same tags:
  crystalBlue `NOR` idle, carpYellow `CMD` while the prefix is pending,
  oniViolet `VIS` in copy mode. Only the cap changes colour.
- **Window numbers stay Latin.** Devanagari numerals were tried and measured
  here; see the script rule at the top of this file for why they didn't stay.
- **Pills are cut on the slant** (U+E0BA / U+E0BC) — the same angle kitty cuts
  its tabs at under `tab_powerline_style slanted`, so a tmux pill sitting
  under a kitty tab reads as one object.

Layout follows waybar's three islands: session left, windows
`absolute-centre`, ambient readouts right. The right island holds cwd, the
Bikram Sambat date, the clock and a 󰋯 himal cap.

Nothing on the bar forks except one `#()` for the date, and that reads an
hourly cache — the segment only changes at midnight. Everything else is
tmux format arithmetic, so a refresh is string compares. `status-interval` is
30s (tmux-sensible's default is 5) and `monitor-activity` stays **off**: it
repaints the whole bar every time any background window writes a byte.

The bar is width-responsive because kitty on this machine swings between 82
columns tiled and 169 maximised. Below 150 the cwd and microseason drop; below
110 inactive windows shed their names and the bar compresses to a row of
numerals with one named island. Both thresholds use `#{e|>=:…}` — the bare
`#{>=:…}` form compares as *strings*, where `"82" >= "110"` is true.
