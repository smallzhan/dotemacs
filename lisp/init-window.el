;; init-window.el --- Initialize window configurations.	-*- lexical-binding: t -*-

;; Directional window-selection routines
(use-package windmove
  :hook (after-init . windmove-default-keybindings))

;; Restore old window configurations
(use-package winner
  :commands (winner-undo winner-redo)
  :hook (after-init . winner-mode)
  :init (setq winner-boring-buffers '("*Completions*"
                                      "*Compile-Log*"
                                      "*inferior-lisp*"
                                      "*Fuzzy Completions*"
                                      "*Apropos*"
                                      "*Help*"
                                      "*cvs*"
                                      "*Buffer List*"
                                      "*Ibuffer*"
                                      "*esh command on file*")))

;;Enforce rules for popups
(use-package shackle
  :hook (after-init . shackle-mode)
  :init
  (setq shackle-default-size 0.4
        shackle-default-alignment 'below
        shackle-default-rule nil
        shackle-select-reused-windows t
        shackle-rules
        '((("*Help*" "*Apropos*") :select t :size 0.3 :align 'below :autoclose t)
          (compilation-mode :select t :size 0.3 :align 'below :autoclose t)
          (comint-mode :select t :size 0.4 :align 'below :autoclose t)
          ("*Completions*" :size 0.3 :align 'below :autoclose t)
          ("*Pp Eval Output*" :size 15 :align 'below :autoclose t)
          ("*Backtrace*" :select t :size 15 :align 'below)
          (("*Warnings*" "*Messages*") :size 0.3 :align 'below :autoclose t)
          ("^\\*.*Shell Command.*\\*$" :regexp t :size 0.3 :align 'below :autoclose t)
          ("\\*[Wo]*Man.*\\*" :regexp t :select t :align 'below :autoclose t)
          ("*Calendar*" :select t :size 0.3 :align 'below)
          (("*shell*" "*eshell*" "*ielm*") :popup t :size 0.3 :align 'below)
          ("^\\*vc-.*\\*$" :regexp t :size 0.3 :align 'below :autoclose t)
          ("*gud-debug*" :select t :size 0.4 :align 'below :autoclose t)
          ("\\*ivy-occur .*\\*" :regexp t :select t :size 0.3 :align 'below)
          (" *undo-tree*" :select t)
          ("*quickrun*" :select t :size 15 :align 'below)
          ("*tldr*" :size 0.4 :align 'below :autoclose t)
          ("*Finder*" :select t :size 0.3 :align 'below :autoclose t)
          ("^\\*macro expansion\\**" :regexp t :size 0.4 :align 'below)
          ("^\\*elfeed-entry" :regexp t :size 0.7 :align 'below :autoclose t)
          
          ("*How Do You*" :select t :size 0.5 :align 'below :autoclose t)

          ((youdao-dictionary-mode osx-dictionary-mode fanyi-mode) :select t :size 0.5 :align 'below :autoclose t)

          (("*Org Agenda*" " *Agenda Commands*" " *Org todo*" "*Org Dashboard*" "*Org Select*")
           :select t :size 0.1 :align 'below :autoclose t)
          (("\\*Capture\\*" "^CAPTURE-.*\\.org*") :regexp t :select t :size 0.3 :align 'below :autoclose t)

          (" *Flycheck checkers*" :select t :size 0.3 :align 'below :autoclose t)
          ((flycheck-error-list-mode flymake-diagnostics-buffer-mode)
           :select t :size 0.25 :align 'below :autoclose t)

          ("*DAP Templates*" :select t :size 0.4 :align 'below :autoclose t)
          (dap-server-log-mode :size 15 :align 'below :autoclose t)
          ("*rustfmt*" :select t :size 0.3 :align 'below :autoclose t)
          ((rustic-compilation-mode rustic-cargo-clippy-mode rustic-cargo-outdated-mode rustic-cargo-test-mode)
           :select t :size 0.3 :align 'below :autoclose t)

          (profiler-report-mode :select t :size 0.5 :align 'below)
          ("*ELP Profiling Restuls*" :select t :size 0.5 :align 'below)

          ((inferior-python-mode inf-ruby-mode swift-repl-mode) :size 0.4 :align 'below)
          ("*prolog*" :size 0.4 :align 'below)

          (("*Gofmt Errors*" "*Go Test*") :select t :size 0.3 :align 'below :autoclose t)
          (godoc-mode :select t :size 0.4 :align 'below :autoclose t)

          ((grep-mode occur-mode rg-mode deadgrep-mode ag-mode pt-mode) :select t :size 0.4 :align 'below)
          (Buffer-menu-mode :select t :size 0.5 :align 'below :autoclose t)
          (gnus-article-mode :select t :size 0.7 :align 'below :autoclose t)
          (helpful-mode :select t :size 0.3 :align 'below :autoclose t)
          (devdocs-mode :select t :size 0.4 :align 'below :autoclose t)
          ((process-menu-mode list-environment-mode cargo-process-mode) :select t :size 0.3 :align 'below)
          (("*docker-containers*" "*docker-images*" "*docker-networks*" "*docker-volumes*")
           :size 0.4 :align 'below :autoclose t)
          (bookmark-bmenu-mode :select t :size 0.4 :align 'below)
          (tabulated-list-mode :size 0.4 :align 'below :autclose t)))
  :config
  (with-no-warnings
    (defvar shackle--popup-window-list nil
      "All popup windows.")
    (defvar-local shackle--current-popup-window nil
      "Current popup window.")
    (put 'shackle--current-popup-window 'permanent-local t)

    (defun shackle-last-popup-buffer ()
      "View last popup buffer."
      (interactive)
      (ignore-errors
        (display-buffer shackle-last-buffer)))
    (bind-key "C-h z" #'shackle-last-popup-buffer)

    ;; Add keyword: `autoclose'
    (defun shackle-display-buffer-hack (fn buffer alist plist)
      (let ((window (funcall fn buffer alist plist)))
        (setq shackle--current-popup-window window)

        (when (plist-get plist :autoclose)
          (push (cons window buffer) shackle--popup-window-list))
        window))
    (advice-add #'shackle-display-buffer :around #'shackle-display-buffer-hack)

    ;; Compatible with org
    (advice-add #'org-switch-to-buffer-other-window
                :override #'switch-to-buffer-other-window)))

(provide 'init-window)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; init-window.el ends here
