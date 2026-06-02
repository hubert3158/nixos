# NixOS Configuration - Claude Code Guidelines

## Avoid Local Builds (check binary cache first)

The user wants to avoid compiling packages from source. Before adding any package to the
Nix config, verify it's in the binary cache so it gets fetched, not built.

### How to check if a package is cached
```bash
# 1. Get the output path (use the flake's pinned nixpkgs, not the registry)
out=$(nix eval --raw --impure --expr 'let f = builtins.getFlake (toString ./.); \
  p = f.inputs.nixpkgs.legacyPackages.x86_64-linux; in p.<ATTR>.outPath')
hash=$(echo "$out" | grep -oP '(?<=/nix/store/)[a-z0-9]{32}')

# 2. Query cache.nixos.org — 200 = cached, 404 = will build locally
curl -s -o /dev/null -w "%{http_code}\n" https://cache.nixos.org/$hash.narinfo

# 3. See the full build-vs-fetch list (watch for torch/onnxruntime/llvm/etc.)
nix build --dry-run --impure --expr 'let f = builtins.getFlake (toString ./.); \
  p = f.inputs.nixpkgs.legacyPackages.x86_64-linux; in p.<ATTR>'
```

### If a package is NOT cached (404) or drags in heavy deps
- **Prefer prebuilt wheels via `uv`** for Python CLIs — PyPI ships precompiled binaries
  (torch, onnxruntime, etc.), no Nix build.
- Declare such tools in `modules/home-manager/tools/uv-tools.nix`. Add an entry to the
  `tools` list — a home-manager activation script runs `uv tool install --upgrade` on every
  rebuild (idempotent, installs to `~/.local/bin`, tracked in config). Do NOT install with a
  bare `uv tool install` in the terminal; it won't survive as declarative config.
- Only fall back to building from source if there's no prebuilt option.

### Known case: markitdown
`python312Packages.markitdown` is NOT cached and pulls torch + onnxruntime + transformers
as **hard** deps (via `speechrecognition` and `magika`) — hours of local compile. Declared in
`uv-tools.nix` instead (base wheels, no torch). Do not add it to `packages.nix`.

## Prisma Engine Workaround

### Why this exists
The `prisma-engines` nixpkgs package fails to compile due to a Rust bug (`rust-lang/rust#141402`). As a workaround, we use a custom Nix derivation that fetches a pre-built static (`linux-static-x64`) schema-engine binary from Prisma's CDN. Prisma 7.x only needs `schema-engine` for migrations — the query engine is compiled into `@prisma/client` as WASM.

### Before doing anything with Prisma
**Always try enabling `prisma-engines` from nixpkgs first.** The Rust bug may be fixed by now.

1. Set `enablePrisma = true` in `hosts/common/default.nix`
2. Revert `modules/nixos/development/tools.nix` to use `pkgs.prisma-engines` directly (the original version before the static workaround)
3. Run `sudo nixos-rebuild switch --flake ~/nixos`
4. **If it builds successfully** — the Rust bug is fixed. Delete `packages/prisma-schema-engine-static/` and `scripts/update-prisma-engine.sh`, they are no longer needed.
5. **If it fails** — keep the static workaround as-is.

### Key files
| File | Purpose |
|------|---------|
| `packages/prisma-schema-engine-static/default.nix` | Nix derivation that fetches static schema-engine binary from Prisma CDN |
| `scripts/update-prisma-engine.sh` | Updates the derivation to match the Prisma version installed in the project |
| `modules/nixos/development/tools.nix` | Dev tools module — wires up `PRISMA_SCHEMA_ENGINE_BINARY` env var |
| `hosts/common/default.nix` | Where `enablePrisma` is toggled |

### How to update after upgrading Prisma in the project
```bash
~/nixos/scripts/update-prisma-engine.sh        # reads version from core-v3/backend
sudo nixos-rebuild switch --flake ~/nixos      # apply
```

### Original tools.nix Prisma config (before workaround)
If `prisma-engines` compiles again, restore this in `tools.nix`:
```nix
# Prisma environment variables
environment.variables = lib.mkIf cfg.enablePrisma {
  PRISMA_SCHEMA_ENGINE_BINARY = "${pkgs.prisma-engines}/bin/schema-engine";
  PRISMA_QUERY_ENGINE_BINARY = "${pkgs.prisma-engines}/bin/query-engine";
  PRISMA_QUERY_ENGINE_LIBRARY = "${pkgs.prisma-engines}/lib/libquery_engine.node";
};

# In systemPackages:
++ (lib.optionals cfg.enablePrisma [
  nodePackages.prisma
  prisma-engines
])
```
And remove the `prisma-schema-engine-static` callPackage from the `let` block.
