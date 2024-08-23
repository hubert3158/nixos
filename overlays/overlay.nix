self: super: {
  examplePackage = super.pkgs.stdenv.mkDerivation {
    name = "gp.nvim";
    src = self.fetchurl {
      url = "https://github.com/Robitx/gp.nvim.git";
      sha256 = "0v1w2x3y4z5...";
    };
  };
}

