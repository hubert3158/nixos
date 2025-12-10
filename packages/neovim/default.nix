# Neovim overlay - builds custom Neovim package with plugins
{ inputs }: final: prev:

let
  pkgs = final;
  plugins = import ./plugins.nix { inherit pkgs inputs; };

  # Use pinned nixpkgs for wrapNeovimUnstable compatibility
  pkgs-wrapNeovim = inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};

  # Helper function that builds the Neovim derivation
  mkNeovim = pkgs.callPackage ./mkNeovim.nix { inherit pkgs-wrapNeovim; };

  extraPackages = with pkgs; [
    lua-language-server
    nil  # Nix LSP
  ];
in
{
  # Main Neovim derivation
  nvim-pkg = mkNeovim {
    plugins = plugins.all-plugins;
    inherit extraPackages;
  };

  # Lua RC JSON for development (symlinked in devShell)
  nvim-luarc-json = final.mk-luarc-json {
    plugins = plugins.all-plugins;
  };
}
