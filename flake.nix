{
  description = "NixOS configuration with Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
  };

  outputs = { self, nixpkgs, home-manager }: {
    nixosConfigurations = {
      work = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit nixpkgs;
        };
        modules = [
          ./configuration.nix
          ./work.nix
          ./hardware-configuration-work.nix
          home-manager.nixosModules.home-manager
          {
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
            in
              packages;
          }
        ];
      };
      home = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit nixpkgs;
        };
        modules = [
          ./configuration.nix
          ./home.nix
          ./hardware-configuration-home.nix
          home-manager.nixosModules.home-manager
          {
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
                overlays = [ (import ./overlays/overlay.nix) ];

              };

              packages = import ./home-manager-home.nix { inherit pkgs; };
              # packages1 = import ./home-manager-home.nix { inherit pkgs; };
            in
            packages;
            # // packages1;
          }
        ];
      };
    };

    homeConfigurations = {
      hubert = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          config = {
            allowUnfree = true;
            allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) [
              "microsoft-edge-stable"
            ];
          };
        };
        modules = [ ./home-manager.nix ];
      };
    };
  };
}

