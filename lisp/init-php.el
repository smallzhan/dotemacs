;;  -*- lexical-binding: t; init-php.el-*-
(use-package php-ts-mode
  :vc (:fetcher github :repo "emacs-php/php-ts-mode")
  :config
  (add-hook 'php-ts-mode-hook #'(lambda () (lsp-bridge-mode 1)))
  (add-to-list 'lsp-bridge-single-lang-server-mode-list '(php-ts-mode . lsp-bridge-php-lsp-server)))


(provide 'init-php)
;;; init-php.el ends here
