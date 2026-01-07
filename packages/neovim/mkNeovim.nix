# Function for creating a Neovim derivation
{
  pkgs,
  lib,
  stdenv,
  pkgs-wrapNeovim ? pkgs,
}:

with lib;

{
  appName ? null,
  neovim-unwrapped ? pkgs-wrapNeovim.neovim-unwrapped,
  plugins ? [],
  devPlugins ? [],
  ignoreConfigRegexes ? [],
  extraPackages ? [],
  extraLuaPackages ? p: [],
  extraPython3Packages ? p: [],
  withPython3 ? true,
  withRuby ? false,
  withNodeJs ? true,
  withSqlite ? true,
  viAlias ? appName == null || appName == "nvim",
  vimAlias ? appName == null || appName == "nvim",
  # blink-cmp fuzzy library for Rust performance
  blink-fuzzy-lib ? pkgs.vimPlugins.blink-cmp.passthru.blink-fuzzy-lib,
  # kulala_http treesitter parser
  kulalaParser ? null,
}:

let
  defaultPlugin = {
    plugin = null;
    config = null;
    optional = false;
    runtime = {};
  };

  externalPackages = extraPackages ++ (optionals withSqlite [pkgs.sqlite]);

  normalizedPlugins = map (x:
    defaultPlugin
    // (
      if x ? plugin
      then x
      else { plugin = x; }
    ))
  plugins;

  neovimConfig = pkgs-wrapNeovim.neovimUtils.makeNeovimConfig {
    inherit extraPython3Packages withPython3 withRuby withNodeJs viAlias vimAlias;
    plugins = normalizedPlugins;
  };

  # Filter nvim config directory
  nvimRtpSrc = let
    src = ../../nvim;
  in
    lib.cleanSourceWith {
      inherit src;
      name = "nvim-rtp-src";
      filter = path: tyoe: let
        srcPrefix = toString src + "/";
        relPath = lib.removePrefix srcPrefix (toString path);
      in
        lib.all (regex: builtins.match regex relPath == null) ignoreConfigRegexes;
    };

  # Split runtimepath into directories
  nvimRtp = stdenv.mkDerivation {
    name = "nvim-rtp";
    src = nvimRtpSrc;

    buildPhase = ''
      mkdir -p $out/nvim
      mkdir -p $out/lua
      rm init.lua
    '';

    installPhase = ''
      cp -r lua $out/lua
      rm -r lua
      if [ -d "after" ]; then
          cp -r after $out/after
          rm -r after
      fi
      if [ ! -z "$(ls -A)" ]; then
          cp -r -- * $out/nvim
      fi
    '';
  };

  # Final init.lua content
  initLua =
    ''
      vim.loader.enable()
      vim.opt.rtp:prepend('${nvimRtp}/lua')
    ''
    + (builtins.readFile ../../nvim/init.lua)
    + optionalString (devPlugins != []) (
      ''
        local dev_pack_path = vim.fn.stdpath('data') .. '/site/pack/dev'
        local dev_plugins_dir = dev_pack_path .. '/opt'
        local dev_plugin_path
      ''
      + strings.concatMapStringsSep
      "\n"
      (plugin: ''
        dev_plugin_path = dev_plugins_dir .. '/${plugin.name}'
        if vim.fn.empty(vim.fn.glob(dev_plugin_path)) > 0 then
          vim.notify('Bootstrapping dev plugin ${plugin.name} ...', vim.log.levels.INFO)
          vim.cmd('!${pkgs.git}/bin/git clone ${plugin.url} ' .. dev_plugin_path)
        end
        vim.cmd('packadd! ${plugin.name}')
      '')
      devPlugins
    )
    + ''
      vim.opt.rtp:prepend('${nvimRtp}/nvim')
      vim.opt.rtp:prepend('${nvimRtp}/after')
    '';

  extraMakeWrapperArgs = builtins.concatStringsSep " " (
    (optional (appName != "nvim" && appName != null && appName != "")
      ''--set NVIM_APPNAME "${appName}"'')
    ++ (optional (externalPackages != [])
      ''--prefix PATH : "${makeBinPath externalPackages}"'')
    ++ (optional withSqlite
      ''--set LIBSQLITE_CLIB_PATH "${pkgs.sqlite.out}/lib/libsqlite3.so"'')
    ++ (optional withSqlite
      ''--set LIBSQLITE "${pkgs.sqlite.out}/lib/libsqlite3.so"'')
    ++ (optional (kulalaParser != null)
      ''--set KULALA_HTTP_PARSER "${kulalaParser}"'')
  );

  luaPackages = neovim-unwrapped.lua.pkgs;
  resolvedExtraLuaPackages = extraLuaPackages luaPackages;

  extraMakeWrapperLuaCArgs =
    optionalString (resolvedExtraLuaPackages != [])
    ''--suffix LUA_CPATH ";" "${concatMapStringsSep ";" luaPackages.getLuaCPath resolvedExtraLuaPackages}"'';

  # Add blink-fuzzy-lib to LUA_CPATH for Rust fuzzy matching
  # Uses lib?.so pattern since the library is named libblink_cmp_fuzzy.so
  blinkFuzzyLuaCArgs =
    optionalString (blink-fuzzy-lib != null)
    ''--suffix LUA_CPATH ";" "${blink-fuzzy-lib}/lib/lib?.so"'';

  extraMakeWrapperLuaArgs =
    optionalString (resolvedExtraLuaPackages != [])
    ''--suffix LUA_PATH ";" "${concatMapStringsSep ";" luaPackages.getLuaPath resolvedExtraLuaPackages}"'';

  neovim-wrapped = pkgs-wrapNeovim.wrapNeovimUnstable neovim-unwrapped (neovimConfig
    // {
      luaRcContent = initLua;
      wrapperArgs =
        escapeShellArgs neovimConfig.wrapperArgs
        + " "
        + extraMakeWrapperArgs
        + " "
        + extraMakeWrapperLuaCArgs
        + " "
        + extraMakeWrapperLuaArgs
        + " "
        + blinkFuzzyLuaCArgs;
      wrapRc = true;
    });

  isCustomAppName = appName != null && appName != "nvim";
in
  neovim-wrapped.overrideAttrs (oa: {
    buildPhase =
      oa.buildPhase
      + lib.optionalString isCustomAppName ''
        mv $out/bin/nvim $out/bin/${lib.escapeShellArg appName}
      '';
    meta.mainProgram =
      if isCustomAppName
      then appName
      else oa.meta.mainProgram;
  })
