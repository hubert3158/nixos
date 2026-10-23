# storytold "*craft" office apps (https://github.com/storytold) packaged from the
# upstream prebuilt linux-x86_64 release tarballs.
#
# Why not nixpkgs:
#   - pdfcraft: not in nixpkgs yet (open PR NixOS/nixpkgs#571437, init at 0.11.0).
#   - gridcraft: in nixpkgs (0.8.0) but 404 on cache.nixos.org at our pinned rev
#     AND at the nixpkgs-unstable channel rev — a from-source build of a large
#     Rust/wgpu workspace. Hydra has a green build only on a newer master rev.
# wordcraft is cached in nixpkgs and comes from there (packages.nix), not here.
#
# Check before bumping: `p.gridcraft` / `p.pdfcraft` cached (200)? -> drop that
# entry and use the nixpkgs attr. See packages/MANUAL_UPDATES.md.
#
# The binaries only NEED glibc; winit/wgpu/rfd dlopen wayland/x11/vulkan/dbus at
# runtime, so those go on the rpath by hand (same list nixpkgs' wordcraft uses).
{ lib
, stdenv
, fetchurl
, autoPatchelfHook
, copyDesktopItems
, makeDesktopItem
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
    , hash
    , description
    , desktopItems ? [ ]   # only for tarballs that ship no share/applications
    }:
    stdenv.mkDerivation {
      inherit pname version description desktopItems;

      src = fetchurl {
        url = "https://github.com/storytold/${pname}/releases/download/v${version}/${pname}-${version}-linux-x86_64.tar.gz";
        inherit hash;
      };

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
  pdfcraft = mkCraft {
    pname = "pdfcraft";
    version = "0.13.0";
    hash = "sha256-WYUZ6ivHfGbKmpBiQeH+Psz3RfUGJ84829W15nWkVtM=";
    description = "Read, organize, combine, split and secure PDFs";
    # tarball ships metainfo + icons but no .desktop
    desktopItems = [
      (makeDesktopItem {
        name = "ai.storyteller.pdfcraft";
        desktopName = "PdfCraft";
        genericName = "PDF Viewer";
        comment = "Read, organize, combine, split and secure PDFs";
        exec = "pdfcraft %F";
        tryExec = "pdfcraft";
        icon = "ai.storyteller.pdfcraft";
        terminal = false;
        startupNotify = true;
        startupWMClass = "ai.storyteller.pdfcraft";
        categories = [ "Office" "Viewer" ];
        keywords = [ "pdf" "document" "reader" "merge" "split" ];
        mimeTypes = [ "application/pdf" ];
      })
    ];
  };

  gridcraft = mkCraft {
    pname = "gridcraft";
    version = "0.11.1";
    hash = "sha256-8sg+bCZEmmxFmD6QO/MsHUwwKyBC8mPq2ZUnESnHDoc=";
    description = "Spreadsheet app with XLSX, CSV and TSV support";
    # tarball ships its own .desktop + mime + icons
  };
}
