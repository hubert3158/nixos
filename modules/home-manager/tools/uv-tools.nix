# uv-managed Python CLIs.
# For tools with massive transitive Python deps (Serena, cocoindex-code) it's
# more pragmatic to let `uv tool install` manage them than to package each
# transitive dep in Nix. Activation re-runs on every home-manager switch, so the
# tools stay installed and upgraded across rebuilds.
#
# Installs land under ~/.local/share/uv/tools and expose bins via ~/.local/bin,
# which is already on PATH (see modules/home-manager/default.nix).
{ pkgs, lib, ... }:

let
  uv = "${pkgs.uv}/bin/uv";

  # Tools to keep installed. Each entry is one `uv tool install` invocation.
  # The leading `--upgrade` makes the call idempotent and bump-on-rebuild.
  tools = [
    {
      name = "serena-agent";
      # Pin Python 3.13 per upstream Quick Start.
      args = "-p 3.13 serena-agent@latest --prerelease=allow";
    }
    {
      name = "cocoindex-code";
      args = "cocoindex-code";
    }
    {
      name = "semble";
      args = "semble";
    }
  ];

  installScript = lib.concatMapStringsSep "\n" (t: ''
    ${uv} tool install --upgrade ${t.args} || \
      echo "warning: failed to install/upgrade ${t.name}" >&2
  '') tools;
in
{
  # nix-ld must be enabled system-wide so prebuilt manylinux wheels run.
  home.activation.uvToolInstall = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    # uv writes its standalone Python + tools under $HOME, no privileges needed.
    export PATH=${pkgs.uv}/bin:${pkgs.gcc}/bin:$PATH
    ${installScript}
  '';
}
