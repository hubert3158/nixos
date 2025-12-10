{
  description = "Professional NixOS configuration with modular structure";

  inputs = {
    # Core inputs
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Secrets management
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Utilities
    flake-utils.url = "github:numtide/flake-utils";

    # Neovim development
    gen-luarc.url = "github:mrcjkb/nix-gen-luarc-json";
    eldritch-nvim = {
      url = "github:eldritch-theme/eldritch.nvim";
      flake = false;
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    sops-nix,
    flake-utils,
    gen-luarc,
    ...
  }: let
    # Supported systems
    supportedSystems = [ "x86_64-linux" "aarch64-linux" ];

    # Helper to generate attrs for each system
    forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

    # Pkgs for each system with overlays
    pkgsFor = system: import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [
        (import ./packages/neovim { inherit inputs; })
        gen-luarc.overlays.default
      ];
    };

    # Helper function to create a NixOS host
    mkHost = hostname: system: nixpkgs.lib.nixosSystem {
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
        }

        # Import all custom NixOS modules
        ./modules/nixos

        # Host-specific configuration
        ./hosts/${hostname}

        # Overlays
        (import ./overlays { inherit inputs; })

        # sops-nix module
        sops-nix.nixosModules.sops

        # Home Manager
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useUserPackages = true;
            useGlobalPkgs = true;
            backupFileExtension = "backup";
            extraSpecialArgs = { inherit inputs; };
            users.hubert = { pkgs, ... }: {
              imports = [ ./modules/home-manager ];

              # Enable all home-manager modules
              modules.shell.zsh.enable = true;
              modules.shell.fish.enable = true;
              modules.shell.starship.enable = true;
              modules.shell.aliases.enable = true;

              modules.terminals.wezterm.enable = true;
              modules.terminals.kitty.enable = true;
              modules.terminals.ghostty.enable = true;

              modules.desktop.hyprland.enable = true;
              modules.desktop.hyprlock.enable = true;
              modules.desktop.hyprpaper.enable = true;
              modules.desktop.i3.enable = true;
              modules.desktop.xdg.enable = true;
              modules.desktop.fuzzel.enable = true;
              modules.desktop.flameshot.enable = true;

              modules.programs.git.enable = true;
              modules.programs.ssh.enable = true;
              modules.programs.gpg.enable = true;
              modules.programs.tmux.enable = true;
              modules.programs.neovim.enable = true;
              modules.programs.browsers.enable = true;
              modules.programs.media.enable = true;
              modules.programs.nixIndex.enable = true;

              modules.fileManagers.yazi.enable = true;
              modules.fileManagers.ranger.enable = true;

              modules.tools.eza.enable = true;
              modules.tools.bat.enable = true;
              modules.tools.zoxide.enable = true;
              modules.tools.fzf.enable = true;
              modules.tools.htop.enable = true;

              modules.packages.enable = true;

              # Add nvim-pkg from overlay
              home.packages = [ pkgs.nvim-pkg ];
            };
          };
        }
      ];
    };

  in {
    # NixOS configurations for each host
    nixosConfigurations = {
      work = mkHost "work" "x86_64-linux";
      home = mkHost "home" "x86_64-linux";
    };

    # Development shells
    devShells = forAllSystems (system: let
      pkgs = pkgsFor system;
    in {
      default = pkgs.mkShell {
        name = "nixos-devShell";
        buildInputs = with pkgs; [
          # Nix tools
          nil
          alejandra
          nixpkgs-fmt

          # Lua tools (for Neovim config)
          lua-language-server
          stylua
          luajitPackages.luacheck

          # Secrets management
          sops
          age
          ssh-to-age
        ];

        shellHook = ''
          # Generate .luarc.json for lua-language-server
          if [ -f "${pkgs.nvim-luarc-json}" ]; then
            ln -fs "${pkgs.nvim-luarc-json}" .luarc.json
            echo "Created symlink for .luarc.json"
          fi
          echo "Entered NixOS development shell"
          echo ""
          echo "Available commands:"
          echo "  nixos-rebuild build --flake .#work   - Build work config"
          echo "  nixos-rebuild build --flake .#home   - Build home config"
          echo "  sops secrets/secrets.yaml            - Edit secrets"
        '';
      };
    });

    # Expose packages
    packages = forAllSystems (system: {
      nvim = (pkgsFor system).nvim-pkg;
    });
  };
}
