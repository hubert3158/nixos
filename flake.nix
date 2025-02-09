{
  description = "NixOS configuration with Home Manager and Neovim";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    flake-utils.url = "github:numtide/flake-utils";
    gen-luarc.url = "github:mrcjkb/nix-gen-luarc-json";
  };

  outputs = inputs @ { self, nixpkgs, home-manager, flake-utils, gen-luarc, ... }: let
    supportedSystems = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];

    # Import overlays correctly
    overlays = [
      (import ./nix/neovim-overlay.nix { inherit inputs; })
      (import ./overlays/posting-overlay.nix) # ✅ Ensure posting-overlay is included
    ];

    # Define pkgs globally with overlays applied
    forAllSystems = f: flake-utils.lib.eachSystem supportedSystems (system:
      f (import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = overlays; # ✅ Apply both overlays globally
      })
    );

  in {
    nixosConfigurations = {
  home = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      ./configuration.nix
      ./home.nix
      ./hardware-configuration-home.nix
      home-manager.nixosModules.home-manager
      {
        nixpkgs.overlays = overlays; # ✅ Apply overlays globally
        nixpkgs.config = {
          allowUnfree = true;
          permittedInsecurePackages = [ "openssl-1.1.1w" ]; # ✅ Allow OpenSSL 1.1.1w
        };
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.hubert = import ./home-manager-home.nix;
      }
    ];
  };
  
  work = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      ./configuration.nix
      ./work.nix
      ./hardware-configuration-work.nix
      home-manager.nixosModules.home-manager
      {
        nixpkgs.config = {
          allowUnfree = true;
          permittedInsecurePackages = [ "openssl-1.1.1w" ]; # ✅ Allow OpenSSL 1.1.1w
        };
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.hubert = import ./home-manager-work.nix;
      }
    ];
  };
};


    # Dev Shells
    devShells = forAllSystems (pkgs: {
      work = pkgs.mkShell {
        name = "nvim-devShell";
        buildInputs = with pkgs; [
          lua-language-server
          nil
          stylua
          luajitPackages.luacheck
        ];
        shellHook = ''
          ln -fs ${pkgs.nvim-luarc-json} .luarc.json
        '';
      };
    });
  };
}

