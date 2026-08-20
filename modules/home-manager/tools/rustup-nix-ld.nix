# Keep rustup toolchains runnable across nixpkgs upgrades + nix GC.
#
# Why this exists
# ---------------
# nixpkgs' `rustup` carries `0001-dynamically-patchelf-binaries.patch`, which
# runs `patchelf --set-interpreter <store-glibc>/lib/ld-linux-x86-64.so.2` on
# every executable it downloads into ~/.rustup/toolchains. Files under $HOME are
# not GC roots, so once nixpkgs bumps glibc and the old one is collected, every
# toolchain binary dies with:
#
#   error: command failed: 'rust-analyzer': No such file or directory (os error 2)
#
# (ENOENT = the ELF interpreter is gone, not the binary.) That takes out cargo,
# rustc, clippy, rustfmt and — because the system `rust-analyzer` is rustup's
# proxy shim — the Neovim Rust LSP too, which quits with exit code 1.
#
# Fix: after every switch, repoint any toolchain executable still pointing at a
# store path to /lib64/ld-linux-x86-64.so.2, which is nix-ld
# (modules/nixos/development/nix-ld.nix). That path is a stable symlink managed
# by the system generation, so GC can never orphan it, and nix-ld supplies the
# shared libs (zlib, stdenv.cc.cc.lib, ...) the toolchains need.
#
# Idempotent: binaries already on /lib64 are skipped, so a no-op rebuild does no
# writes. Runs on every switch, which is exactly when glibc can change — the
# repair lands before the next GC would bite.
{ pkgs, lib, ... }:

let
  patchelf = "${pkgs.patchelf}/bin/patchelf";
in
{
  home.activation.rustupNixLdInterpreter = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    rustupRoot="''${RUSTUP_HOME:-$HOME/.rustup}/toolchains"
    [ -d "$rustupRoot" ] || exit 0

    nixLd=/lib64/ld-linux-x86-64.so.2
    if [ ! -e "$nixLd" ]; then
      echo "warning: $nixLd missing — is programs.nix-ld enabled?" >&2
      exit 0
    fi

    # Only executables live in these dirs; skipping lib/ and share/doc/ keeps the
    # scan to a few dozen files instead of the whole rust-docs tree.
    for tc in "$rustupRoot"/*/; do
      [ -d "$tc" ] || continue
      scanDirs="$tc/bin $tc/libexec"
      for d in "$tc"lib/rustlib/*/bin; do
        [ -d "$d" ] && scanDirs="$scanDirs $d"
      done

      for d in $scanDirs; do
        [ -d "$d" ] || continue
        while IFS= read -r -d ''' f; do
          interp=$(${patchelf} --print-interpreter "$f" 2>/dev/null) || continue
          case "$interp" in
            /nix/store/*)
              ${patchelf} --set-interpreter "$nixLd" "$f" 2>/dev/null \
                && echo "rustup: repointed $f to nix-ld" \
                || echo "warning: failed to patch $f" >&2
              ;;
          esac
        done < <(find "$d" -type f -print0)
      done
    done
  '';
}
