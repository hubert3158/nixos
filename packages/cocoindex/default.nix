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
  version = "1.0.7";
  format = "wheel";

  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/9c/b3/f9f494e7293ce07e40c1bdf02cd3d7eb0ace8bcc3b30c6841f9c8e9bd67b/cocoindex-${version}-cp311-abi3-manylinux_2_28_x86_64.whl";
    hash = "sha256-mICRrume6MdmrG1owXEzkUONWZrL9361FagEwjRSNpw=";
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
