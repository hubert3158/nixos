# Manual Package Updates

`nix flake update` only bumps the inputs in `flake.lock` that track a branch or
`HEAD` (nixpkgs, home-manager, sops-nix, flake-utils, gen-luarc, eldritch.nvim,
claude-desktop, and everything under `pkgs.vimPlugins.*`). The packages below are
pinned to a fixed version/rev/hash and **will not move on `nix flake update`** —
they must be bumped by hand.

After any bump: `sudo nixos-rebuild switch --flake ~/nixos`.

## Auto-updated by other mechanisms (no action needed)

These look manual but aren't — listed so they're not bumped twice:

- **uv tools** (`modules/home-manager/tools/uv-tools.nix`): `serena-agent`,
  `cocoindex-code`, `semble`, `graphify` (PyPI `graphifyy`). Installed with
  `uv tool install --upgrade`, which re-runs on every home-manager switch →
  upgraded on every rebuild.
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

The grammar must match the **`kulala-nvim` plugin version that nixpkgs ships**,
not upstream `HEAD`. Bumping it independently risks grammar/plugin drift.

```bash
# what version the plugin currently resolves to
nix eval --raw "github:NixOS/nixpkgs/nixpkgs-unstable#vimPlugins.kulala-nvim.src.rev"
```

Only bump the grammar `rev`/`hash` to match that tag, and ideally only when
`nix flake update` moves the plugin.

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

The Flatpak daemon is declared (`modules/services/flatpak.nix` →
`services.flatpak.enable = true`), but **installed apps are imperative** — they
live in `~/.local/share/flatpak/` and are never declared in this flake.

### Auto Claude (`com.autoclaude.ui`)

- Installed as a **user Flatpak** from a **sideloaded bundle** (origin
  `ui-origin`, branch `master`) — not on Flathub, so there is no network repo to
  pull from. `flatpak update` will not bump it.
- To update: download the new `.flatpak` bundle from upstream and reinstall:
  ```bash
  flatpak install --user --reinstall ./AutoClaude-<version>.flatpak
  ```
- Other Flatpaks installed from Flathub (if any) do update with `flatpak update`.

### claude-code (npm global)

`@anthropic-ai/claude-code` is installed **twice**: via nixpkgs
(`hosts/common/default.nix` → auto on `nix flake update`) **and** as an npm
global (`npm i -g`, manual). Whichever wins depends on PATH order. Update the
npm copy with `npm update -g @anthropic-ai/claude-code`, or remove it with
`npm rm -g @anthropic-ai/claude-code` to rely on the Nix one only.
