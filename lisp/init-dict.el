;; lisp/init-dict.el -*- lexical-binding: t; -*-

(use-package sdcv
  :vc (:fetcher github :repo "manateelazycat/sdcv")
  :ensure nil
  :defer t
  :commands (sdcv-search-input sdcv-search-pointer+)
  :config
  ;;(set-face-foreground 'sdcv-tooltip-face "#51afef")
  (setq sdcv-program (executable-find "sdcv"))
  (setq sdcv-dictionary-simple-list '("牛津现代英汉双解词典"))
  (setq sdcv-dictionary-complete-list '("牛津现代英汉双解词典"
                                        "CEDICT汉英辞典"
                                        "朗道汉英字典5.0"
                                        "21世纪双语科技词典"
                                        "朗道英汉字典5.0"))
  (setq sdcv-dictionary-data-dir (expand-file-name "~/.stardict/dic")))

(use-package websocket :defer t)
(use-package websocket-bridge
  :vc (:fetcher github :repo "ginqi7/websocket-bridge")
  :ensure nil
  :defer t)
 
(use-package dictionary-overlay
  :vc (:fetcher github :repo "ginqi7/dictionary-overlay")
  :commands (dictionary-overlay-toggle
             dictionary-overlay-render-buffer
             dictionary-overlay-start))

(provide 'init-dict)
;;; init-dict.el ends here

