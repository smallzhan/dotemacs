;;; init-php.el  -*- lexical-binding: t; -*-
(use-package typst-ts-mode
  :quelpa (typst-ts-mode :fetcher git :url "https://git.sr.ht/~meow_king/typst-ts-mode")
  :config
  (with-eval-after-load 'apheleia
    (add-to-list 'apheleia-formatters
                 '(typstyle . ("typstyle")))
    (add-to-list 'apheleia-mode-alist '(typst-ts-mode . typstyle))))
 
                                           
  
(use-package websocket :defer t)
(use-package typst-preview
  :quelpa (typst-preview :fetcher git :url "https://github.com/havarddj/typst-preview.el" :branch "main")
  :config
  (setq typst-preview-browser "xwidget")
  (define-key typst-preview-mode-map (kbd "C-c C-j") 'typst-preview-send-position))
         


(provide 'init-typst)
;;; init-php.el ends here
