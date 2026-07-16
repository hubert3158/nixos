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
      dotDir = "${config.xdg.configHome}/zsh";

      autosuggestion = {
        enable = true;
        # fujiGray ghost text — quiet, on-palette (docs/THEME.md)
        highlight = "fg=#727169,italic";
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
        unalias gsd 2>/dev/null

        # ---- fastfetch greeting (kanagawa fetch, tools/fastfetch.nix) ----
        # top-level interactive shells only: skip tmux panes, nested shells,
        # nvim :terminal, and non-interactive contexts
        if [[ -o interactive && -z "$TMUX" && -z "$NVIM" && -z "$_FF_GREETED" ]]; then
          export _FF_GREETED=1
          command -v fastfetch >/dev/null && fastfetch
        fi

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

        # git log compare against default branch
        glc() {
          local base=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@')
          [ -z "$base" ] && base="main"
          git log "$base"... --left-right --oneline "$@"
        }

        # Use kitty's ssh kitten when inside kitty (but not inside tmux)
        if [[ -n "$KITTY_WINDOW_ID" && -z "$TMUX" ]]; then
          alias ssh="kitten ssh"
        fi
      '';

      profileExtra = ''
              # NOTE: no custom zi() here — zoxide ships a built-in interactive `zi`
              # that this used to shadow with a broken duplicate.

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
