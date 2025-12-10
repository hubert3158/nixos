# Custom library functions for NixOS configuration
{ inputs, ... }:

let
  inherit (inputs.nixpkgs) lib;
in
rec {
  # Helper to create a NixOS system configuration
  mkHost = {
    hostname,
    system ? "x86_64-linux",
    users ? [ "hubert" ],
    extraModules ? [],
  }: inputs.nixpkgs.lib.nixosSystem {
    inherit system;
    specialArgs = { inherit inputs; };
    modules = [
      # Nixpkgs configuration
      {
        nixpkgs.config = {
          allowUnfree = true;
          permittedInsecurePackages = [
            "emacs-29.4"
          ];
        };
        networking.hostName = hostname;
      }

      # Import all custom NixOS modules
      ../modules/nixos

      # Host-specific configuration
      ../hosts/${hostname}

      # Overlays
      (import ../overlays { inherit inputs; })

      # Home Manager
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager = {
          useUserPackages = true;
          useGlobalPkgs = true;
          backupFileExtension = "backup";
          extraSpecialArgs = { inherit inputs; };
          users = lib.genAttrs users (user: {
            imports = [ ../modules/home-manager ];
          });
        };
      }

      # sops-nix for secrets management
      inputs.sops-nix.nixosModules.sops
    ] ++ extraModules;
  };

  # Helper to iterate over multiple systems
  forAllSystems = inputs.nixpkgs.lib.genAttrs [
    "x86_64-linux"
    "aarch64-linux"
    "x86_64-darwin"
    "aarch64-darwin"
  ];

  # Helper to create package sets for each system
  pkgsFor = system: import inputs.nixpkgs {
    inherit system;
    config.allowUnfree = true;
    overlays = [
      (import ../overlays { inherit inputs; })
      inputs.gen-luarc.overlays.default
    ];
  };
}
