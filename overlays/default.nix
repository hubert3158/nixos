{inputs, ...}: {
  nixpkgs.overlays = [
    # (final: prev: {
    #   flameshot = prev.flameshot.overrideAttrs (old: {
    #     cmakeFlags = (old.cmakeFlags or []) ++ ["-DUSE_WAYLAND_GRIM=ON"];
    #   });
    # })

    # Overlay to disable checks for packages with failing tests
    (final: prev: {
      python3Packages =
        prev.python3Packages
        // {
          psycopg = prev.python3Packages.psycopg.overridePythonAttrs (old: {
            doCheck = false;
          });
          pytest-postgresql = prev.python3Packages.pytest-postgresql.overridePythonAttrs (old: {
            doCheck = false;
          });
          sqlframe = prev.python3Packages.sqlframe.overridePythonAttrs (old: {
            doCheck = false;
          });
          narwhals = prev.python3Packages.narwhals.overridePythonAttrs (old: {
            doCheck = false;
          });
          pyreadstat = prev.python3Packages.pyreadstat.overridePythonAttrs (old: {
            doCheck = false;
          });
          pandas-stubs = prev.python3Packages.pandas-stubs.overridePythonAttrs (old: {
            doCheck = false;
          });
          pdfplumber = prev.python3Packages.pdfplumber.overridePythonAttrs (old: {
            doCheck = false;
          });
        };
    })
    (import ../nix/neovim-overlay.nix {inherit inputs;})
  ];
}
