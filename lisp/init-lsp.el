;;; private/lsp/config.el -*- lexical-binding: t; -*-

;; (use-package corfu
;;   :init
;;   (setq corfu-quit-no-match t)
;;   (global-corfu-mode)
;;   :config
;;   ;;; all the icons formatter for corfu
;;   (require 'corfu-history)
;;   (require 'corfu-info)
;;   (require 'kind-all-the-icons)
;;   (add-to-list 'corfu-margin-formatters 
;;                #'kind-all-the-icons-margin-formatter))

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
;; (use-package eldoc-box
;;   :config
;;   (add-hook 'eglot--managed-mode-hook #'eldoc-box-hover-at-point-mode t))

(use-package markdown-mode
  :defer t)

(use-package lsp-bridge
  :straight nil
  :load-path "~/.emacs.d/site-lisp/lsp-bridge"
  :config
  (add-to-list 'lsp-bridge-lang-server-mode-list '(rustic-mode . "rust-analyzer"))
  (setq lsp-bridge-enable-log nil)
  
  (require 'lsp-bridge-ui)
  (require 'lsp-bridge-ui-history)
  (require 'lsp-bridge-orderless)
  
  (global-lsp-bridge-ui-mode)       ;; use lsp-bridge-fw as completion ui
  (lsp-bridge-ui-history-mode t)
  ;;(global-lsp-bridge-mode)

  (global-lsp-bridge-mode)
  
  (add-hook 'lsp-bridge-mode-hook 
            (lambda ()
               (add-hook 'xref-backend-functions 
                         #'lsp-bridge-xref-backend nil t)))
  
  (dolist (hook (list
                 'emacs-lisp-mode-hook))
               
   (add-hook hook (lambda ()
                    (setq-local lsp-bridge-ui-auto t)))) ; Elisp文件自动弹出补全
  (defun lsp-bridge-mix-multi-backends ()
   (setq-local completion-category-defaults nil)
   (setq-local completion-at-point-functions
               (list
                (cape-capf-buster
                 (cape-super-capf
                  #'lsp-bridge-capf)

                  ;; 我嫌弃TabNine太占用我的CPU了， 需要的同学注释下面这一行就好了
                  ;; #'tabnine-completion-at-point

                  ;; #'cape-file
                  ;; #'cape-dabbrev
                 
                 'equal))))
               


  (dolist (hook lsp-bridge-default-mode-hooks)
    (add-hook hook (lambda ()
                     (setq-local lsp-bridge-ui-auto nil) ; 编程文件关闭Lsp-Bridge-Ui自动补全， 由lsp-bridge来手动触发补全
                     (lsp-bridge-mode 1)         ; 开启lsp-bridge
                     (lsp-bridge-mix-multi-backends))))) ; 通过Cape融合多个补全后端

(use-package cape
  :config
  (add-to-list 'completion-at-point-functions #'cape-symbol)
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-dabbrev))
 

(provide 'init-lsp)
;;; init-lsp.el ends here
