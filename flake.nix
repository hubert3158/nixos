{
  description = "NixOS configuration with Home Manager and Neovim";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    flake-utils.url = "github:numtide/flake-utils";
    gen-luarc.url = "github:mrcjkb/nix-gen-luarc-json";
  nixvim.url = "github:nix-community/nixvim";
  };

  outputs = inputs @ { self, nixpkgs, home-manager, flake-utils, gen-luarc,nixvim, ... }: let
    supportedSystems = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];

    # Import the neovim overlay
    # neovim-overlay = import ./nix/neovim-overlay.nix { inherit inputs; };
  in {
    nixosConfigurations = {
      work = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          ./work.nix
          ./hardware-configuration-work.nix
          home-manager.nixosModules.home-manager
          {
             nixpkgs.config.permittedInsecurePackages = [
              "openssl-1.1.1w"
            ];
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.users.hubert = let
              pkgs = import nixpkgs {
                system = "x86_64-linux";
                config = {
                  allowUnfree = true;
                  allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) [
                    "microsoft-edge-stable"
                  ];
                };
                # overlays = [neovim-overlay];
              };
              packages = import ./home-manager-work.nix { inherit pkgs; };
            in
              packages // {
                # Add nvim from the overlay to the user's packages
                # home.packages = [ pkgs.nvim-pkg ];
              };
          }
        ];
      };

      home = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          ./home.nix
          ./hardware-configuration-home.nix
          home-manager.nixosModules.home-manager
          {
             nixpkgs.config.permittedInsecurePackages = [
              "openssl-1.1.1w"
            ];
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.users.hubert = let
              pkgs = import nixpkgs {
                system = "x86_64-linux";
                config = {
                  allowUnfree = true;
                  allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) [
                    "microsoft-edge-stable"
                  ];
                };
                # overlays = [neovim-overlay];
              };
              packages = import ./home-manager-home.nix { inherit pkgs; };
            in
              packages // {
                # Add nvim from the overlay to the user's packages
                # home.packages = [ pkgs.nvim-pkg ];
              };
          }
        ];
      };
    };
  };
}

