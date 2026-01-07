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
    version = "5.4.0";
    src = pkgs.fetchFromGitHub {
      owner = "mistweaverco";
      repo = "kulala.nvim";
      rev = "cd3eaa83b8d60533837202dede73238334d71832";
      hash = "sha256-RKtjVWC25D7k9nI0xKPEmO+MNqf77PWfg8h7hdK5+ik=";
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
