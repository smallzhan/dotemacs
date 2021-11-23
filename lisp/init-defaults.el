;;; -*- lexical-binding: t -*-

(setq-default
 ;; no start messages
 inhibit-startup-message t
 ;; don't read x resource file
 inhibit-x-resources t
 ;; no welcome screen
 inhibit-splash-screen t
 inhibit-startup-screen t
 ;; no client startup messages
 server-client-instructions nil
 ;; no startup messages
 inhibit-startup-echo-area-message t
 frame-inhibit-implied-resize t
 initial-scratch-message ""
 hl-line-sticky-flag t
 ;; prefer horizental split
 split-height-threshold nil
 split-width-threshold 120
 ;; don't create lockfiles
 create-lockfiles nil
 ;; UTF-8
 ;; buffer-file-coding-system 'utf-8-unix
 ;; default-file-name-coding-system 'utf-8-unix
 ;; default-keyboard-coding-system 'utf-8-unix
 ;; default-process-coding-system '(utf-8-unix . utf-8-unix)
 ;; default-sendmail-coding-system 'utf-8-unix
 ;; default-terminal-coding-system 'utf-8-unix
 ;; add final newline
 require-final-newline t
 ;; backup setups
 backup-directory-alist `((".*" . ,temporary-file-directory))
 auto-save-file-name-transforms `((".*" ,temporary-file-directory t))
 backup-by-copying t
 delete-old-versions t
 kept-new-versions 6
 kept-old-versions 2
 version-control t
 ;; xref no prompt
 xref-prompt-for-identifier nil
 ;; mouse yank at point instead of click position.
 mouse-yank-at-point t
 ;; this fix the cursor movement lag
 auto-window-vscroll t
 ;; window divider setup
 window-divider-default-right-width 1
 window-divider-default-bottom-width 1
 ;; don't wait for keystrokes display
 echo-keystrokes 0.01
 show-paren-style 'parenthese
 ;; overline no margin
 overline-margin 0
 ;; underline no margin
 underline-minimum-offset 0
 ;; default tab width to 4(instead of 8)
 ;; some major modes will override this
 tab-width 4
 fill-column 80
 ;; don't show cursor in non selected window.
 cursor-in-non-selected-windows nil
 comment-empty-lines t
 visible-cursor nil
 ;; improve long line display performance
 bidi-inhibit-bpa t
 bidi-paragraph-direction 'left-to-right
 ;; allow resize by pixels
 frame-resize-pixelwise t
 x-gtk-resize-child-frames nil
 x-underline-at-descent-line t
 ;; indent with whitespace by default
 indent-tabs-mode nil
 ;; larger process output buffer
 read-process-output-max (* 1024 1024)
 ;; Don't truncate lines in a window narrower than 65 chars.
 truncate-partial-width-windows 65
 ;; Default line number width.
 display-line-numbers-width 3
 ;; Don't display comp warnings
 warning-suppress-log-types '((comp))
 ;; Firefox as default browser
 browse-url-browser-function 'browse-url-firefox
 ;; Custom file path
 custom-file (expand-file-name "custom.el" user-emacs-directory)
 ;; prefer y or n
 y-or-n-p-use-read-key t
 ;; always follow link
 vc-follow-symlinks t
 ;; disable visual line move
 line-move-visual t
 ;; case insensitive completion
 read-buffer-completion-ignore-case t
 read-file-name-completion-ignore-case t
 ;; use short answer
 read-answer-short t
 ;; move cursor to top/bottom before signaling a scroll error
 scroll-error-top-bottom t
 ;; pinentry
 epa-pinentry-mode 'loopback
 ;; disable input method in pgtk
 pgtk-use-im-context-on-new-connection nil
 ;; disable bell completely
 ring-bell-function 'ignore
 ;; eldoc idle delay
 eldoc-idle-delay 1
 ;; disable copy region blink
 copy-region-blink-delay 0
 ;; hscroll only for current line
 auto-hscroll-mode 'current-line)

(fset 'yes-or-no-p 'y-or-n-p)

(show-paren-mode -1)
;;(menu-bar-mode -1)
;;(scroll-bar-mode -1)
(push '(menu-bar-lines . 0)   default-frame-alist)
(push '(tool-bar-lines . 0)   default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)
;; And set these to nil so users don't have to toggle the modes twice to
;; reactivate them.
(setq menu-bar-mode nil
      tool-bar-mode nil
      scroll-bar-mode nil)

(setq user-full-name "Guoqiang Jin"
      user-mail-address "ustczhan@gmail.com")

(add-hook 'prog-mode-hook 'visual-line-mode)
(add-hook 'conf-mode-hook 'visual-line-mode)
(add-hook 'prog-mode-hook 'hl-line-mode)
(add-hook 'conf-mode-hook 'hl-line-mode)
(add-hook 'text-mode-hook 'hl-line-mode)
;;(add-hook 'prog-mode-hook 'display-line-numbers-mode)
;;(add-hook 'text-mode-hook 'display-line-numbers-mode)
;;(add-hook 'conf-mode-hook 'display-line-numbers-mode)
(add-hook 'prog-mode-hook 'subword-mode)
(add-hook 'before-save-hook 'delete-trailing-whitespace)

(setq time-stamp-active t)
(setq time-stamp-warn-inactive t)
(setq time-stamp-format "%:u %04y-%02m-%02d %02H:%02M:%02S")
(setq time-stamp-end: "\n")
(add-hook 'write-file-hooks 'time-stamp)

;; Encoding
;; UTF-8 as the default coding system
(when (fboundp 'set-charset-priority)
  (set-charset-priority 'unicode))

;; Explicitly set the prefered coding systems to avoid annoying prompt
;; from emacs (especially on Microsoft Windows)
(prefer-coding-system 'utf-8)
(setq locale-coding-system 'utf-8)

(set-language-environment 'utf-8)
(set-default-coding-systems 'utf-8)
(set-buffer-file-coding-system 'utf-8)
(set-clipboard-coding-system 'utf-8)
(set-file-name-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(modify-coding-system-alist 'process "*" 'utf-8)

(setq visible-bell t
      inhibit-compacting-font-caches t  ; Don’t compact font caches during GC.
      delete-by-moving-to-trash t       ; Deleting files go to OS's trash folder
      make-backup-files nil             ; Forbide to make backup files
      auto-save-default nil             ; Disable auto save

      uniquify-buffer-name-style 'post-forward-angle-brackets ; Show path if names are same
      adaptive-fill-regexp "[ t]+|[ t]*([0-9]+.|*+)[ t]*"
      adaptive-fill-first-line-regexp "^* *$"
      sentence-end "\\([。！？]\\|……\\|[.?!][]\"')}]*\\($\\|[ \t]\\)\\)[ \t\n]*"
      sentence-end-double-space nil
      word-wrap-by-category t)

;; kmacro keys
(global-set-key (kbd "C-,") 'kmacro-start-macro-or-insert-counter)
(global-set-key (kbd "C-.") 'kmacro-end-or-call-macro)
(global-set-key (kbd "<mouse-4>") 'scroll-down-line)
(global-set-key (kbd "<mouse-5>") 'scroll-up-line)

(defun +reopen-file-with-sudo ()
  (interactive)
  (find-alternate-file (format "/sudo::%s" (buffer-file-name))))

(global-set-key (kbd "C-x C-z") #'+reopen-file-with-sudo)
(setq-default max-mini-window-height 0.1)

(defvar +proxy-host "localhost")
(defvar +proxy-port 1089)

(cond
 (IS-WINDOWS
  (setq w32-lwindow-modifier 'super
        w32-apps-modifier 'hyper)
  (w32-register-hot-key [s-t]))
 (IS-MAC
  (setq max-option-modifier 'meta
        mac-command-modifier 'super)
  (bind-keys ([(super a)] . mark-whole-buffer)
             ([(super c)] . kill-ring-save)
             ([(super l)] . goto-line)
             ([(super q)] . save-buffers-kill-emacs)
             ([(super s)] . save-buffer)
             ([(super v)] . yank)
             ([(super w)] . delete-frame)
             ([(super z)] . undo))))



(use-package gcmh
  :init
  (setq gcmh-idle-delay 5
        gcmh-high-cons-threshold #x1000000)
  (gcmh-mode 1))

(use-package recentf
  :bind (("C-x C-r" . recentf-open-files))
  :hook (after-init . recentf-mode)
  :init (setq recentf-max-saved-items 300
              recentf-exclude
              '("\\.?cache" ".cask" "url" "COMMIT_EDITMSG\\'" "bookmarks"
                "\\.\\(?:gz\\|gif\\|svg\\|png\\|jpe?g\\|bmp\\|xpm\\)$"
                "\\.?ido\\.last$" "\\.revive$" "/G?TAGS$" "/.elfeed/"
                "^/tmp/" "^/var/folders/.+$" "^/ssh:" "/persp-confs/"
                (lambda (file) (file-in-directory-p file package-user-dir))))
  :config
  (push (expand-file-name recentf-save-file) recentf-exclude)
  (add-to-list 'recentf-filename-handlers #'abbreviate-file-name))

(use-package savehist
  :hook (after-init . savehist-mode)
  :init (setq enable-recursive-minibuffers t ; Allow commands in minibuffers
              history-length 1000
              savehist-additional-variables '(mark-ring
                                              global-mark-ring
                                              search-ring
                                              regexp-search-ring
                                              extended-command-history)
              savehist-autosave-interval 300))

(use-package so-long
    :ensure nil
    :hook (after-init . global-so-long-mode)
    :config (setq so-long-threshold 400))

(provide 'init-defaults)
