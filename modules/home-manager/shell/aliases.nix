# Shell aliases configuration
{ config, lib, pkgs, ... }:

let
  cfg = config.modules.shell.aliases;
in
{
  options.modules.shell.aliases = {
    enable = lib.mkEnableOption "shell aliases";
  };

  config = lib.mkIf cfg.enable {
    home.shellAliases = {
      # Git aliases
      "gs" = "git status";
      "gaa" = "git add .";
      "gp" = "git push";
      "gl" = "git pull";
      "gd" = "git diff";
      "gwip" = "git commit -m \"wip\"";

      # Editor aliases
      "v" = "nvim";
      "vi" = "nvim";

      # File manager aliases
      "r" = "ranger";
      "y" = "yazi";

      # Navigation
      "cd" = "z";

      # Utilities
      "cat" = "bat";
      "man" = "batman";
      "open" = "xdg-open";

      # Eza (ls replacement)
      "l" = "eza --icons --group-directories-first --git --header --time-style=iso --color=always";
      "ll" = "eza -l --icons --group-directories-first --git --header --time-style=iso --color=always";
      "la" = "eza -la --icons --group-directories-first --git --header --time-style=iso --color=always";
      "lt" = "eza --tree --icons --level=2 --group-directories-first --git --time-style=iso --color=always";

      # Screenshots
      "ss" = "sleep 2 && flameshot gui";

      # Python
      "p" = "python";

      # FZF file finder
      "f" = ''
        fzf \
        -i \
        --margin 5% --padding 5% --border --preview 'cat {}' \
        --bind 'enter:execute(nvim {})' \
        --color bg:#222222,preview-bg:#333333
      '';

      # Git restore with FZF
      "gr" = ''
        git status --porcelain | fzf --height 40% --border | awk '{print $2}' | xargs git restore
      '';

      # History search with FZF
      "h" = ''
        selected=$(fc -l 1 | fzf \
          --tac \
          --height 60% \
          --border rounded \
          --margin 2% \
          --padding 1% \
          --preview 'echo {2..} | fold -w $((COLUMNS-20))' \
          --preview-window 'down:3:wrap' \
          --bind 'ctrl-y:execute-silent(echo {2..} | wl-copy)+abort' \
          --bind 'ctrl-e:execute(echo {2..} > /tmp/fzf-cmd && nvim /tmp/fzf-cmd)+abort' \
          --header '󰋚 History Search | ENTER: execute, CTRL-Y: copy, CTRL-E: edit, ESC: cancel' \
          --prompt '󰞷 ' \
          --pointer '󰁕' \
          --color 'header:italic:underline,label:blue,prompt:cyan,pointer:green,marker:yellow' \
          | sed 's/^[ ]*[0-9]*[ ]*//')
        if [[ -n "$selected" ]]; then
          print -s "$selected"
          eval "$selected"
        fi
      '';

      # Cleanup aliases
      "clean-hm" = "nix-env -v --delete-generations +10 --profile ~/.local/state/nix/profiles/home-manager && nix-collect-garbage -v -d";
      "clean-system" = "sudo nix-env -v --delete-generations +10 --profile /nix/var/nix/profiles/system && sudo nix-collect-garbage -v -d";
      "clean-all" = ''
        nix-env -v --delete-generations +10 --profile ~/.local/state/nix/profiles/home-manager && \
        sudo nix-env -v --delete-generations +10 --profile /nix/var/nix/profiles/system && \
        sudo nix-collect-garbage -v -d && \
        sudo nix-store --optimise
      '';
    };
  };
}
