# Zsh shell configuration
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.shell.zsh;
in {
  options.modules.shell.zsh = {
    enable = lib.mkEnableOption "Zsh shell";
  };

  config = lib.mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      enableCompletion = true;

      autosuggestion = {
        enable = true;
        highlight = "fg=red,bold,underline";
      };

      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "mvn"
          "docker"
          "kubectl"
          "history-substring-search"
          "colored-man-pages"
          "extract"
        ];
      };

      initContent = ''
        # ---- Vi editing mode ----
        bindkey -v
        export KEYTIMEOUT=1
        # Edit current line in $EDITOR
        autoload -Uz edit-command-line
        zle -N edit-command-line
        bindkey -M vicmd 'v' edit-command-line
        bindkey '^X^E' edit-command-line
        # Vim-like word motions
        autoload -Uz select-word-style
        select-word-style bash
        # History
        setopt INC_APPEND_HISTORY SHARE_HISTORY HIST_FIND_NO_DUPS HIST_IGNORE_DUPS HIST_IGNORE_ALL_DUPS
        HISTSIZE=100000
        SAVEHIST=100000
        # Cursor shape by mode
        function zle-keymap-select {
          case $KEYMAP in
            vicmd)      print -n -- "\e[1 q" ;;
            main|viins) print -n -- "\e[5 q" ;;
          esac
        }
        zle -N zle-keymap-select
        echo -ne '\e[5 q'
        # ---- Autosuggestion Ctrl-F binding ----
        bindkey '^ ' autosuggest-accept  # Ctrl-Space as backup
        bindkey '^F' autosuggest-accept  # Ctrl-F
        # Handy: edit & re-run last command in $EDITOR
        alias fcvim='fc -e "$EDITOR"'
      '';

      profileExtra = ''
              zi() {
                zoxide query -i "$@" | fzf --height 40% --reverse --inline-info | xargs -I {} zoxide cd {}
              }

              zia() {
                zoxide query -i "$@" | fzf --height 40% --reverse --inline-info | xargs -I {} zoxide add {}
              }

                tailf() {
          tail -f "$1" | bat --paging=never --file-name="$1"
        }
      '';
    };
  };
}
