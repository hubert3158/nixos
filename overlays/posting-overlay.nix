self: super: {
  posting = super.python3Packages.buildPythonPackage rec {
    pname = "posting";
    version = "2.3.0"; # Check latest version
    src = super.fetchPypi {
      inherit pname version;
      sha256 = "065varhnqwyc1qmmavm2w9ig40rj9inq52cch5yr6rrvwsnidmk9"; # Replace with actual hash
    };
    doCheck = false;
  };
}

