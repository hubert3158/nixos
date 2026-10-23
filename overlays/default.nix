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

    # diff-cover 10.5.1 (nixpkgs bump 2026-10-08, PR #470881) fails 6 HTML
    # snapshot tests on the python314 set (rendered report differs from the
    # checked-in fixture) -> uncached on hydra -> sqlfluff builds locally and
    # fails. Only sqlfluff depends on diff-cover, so scope the override to it
    # rather than pythonPackagesExtensions. Both are pure python, cheap to build.
    # Check: p.sqlfluff cached again (200)? -> drop this block.
    (final: prev: {
      sqlfluff = prev.sqlfluff.override {
        python3Packages = prev.python3Packages.overrideScope (pyfinal: pyprev: {
          diff-cover = pyprev.diff-cover.overridePythonAttrs (old: {
            disabledTests = (old.disabledTests or [ ]) ++ [
              "test_added_file_pycodestyle_html"
              "test_added_file_pyflakes_html"
              "test_added_file_pylint_html"
              "test_all_reports"
              "test_fail_under_html"
              "test_fail_under_pass_html"
            ];
          });
        });
      };
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
  ];
}
