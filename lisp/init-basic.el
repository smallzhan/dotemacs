;;; init-basic.el  -*- lexical-binding: t; -*-

(require 'init-env)
(my/load-env)

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
             ([(super x)] . execute-extended-command)
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

;; (when IS-MAC
;;  (use-package exec-path-from-shell
;;    :config
;;    (exec-path-from-shell-initialize))
;;  (use-package cache-path-from-shell
;;    :straight (:type git :host github :repo "manateelazycat/cache-path-from-shell")))

(use-package cc-mode 
  :straight nil
  :hook (c-mode-common . (lambda () (c-set-style "stroustrup")))
  :init (setq-default c-basic-offset 4))
  
(use-package isearch-mb
  :init (isearch-mb-mode 1)
  :config
  (setq-default
   ;; Match count next to the minibuffer prompt
   isearch-lazy-count t
   ;; Don't be stingy with history; default is to keep just 16 entries
   search-ring-max 200
   regexp-search-ring-max 200
   isearch-regexp-lax-whitespace t
   search-whitespace-regexp ".*?")

  (add-to-list 'isearch-mb--with-buffer #'consult-isearch)
  (define-key isearch-mb-minibuffer-map (kbd "M-r") #'consult-isearch)
  (add-to-list 'isearch-mb--after-exit #'consult-line)
  (define-key isearch-mb-minibuffer-map (kbd "M-s") #'consult-line)

  (defun move-end-of-line-maybe-ending-isearch (arg)
    "End search and move to end of line, but only if already at the end of the minibuffer."
    (interactive "p")
    (if (eobp)
        (isearch-mb--after-exit
         (lambda ()
           (move-end-of-line arg)
           (isearch-done)))
      (move-end-of-line arg)))

  (define-key isearch-mb-minibuffer-map (kbd "C-e") #'move-end-of-line-maybe-ending-isearch))

(use-package elisp-demos
  :config
 (advice-add 
  'describe-function-1 
  :after 
  #'elisp-demos-advice-describe-function-1))

(use-package dirvish
  :config
  ;; Override dired with dirvish globally
  (dirvish-override-dired-mode)
  ;; Enable file preview when narrowing files in minibuffer.
  ;; This feature only support `vertico/selectrum' for now.
  (dirvish-peek-mode)
  (defun my--dirvish-preview-args (args)
    (prin1-to-string args)
    (let ((file (car args))
          (tail (cdr args)))
      (cons (file-name-nondirectory file) tail)))
    
  (advice-add 'dirvish--get-image-cache-for-file :filter-args #'my--dirvish-preview-args)
  (setq dirvish-header-style nil)
  (setq dirvish-mode-line-format nil)
  (setq dirvish-attributes '(all-the-icons file-size))
  :bind
  (:map dired-mode-map
        ("SPC" . dirvish-show-history)
        ("f"   . dirvish-menu-file-info-cmds)
        ("r"   . dirvish-roam)
        ("M-c" . dirvish-ui-config)
        ("M-m" . dirvish-toggle-fullscreen)
        ([remap dired-summary] . dirvish-dispatch)
        ([remap dired-do-copy] . dirvish-yank)
        ([remap mode-line-other-buffer] . dirvish-other-buffer)))

(provide 'init-basic)
;;; init-basic.el ends here
