{
  description = "NixOS configuration with Home Manager and Neovim using nixvim";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    flake-utils.url = "github:numtide/flake-utils";
    gen-luarc.url = "github:mrcjkb/nix-gen-luarc-json";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ { self, nixpkgs, home-manager, flake-utils, gen-luarc, nixvim, flake-parts, ... }: let
    supportedSystems = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
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
              };
              packages = import ./home-manager-work.nix { inherit pkgs; };
              nixvimLib = nixvim.lib."x86_64-linux";
              nixvim' = nixvim.legacyPackages."x86_64-linux";
              nixvimModule = {
                inherit pkgs;
                module = import ./config; # Import the entire config folder
                extraSpecialArgs = {
                  # Add any extra arguments you need for the module
                  exampleArg = "exampleValue";
                };
              };
              nvim = nixvim'.makeNixvimWithModule nixvimModule;
            in
              packages // {
                # Add nvim from nixvim
                home.packages = with pkgs; [
                  nvim
                ];
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
              };
              packages = import ./home-manager-home.nix { inherit pkgs; };
              nixvimLib = nixvim.lib."x86_64-linux";
              nixvim' = nixvim.legacyPackages."x86_64-linux";
              nixvimModule = {
                inherit pkgs;
                module = import ./config; # Import the entire config folder
                extraSpecialArgs = {
                  # Add any extra arguments you need for the module
                  exampleArg = "exampleValue";
                };
              };
              nvim = nixvim'.makeNixvimWithModule nixvimModule;
            in
              packages // {
                # Add nvim from nixvim
                home.packages = with pkgs; [
                  nvim
                ];
              };
          }
        ];
      };
    };
  };
}

