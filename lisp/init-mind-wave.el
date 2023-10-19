;;; init-mind-wave.el -*- lexical-binding: t; -*-


(use-package mind-wave
  :load-path "~/.emacs.d/site-lisp/mind-wave"
  :defer t
  :commands (mind-wave-chat-ask mind-wave-refactory-code)
  :config
  (setq mind-wave-auto-change-title nil)
  (setq mind-wave-chat-model "gpt-4"))

;; (add-to-list 'load-path "~/.emacs.d/site-lisp/mind-wave")
;; (require 'mind-wave)

(provide 'init-mind-wave)
;;; init-mind-wave.el ends here
