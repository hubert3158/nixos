# NixOS Configuration - Claude Code Guidelines

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
