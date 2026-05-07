# Post-install steps (per machine)

Things that aren't tracked declaratively by the flake. Run these once on each machine after `nixos-rebuild switch`.

## graphifyy

Python CLI — not in nixpkgs. Installed via `uv` (which is provided by the flake).

```bash
uv tool install graphifyy
# or with extras:
uv tool install 'graphifyy[mcp]'
```

Verify: `graphify --help`

Upgrade later: `uv tool upgrade graphifyy`
