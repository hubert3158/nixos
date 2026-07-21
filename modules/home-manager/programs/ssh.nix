# SSH client configuration
#
# Work/private host definitions are NOT tracked in this repo (it is public).
# They live in gopass (entry `ssh/work-config`) and are decrypted into
# ~/.ssh/config.d/work by an activation script on every rebuild (work host
# only, via workHostsFromPass). The Include below picks them up; a glob that
# matches nothing is a silent no-op, so machines without the entry still work.
#
# Update flow: gopass edit ssh/work-config   (or edit ~/.ssh/config.d/work,
# then `gopass cat ssh/work-config < ~/.ssh/config.d/work` — activation
# overwrites the file from gopass on the next rebuild). See POST_INSTALL.md.
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.programs.ssh;
in {
  options.modules.programs.ssh = {
    enable = lib.mkEnableOption "SSH client configuration";

    enableForwardAgent = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable SSH agent forwarding";
    };

    serverAliveInterval = lib.mkOption {
      type = lib.types.int;
      default = 60;
      description = "Server alive interval in seconds";
    };

    serverAliveCountMax = lib.mkOption {
      type = lib.types.int;
      default = 30;
      description = "Maximum server alive count";
    };

    workHostsFromPass = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Decrypt work SSH host blocks from gopass into ~/.ssh/config.d/work on activation";
    };

    passEntry = lib.mkOption {
      type = lib.types.str;
      default = "ssh/work-config";
      description = "gopass entry holding the work SSH host config";
    };

    keysFromPass = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Materialize every gopass entry under passKeysPrefix as a key file in ~/.ssh on activation";
    };

    passKeysPrefix = lib.mkOption {
      type = lib.types.str;
      default = "ssh/keys";
      description = "gopass prefix whose entries are written to ~/.ssh/<basename> (mode 600)";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;

      # Untracked host definitions (work servers etc.)
      includes = [ "config.d/*" ];

      settings = {
        "*" = {
          ForwardAgent = cfg.enableForwardAgent;
          ForwardX11 = false;
          ForwardX11Trusted = true;
          ServerAliveInterval = cfg.serverAliveInterval;
          ServerAliveCountMax = cfg.serverAliveCountMax;
          KexAlgorithms = "sntrup761x25519-sha512@openssh.com,curve25519-sha256,curve25519-sha256@libssh.org";
        };

        "github.com-work" = {
          HostName = "github.com";
          User = "git";
          IdentityFile = "~/.ssh/id_ed25519_work";
          IdentitiesOnly = true;
        };

        "github.com" = {
          HostName = "github.com";
          User = "git";
          IdentityFile = "~/.ssh/id_ed25519";
          IdentitiesOnly = true;
        };
      };
    };

    # Decrypt work hosts from gopass at activation time — never at eval time,
    # which would copy the plaintext into the world-readable /nix/store.
    # The dotted tmp name keeps the `config.d/*` Include glob from ever
    # matching a half-written file.
    home.activation.syncWorkSshHosts = lib.mkIf cfg.workHostsFromPass (
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        export PATH="${lib.makeBinPath [ pkgs.gopass pkgs.gnupg pkgs.coreutils ]}:$PATH"
        mkdir -p "$HOME/.ssh/config.d"
        chmod 700 "$HOME/.ssh/config.d"
        if timeout 10 gopass cat ${lib.escapeShellArg cfg.passEntry} \
            > "$HOME/.ssh/config.d/.work.tmp" 2>/dev/null; then
          chmod 600 "$HOME/.ssh/config.d/.work.tmp"
          mv "$HOME/.ssh/config.d/.work.tmp" "$HOME/.ssh/config.d/work"
        else
          rm -f "$HOME/.ssh/config.d/.work.tmp"
          echo "ssh.nix: cannot decrypt gopass entry '${cfg.passEntry}' (gpg-agent locked?); keeping existing ~/.ssh/config.d/work" >&2
        fi
      ''
    );

    # Materialize private keys from gopass. The key NAMES live only in the
    # store (enumerated via `gopass ls --flat`), so the public repo carries
    # the mechanism but no hint of which keys exist. Add a key with
    #   gopass cat ssh/keys/<name> < ~/.ssh/<name>
    # and rebuild — no nix changes needed.
    home.activation.syncWorkSshKeys = lib.mkIf cfg.keysFromPass (
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        export PATH="${lib.makeBinPath [ pkgs.gopass pkgs.gnupg pkgs.coreutils ]}:$PATH"
        if entries=$(timeout 10 gopass ls --flat ${lib.escapeShellArg cfg.passKeysPrefix} 2>/dev/null); then
          while IFS= read -r entry; do
            [ -n "$entry" ] || continue
            name=$(basename "$entry")
            if timeout 10 gopass cat "$entry" > "$HOME/.ssh/.$name.tmp" 2>/dev/null; then
              chmod 600 "$HOME/.ssh/.$name.tmp"
              mv "$HOME/.ssh/.$name.tmp" "$HOME/.ssh/$name"
            else
              rm -f "$HOME/.ssh/.$name.tmp"
              echo "ssh.nix: cannot decrypt gopass entry '$entry'; keeping existing ~/.ssh/$name" >&2
            fi
          done <<< "$entries"
        else
          echo "ssh.nix: cannot list gopass prefix '${cfg.passKeysPrefix}' (gpg-agent locked?); ssh keys not synced" >&2
        fi
      ''
    );
  };
}
