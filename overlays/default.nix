# Overlays aggregator
{ inputs, ... }:

{
  nixpkgs.overlays = [
    # Neovim custom package overlay
    (import ../packages/neovim { inherit inputs; })

    # gen-luarc overlay for Lua LSP support
    inputs.gen-luarc.overlays.default

    # Workaround: ibis-framework duckdb tests fail upstream
    (final: prev: {
      pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
        (pyFinal: pyPrev: {
          ibis-framework = pyPrev.ibis-framework.overridePythonAttrs {
            doCheck = false;
            pythonImportsCheck = [ "ibis" ];
          };
        })
      ];
    })
  ];
}
