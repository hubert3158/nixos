# CocoIndex — prebuilt manylinux wheel from PyPI
# Upstream PyO3/maturin Rust core makes source build heavy; the abi3 wheel
# works on any CPython >= 3.11. Update version + hash to bump.
{ lib
, python3
, fetchurl
, autoPatchelfHook
, stdenv
, zlib
, openssl
}:

python3.pkgs.buildPythonApplication rec {
  pname = "cocoindex";
  version = "1.0.3";
  format = "wheel";

  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/f4/87/502fb337b4d8a821284b1a7c3fd0a06772360a68f2ae955ccb58b719f5cc/cocoindex-${version}-cp311-abi3-manylinux_2_28_x86_64.whl";
    hash = "sha256-eBvGKVnYhHCA83q/OoGVie6vEgyExi57gO9MlR012VA=";
  };

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
    watchfiles
    numpy
    psutil
    msgspec
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
