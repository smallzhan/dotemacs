;;; init-vertico.el -*- lexical-binding: t; -*-
;; Enable vertico

(use-package vertico
  :straight (:files ("*.el" "extensions/*.el"))
  :init
  (vertico-mode)
  :config

  ;; Different scroll margin
  (setq vertico-scroll-margin 0)

  ;; Show more candidates
  (setq vertico-count 16)

  ;; Grow and shrink the Vertico minibuffer
  (setq vertico-resize nil)

  ;; Optionally enable cycling for `vertico-next' and `vertico-previous'.
  (setq vertico-cycle t)
  (setq completion-in-region-function
        (lambda (&rest args)
          (apply (if vertico-mode
                     #'consult-completion-in-region
                   #'completion--in-region)
                 args)))
  (add-hook 'rfn-eshadow-update-overlay-hook #'vertico-directory-tidy)
  (add-hook 'minibuffer-setup-hook #'vertico-repeat-save)
  (define-key vertico-map [backspace] #'vertico-directory-delete-char))


(use-package orderless
  :config
   (defun +vertico-orderless-dispatch (pattern _index _total)
     (cond
      ;; Ensure $ works with Consult commands, which add disambiguation suffixes
      ((string-suffix-p "$" pattern)
       `(orderless-regexp . ,(concat (substring pattern 0 -1) "[\x100000-\x10FFFD]*$")))
      ;; Ignore single !
      ((string= "!" pattern) 
       `(orderless-literal . ""))
      ;; Without literal
      ((string-prefix-p "!" pattern) 
       `(orderless-without-literal . ,(substring pattern 1)))
      ;; Character folding
      ((string-prefix-p "%" pattern) 
       `(char-fold-to-regexp . ,(substring pattern 1)))
      ((string-suffix-p "%" pattern) 
       `(char-fold-to-regexp . ,(substring pattern 0 -1)))
      ;; Initialism matching
      ((string-prefix-p "`" pattern) 
       `(orderless-initialism . ,(substring pattern 1)))
      ((string-suffix-p "`" pattern) 
       `(orderless-initialism . ,(substring pattern 0 -1)))
      ;; Literal matching
      ((string-prefix-p "=" pattern) 
       `(orderless-literal . ,(substring pattern 1)))
      ((string-suffix-p "=" pattern) 
       `(orderless-literal . ,(substring pattern 0 -1)))
      ;; Flex matching
      ((string-prefix-p "~" pattern) 
       `(orderless-flex . ,(substring pattern 1)))
      ((string-suffix-p "~" pattern) 
       `(orderless-flex . ,(substring pattern 0 -1)))))
  
   (setq completion-styles '(orderless flex)
         completion-category-defaults nil
         completion-category-overrides '((file (styles orderless partial-completion))
                                         (eglot (styles orderless flex)))
         orderless-style-dispatchers '(+vertico-orderless-dispatch)
         orderless-component-separator "[ &]")
   
   ;; (defun my/use-orderless-in-minibuffer ()
   ;;  (setq-local completion-styles '(substring orderless)))
   ;; (add-hook 'minibuffer-setup-hook #'my/use-orderless-in-minibuffer)
 
  ;; ...otherwise find-file gets different highlighting than other commands
  (set-face-attribute 'completions-first-difference nil :inherit nil))
  
;; Persist history over Emacs restarts. Vertico sorts by history position.
(use-package savehist
  :init
  (savehist-mode))

;; A few more useful configurations...
(use-package emacs
  :init
  ;; Add prompt indicator to `completing-read-multiple'.
  ;; Alternatively try `consult-completing-read-multiple'.
  (defun crm-indicator (args)
    (cons (concat "[CRM] " (car args)) (cdr args)))
  (advice-add #'completing-read-multiple :filter-args #'crm-indicator)

  ;; Do not allow the cursor in the minibuffer prompt
  (setq minibuffer-prompt-properties
        '(read-only t cursor-intangible t face minibuffer-prompt))
  (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)

  ;; Emacs 28: Hide commands in M-x which do not work in the current mode.
  ;; Vertico commands are hidden in normal buffers.
  ;; (setq read-extended-command-predicate
  ;;       #'command-completion-default-include-p)

  ;; Enable recursive minibuffers
  (setq enable-recursive-minibuffers t))


;; Example configuration for Consult
(use-package consult
  :bind (([remap apropos]                       . consult-apropos)
         ([remap bookmark-jump]                 . consult-bookmark)
         ([remap goto-line]                     . consult-goto-line)
         ([remap imenu]                         . consult-imenu)
         ([remap locate]                        . consult-locate)
         ([remap load-theme]                    . consult-theme)
         ([remap man]                           . consult-man)
         ([remap recentf-open-files]            . consult-recent-file)
         ([remap switch-to-buffer]              . consult-buffer)
         ([remap switch-to-buffer-other-window] . consult-buffer-other-window)
         ([remap switch-to-buffer-other-frame]  . consult-buffer-other-frame)
         ([remap yank-pop]                      . consult-yank-pop))
  
  :init
  (advice-add #'multi-occur :override #'consult-multi-occur)
  
  ;; Use Consult to select xref locations with preview
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)

  :config
  (setq   consult-narrow-key "<"
          consult-line-numbers-widen t
          consult-async-min-input 2
          consult-async-refresh-delay  0.15
          consult-async-input-throttle 0.2
          consult-async-input-debounce 0.1)
 
  (consult-customize
   consult-theme
   :preview-key '(:debounce 0.2 any)
   consult-ripgrep consult-git-grep consult-grep
   consult-bookmark consult-recent-file consult-xref
   consult--source-recent-file consult--source-project-recent-file consult--source-bookmark
   :preview-key (kbd "M-."))
  
  (defun my/cosult-line-symbol ()
    (consult-line (thing-at-point 'symbol))))


(use-package marginalia
  :bind (("M-A" . marginalia-cycle)
         :map minibuffer-local-map
         ("M-A" . marginalia-cycle))
  
  :init
  (marginalia-mode))
  

(use-package embark
  :bind
  (("C-." . embark-act) 
   ("C-;" . embark-dwim)
   ([remap describe-bindings] . embark-bindings)) 

  :init

  ;; Optionally replace the key help with a completing-read interface
  (setq prefix-help-command #'embark-prefix-help-command)

  :config

  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

;; Consult users will also want the embark-consult package.
(use-package embark-consult
  :after (embark consult)
  :demand t ; only necessary if you have the hook below
  ;; if you want to have consult previews as you move around an
  ;; auto-updating embark collect buffer
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

(use-package dabbrev
  ;; Swap M-/ and C-M-/
  :bind (("M-/" . dabbrev-completion)
         ("C-M-/" . dabbrev-expand)))

(use-package all-the-icons-completion
  :config
  (all-the-icons-completion-mode)
  (add-hook 'marginalia-mode-hook #'all-the-icons-completion-marginalia-setup))

;; Configure Tempel
;;(use-package tempel
;;  :straight (:type git :host github :repo "minad/tempel"))
  ;; :bind (("M-+" . tempel-complete) ;; Alternative tempel-expand
  ;;        ("M-*" . tempel-insert))
  ;; 
  ;; :init
  ;; 
  ;; ;; Setup completion at point
  ;; (defun tempel-setup-capf ()
  ;;   ;; Add the Tempel Capf to `completion-at-point-functions'.
  ;;   ;; The depth is set to -1, such that `tempel-expand' is tried *before* the
  ;;   ;; programming mode Capf. If a template name can be completed it takes
  ;;   ;; precedence over the programming mode completion. `tempel-expand' only
  ;;   ;; triggers on exact matches. Alternatively use `tempel-complete' if you
  ;;   ;; want to see all matches, but then Tempel will probably trigger too
  ;;   ;; often when you don't expect it.
  ;;   (add-hook 'completion-at-point-functions #'tempel-expand -1 'local))
  ;; 
  ;; (add-hook 'prog-mode-hook 'tempel-setup-capf)
  ;; (add-hook 'text-mode-hook 'tempel-setup-capf))

(provide 'init-vertico)
;;; init-vertico.el ends here
