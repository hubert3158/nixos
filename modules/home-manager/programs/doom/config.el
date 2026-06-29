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
