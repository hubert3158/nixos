# Legacy Preeti-encoded Nepali fonts, needed to open designs that use them
# (Latin codepoints map to Devanagari glyphs; Unicode fonts can't stand in).
#
# Fetched by pinned hash rather than vendored: the upstream README gives no
# license, so the binaries stay out of this public repo.
{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
}: let
  fonts = [
    {
      zip = "ARAP_002.zip";
      hash = "sha256-XJaErbAwaX7v1b6bKIxLeuX0Nz5Nahqi/JHnUrTtjPY=";
    }
    {
      zip = "ARAP_008.zip";
      hash = "sha256-IoUTQ8ZDjqeqCcK1y4Gyi+QkcmS9YJa9DeVNEqRmz9c=";
    }
    {
      zip = "001__Arap_Graphic.zip";
      hash = "sha256-r+gz5hw0hd2DHbDcfzTbmJuYXZaCTmcYZ7WdrOgoLjs=";
    }
  ];

  zips = map (font:
    fetchurl {
      url = "https://assets.anepali.com/fonts/${font.zip}";
      inherit (font) hash;
    })
  fonts;
in
  stdenvNoCC.mkDerivation {
    pname = "nepali-fonts";
    version = "0-unstable-2026-11-06";

    srcs = zips;
    dontUnpack = true;

    nativeBuildInputs = [unzip];

    installPhase = ''
      runHook preInstall

      dest=$out/share/fonts/truetype/nepali
      mkdir -p "$dest" extracted

      for zip in $srcs; do
        unzip -j -o "$zip" '*.TTF' -d extracted
      done

      # Upstream names have spaces and an uppercase extension; normalise them
      # so the fonts.fontDir link step picks them up.
      for font in extracted/*.TTF; do
        name=$(basename "$font" .TTF | tr -d ' ')
        install -Dm444 "$font" "$dest/$name.ttf"
      done

      runHook postInstall
    '';

    meta = {
      description = "Legacy Preeti-encoded Nepali fonts (ARAP 002, ARAP 008, 001 Arap Graphic)";
      homepage = "https://www.anepali.com/font/arap-002/";
      license = lib.licenses.unfree;
      platforms = lib.platforms.all;
    };
  }
