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
   
  ;;(add-to-list 'eglot-server-programs '((python-mode) "pyright-langserver" "--stdio"))
  ;;;;(add-to-list 'eglot-server-programs '((python-mode) "jedi-language-server"))
  ;;(add-to-list 'eglot-server-programs '((c++-mode c-mode) "clangd")))
(use-package eldoc-box
  :config
  (add-hook 'eglot--managed-mode-hook #'eldoc-box-hover-at-point-mode t))

(use-package lsp-bridge
  :straight nil
  :load-path "~/.emacs.d/site-lisp/lsp-bridge"
  :config
  ;; (setq lsp-bridge-enable-log t)
  (dolist (hook (list
                 'emacs-lisp-mode-hook))
               
   (add-hook hook (lambda ()
                    (setq-local corfu-auto t))))
                   

  ;; Enable lsp-bridge.
  (dolist (hook (list
                 'c-mode-hook
                 'c++-mode-hook
                 'java-mode-hook
                 'python-mode-hook
                 'ruby-mode-hook
                 'rust-mode-hook
                 'elixir-mode-hook
                 'go-mode-hook
                 'haskell-mode-hook
                 'haskell-literate-mode-hook
                 'dart-mode-hook
                 'scala-mode-hook
                 'typescript-mode-hook
                 'typescript-tsx-mode-hook
                 'js2-mode-hook
                 'js-mode-hook
                 'rjsx-mode-hook
                 'tuareg-mode-hook
                 'latex-mode-hook
                 'Tex-latex-mode-hook
                 'texmode-hook
                 'context-mode-hook
                 'texinfo-mode-hook
                 'bibtex-mode-hook
                 'clojure-mode-hook
                 'clojurec-mode-hook
                 'clojurescript-mode-hook
                 'clojurex-mode-hook
                 'sh-mode-hook
                 'web-mode-hook))
               
    (add-hook hook (lambda ()
                     (setq-local corfu-auto nil)  ;; let lsp-bridge control when popup completion frame
                     (lsp-bridge-mode 1)))))
                   

(provide 'init-lsp)
;;; init-lsp.el ends here
