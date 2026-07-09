;;; init.el -*- lexical-binding: t; -*-

;; This file controls which Doom modules are enabled. After editing it run
;; `doom sync` on the command line, then restart Emacs.
;; Press 'K' on a module name (in evil/normal mode) for its documentation,
;; or 'gd' to jump to its source. Full reference: 'SPC h d h'.

(doom! :input
       ;;chinese
       ;;japanese
       ;;layout

       :completion
       (corfu +orderless)      ; in-buffer completion popups
       (vertico +icons)        ; the search/command UI (SPC, M-x, find-file)

       :ui
       doom                    ; the default look
       doom-dashboard          ; the startup splash screen
       hl-todo                  ; highlight TODO/FIXME/etc (todo-comments)
       indent-guides           ; indent-blankline equivalent
       (ligatures)             ; pretty programming ligatures
       modeline                ; a fancier status bar (lualine)
       ophints                 ; highlight regions on yank/delete
       (popup +defaults)       ; tame stray windows
       (treemacs +lsp)         ; neo-tree-style file sidebar ('SPC o p')
       vc-gutter               ; git diff in the fringe (gitsigns)
       workspaces              ; tab-like workspaces

       :editor
       (evil +everywhere)      ; <<< vim keybindings, everywhere. This is "evil".
       file-templates          ; auto-snippets for new files
       fold                    ; code folding
       (format +onsave)        ; auto-format on save
       snippets                ; my elisp snippets

       :emacs
       dired                   ; the Emacs file manager
       electric                ; smart indentation
       undo                    ; persistent, branching undo
       vc                      ; version-control glue

       :term
       vterm                   ; a real terminal in Emacs

       :checkers
       syntax                  ; on-the-fly syntax checking

       :tools
       debugger                ; DAP debugging (nvim-dap / dap-ui equiv; dape backend, no flags)
       (docker +lsp)           ; Dockerfile LSP (docker-langserver) + hadolint
       (eval +overlay)         ; run code inline
       lookup                  ; jump-to-definition / docs
       lsp                     ; language-server support (lsp-mode backend)
       magit                   ; the best git porcelain there is
       tree-sitter             ; treesitter highlighting + text objects

       :lang
       (cc +lsp)               ; c/c++ via clangd + clang-format
       data                    ; xml/csv and friends
       emacs-lisp              ; configuring Emacs itself
       (go +lsp)               ; gopls + goimports + delve
       (graphql +lsp +tree-sitter) ; graphql-lsp
       (java +lsp)             ; jdtls
       (javascript +lsp +tree-sitter) ; js/ts/jsx/tsx — ts-ls + eslint + prettier
       (json +lsp)             ; vscode-json-language-server
       (lua +lsp)              ; lua-language-server
       (markdown)              ; writing
       (nix +lsp)              ; this very config (nil/nixd)
       (python +lsp +pyright)  ; pyright language server
       (rust +lsp +tree-sitter) ; rust-analyzer + rustfmt + clippy + codelldb
       (sh +lsp)               ; bash-language-server
       (web +lsp)              ; html/css/scss/less/vue — cssls/html-ls/volar
       (yaml +lsp)             ; yaml-language-server + yamllint

       :config
       (default +bindings +smartparens))
