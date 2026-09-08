# Manual Package Updates

`nix flake update` only bumps the inputs in `flake.lock` that track a branch or
`HEAD` (nixpkgs, home-manager, sops-nix, flake-utils, gen-luarc, eldritch.nvim,
claude-desktop, and everything under `pkgs.vimPlugins.*`). Everything below —
the derivations in `packages/`, a plugin override under `modules/`, and the
imperative installs at the end — is pinned to a fixed version/rev/hash or lives
outside Nix entirely, so it **will not move on `nix flake update`** and must be
bumped by hand.

After any bump: `sudo nixos-rebuild switch --flake ~/nixos`.

## Auto-updated by other mechanisms (no action needed)

These look manual but aren't — listed so they're not bumped twice:

- **uv tools** (`modules/home-manager/tools/uv-tools.nix`): `serena-agent`,
  `cocoindex-code`, `semble`, `graphify` (PyPI `graphifyy`), `markitdown`.
  Installed with `uv tool install --upgrade`, which re-runs on every
  home-manager switch → upgraded on every rebuild.
  > Note: `cocoindex-code` (uv) is **not** the same as the Nix `cocoindex`
  > package below.

## Manual — bump to latest

| Package | File | Source | How to get the new hash |
|---------|------|--------|-------------------------|
| **ccline** | `packages/ccline/default.nix` | npm `@cometix/ccline-linux-x64` | see below |
| **cocoindex** | `packages/cocoindex/default.nix` | PyPI `cocoindex` (manylinux wheel) | see below |
| **sigmap** | `packages/sigmap/default.nix` | npm `sigmap` | see below |

### ccline / sigmap (npm tarballs)

```bash
# latest version
curl -s https://registry.npmjs.org/@cometix/ccline-linux-x64 | jq -r '.["dist-tags"].latest'
curl -s https://registry.npmjs.org/sigmap | jq -r '.["dist-tags"].latest'

# new hash (substitute pkg + version)
nix-prefetch-url --type sha256 "https://registry.npmjs.org/sigmap/-/sigmap-<VERSION>.tgz" \
  | tail -1 | xargs -I{} nix hash convert --hash-algo sha256 --to sri {}
```

Then edit `version` + `hash` in the derivation.

### cocoindex (PyPI wheel)

The wheel URL contains a per-file hash directory, so **both the URL and the hash
change** on a bump.

```bash
# latest version
curl -s https://pypi.org/pypi/cocoindex/json | jq -r '.info.version'

# URL + sha256 for the cp311-abi3 manylinux wheel of a given version
curl -s https://pypi.org/pypi/cocoindex/<VERSION>/json | jq -r '
  .urls[] | select(.filename | endswith("cp311-abi3-manylinux_2_28_x86_64.whl"))
  | "url: \(.url)\nsha256: \(.digests.sha256)"'

# convert the hex sha256 PyPI gives you into an SRI hash
nix hash convert --hash-algo sha256 --to sri <HEX_SHA256>
```

Then edit `version`, `url`, and `hash` in the derivation.

## Manual — version-gated (do NOT chase upstream latest)

### kulala_http tree-sitter grammar (`packages/neovim/default.nix`)

**Scripted — do not hand-edit.** The grammar rev must equal the one the
`kulala-nvim` plugin nixpkgs ships pins in
`lua/kulala/globals/versions/treesitter.lua`, never upstream `HEAD`: the plugin's
queries and the compiled parser drift apart otherwise and
`vim.treesitter.start()` throws on `ft=http`.

Two mechanisms keep the pin honest:

- **Drift warning at eval.** `packages/neovim/default.nix` reads the rev out of
  the built plugin (IFD) and compares it to the `kulalaGrammarPin` attrset. On
  mismatch every `nixos-rebuild` prints
  `evaluation warning: kulala grammar drift: kulala.nvim pins <a>, this flake
  pins <b>` — so a stale pin cannot rot silently after `nix flake update`.
- **Bump script.** `scripts/update-kulala-grammar.sh` resolves the plugin from
  *this flake's* locked nixpkgs (`--inputs-from`), reads the rev + plugin
  version out of it, prefetches the SRI hash, and rewrites all three values
  inside `kulalaGrammarPin`.

```bash
./scripts/update-kulala-grammar.sh --check   # report drift only, exit 1 if stale
./scripts/update-kulala-grammar.sh           # bump pluginVersion + rev + hash
sudo nixos-rebuild switch --flake ~/nixos
```

Currently at kulala.nvim `6.28.0` / grammar `630e2b8` (resynced 2026-09-08 from
`6.15.3` / `cb7a092`).

### hypr-dynamic-cursors plugin (`modules/home-manager/desktop/hyprland.nix`)

**Scripted — do not hand-edit `dynamicCursorsPin`.** `pkgs.hyprlandPlugins.hypr-dynamic-cursors`
is `overrideAttrs`-pinned because nixpkgs' own rev lags the Hyprland it ships,
and the plugin resolves Hyprland internals by function signature at init — a
mismatch throws at load and paints a red overlay across the top of the screen
(`[dynamic-cursors] cannot load, unexpected function signature`).

The correct rev is whatever upstream's `hyprpm.toml` `commit_pins` table lists
for the Hyprland version in use. Never the plugin's `HEAD`: that tracks Hyprland
git main, which moved the IPC to `hyprland/src/ipc/s2/S2.hpp`, a header 0.56.2
does not ship → build failure.

Two eval-time guards (plain nixpkgs attribute reads, no IFD):

