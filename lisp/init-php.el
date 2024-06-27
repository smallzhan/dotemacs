;;; init-php.el  -*- lexical-binding: t; -*-
(use-package php-ts-mode
  :quelpa (php-ts-mode :fetcher git :url "https://github.com/emacs-php/php-ts-mode")
  :config
  (add-hook 'php-ts-mode-hook #'(lambda () (lsp-bridge-mode 1)))
  (with-eval-after-load "lsp-bridge"
    (add-to-list 'lsp-bridge-single-lang-server-mode-list '(php-ts-mode . lsp-bridge-php-lsp-server)))
  (with-eval-after-load 'apheleia
    (add-to-list 'apheleia-formatters '(prettier-php . ("prettier")))
    (add-to-list 'apheleia-mode-alist '(php-ts-mode . prettier-php))))
  ;;(add-to-list 'language-id--definitions
  ;;             '("PHP"
  ;;               php-mode
  ;;               php-ts-mode
  ;;               (web-mode
  ;;                (web-mode-content-type "html")
  ;;                (web-mode-engine "php")))))
       


(provide 'init-php)
;;; init-php.el ends here
