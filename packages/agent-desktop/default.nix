# agent-desktop — computer use for AI agents via the OS accessibility tree.
# Not in nixpkgs. The npm package bundles prebuilt binaries for every platform
# and its postinstall picks one, so we fetch the tarball and install the
# linux-x64 pair directly, patched for NixOS. The helper must sit beside the CLI.
{ lib
, stdenv
, sources
, autoPatchelfHook
}:

stdenv.mkDerivation {
  inherit (sources.agent-desktop) pname version src;

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [ stdenv.cc.cc.lib ];

  sourceRoot = "package";

  installPhase = ''
    runHook preInstall
    install -Dm755 bin/agent-desktop-linux-x64 $out/bin/agent-desktop
    install -Dm755 bin/agent-desktop-linux-clipboard-owner-linux-x64 \
      $out/bin/agent-desktop-linux-clipboard-owner
    runHook postInstall
  '';

  meta = with lib; {
    description = "Computer use for AI agents through the OS accessibility tree";
    homepage = "https://github.com/vercel-labs/agent-desktop";
    license = licenses.asl20;
    platforms = [ "x86_64-linux" ];
    mainProgram = "agent-desktop";
  };
}