- **Hyprland moved** → `hypr-dynamic-cursors: rev is pinned for Hyprland <a> but
  nixpkgs now ships <b>` — the pin is for the wrong Hyprland, re-run the script.
- **nixpkgs caught up** → `nixpkgs now ships the pinned rev — the overrideAttrs
  block ... can be deleted` — the override became dead weight; drop it and use
  `pkgs.hyprlandPlugins.hypr-dynamic-cursors` directly.

```bash
./scripts/update-hypr-dynamic-cursors.sh --check   # report drift, exit 1 if stale
./scripts/update-hypr-dynamic-cursors.sh           # bump hyprlandVersion + version + rev + hash
sudo nixos-rebuild switch --flake ~/nixos
```

The script reads Hyprland's version from *this flake's* locked nixpkgs, looks the
matching entry up in upstream `hyprpm.toml`, and prefetches the hash. If upstream
has no entry for that Hyprland yet it stops and says so — keep the old pin and
retry later rather than guessing.

Currently Hyprland `0.56.2` → plugin `5a22428` (nixpkgs still at `f5ba36c`, so
the override is still required).

### nixpkgs-flameshot input (`flake.nix`)

Deliberately pinned to a fixed nixpkgs commit to work around a flameshot v14 +
xdg-desktop-portal-hyprland screenshot-interface ABI mismatch (30s portal
timeout). **Leave pinned.** Only revisit when nixpkgs ships compatible versions —
see the comment in `flake.nix`.

### Prisma schema engine (`packages/prisma-schema-engine-static/`)

Tracks the Prisma version **installed in the core-v3 project**, not npm-latest.
Bump only after upgrading Prisma there:

```bash
~/nixos/scripts/update-prisma-engine.sh   # reads version from core-v3/backend
```

See `.claude/CLAUDE.md` for the full Prisma workaround rationale.

## Imperative installs — outside Nix entirely

Nothing in this section is declared in the flake. Neither `nix flake update` nor
`nixos-rebuild switch` touches any of it.

### Flatpak apps

The Flatpak daemon is declared (`modules/services/flatpak.nix` →
`services.flatpak.enable = true`), but **installed apps are imperative** — they
live in `~/.local/share/flatpak/` and are never declared in this flake.

- **Auto Claude (`com.autoclaude.ui`)** — installed as a **user Flatpak** from a
  **sideloaded bundle** (origin `ui-origin`, branch `master`), not on Flathub, so
  there is no network repo to pull from. `flatpak update` will not bump it.
  To update, download the new bundle from upstream and reinstall:
  ```bash
  flatpak install --user --reinstall ./AutoClaude-<version>.flatpak
  ```
- Everything else is from Flathub (`com.github.IsmaelMartinez.teams_for_linux`,
  IntelliJ IDEA Ultimate, the `org.freedesktop.*` runtimes) and **does** update
  with `flatpak update`.

### npm globals

`@anthropic-ai/claude-code` is installed **twice**: via nixpkgs
(`hosts/common/default.nix` → auto on `nix flake update`) **and** as an npm
global in `~/.npm-global` (`npm i -g`, manual). Whichever wins depends on PATH
order. Update the npm copy with `npm update -g @anthropic-ai/claude-code`, or
remove it with `npm rm -g @anthropic-ai/claude-code` to rely on the Nix one only.

### `~/.local/bin` — hand-dropped binaries

- **`cs` — claude-squad** (`github.com/smtg-ai/claude-squad`, currently 1.0.16).
  Plain Go binary copied into `~/.local/bin/cs`; no package manager behind it and
  **not in nixpkgs** (`pkgs.claude-squad` does not exist). Update = grab the new
  linux-amd64 release binary and overwrite the file:
  ```bash
  cs version                                    # what's installed now
  # download the latest release asset, then:
  install -m755 ./claude-squad ~/.local/bin/cs
  ```
- The other bins in that directory (`serena`, `serena-agent`, `graphify`,
  `graphify-mcp`, `ccc`, `semble`, `markitdown`) are **uv-managed** — see
  "Auto-updated by other mechanisms" at the top; do not touch them by hand.

### `nix profile` — imperative flake installs

Separate from this flake's system/home closures. Currently holds **nixd**
(`github:nix-community/nixd`, `nixd-nightly`), which is pinned in the profile's
own lock and does not follow `flake.lock`:

```bash
nix profile list             # what's in there
nix profile upgrade nixd     # or: nix profile upgrade --all
```

### rustup toolchains (`~/.rustup`)

The `rustup` **package** is from nixpkgs
(`modules/nixos/development/languages.nix`) and does move on `nix flake update`.
The **toolchains it downloads** (currently `stable` + `nightly`, nightly is
default) live under `~/.rustup` and are invisible to Nix — as are the components
installed into them (`rust-analyzer`, `clippy`, `rustfmt`):

```bash
rustup update
```

See `modules/home-manager/tools/rustup-nix-ld.nix` for why toolchain binaries are
repointed to nix-ld on every home-manager switch (nixpkgs' rustup patchelfs them
to a store glibc that Nix GC will eventually delete).

### Claude Code plugins (`~/.claude/plugins/`)

Installed with Claude Code's in-app `/plugin` command. Marketplaces and the
installed set live in `~/.claude/plugins/known_marketplaces.json` /
`installed_plugins.json`, entirely outside this repo. Currently installed:
`caveman`, `claude-mem`, `superpowers`, `ralph-loop`, `i-have-adhd`,
`mattpocock-skills`, `frontend-design`, and the LSP set (`pyright-lsp`,
`jdtls-lsp`, `lua-lsp`, `typescript-lsp`). Update them from `/plugin` inside
Claude Code.
