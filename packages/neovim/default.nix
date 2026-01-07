# Neovim overlay - builds custom Neovim package with plugins
{ inputs }: final: prev:

let
  pkgs = final;
  plugins = import ./plugins.nix { inherit pkgs inputs; };

  # Use pinned nixpkgs for wrapNeovimUnstable compatibility
  pkgs-wrapNeovim = inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};

  # Helper function that builds the Neovim derivation
  mkNeovim = pkgs.callPackage ./mkNeovim.nix { inherit pkgs-wrapNeovim; };

  # Pre-build the kulala_http tree-sitter grammar
  treesitter-kulala-http = pkgs.tree-sitter.buildGrammar {
    language = "kulala_http";
    version = "5.3.1";
    src = pkgs.fetchFromGitHub {
      owner = "mistweaverco";
      repo = "kulala.nvim";
      rev = "902fc21e8a3fee7ccace37784879327baa6d1ece";
      hash = "sha256-whQpwZMEvD62lgCrnNryrEvfSwLJJ+IqVCywTq78Vf8=";
    };
    location = "lua/tree-sitter";
  };

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
    kulalaParser = treesitter-kulala-http;
  };

  # Lua RC JSON for development (symlinked in devShell)
  nvim-luarc-json = final.mk-luarc-json {
    plugins = plugins.all-plugins;
  };
}
