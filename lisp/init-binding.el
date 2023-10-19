;;; init-bindings.el  -*- lexical-binding: t; -*-

;; (use-package which-key
;;   :hook (after-init . which-key-mode)
;;   :init (setq which-key-max-description-length 30
;;               which-key-show-remaining-keys t))
;; ;;              which-key-popup-type 'frame))


(defvar app-org-keymap
  (let ((keymap (make-keymap)))
    (define-key keymap (kbd "a") #'org-agenda)
    (define-key keymap (kbd "b") #'org-switchb)
    (define-key keymap (kbd "B") #'my-pages-start-post)
    (define-key keymap (kbd "c") #'org-capture)
    (define-key keymap (kbd "C") #'org-capture-goto-target)
    (define-key keymap (kbd "g") #'org-tags-view)
    (define-key keymap (kbd "i") #'org-clock-in)
    (define-key keymap (kbd "I") #'my/org-clock-in)
    (define-key keymap (kbd "L") #'org-store-link)
    (define-key keymap (kbd "d") #'org-caldav-sync)
    (define-key keymap (kbd "o") #'org-clock-out)
    (define-key keymap (kbd "T") #'org-clock-mark-default-task)
    (define-key keymap (kbd "m") #'org-pomodoro)
    (define-key keymap (kbd "v") #'org-search-view)
    (define-key keymap (kbd "pi") #'bh/punch-in)
    (define-key keymap (kbd "po") #'bh/punch-out)
    (define-key keymap (kbd "pf") #'org-publish-current-file)
    (define-key keymap (kbd "pp") #'org-publish-current-project)
    (define-key keymap (kbd "rn") #'org-roam-node-find)
    (define-key keymap (kbd "rf") #'org-roam-ref-find)
    (define-key keymap (kbd "rc") #'org-roam-capture)
    (define-key keymap (kbd "ra") #'org-roam-node-random)
    (define-key keymap (kbd "ri") #'org-roam-node-insert)
    (define-key keymap (kbd "rs") #'org-roam-db-sync)
    (define-key keymap (kbd "rd") #'org-roam-dailies-goto-date)
    (define-key keymap (kbd "rr") #'org-roam-buffer-toggle)
    (define-key keymap (kbd "rt") #'org-roam-dailies-goto-today)
    (define-key keymap (kbd "ry") #'org-roam-dailies-find-yesterday)

    keymap))

;; define an alias for your keymap
(defalias 'app-org-keymap app-org-keymap)

(global-set-key (kbd "C-c o") 'app-org-keymap)


(defvar app-edit-keymap
  (let ((keymap (make-keymap)))
    (define-key keymap (kbd "c") #'compile)
    (define-key keymap (kbd "C") #'recompile)
    ;;(define-key keymap (kbd "d") #'xref-find-definitions)
    ;;(define-key keymap (kbd "x") #'xref-find-references)
    (define-key keymap (kbd "f") #'format-all-buffer)
    (define-key keymap (kbd "F") #'format-all-region)
    (define-key keymap (kbd "D") #'delete-trailing-whitespace)
    (define-key keymap (kbd "t") #'citar-open-entry)

    (define-key keymap (kbd "L") #'my-mark-line)
    (define-key keymap (kbd "K") #'my-kill)
    (define-key keymap (kbd "w") #'markmacro-mark-words)
    (define-key keymap (kbd "l") #'markmacro-mark-lines)
    (define-key keymap (kbd "h") #'markmacro-mark-chars)
    (define-key keymap (kbd "A") #'markmacro-apply-all-except-first)
    (define-key keymap (kbd "a") #'markmacro-apply-all)
    (define-key keymap (kbd "s") #'markmacro-rect-set)
    (define-key keymap (kbd "d") #'markmacro-rect-delete)
    (define-key keymap (kbd "r") #'markmacro-rect-replace)
    (define-key keymap (kbd "i") #'markmacro-rect-insert)
    (define-key keymap (kbd "ms") #'markmacro-rect-mark-symbols)
    (define-key keymap (kbd "mc") #'markmacro-rect-mark-columns)
    (define-key keymap (kbd "mi") #'markmacro-mark-imenus)
    (define-key keymap (kbd "mr") #'markmacro-secondary-region-set)
    (define-key keymap (kbd "mm") #'markmacro-secondary-region-mark-cursors)
    
    keymap))

(defalias 'app-edit-keymap app-edit-keymap)
(global-set-key (kbd "C-c e") 'app-edit-keymap)

(defvar app-search-keymap
  (let ((keymap (make-keymap)))
    (define-key keymap (kbd "r") #'color-rg-search-input-in-project)
    (define-key keymap (kbd "s") #'color-rg-search-symbol-in-project)
    (define-key keymap (kbd "f") #'color-rg-search-input-in-current-file)
    (define-key keymap (kbd "c") #'color-rg-search-symbol-in-current-file)
    (define-key keymap (kbd "v") #'consult-git-grep)
    (define-key keymap (kbd "g") #'consult-ripgrep)
    (define-key keymap (kbd "l") #'consult-line)
    (define-key keymap (kbd "e") #'my/consult-line-symbol)
    (define-key keymap (kbd "k") #'consult-keep-lines)
    (define-key keymap (kbd "z") #'symbol-overlay-transient)
    (define-key keymap (kbd "j") #'consult-bookmark)
    (define-key keymap (kbd "i") #'consult-imenu)
    (define-key keymap (kbd "d") #'sdcv-search-input)
    (define-key keymap (kbd "t") #'sdcv-search-pointer+)
    (define-key keymap (kbd "a") #'consult-org-agenda)
    (define-key keymap (kbd "o") #'consult-outline)
    (define-key keymap (kbd "n") #'consult-narrow)
    (define-key keymap (kbd "p") #'consult-find)
    (define-key keymap (kbd "x") #'blink-search)
    (define-key keymap (kbd "b") #'blink-search)
    keymap))

(defalias 'app-search-keymap app-search-keymap)
(global-set-key (kbd "C-c s") 'app-search-keymap)

(defvar app-toggle-keymap
  (let ((keymap (make-keymap)))
    (define-key keymap (kbd "s") #'flyspell-mode)
    (define-key keymap (kbd "f") #'flycheck-mode)
    (define-key keymap (kbd "m") #'flymake-mode)
    (define-key keymap (kbd "F") #'toggle-frame-fullscreen)
    (define-key keymap (kbd "v") #'visual-line-mode)
    (define-key keymap (kbd "h") #'hl-line-mode)
    (define-key keymap (kbd "c") #'toggle-truncate-lines)
    (define-key keymap (kbd "t") #'consult-theme)

    keymap))

(defalias 'app-toggle-keymap app-toggle-keymap)
(global-set-key (kbd "C-c t") 'app-toggle-keymap)
;;                              ^ note the quote

(defvar app-notes-keymap
  (let ((keymap (make-sparse-keymap)))
    (define-key keymap (kbd "n") #'denote)
    (define-key keymap (kbd "j") #'my-denote-journal)
    (define-key keymap (kbd "b") #'my-denote-blog)
    (define-key keymap (kbd "d") #'denote-date)
    (define-key keymap (kbd "c") #'denote-subdirectory)
    (define-key keymap (kbd "s") #'consult-notes)
    (define-key keymap (kbd "S") #'consult-notes-search-in-all-notes)
    (define-key keymap (kbd "t") #'denote-template)
    (define-key keymap (kbd "i") #'denote-link)
    (define-key keymap (kbd "I") #'denote-link-add-links)
    (define-key keymap (kbd "f") #'denote-link-find-file)
    (define-key keymap (kbd "l") #'denote-link-find-backlink)
    (define-key keymap (kbd "r") #'denote-rename-file)
    (define-key keymap (kbd "R") #'denote-rename-file-using-front-matter)
    keymap))

(defalias 'app-notes-keymap app-notes-keymap)
(global-set-key (kbd "C-c n") 'app-notes-keymap)


(defvar app-hs-keymap
  (let ((keymap (make-sparse-keymap)))
    (define-key keymap (kbd "h") #'hs-hide-all)
    (define-key keymap (kbd "s") #'hs-show-all)
    (define-key keymap (kbd "c") #'hs-cycle)
    (define-key keymap (kbd "l") #'hs-hide-level)
    (define-key keymap (kbd "b") #'hs-hide-block)
    (define-key keymap (kbd "B") #'hs-show-block)
    (define-key keymap (kbd "p") #'hs-hide-block-at-point)
    (define-key keymap (kbd "r") #'hs-hide-comment-region)
    (define-key keymap (kbd "L") #'hs-hide-level-recursive)
    (define-key keymap (kbd "t") #'hs-toggle-hiding)
    keymap))

(defalias 'app-hs-keymap app-hs-keymap)
(global-set-key (kbd "C-c -") 'app-hs-keymap)

(global-set-key (kbd "C-0") #'scroll-other-window)  ;; 向下翻
(global-set-key (kbd "C-9") #'scroll-other-window-down) ;; 向上翻

(global-set-key (kbd "C->") #'remember-init)
(global-set-key (kbd "C-<") #'remember-jump)
(global-set-key (kbd "M-N") #'delete-block-backward)
(global-set-key (kbd "M-M") #'delete-block-forward)
(global-set-key (kbd "M-w") #'my-copy)

(provide 'init-binding)
;;; init-bingding.el ends here
