;;; private/lsp/config.el -*- lexical-binding: t; -*-

;; (use-package eglot
;;   :commands (eglot-ensure eglot)
;;   :init 
;;   (setq eglot-python-path (executable-find "python3")
;;         eglot-sync-connect 1
;;         eglot-connect-timeout 10
;;         eglot-autoshutdown t
;;         eglot-auto-display-help-buffer nil)
;;         ;;eglot-stay-out-of '(flymake))
;;   (dolist (hook (list
;;                  'js-mode-hook
;;                  'rust-mode-hook
;;                  'python-mode-hook
;;                  'ruby-mode-hook
;;                  'java-mode-hook
;;                  'sh-mode-hook
;;                  'php-mode-hook
;;                  'c-mode-common-hook
;;                  'c-mode-hook
;;                  'c++-mode-hook
;;                  'haskell-mode-hook))
;;     (add-hook hook #'eglot-ensure))
;;   :config 
;;   (setq corfu-auto t)
;;   (define-key app-edit-keymap "i" #'eglot-find-implementation)
;;   (define-key app-edit-keymap "D" #'eglot-find-typeDefinition)
;;   (define-key app-edit-keymap "m" #'eglot-find-declaration))
   
;; (use-package eldoc-box
;;   :config
;;   (add-hook 'eglot--managed-mode-hook #'eldoc-box-hover-at-point-mode t))

(use-package markdown-mode
  :defer t)

;; (use-package corfu
;;   :init
;;   (setq corfu-quit-no-match t)
;;   (global-corfu-mode)
;;   :config
;;   ;;; all the icons formatter for corfu
;;   (require 'kind-all-the-icons)
;;   (add-to-list 'corfu-margin-formatters 
;;                #'kind-all-the-icons-margin-formatter))
;; 
;; (use-package corfu-doc
;;   :defer t)
  
(use-package lsp-bridge
  :straight nil
  :load-path "~/.emacs.d/site-lisp/lsp-bridge"
  :config
 
  (setq lsp-bridge-enable-log nil
        lsp-bridge-enable-auto-import t
        ;;acm-enable-doc nil
        acm-enable-yas nil)
  
  (global-lsp-bridge-mode)
  (bind-keys :map lsp-bridge-mode-map
             ;; ("M-." . lsp-bridge-find-def)  ;; override Xref bindings
             ;; ("M-," . lsp-bridge-return-from-def)
             ("C-c e d" . lsp-bridge-find-def)
             ("C-c e k" . lsp-bridge-return-from-def)
             ("C-c e x" . lsp-bridge-find-references)
             ("C-c e i" . lsp-bridge-find-impl)
             ("C-c e r" . lsp-bridge-rename)
             ("C-c e m" . lsp-bridge-lookup-documentation)
             :map acm-mode-map
             ("<return>" . acm-complete))
  (defun acm-reset-faces()
    (set-face-attribute 'acm-default-face nil :background 'unspecified)
    (set-face-attribute 'acm-select-face nil :background 'unspecified))
  (add-hook 'after-load-theme-hook #'acm-reset-faces)
  (setq acm-candidate-match-function 'orderless-flex))

  ;;(defun acm-match-orderless-flex (keyword candidate)
   ;;(string-match-p (orderless-flex (downcase keyword)) (downcase candidate)))
 
  ;;(advice-add #'acm-candidate-fuzzy-search :override #'acm-match-orderless-flex))
  
  

;; 通过Cape融合多个补全后端

;; (use-package cape
;;   :config
;;   (add-to-list 'completion-at-point-functions #'cape-symbol)
;;   (add-to-list 'completion-at-point-functions #'cape-file)
;;   (add-to-list 'completion-at-point-functions #'cape-dabbrev))
 
(use-package citre
  :straight (:type git :host github :repo "universal-ctags/citre")
  :defer t
  :init
  ;; This is needed in `:init' block for lazy load to work.
  (require 'citre-config)
  (setq citre-enable-capf-integration nil)
  (setq citre-peek-fill-fringe nil)
  :config
  (bind-keys :map app-edit-keymap
             ("j" . citre-jump)
             ("b" . citre-jump-back)
             ("p" . citre-peek)
             ("P" . citre-ace-peek)
             ("u" . citre-update-tags-file)
             ("n" . citre-create-tags-file)))
    
;; (use-package yasnippet
;;   :config
;;   (yas-global-mode 1))
;; 
;; (use-package yasnippet-snippets
;;   :config 
;;   (add-to-list 'yas/root-directory yasnippet-snippets-dir))

(use-package tempel
  :config
  (bind-keys ("M-+" . tempel-complete)
             ("M-*" . tempel-insert)
             :map tempel-map
             ("TAB" . tempel-next)))

(provide 'init-lsp)
;;; init-lsp.el ends here


