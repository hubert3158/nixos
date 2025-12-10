# Overlays aggregator
{ inputs, ... }:

{
  nixpkgs.overlays = [
    # Neovim custom package overlay
    (import ../packages/neovim { inherit inputs; })

    # gen-luarc overlay for Lua LSP support
    inputs.gen-luarc.overlays.default
  ];
}
