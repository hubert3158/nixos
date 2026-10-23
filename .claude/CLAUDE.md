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
