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

              packages = import ./home-manager.nix { inherit pkgs; };
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
              };

              packages = import ./home-manager.nix { inherit pkgs; };
            in
              packages;
          }
        ];
      };
    };
  };
}
