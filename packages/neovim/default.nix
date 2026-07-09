# Neovim overlay - builds custom Neovim package with plugins
{ inputs }: final: prev:

let
  pkgs = final;
  plugins = import ./plugins.nix { inherit pkgs inputs; };

  # Use pinned nixpkgs for wrapNeovimUnstable compatibility
  pkgs-wrapNeovim = inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};

  # Helper function that builds the Neovim derivation
  mkNeovim = pkgs.callPackage ./mkNeovim.nix { inherit pkgs-wrapNeovim; };

  # Pre-build the kulala_http tree-sitter grammar.
  #
  # As of kulala.nvim 6.15.x the grammar is NO LONGER bundled in the plugin. At
  # runtime the plugin git-clones a separate repo into stdpath('data') and runs
  # `tree-sitter build` — which fails on NixOS (no cc/tree-sitter CLI on PATH, and
  # the store is immutable). So we pre-build it here and register it eagerly via the
  # KULALA_HTTP_PARSER env var (see nvim/plugin/treesitter.lua). That makes kulala's
  # Parser.is_up_to_date() return true and skips the runtime fetch+build entirely.
  # The grammar ships its own queries (queries/kulala_http/*.scm), appended to rtp.
  #
  # IMPORTANT: rev MUST match the grammar version the plugin pins, i.e.
  #   pkgs.vimPlugins.kulala-nvim → lua/kulala/globals/versions/treesitter.lua
  # Bump both together whenever nixpkgs bumps kulala.nvim, or the queries (from this
  # repo) and the compiled parser drift and vim.treesitter.start() throws on ft=http.
  # The repo vendors a generated src/parser.c, so buildGrammar compiles it directly.
  treesitter-kulala-http = pkgs.tree-sitter.buildGrammar {
    language = "kulala_http";
    version = "6.15.3"; # kulala.nvim version this grammar rev ships with
    src = pkgs.fetchFromGitHub {
      owner = "mistweaverco";
      repo = "tree-sitter-kulala-http";
      rev = "cb7a092a6e9923f611c34d0448a9084c9949c923";
      hash = "sha256-waldW9KmNMY7sFanW6sqVMURwhseH/BnpqDwGJd36oY=";
    };
  };

  extraPackages = with pkgs; [
    lua-language-server
    nil  # Nix LSP
    (rWrapper.override {
      packages = with rPackages; [
        languageserver
        tidyverse
        ggplot2
        dplyr
        readr
        jsonlite
      ];
    })
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
