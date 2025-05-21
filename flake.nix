{
  description = "NixOS configuration with Home Manager and Neovim";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    flake-utils.url = "github:numtide/flake-utils";
    gen-luarc.url = "github:mrcjkb/nix-gen-luarc-json";
    # Consider adding your neovim overlay source as an input if it's external
    # neovim-overlay-src.url = "github:your/neovim-overlay-repo"; # Example
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    flake-utils,
    gen-luarc,
    ...
  }: let
    # Define common home-manager settings
    commonHomeManagerSettings = {
      pkgs,
      lib,
      ...
    }: {
      home-manager.useUserPackages = true;
      home-manager.backupFileExtension = "backup";
      # Add nvim from the (now global) overlay to the user's packages
      # This assumes nvim-pkg is the attribute name exposed by your overlay
      home-manager.users.hubert.home.packages = [pkgs.nvim-pkg];
    };

    # Define system-specific global nixpkgs configuration
    nixpkgsConfigWork = {lib, ...}: {
      nixpkgs.config = {
        allowUnfree = true;
        # Use lib.getName for safer package name checking
        allowUnfreePredicate = pkg:
          builtins.elem (lib.getName pkg) [
          ];
        permittedInsecurePackages = [
          "emacs-29.4"
        ];
      };
    };

    # Define system-specific global nixpkgs configuration (can be same as work if desired)
    nixpkgsConfigHome = {lib, ...}: {
      # neovimOverlay = import ./overlays/default.nix {
      #   pkgs = import nixpkgs {inherit system;};
      # };
      nixpkgs.config = {
        allowUnfree = true;
        allowUnfreePredicate = pkg:
          builtins.elem (lib.getName pkg) [
          ];
        permittedInsecurePackages = [
          "emacs-29.4"
        ];
      };
    };
  in {
    # NixOS Configurations
    nixosConfigurations = {
      work = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        # Special arguments passed to modules
        specialArgs = {inherit inputs;}; # Pass inputs if needed in your modules
        modules = [
          # Global Nixpkgs config for this system
          nixpkgsConfigWork
          # Core configurations
          ./configuration.nix
          ./work.nix
          ./hardware-configuration-work.nix

          (import ./overlays/default.nix {
            inputs = inputs;
          })

          # Home Manager module
          home-manager.nixosModules.home-manager

          # Home Manager user configuration
          {
            # Import common settings
            imports = [commonHomeManagerSettings];

            # Import user-specific settings for 'work'
            # This file should be a function accepting { pkgs, lib, config, ... }
            home-manager.users.hubert = import home-manager-config-files/common.nix;
          }
        ];
      };

      home = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          # Global Nixpkgs config for this system
          nixpkgsConfigHome

          # Core configurations
          ./configuration.nix
          ./home.nix
          ./hardware-configuration-home.nix
          (import ./overlays/default.nix {
            inputs = inputs;
          })
          # Home Manager module
          home-manager.nixosModules.home-manager

          # Home Manager user configuration
          {
            # Import common settings
            imports = [commonHomeManagerSettings];

            # Import user-specific settings for 'home'
            # This file should be a function accepting { pkgs, lib, config, ... }
            home-manager.users.hubert = import home-manager-config-files/common.nix;
          }
        ];
      };
    };

    # Development Shells
    devShells = flake-utils.lib.eachDefaultSystem (
      system: let
        # Create a pkgs instance specifically for the dev shell if needed
        # Apply overlays needed only for development here
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            # neovimOverlay # Include if needed in dev shell
            gen-luarc.overlays.default
          ];
          # Add dev-specific nixpkgs config if necessary
          # config = { ... };
        };
      in {
        default = pkgs.mkShell {
          name = "nvim-devShell";
          # Packages available in the shell
          buildInputs = with pkgs; [
            lua-language-server
            nil # Nix Language Server
            stylua # Lua formatter
            luajitPackages.luacheck # Lua linter
            # Add other dev tools if needed
          ];
          # Shell initialization hook
          shellHook = ''
            # Generate .luarc.json for lua-language-server based on nvim config
            # Ensure nvim-luarc-json attribute exists in pkgs (provided by gen-luarc overlay)
            if [ -f "${pkgs.nvim-luarc-json}" ]; then
              ln -fs "${pkgs.nvim-luarc-json}" .luarc.json
              echo "Created symlink for .luarc.json"
            else
              echo "Warning: nvim-luarc-json not found in pkgs."
            fi
            echo "Entered nvim-devShell"
          '';
        };
      }
    );
  };
}
