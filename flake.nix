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
              pkgs = import nixpkgs { system = "x86_64-linux"; };
              hmConfig = import ./home-manager.nix { inherit pkgs; };
              packages = import ./home-manager-packages.nix { inherit pkgs; };
            in
              hmConfig // packages;
          }
        ];
      };
      home = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          ./home.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.users.hubert = let
              pkgs = import nixpkgs { system = "x86_64-linux"; };
              hmConfig = import ./home-manager.nix { inherit pkgs; };
              packages = import ./home-manager-packages.nix { inherit pkgs; };
            in
             hmConfig // packages;
          }
        ];
      };
    };
  };
}

