;;; config.el -*- lexical-binding: t; -*-

;; Your personal Doom config. Loaded after all modules. Safe to edit freely;
;; run `doom sync` only when you add packages (packages.el) or change init.el.
;; Anything you'd normally put in ~/.emacs.d goes here instead.

;; --- identity (used by templates, snippets, magit) -------------------------
(setq user-full-name "hubert"
      user-mail-address "subash@smartmca.com")

;; --- look ------------------------------------------------------------------
;; Pick a font you have installed. `doom install` offers to install the
;; Nerd/Symbola fonts Doom's UI wants. List faces with 'SPC h t' (load-theme).
(setq doom-theme 'doom-one)

;; Relative line numbers play nicely with evil's count motions (e.g. 5j).
(setq display-line-numbers-type 'relative)

;; --- evil quality-of-life --------------------------------------------------
;; Keep evil's normal/insert state but make some Emacs reflexes less surprising.
(after! evil
  ;; jk to escape insert mode is a common vim-ism; uncomment if you want it:
  ;; (define-key evil-insert-state-map "j" #'evil-escape)
  (setq evil-want-fine-undo t            ; undo insert in smaller chunks
        evil-vsplit-window-right t       ; new vsplit opens on the right
        evil-split-window-below t))      ; new split opens below

;; --- where to find projects ------------------------------------------------
;; 'SPC SPC' finds files in the current project; 'SPC p p' switches projects.
(setq projectile-project-search-path '("~/" "~/nixos"))

;; Handy: 'SPC h' = help, 'SPC f p' = open this private config dir.

;; --- completion: make corfu behave like blink-cmp --------------------------
;; Eager auto-popup (1 char, fast) + C-j/C-k nav, matching your Neovim keymap.
(after! corfu
  (setq corfu-auto t                    ; pop up automatically as you type
        corfu-auto-delay 0.1            ; nearly instant (blink-cmp feel)
        corfu-auto-prefix 1             ; trigger after the FIRST character
        corfu-preview-current t         ; inline preview of the selection
        corfu-popupinfo-delay '(0.3 . 0.2))
  (corfu-popupinfo-mode +1)             ; show doc panel beside candidates
  (define-key corfu-map (kbd "C-j") #'corfu-next)
  (define-key corfu-map (kbd "C-k") #'corfu-previous))

;; Always-on completion sources (blink-cmp ships buffer-words + paths by
;; default; Corfu doesn't). Cape ships with Doom's corfu module — just wire it.
(after! cape
  (add-to-list 'completion-at-point-functions #'cape-dabbrev) ; words in buffers
  (add-to-list 'completion-at-point-functions #'cape-file))   ; file paths
(add-hook 'prog-mode-hook
          (lambda ()
            (add-hook 'completion-at-point-functions #'cape-dabbrev 90 t)))

;; --- nvim-colorizer: show colors inline in CSS/web/conf buffers ------------
(use-package! rainbow-mode
  :hook ((css-mode scss-mode web-mode html-mode conf-mode) . rainbow-mode))


;;; ============================================================================
;;; Language parity with Neovim — append to ~/.config/doom/config.el
;;; lsp-mode backend (no +eglot), flycheck (no +flymake), apheleia (format +onsave),
;;; dape (NOT dap-mode) for :tools debugger.
;;; ============================================================================

;;; ---- JS / TS / JSX / TSX ---------------------------------------------------
;; Format on save with prettierd (daemon) like Neovim conform.
(after! apheleia
  (setf (alist-get 'prettierd apheleia-formatters) '("prettierd" filepath))
  (dolist (mode '(js-mode js-ts-mode typescript-mode typescript-ts-mode tsx-ts-mode))
    (setf (alist-get mode apheleia-mode-alist) 'prettierd)))

;; Node/JS debugging via dape -> nix vscode-js-debug `js-debug` binary.
(after! dape
  (add-to-list 'dape-configs
               `(js-debug-launch
                 modes (js-mode js-ts-mode typescript-mode typescript-ts-mode tsx-ts-mode)
                 host "localhost"
                 command "js-debug"
                 command-args (:autoport)
                 port :autoport
                 :type "pwa-node" :request "launch"
                 :cwd dape-cwd-fn :program dape-buffer-default
                 :console "internalConsole"))
  (add-to-list 'dape-configs
               `(js-debug-attach
                 modes (js-mode js-ts-mode typescript-mode typescript-ts-mode tsx-ts-mode)
                 host "localhost"
                 command "js-debug"
                 command-args (:autoport)
                 port :autoport
                 :type "pwa-node" :request "attach" :port 9229
                 :cwd dape-cwd-fn)))

;;; ---- Web: HTML / CSS / SCSS / LESS / Vue -----------------------------------
(after! apheleia
  (setf (alist-get 'prettier-less apheleia-formatters)
        '("apheleia-npx" "prettier" "--stdin-filepath" filepath "--parser=less"
          (apheleia-formatters-js-indent "--use-tabs" "--tab-width")))
  (add-to-list 'apheleia-mode-alist '(less-css-mode . prettier-less)))
;; Pin prettier per-mode so (format +onsave)'s lsp-toggle doesn't hand formatting
;; to cssls/html-ls (which ignore .prettierrc). Matches Neovim conform.
(setq-hook! '(css-mode-hook css-ts-mode-hook) apheleia-formatter 'prettier-css)
(setq-hook! 'scss-mode-hook                   apheleia-formatter 'prettier-scss)
(setq-hook! 'less-css-mode-hook               apheleia-formatter 'prettier-less)
(setq-hook! '(web-mode-hook html-mode-hook html-ts-mode-hook mhtml-mode-hook)
            apheleia-formatter 'prettier)
;; Vue/Volar is registered :add-on? to ts-ls, so it needs typescript-language-server.
(after! lsp-volar
  (setq lsp-volar-typescript-server-id 'ts-ls))

;;; ---- Data: JSON / YAML / TOML / XML ----------------------------------------
;; TOML: no Doom module turns on a LSP; lsp-mode ships the taplo client + apheleia
;; already maps the toml modes to taplo. Just fire lsp! in TOML buffers.
(add-hook 'conf-toml-mode-local-vars-hook #'lsp! 'append)
(when (fboundp 'toml-ts-mode)
  (add-hook 'toml-ts-mode-local-vars-hook #'lsp! 'append))
;; YAML: keep yamllint running alongside yaml-language-server (Neovim parity).
;; Guarded so it never errors if flycheck loads before lsp registers the 'lsp checker.
(after! (lsp-mode flycheck)
  (when (flycheck-valid-checker-p 'lsp)
    (flycheck-add-next-checker 'lsp '(warning . yaml-yamllint))))

;;; ---- Rust ------------------------------------------------------------------
(after! lsp-rust
  (setq lsp-rust-analyzer-cargo-watch-enable t
        lsp-rust-analyzer-cargo-watch-command "clippy"
        lsp-rust-features "all"
        lsp-rust-analyzer-proc-macro-enable t
        lsp-rust-analyzer-cargo-run-build-scripts t))
;; Run `cargo run` in an interactive comint buffer so programs that read stdin
;; (e.g. `std::io::stdin().read_line(...)`) can be typed into. Default rustic
;; uses a read-only compilation buffer that can't forward keystrokes.
(setq rustic-cargo-run-use-comint t)
;; Rust DAP via codelldb (vscode-lldb) — dape only ships plain lldb-dap by default.
(after! dape
  (let* ((ext (getenv "CODELLDB_PATH"))
         (adapter (and ext (expand-file-name "adapter/codelldb" ext))))
    (when (and adapter (file-executable-p adapter))
      (add-to-list 'dape-configs
                   `(codelldb-rust
                     modes (rust-mode rust-ts-mode rustic-mode)
                     ensure dape-ensure-command
                     command ,adapter
                     command-args ("--port" :autoport)
                     command-cwd dape-command-cwd
                     port :autoport
                     compile "cargo build"
                     :type "lldb" :request "launch" :cwd "."
                     :program "target/debug/")))))

;;; ---- Go --------------------------------------------------------------------
;; goimports (gofmt + manage imports) instead of apheleia's default gofmt.
(after! apheleia
  (when (executable-find "goimports")
    (setf (alist-get 'go-mode apheleia-mode-alist) 'goimports)
    (setf (alist-get 'go-ts-mode apheleia-mode-alist) 'goimports)))

;;; ---- C / C++ ---------------------------------------------------------------
(after! lsp-clangd
  (setq lsp-clients-clangd-args
        '("--background-index" "--clang-tidy" "--completion-style=detailed"
          "--header-insertion=iwyu" "--header-insertion-decorators=0"))
  (set-lsp-priority! 'clangd 2))   ; prefer clangd over also-installed ccls
(after! dape
  (let ((codelldb (and (getenv "CODELLDB_PATH")
                       (expand-file-name "adapter/codelldb" (getenv "CODELLDB_PATH")))))
    (when (and codelldb (file-executable-p codelldb))
      (add-to-list 'dape-configs
                   `(codelldb-cc
                     modes (c-mode c-ts-mode c++-mode c++-ts-mode)
                     ensure dape-ensure
                     command ,codelldb
                     command-args ("--port" :autoport)
                     port :autoport
                     :type "lldb" :request "launch" :cwd "."
                     :program (lambda () (expand-file-name (read-file-name "Program: ")))
                     :args [])))))

;;; ---- Python ----------------------------------------------------------------
;; isort -> black chain (apheleia default is black only); matches Neovim conform.
(after! apheleia
  (setf (alist-get 'python-mode apheleia-mode-alist) '(isort black))
  (setf (alist-get 'python-ts-mode apheleia-mode-alist) '(isort black)))
;; flake8 after the lsp checker so pyright + flake8 coexist (Neovim parity).
(after! lsp-mode
  (after! flycheck
    (flycheck-add-next-checker 'lsp '(warning . python-flake8))))

;;; ---- GraphQL (handled by (graphql +lsp +tree-sitter)) + SQL (hand-wired) ---
;; SQL: no :lang sql Doom module — wire built-in sql-mode + lsp-mode's sqls client.
(after! sql
  (add-hook 'sql-mode-local-vars-hook #'lsp! 'append))
;; pg_format on save: re-enable sql-mode (Doom disables it) and pin pgformatter.
(after! apheleia
  (setq +format-on-save-disabled-modes
        (delq 'sql-mode +format-on-save-disabled-modes))
  (add-hook 'sql-mode-hook
            (defun +sql-pin-pgformatter-h ()
              (setq-local apheleia-formatter 'pgformatter))))
;; sqlfluff (postgres) flycheck checker — flycheck core ships none.
(after! flycheck
  (defun +sqlfluff-error-parser (output checker buffer)
    "Parse sqlfluff `--format json' OUTPUT into flycheck errors."
    (let (errors)
      (dolist (file (ignore-errors
                      (json-parse-string output :object-type 'alist :array-type 'list)))
        (dolist (v (alist-get 'violations file))
          (let ((line (or (alist-get 'start_line_no v) (alist-get 'line_no v) 1))
                (col  (or (alist-get 'start_line_pos v) (alist-get 'line_pos v) 1))
                (code (or (alist-get 'code v) ""))
                (desc (or (alist-get 'description v) "")))
            (push (flycheck-error-new-at
                   line col (if (string-prefix-p "PRS" code) 'error 'warning)
                   (format "%s [%s]" desc code)
                   :checker checker :buffer buffer
                   :filename (buffer-file-name buffer))
                  errors))))
      (nreverse errors)))
  (flycheck-define-checker sql-sqlfluff
    "A SQL linter using sqlfluff with the postgres dialect."
    :command ("sqlfluff" "lint" "--dialect" "postgres" "--format" "json" "-")
    :standard-input t
    :error-parser +sqlfluff-error-parser
    :modes (sql-mode))
  (add-to-list 'flycheck-checkers 'sql-sqlfluff))
(after! (lsp-mode flycheck)
  (when (flycheck-valid-checker-p 'lsp)
    (let ((nexts (flycheck-checker-get 'lsp 'next-checkers)))
      (unless (or (memq 'sql-sqlfluff nexts) (rassq 'sql-sqlfluff nexts))
        (flycheck-add-next-checker 'lsp '(warning . sql-sqlfluff) 'append)))))
(after! sql
  (when (require 'sql-indent nil t)
    (add-hook 'sql-mode-hook #'sqlind-minor-mode)))

;;; ---- DevOps: terraform / docker / nix / java formatter+linter parity -------
;; nix: alejandra (Doom defaults to nixfmt).
(set-formatter! 'alejandra '("alejandra" "--quiet" "-") :modes '(nix-mode nix-ts-mode))
;; java: google-java-format (Doom's java module assumes clang-format).
(set-formatter! 'google-java-format '("google-java-format" "-") :modes '(java-mode java-ts-mode))
;; terraform: this Doom fork has NO :lang terraform module, so terraform-mode
;; comes from packages.el. Start lsp-mode (built-in lsp-terraform-ls client ->
;; terraform-ls binary) in terraform buffers, and format with `terraform fmt`.
(add-hook 'terraform-mode-local-vars-hook #'lsp! 'append)
(set-formatter! 'terraform '("terraform" "fmt" "-") :modes '(terraform-mode))
;; Layer tflint + hadolint after the lsp checker (Neovim nvim-lint parity).
(after! (flycheck lsp-mode)
  (when (flycheck-valid-checker-p 'lsp)
    (when (flycheck-valid-checker-p 'terraform-tflint)
      (flycheck-add-next-checker 'lsp 'terraform-tflint 'append))
    (when (flycheck-valid-checker-p 'dockerfile-hadolint)
      (flycheck-add-next-checker 'lsp 'dockerfile-hadolint 'append))))
