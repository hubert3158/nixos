;; -*- no-byte-compile: t; -*-
;;; packages.el

;; Declare extra packages here, then run `doom sync` to install them.
;; Examples (uncomment to use):
;;
;; (package! some-package)
;; (package! another :recipe (:host github :repo "user/repo"))
;;
;; Disable a package a Doom module pulls in:
;; (package! builtin-package :disable t)
;;
;; Most things you'd want are already provided by the modules in init.el.

;; nvim-colorizer equivalent: highlight #rrggbb / color names inline.
(package! rainbow-mode)

;; --- Language parity additions (workflow: doom-language-parity) -------------
(package! sql-indent)      ; smart SQL indentation (no sql tree-sitter mode)
(package! terraform-mode)  ; no :lang terraform module in this Doom fork
