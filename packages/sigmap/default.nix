# SigMap — zero-dependency AI context engine (Node 18+).
# npm pkg ships standalone .js bundles with `#!/usr/bin/env node` shebangs.
# We unpack the tarball, install the JS files, and wrap with nix-provided nodejs.
{ lib
, stdenvNoCC
, fetchurl
, nodejs
, makeWrapper
}:

stdenvNoCC.mkDerivation rec {
  pname = "sigmap";
  version = "6.10.12";

  src = fetchurl {
    url = "https://registry.npmjs.org/sigmap/-/sigmap-${version}.tgz";
    hash = "sha256-s2RpWKZNAG1+OLKaGd/lqctqInxsk0rfmDi0cx8B4Zg=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    libDir=$out/lib/node_modules/sigmap
    mkdir -p "$libDir" $out/bin
    cp -r ./* "$libDir/"

    for bin in sigmap gen-context gen-project-map; do
      case "$bin" in
        sigmap|gen-context) script="gen-context.js" ;;
        gen-project-map)    script="gen-project-map.js" ;;
      esac
      makeWrapper ${nodejs}/bin/node "$out/bin/$bin" \
        --add-flags "$libDir/$script"
    done

    runHook postInstall
  '';

  meta = with lib; {
    description = "Zero-dependency AI context engine (97% token reduction)";
    homepage = "https://github.com/manojmallick/sigmap";
    license = licenses.mit;
    platforms = platforms.unix;
    mainProgram = "sigmap";
  };
}
