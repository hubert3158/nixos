# CCometixLine — Claude Code statusline tool (Rust binary shipped via npm).
# Upstream publishes platform-specific tarballs under @cometix/ccline-<os>-<arch>.
# We fetch the linux-x64 tarball directly and patchelf for NixOS.
{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

stdenv.mkDerivation rec {
  pname = "ccline";
  version = "1.1.2";

  src = fetchurl {
    url = "https://registry.npmjs.org/@cometix/ccline-linux-x64/-/ccline-linux-x64-${version}.tgz";
    hash = "sha256-i9DpPMtbKJAnfdA7xLHlYbvSzQGmQ6RLq9wTirQzRYk=";
  };

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [ stdenv.cc.cc.lib ];

  sourceRoot = "package";

  installPhase = ''
    runHook preInstall
    install -Dm755 ccline $out/bin/ccline
    runHook postInstall
  '';

  meta = with lib; {
    description = "High-performance Claude Code statusline tool";
    homepage = "https://github.com/Haleclipse/CCometixLine";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "ccline";
  };
}
