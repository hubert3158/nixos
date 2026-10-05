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

    # NOTE (2026-10-05): the inline-snapshot doCheck=false override that used to
    # live here is gone. It existed because inline-snapshot's own unit tests
    # failed on the python312 set, and it is a check-time dep of openai — but
    # the python env now tracks the default interpreter (see packages.nix), and
    # on that set both inline-snapshot and openai are cached and green.
    # Worse, keeping it was actively harmful: overriding a check-time dep changes
    # openai's drv hash, so openai lost its binary-cache hit and compiled
    # locally. If a python check failure ever needs skipping again, scope it to
    # the env that needs it rather than putting it here.

    # vscode-langservers-extracted 4.10.0 ships *ServerMain.js bundles that are
    # CommonJS (babel-injected top-level `require("core-js/...")`) except for a
    # single stray esbuild artifact, `createRequire(import.meta.url)`. That lone
    # `import.meta` makes node >= 22 auto-detect the file as ESM, where the
    # top-level `require` is undefined — so jsonls dies with
    # "ReferenceError: require is not defined in ES module scope" and quits with
    # exit code 1 in neovim (html/css servers hit the same bug). Fix: rewrite the
    # one ESM token to its CJS equivalent — `createRequire` accepts a path, and
    # `__filename` is valid in CommonJS. With no ESM syntax left, node loads the
    # bundle as CommonJS natively (verified: server answers `initialize`).
    (final: prev: {
      vscode-langservers-extracted = prev.vscode-langservers-extracted.overrideAttrs (old: {
        postFixup = (old.postFixup or "") + ''
          for main in "$out"/lib/node_modules/vscode-langservers-extracted/lib/*/node/*ServerMain.js; do
            sed -i 's/import\.meta\.url/__filename/g' "$main"
          done
        '';
      });
    })
  ];
}
