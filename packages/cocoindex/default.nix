# CocoIndex — prebuilt manylinux wheel from PyPI
# Upstream PyO3/maturin Rust core makes source build heavy; the abi3 wheel
# works on any CPython >= 3.11. Version + src come from nvfetcher.
{ lib
, python3
, sources
, autoPatchelfHook
, stdenv
, zlib
, openssl
}:

python3.pkgs.buildPythonApplication {
  inherit (sources.cocoindex) pname version src;
  format = "wheel";

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [
    stdenv.cc.cc.lib
    zlib
    openssl
  ];

  propagatedBuildInputs = with python3.pkgs; [
    typing-extensions
    click
    rich
    python-dotenv
    numpy
    psutil
    msgspec
    watchdog
  ];

  pythonImportsCheck = [ "cocoindex" ];

  meta = with lib; {
    description = "Incremental engine for long-horizon agents (Python framework)";
    homepage = "https://github.com/cocoindex-io/cocoindex";
    license = licenses.asl20;
    platforms = [ "x86_64-linux" ];
    mainProgram = "cocoindex";
  };
}
