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
  #
  # The three values below are GENERATED — do not hand-edit. After `nix flake update`
  # moves kulala.nvim, run:  ./scripts/update-kulala-grammar.sh
  # The eval-time check underneath warns loudly if they have drifted, so a stale pin
  # can never rot silently.
  kulalaGrammarPin = {
    pluginVersion = "6.28.0"; # kulala.nvim version this grammar rev ships with
    rev = "630e2b8523c775ba866564c2b4ad88d649a56c00";
    hash = "sha256-+BtU7xGUwgZeFX21St8YNYCDrOstDzLjQvbedNtbhvU=";
  };

  # What the *installed* plugin pins. Read out of the built plugin (IFD — kulala.nvim
  # is a plain fetch that substitutes from cache, so this costs a download at most)
  # purely to compare against the pin above; the grammar fetch itself stays pinned
  # and hashed, so evaluation remains reproducible.
  kulalaPluginRev =
    let
      versionFile = "${pkgs.vimPlugins.kulala-nvim}/lua/kulala/globals/versions/treesitter.lua";
      m = builtins.match "return \"([0-9a-f]+)\"[[:space:]]*" (builtins.readFile versionFile);
    in
    if m == null then null else builtins.head m;

  treesitter-kulala-http =
    pkgs.lib.warnIf (kulalaPluginRev == null)
      "kulala: could not parse the grammar rev out of kulala.nvim - drift check skipped"
      (pkgs.lib.warnIf (kulalaPluginRev != null && kulalaPluginRev != kulalaGrammarPin.rev)
        ("kulala grammar drift: kulala.nvim pins ${toString kulalaPluginRev}, this flake pins "
          + "${kulalaGrammarPin.rev}. Run ./scripts/update-kulala-grammar.sh to resync, "
          + "or ft=http highlighting breaks.")
        (pkgs.tree-sitter.buildGrammar {
          language = "kulala_http";
          version = kulalaGrammarPin.pluginVersion;
          src = pkgs.fetchFromGitHub {
            owner = "mistweaverco";
            repo = "tree-sitter-kulala-http";
            rev = kulalaGrammarPin.rev;
            hash = kulalaGrammarPin.hash;
          };
        }));

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
