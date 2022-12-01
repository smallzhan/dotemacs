;;; init-eaf.el  -*- lexical-binding: t; -*-

(use-package eaf
  ;; :init
  ;; (when IS-MAC
  ;;   (setq ns-use-native-fullscreen nil
  ;;         ns-use-fullscreen-animation nil))
  ;;:straight nil
  :load-path "~/.emacs.d/site-lisp/emacs-application-framework" ; Set to "/usr/share/emacs/site-lisp/eaf" if installed from AUR
  :defer t
  :commands eaf-open
  :custom
  (eaf-browser-continue-where-left-off t)
  :config
  (when (executable-find "asdf")
    (setq eaf-python-command
          (string-trim (shell-command-to-string "asdf which python3"))))
  ;; (defun my-eaf-mac-get-size-advice (orig-fn &rest args)
  ;;   ;; (message "<<< %s" args)
  ;;   (if (memq (frame-parameter (car args) 'fullscreen)
  ;;             '(fullscreen fullboth maximized))
  ;;       0
  ;;     (apply orig-fn args)))

  ;;(advice-add 'eaf--frame-top :around #'my-eaf-mac-get-size-advice)
  ;;(advice-add 'eaf--frame-left :around #'my-eaf-mac-get-size-advice)
  ;;(advice-add 'eaf--frame-internal-height :around #'my-eaf-mac-get-size-advice)

  ;; (advice-add 'eaf--mac-focus-change :override #'my-eaf--mac-focus-change)


  (require 'eaf-pdf-viewer)
  (eaf-bind-key scroll_up "C-n" eaf-pdf-viewer-keybinding)
  (eaf-bind-key scroll_down "C-p" eaf-pdf-viewer-keybinding)

  (require 'eaf-browser)
  (setq eaf-browser-enable-adblocker t)
  (eaf-bind-key nil "M-q" eaf-browser-keybinding)

  (require 'eaf-interleave)
  (add-to-list 'eaf-interleave-org-notes-dir-list (concat org-directory "research"))
   
  (require 'eaf-git))
  ;;(require 'eaf-interleave-noter))
  

(use-package epc :defer t)
;;(use-package ctable :defer t)
;;(use-package deferred :defer t)

(provide 'init-eaf)
;;; init-eaf.el ends here
