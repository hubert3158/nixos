# raea — "Render Anything Engine": React/TypeScript compositions rendered on the
# GPU (Rust + Bevy). https://github.com/shinyobjectz/raea
#
# Not in nixpkgs. Packaged from the upstream prebuilt linux-x86_64 tarball
# instead of the `curl | sh` installer (which writes ~/.raea, ~/.local/bin and
# ~/.claude/skills outside this config). Version + src come from nvfetcher; see
# packages/nvfetcher.toml. Upstream is a daily canary: expect frequent bumps.
#
# The binaries find share/raea relative to their own path (current_exe), so the
# tarball's bin/ + share/ layout is kept as-is under $out.
{ lib
, stdenv
, sources
, autoPatchelfHook
, alsa-lib
, fontconfig
, udev
, libxkbcommon
, libx11
, libxcb
, libxcursor
, libxi
, libxrandr
, wayland
, vulkan-loader
, libGL
}:

let
  # winit/wgpu dlopen these at runtime; they're not in NEEDED, so autoPatchelf
  # can't see them (README lists the same set for app windows).
  runtimeDeps = [
    libxkbcommon
    libx11
    libxcb
    libxcursor
    libxi
    libxrandr
    wayland
    vulkan-loader
    libGL
  ];
in
stdenv.mkDerivation {
  inherit (sources.raea) pname version src;

  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [ stdenv.cc.cc.lib alsa-lib fontconfig udev ];

  appendRunpaths = map (p: "${lib.getLib p}/lib") runtimeDeps;

  # Multi-GB release binaries: stripping buys nothing and risks breaking them.
  dontStrip = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -R bin share $out/
    chmod 755 $out/bin/raea $out/bin/raea-*
    runHook postInstall
  '';

  meta = {
    description = "Render Anything Engine: videos, motion graphics, 3D and games as React/TypeScript, rendered on the GPU";
    homepage = "https://github.com/shinyobjectz/raea";
    changelog = "https://github.com/shinyobjectz/raea/releases/tag/v${sources.raea.version}";
    license = lib.licenses.fsl11Asl20;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "raea";
  };
}
