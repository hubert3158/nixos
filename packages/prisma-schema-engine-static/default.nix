# Static Prisma schema-engine binary (linux-static-x64)
# Workaround for prisma-engines failing to compile with current Rust (rust-lang/rust#141402)
# This fetches the pre-built static binary from Prisma's CDN instead.
# Update prismaVersion and hash when upgrading Prisma in the project.
{ lib, stdenvNoCC, fetchurl }:

let
  prismaVersion = "7.4.1";
  engineCommit = "55ae170b1ced7fc6ed07a15f110549408c501bb3";
in
stdenvNoCC.mkDerivation {
  pname = "prisma-schema-engine-static";
  version = prismaVersion;

  src = fetchurl {
    url = "https://binaries.prisma.sh/all_commits/${engineCommit}/linux-static-x64/schema-engine.gz";
    hash = "sha256-NOV5uFsNGFHlol57PuaOGLnXBKOznCh0vE0Z0m7fkt8=";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    gunzip -c $src > $out/bin/schema-engine
    chmod +x $out/bin/schema-engine
  '';

  meta = with lib; {
    description = "Prisma schema engine (static binary)";
    homepage = "https://www.prisma.io/";
    license = licenses.asl20;
    platforms = [ "x86_64-linux" ];
  };
}
