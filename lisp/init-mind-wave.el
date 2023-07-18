;; -*- lexical-binding: t; init-mind-wave.el -*-


(use-package mind-wave
  :load-path "~/.emacs.d/site-lisp/mind-wave"
  :config
  (setq mind-wave-auto-change-title nil)
  (setq mind-wave-chat-model "gpt-4"))

;; (add-to-list 'load-path "~/.emacs.d/site-lisp/mind-wave")
;; (require 'mind-wave)

(provide 'init-mind-wave)
;;; init-mind-wave.el ends here
