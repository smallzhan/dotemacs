;;; init-ui.el -*- lexical-binding: t; -*-

;; theme

(use-package doom-themes 
  :config 
  (when IS-WINDOWS (load-theme 'doom-one t)))

(when IS-MAC
  (use-package auto-dark
    :straight (:type git :host github :repo "emacsmirror/auto-dark")
    :config
    (setq auto-dark--dark-theme 'doom-one
          auto-dark--light-theme 'doom-one-light)))
  ;; :config
  ;; (if IS-MAC
  ;;     (add-hook 'ns-system-appearance-change-functions
  ;;               #'(lambda (appearance)
  ;;                   (mapc #'disable-theme custom-enabled-themes)
  ;;                   (pcase appearance
  ;;                     ('light (load-theme 'doom-one-light t))
  ;;                     ('dark (load-theme 'doom-one t)))))
  ;;   (load-theme 'doom-one t)))

;; disable line-number
(setq display-line-numbers-type nil)
(when IS-MAC
  (add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
  (add-to-list 'default-frame-alist '(undecorated . t))
  (add-to-list 'default-frame-alist '(ns-appearance . dark))
  (add-to-list 'initial-frame-alist '(fullscreen . maximized))
  (add-hook 'after-load-theme-hook
            (lambda ()
              (let ((bg (frame-parameter nil 'background-mode)))
                (set-frame-parameter nil 'ns-appearance bg)
                (setcdr (assq 'ns-appearance default-frame-alist) bg)))))


;;(when IS-WINDOWS
;; (use-package modus-themes
;;   :init
;;   (setq modus-themes-italic-constructs t
;;         modus-themes-bold-constructs nil
;;         modus-themes-mixed-fonts t
;;         modus-themes-subtle-line-numbers nil
;;         modus-themes-intense-mouseovers nil
;;         modus-themes-deuteranopia t
;;         modus-themes-tabs-accented t
;;         modus-themes-variable-pitch-ui nil
;;         modus-themes-inhibit-reload t ; only applies to `customize-set-variable' and related
;; 
;;         modus-themes-fringes nil ; {nil,'subtle,'intense}
;; 
;;         ;; Options for `modus-themes-lang-checkers' are either nil (the
;;         ;; default), or a list of properties that may include any of those
;;         ;; symbols: `straight-underline', `text-also', `background',
;;         ;; `intense' OR `faint'.
;;         modus-themes-lang-checkers nil
;; 
;;         ;; Options for `modus-themes-mode-line' are either nil, or a list
;;         ;; that can combine any of `3d' OR `moody', `borderless',
;;         ;; `accented', a natural number for extra padding (or a cons cell
;;         ;; of padding and NATNUM), and a floating point for the height of
;;         ;; the text relative to the base font size (or a cons cell of
;;         ;; height and FLOAT)
;;         ;;modus-themes-mode-line '(accented borderless (padding . 4) (height . 0.9))
;; 
;;         ;; Same as above:
;;         ;; modus-themes-mode-line '(accented borderless 4 0.9)
;; 
;;         ;; Options for `modus-themes-markup' are either nil, or a list
;;         ;; that can combine any of `bold', `italic', `background',
;;         ;; `intense'.
;;         modus-themes-markup '(background italic)
;; 
;;         ;; Options for `modus-themes-syntax' are either nil (the default),
;;         ;; or a list of properties that may include any of those symbols:
;;         ;; `faint', `yellow-comments', `green-strings', `alt-syntax'
;;         modus-themes-syntax nil
;; 
;;         ;; Options for `modus-themes-hl-line' are either nil (the default),
;;         ;; or a list of properties that may include any of those symbols:
;;         ;; `accented', `underline', `intense'
;;         modus-themes-hl-line '(accented)
;; 
;;         ;; Options for `modus-themes-paren-match' are either nil (the
;;         ;; default), or a list of properties that may include any of those
;;         ;; symbols: `bold', `intense', `underline'
;;         modus-themes-paren-match '(bold intense)
;; 
;;         ;; Options for `modus-themes-links' are either nil (the default),
;;         ;; or a list of properties that may include any of those symbols:
;;         ;; `neutral-underline' OR `no-underline', `faint' OR `no-color',
;;         ;; `bold', `italic', `background'
;;         ;; modus-themes-links '(neutral-underline background)
;; 
;;         ;; Options for `modus-themes-box-buttons' are either nil (the
;;         ;; default), or a list that can combine any of `flat', `accented',
;;         ;; `faint', `variable-pitch', `underline', the symbol of any font
;;         ;; weight as listed in `modus-themes-weights', and a floating
;;         ;; point number (e.g. 0.9) for the height of the button's text.
;;         modus-themes-box-buttons '(variable-pitch flat faint 0.9)
;; 
;;         ;; Options for `modus-themes-prompts' are either nil (the
;;         ;; default), or a list of properties that may include any of those
;;         ;; symbols: `background', `bold', `gray', `intense', `italic'
;;         modus-themes-prompts '(intense bold)
;; 
;;         ;; The `modus-themes-completions' is an alist that reads three
;;         ;; keys: `matches', `selection', `popup'.  Each accepts a nil
;;         ;; value (or empty list) or a list of properties that can include
;;         ;; any of the following (for WEIGHT read further below):
;;         ;;
;;         ;; `matches' - `background', `intense', `underline', `italic', WEIGHT
;;         ;; `selection' - `accented', `intense', `underline', `italic', `text-also' WEIGHT
;;         ;; `popup' - same as `selected'
;;         ;; `t' - applies to any key not explicitly referenced (check docs)
;;         ;;
;;         ;; WEIGHT is a symbol such as `semibold', `light', or anything
;;         ;; covered in `modus-themes-weights'.  Bold is used in the absence
;;         ;; of an explicit WEIGHT.
;;         modus-themes-completions '((matches . (extrabold))
;;                                    (selection . (semibold accented))
;;                                    (popup . (accented intense)))
;; 
;;         modus-themes-mail-citations nil ; {nil,'intense,'faint,'monochrome}
;; 
;;         ;; Options for `modus-themes-region' are either nil (the default),
;;         ;; or a list of properties that may include any of those symbols:
;;         ;; `no-extend', `bg-only', `accented'
;;         modus-themes-region '(accented no-extend)
;; 
;;         ;; Options for `modus-themes-diffs': nil, 'desaturated, 'bg-only
;;         modus-themes-diffs 'desaturated
;; 
;;         modus-themes-org-blocks 'gray-background ; {nil,'gray-background,'tinted-background}
;; 
;;         modus-themes-org-agenda ; this is an alist: read the manual or its doc string
;;         '((header-block . (variable-pitch 1.1))
;;           (header-date . (grayscale workaholic bold-today))
;;           (event . (accented varied))
;;           (scheduled . uniform)
;;           (habit . traffic-light))
;; 
;;         modus-themes-headings ; this is an alist: read the manual or its doc string
;;         '((1 . (variable-pitch 1.1))
;;           (2 . (rainbow))
;;           (t . (semibold))))
;;   (modus-themes-load-themes)
;;   (when IS-MAC
;;    (add-hook 'ns-system-appearance-change-functions
;;                #'(lambda (appearance)
;;                    (mapc #'disable-theme custom-enabled-themes)
;;                    (pcase appearance
;;                      ('light (modus-themes-load-operandi))
;;                      ('dark (modus-themes-load-vivendi))))))
;;   :config
;;   (when IS-WINDOWS
;;     (modus-themes-load-vivendi)))
;;(load-theme 'modus-vivendi t))
                       ;
;; (use-package circadian
;;   :config
;;   (when IS-WINDOWS
;;     (defun my--encode-time (hour min)
;;       "Encode HOUR hours and MIN minutes into a valid format for `run-at-time'."
;;       (let ((now (decode-time)))
;;         (let ((day (nth 3 now))
;;               (month (nth 4 now))
;;               (year (nth 5 now)))
;;           (encode-time 0 min hour day month year))))
;;     (advice-add 'circadian--encode-time :override #'my--encode-time))
;;     
;;   (setq circadian-themes '(("8:00" . doom-one-light)
;;                            ("19:30" . doom-one)))
;;   (circadian-setup))


;;;======= font config

(defvar my-fonts '((default . ("DejaVu Sans Mono" "JetBrains Mono" "Cascadia Code" "Fira Code" "SF Mono"))
                   (cjk . ("Source Han Serif SC" "PingFang SC" "Microsoft YaHei UI" "Sarasa Mono SC"))
                   (unicode . ("Apple Color Emoji" "Segoe UI Emoji" "Symbola"))
                   (fixed . ("Iosevka Fixed" "Sarasa Mono SC"))
                   (fixed-serif . ("Latin Modern Mono" "LM Mono 10" "Courier New"))
                   (variable . ("Bookerly" "Source Serif 4" "Times New Roman"))))
                   

(defvar my-font-size 14)   

(defun my--get-font-with-code (key)
  (cl-find-if (lambda (font)
                (member font (font-family-list)))
              (alist-get key my-fonts)))

(defun my-load-font ()
  "Load font configuration."
  (let ((default-font (format "%s:pixelsize=%s"
                              (my--get-font-with-code 'default)
                              my-font-size))
        (cjk-font (my--get-font-with-code 'cjk))
        (symbol-font (my--get-font-with-code 'unicode))
        (variable-font (my--get-font-with-code 'variable))
        (fixed-font (my--get-font-with-code 'fixed))
        (fixed-serif-font (my--get-font-with-code 'fixed-serif)))
    
    (set-face-attribute 'default nil :font default-font)
    (dolist (charset '(kana han hangul cjk-misc bopomofo))
      (set-fontset-font t charset cjk-font))
    (set-fontset-font t 'unicode symbol-font nil 'prepend)
    ;; Fonts for faces
    (set-face-attribute 'variable-pitch nil :family variable-font :height 1.0)
    (set-face-attribute 'fixed-pitch nil :family fixed-font :height 1.0)
    (set-face-attribute 'fixed-pitch-serif nil :family fixed-serif-font :height 1.0)))

(when window-system
  (my-load-font))

;; Run after startup
(add-hook 'after-init-hook
          (lambda ()
            (when window-system
              (my-load-font))))     


(use-package awesome-tray
  :straight (:type git :host github :repo "manateelazycat/awesome-tray")
  :config
  (defvar modeline-backup-format nil)
  (defun enable-awesome-tray-mode()
    (interactive)
    (set-face-attribute 'header-line nil :inherit 'unspecified)
    (setq modeline-backup-format mode-line-format)
    (setq-default mode-line-format '(" "))
    (setq awesome-tray-mode-line-active-color (face-attribute 'highlight :background))
    (awesome-tray-mode +1))
  (defun disable-awesome-tray-mode()
    (interactive)
    (set-face-attribute 'header-line nil :inherit 'mode-line)
    (setq-default mode-line-format modeline-backup-format)
    (setq modeline-backup-format nil)
    (awesome-tray-mode -1))
  
  (add-hook 'emacs-startup-hook #'enable-awesome-tray-mode)
  (add-hook 'after-load-theme-hook #'enable-awesome-tray-mode)

  (defun awesome-tray-module-datetime-info ()
    (let ((system-time-locale "C"))
      (format-time-string "[%H:%M] %a")))


  (add-to-list 'awesome-tray-module-alist
               '("datetime" . (awesome-tray-module-datetime-info awesome-tray-module-date-face)))
  (add-to-list 'awesome-tray-module-alist
               '("meow" . (meow-indicator awesome-tray-module-evil-face)))

  (setq awesome-tray-active-modules '("meow"
                                      "git"
                                      "location"
                                      "mode-name"
                                      "parent-dir"
                                      "buffer-name"
                                      "buffer-read-only"
                                      "datetime")))

(use-package all-the-icons
  :init (unless (or IS-WINDOWS (font-installed-p "all-the-icons"))
          (all-the-icons-install-fonts t))
  :config
  (with-no-warnings
    (defun all-the-icons-reset ()
      "Reset the icons."
      (interactive)
      (dolist (func '(all-the-icons-icon-for-dir
                      all-the-icons-icon-for-file
                      all-the-icons-icon-for-mode
                      all-the-icons-icon-for-url
                      all-the-icons-icon-family-for-file
                      all-the-icons-icon-family-for-mode
                      all-the-icons-icon-family))
        (all-the-icons-cache func))
      (message "Reset all-the-icons"))))

(provide 'init-ui)
;;; init-ui.el ends here
