{
  description = "Professional NixOS configuration with modular structure";

  inputs = {
    # Core inputs
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # Pinned nixpkgs for flameshot — flameshot v14 + xdg-desktop-portal-hyprland 1.3.12
    # have a Screenshot interface ABI mismatch (interface declared but not exposed to
    # clients, causing 30s portal timeout). Revisit when nixpkgs ships compatible versions.
    nixpkgs-flameshot.url = "github:NixOS/nixpkgs/13043924aaa7375ce482ebe2494338e058282925";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Utilities
    flake-utils.url = "github:numtide/flake-utils";

    # Neovim development
    gen-luarc.url = "github:mrcjkb/nix-gen-luarc-json";

    # Claude Desktop (aaddrick) — FHS variant w/ MCP + Cowork sandboxing
    claude-desktop = {
      url = "github:aaddrick/claude-desktop-debian";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Kanagawa flavor for yazi (Ink & Wave, docs/THEME.md)
    kanagawa-yazi = {
      url = "github:dangooddd/kanagawa.yazi";
      flake = false;
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    flake-utils,
    gen-luarc,
    ...
  }: let
    # Ink & Wave palette — single machine-readable source of truth for .nix
    # surfaces (docs/THEME.md is the human-readable companion).
    # `colors` re-encodes those hexes for surfaces that don't take #RRGGBB
    # (hyprland rgb(), GTK rgba(), fastfetch SGR escapes, fuzzel bare hex).
    palette = import ./lib/palette.nix;
    colors = import ./lib/color.nix { inherit (nixpkgs) lib; };

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
      specialArgs = { inherit inputs palette colors; };
      modules = [
        # Nixpkgs configuration
        {
          nixpkgs.config = {
            allowUnfree = true;
          };
        }

        # Import all custom NixOS modules
        ./modules/nixos

        # Host-specific configuration
        ./hosts/${hostname}

        # Overlays
        (import ./overlays { inherit inputs; })

        # Home Manager
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useUserPackages = true;
            useGlobalPkgs = true;
            backupFileExtension = "backup";
            extraSpecialArgs = { inherit inputs palette colors; };
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
              modules.desktop.hypridle.enable = true;
              modules.desktop.swayosd.enable = true;
              # hyprpaper retired → swww (awww): animated transitions + `wallpaper` CLI
              modules.desktop.swww.enable = true;
              modules.desktop.i3.enable = true;
              modules.desktop.xdg.enable = true;
              modules.desktop.fuzzel.enable = true;
              modules.desktop.flameshot.enable = true;
              modules.desktop.waybar.enable = true;
              # mako retired → swaync: control center + mpris + sliders
              modules.desktop.swaync.enable = true;
              modules.desktop.wlogout.enable = true;

              modules.programs.git.enable = true;
              modules.programs.lazygit.enable = true;
              modules.programs.ssh.enable = true;
              # Work SSH hosts + private keys decrypted from gopass (repo is
              # public) — work machine only
              modules.programs.ssh.workHostsFromPass = hostname == "work";
              modules.programs.ssh.keysFromPass = hostname == "work";
              modules.programs.gpg.enable = true;
              modules.programs.tmux.enable = true;
              modules.programs.browsers.enable = true;
              modules.programs.media.enable = true;
              modules.programs.nixIndex.enable = true;
              modules.programs.opencode.enable = true;
              modules.programs.emacs.enable = true;
              # daemon disabled — resident emacs server was eating ~340M RAM.
              # Re-enable for instant `emacsclient` startup.
              # modules.programs.emacs.daemon = true;
              modules.programs.helix.enable = true;

              modules.fileManagers.yazi.enable = true;
              modules.fileManagers.ranger.enable = true;

              modules.tools.eza.enable = true;
              modules.tools.bat.enable = true;
              modules.tools.zoxide.enable = true;
              modules.tools.fzf.enable = true;
              modules.tools.htop.enable = true;
              modules.tools.fastfetch.enable = true;
              modules.tools.cava.enable = true;

              modules.packages.enable = true;
              # Heavy Java IDE suite only where Java work happens
              modules.packages.enableJetbrains = hostname == "work";
              # Network/security testing tools (zenmap, bettercap, nmap, ...)
              modules.packages.enablePentest = true;

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
        '';
      };
    });

    # Expose packages
    packages = forAllSystems (system: {
      nvim = (pkgsFor system).nvim-pkg;
    });
  };
}
