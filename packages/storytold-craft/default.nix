# storytold "*craft" office apps (https://github.com/storytold) packaged from the
# upstream prebuilt linux-x86_64 release tarballs.
#
# Only gridcraft is left here: nixpkgs has it, but far behind upstream.
# wordcraft, pdfcraft and vectorcraft are cached in nixpkgs (packages.nix).
# Version + src come from nvfetcher; see packages/nvfetcher.toml.
#
# The binaries only NEED glibc; winit/wgpu/rfd dlopen wayland/x11/vulkan/dbus at
# runtime, so those go on the rpath by hand (same list nixpkgs' wordcraft uses).
{ lib
, stdenv
, sources
, autoPatchelfHook
, copyDesktopItems
, libxkbcommon
, libx11
, libxcb
, libxcursor
, libxi
, libxrandr
, wayland
, vulkan-loader
, libGL
, dbus
}:

let
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
    dbus
  ];

  mkCraft =
    { pname
    , version
    , src
    , description
    , desktopItems ? [ ]   # only for tarballs that ship no share/applications
    }:
    stdenv.mkDerivation {
      inherit pname version src description desktopItems;

      nativeBuildInputs = [ autoPatchelfHook copyDesktopItems ];
      buildInputs = [ stdenv.cc.cc.lib ];

      # dlopen'd, not in NEEDED — autoPatchelf can't see them.
      appendRunpaths = map (p: "${lib.getLib p}/lib") runtimeDeps;

      installPhase = ''
        runHook preInstall
        mkdir -p $out
        cp -R bin share $out/
        chmod 755 $out/bin/*
        # upstream .desktop (if shipped) may point at an FHS path
        if [ -d $out/share/applications ]; then
          sed -i -E 's,^(Exec|TryExec)=/usr/(local/)?bin/,\1=,' $out/share/applications/*.desktop
        fi
        runHook postInstall
      '';

      meta = {
        inherit description;
        homepage = "https://github.com/storytold/${pname}";
        changelog = "https://github.com/storytold/${pname}/releases/tag/v${version}";
        license = with lib.licenses; [ mit asl20 ofl ];
        sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
        platforms = [ "x86_64-linux" ];
        mainProgram = pname;
      };
    };
in
{
  gridcraft = mkCraft {
    inherit (sources.gridcraft) pname version src;
    description = "Spreadsheet app with XLSX, CSV and TSV support";
    # tarball ships its own .desktop + mime + icons
  };
}
