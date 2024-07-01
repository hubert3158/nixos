{
  description = "NixOS configuration with Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
  };

  outputs = { self, nixpkgs, home-manager }: {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
         ./configuration.nix
          (import (if builtins.getEnv "NIXOS_PROFILE" == "work" then ./configuration-work.nix else ./configuration-home.nix))
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            #home-manager.users.hubert = import ./home-manager-home.nix;
            home-manager.users.hubert = import (if builtins.getEnv "NIXOS_PROFILE" == "work" then ./home-manager-work.nix else ./home-manager-home.nix);

          }
        ];
      };
    };
  };
}

