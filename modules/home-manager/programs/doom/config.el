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
