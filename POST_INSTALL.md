# Post-install steps (per machine)

Things that aren't tracked declaratively by the flake. Run these once on each machine after `nixos-rebuild switch`.

## Work SSH hosts (untracked — repo is public)

`~/.ssh/config` includes `config.d/*`. Work host definitions (stg, prod, dev, …)
are NOT in this repo. Copy `~/.ssh/config.d/work` (mode 600, dir 700) from an
existing machine or your password manager:

```bash
mkdir -p ~/.ssh/config.d && chmod 700 ~/.ssh/config.d
# place the work host blocks + matching .pem keys, then:
chmod 600 ~/.ssh/config.d/work ~/.ssh/*.pem
```

Verify: `ssh -G prod | head` shows the right HostName.

## graphifyy

Python CLI — not in nixpkgs. Installed via `uv` (which is provided by the flake).

```bash
uv tool install graphifyy
# or with extras:
uv tool install 'graphifyy[mcp]'
```

Verify: `graphify --help`

Upgrade later: `uv tool upgrade graphifyy`
