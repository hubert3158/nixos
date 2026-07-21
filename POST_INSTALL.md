# Post-install steps (per machine)

Things that aren't tracked declaratively by the flake. Run these once on each machine after `nixos-rebuild switch`.

## Work SSH hosts (in gopass — repo is public)

`~/.ssh/config` includes `config.d/*`. Work host definitions (stg, prod, dev, …)
are NOT in this repo. They live in gopass as `ssh/work-config`; on the work host
(`workHostsFromPass = hostname == "work"` in flake.nix) a home-manager
activation script decrypts them to `~/.ssh/config.d/work` on every rebuild.
Needs an unlocked gpg-agent — otherwise it warns and keeps the existing file.

Private keys (`.pem`, work ed25519) live in gopass under `ssh/keys/<filename>`;
the same activation pass (`keysFromPass`) materializes every entry there to
`~/.ssh/<filename>` (mode 600). Key names are enumerated from the store, so
adding a key never touches the repo.

Fresh machine: import the GPG key + gopass store first, then rebuild — hosts
and keys both regenerate.

Update flows:

```bash
# hosts: edit the plaintext file, then push it up (or next rebuild reverts it)
nvim ~/.ssh/config.d/work
gopass cat ssh/work-config < ~/.ssh/config.d/work

# add/update a private key, then rebuild
gopass cat ssh/keys/<name> < ~/.ssh/<name>
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
