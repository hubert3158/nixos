{ lib, stdenv, fetchFromGitHub, go }:

stdenv.mkDerivation rec {
  pname = "pug-lsp";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "opa-oz";
    repo = "pug-lsp";
    rev = "v0.1.0";
    sha256 = "0kifa2r37ql37ja145r9bpl2na0yrc456197v0ajqripavrk1n8z";
  };

  buildInputs = [ go ];

  buildPhase = ''
    # Set HOME to the current working directory to avoid permission issues
    export HOME=$(pwd)
    export GOCACHE=$TMPDIR/go-build-cache
    mkdir -p $GOCACHE
    go build -mod=mod -o pug-lsp
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp pug-lsp $out/bin/
  '';

  meta = with lib; {
    description = "Pug language server";
    homepage = "https://github.com/opa-oz/pug-lsp";
    license = licenses.mit;
    platforms = platforms.all;
  };
}

