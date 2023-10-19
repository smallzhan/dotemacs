;;; init-php.el  -*- lexical-binding: t; -*-
(use-package php-ts-mode
  :vc (:fetcher github :repo "emacs-php/php-ts-mode")
  :config
  (add-hook 'php-ts-mode-hook #'(lambda () (lsp-bridge-mode 1)))
  (with-eval-after-load "lsp-bridge"
   (add-to-list 'lsp-bridge-single-lang-server-mode-list '(php-ts-mode . lsp-bridge-php-lsp-server)))
  (add-to-list 'language-id--definitions
               '("PHP"
                 php-mode
                 php-ts-mode
                 (web-mode
                  (web-mode-content-type "html")
                  (web-mode-engine "php")))))
       


(provide 'init-php)
;;; init-php.el ends here
