# Open Code — AI coding agent for the terminal
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.programs.opencode;
in {
  options.modules.programs.opencode = {
    enable = lib.mkEnableOption "Open Code AI terminal agent";

    model = lib.mkOption {
      type = lib.types.str;
      default = "anthropic/claude-sonnet-4-20250514";
      description = "Default model for Open Code";
    };

    smallModel = lib.mkOption {
      type = lib.types.str;
      default = "anthropic/claude-haiku-4-5-20251001";
      description = "Small/fast model for sub-agents";
    };

    theme = lib.mkOption {
      type = lib.types.str;
      default = "catppuccin";
      description = "TUI theme";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.opencode = {
      enable = true;

      settings = {
        "$schema" = "https://opencode.ai/config.json";
        model = cfg.model;
        small_model = cfg.smallModel;

        # Nix manages updates — disable auto-update
        autoupdate = false;

        # Privacy — no session sharing
        share = "disabled";

        # Provider config
        provider = {
          anthropic = {
            options = {
              timeout = 600000;
              chunkTimeout = 30000;
              # Key read from ANTHROPIC_API_KEY env or gopass
              apiKey = "{env:ANTHROPIC_API_KEY}";
            };
          };
        };

        # Sensible permissions
        permission = {
          "*" = "ask";
          read = "allow";
          glob = "allow";
          grep = "allow";
          list = "allow";
          lsp = "allow";
          webfetch = "allow";
          websearch = "allow";
          edit = "ask";
          write = "ask";
          bash = {
            "*" = "ask";
            "git *" = "allow";
            "nix *" = "allow";
            "nixos-rebuild *" = "allow";
            "rm *" = "deny";
            "rm -rf *" = "deny";
          };
        };

        # Compaction keeps context efficient
        compaction = {
          auto = true;
          prune = true;
          reserved = 10000;
        };

        # Ignore build artifacts and nix store paths
        watcher = {
          ignore = [
            "node_modules/**"
            "dist/**"
            ".git/**"
            "result/**"
            ".direnv/**"
          ];
        };
      };

      # Global rules
      rules = ''
        # Global Rules for Open Code

        ## NixOS Context
        - This machine runs NixOS with a flake-based configuration
        - Home-manager is integrated as a NixOS module (not standalone)
        - Packages are managed declaratively — never use `npm install -g` or `pip install` system-wide
        - Use `nix shell nixpkgs#<pkg>` for temporary tool access
        - The NixOS config lives at ~/nixos

        ## Code Style
        - Prefer simple, readable code over clever abstractions
        - Follow existing project conventions before introducing new patterns
        - Nix code uses alejandra formatting
      '';
    };

    # TUI configuration (separate from main config)
    xdg.configFile."opencode/tui.json".text = builtins.toJSON {
      "$schema" = "https://opencode.ai/tui.json";
      theme = cfg.theme;
      scroll_speed = 3;
      scroll_acceleration = {enabled = true;};
      diff_style = "auto";
      keybinds = {
        leader = "ctrl+x";
      };
    };
  };
}
