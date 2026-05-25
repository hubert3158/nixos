# Overlays aggregator
{ inputs, ... }:

{
  nixpkgs.overlays = [
    # Neovim custom package overlay
    (import ../packages/neovim { inherit inputs; })

    # gen-luarc overlay for Lua LSP support
    inputs.gen-luarc.overlays.default

    # Claude Desktop (aaddrick) — exposes pkgs.claude-desktop and pkgs.claude-desktop-fhs
    inputs.claude-desktop.overlays.default

    # Pin flameshot to old nixpkgs (v12.x) — v14 has a Screenshot portal ABI
    # mismatch with current xdg-desktop-portal-hyprland on this nixpkgs.
    (final: prev: {
      flameshot = inputs.nixpkgs-flameshot.legacyPackages.${prev.stdenv.hostPlatform.system}.flameshot;
    })

    # pipx 1.8.0 test suite fails against newer `packaging` lib (canonicalizes
    # `name@ url` -> `name @ url`). Tests-only failure, skip them.
    (final: prev: {
      pipx = prev.pipx.overridePythonAttrs (old: {
        doCheck = false;
        doInstallCheck = false;
      });
    })
  ];
}
