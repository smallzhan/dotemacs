;;; init-php.el  -*- lexical-binding: t; -*-
(use-package typst-ts-mode
  :vc (typst-ts-mode :url "https://git.sr.ht/~meow_king/typst-ts-mode" :files (:defaults "*.el")))
  
(use-package websocket :defet t)
(use-package typst-preview
  :vc (typst-preview :url "https://github.com/havarddj/typst-preview.el")
  :config
  (setq typst-preview-browser "default")
  (define-key typst-preview-mode-map (kbd "C-c C-j") 'typst-preview-send-position))
         


(provide 'init-typst)
;;; init-php.el ends here
