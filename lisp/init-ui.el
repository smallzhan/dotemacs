;;; init-ui.el -*- lexical-binding: t; -*-

;; theme


      
(use-package doom-themes
  :pin melpa
  :config
  (cond ((boundp 'ns-system-appearance-change-functions)
         (defun change-appearance (appearance)
           (mapc #'disable-theme custom-enabled-themes)
           (pcase appearance
             ('light (load-theme 'doom-one-light t))
             ('dark (load-theme 'doom-one t))))
         (add-hook 'ns-system-appearance-change-functions #'change-appearance))
        ((boundp 'mac-effective-appearance-change-hook)
         (defun change-appearance ()
            (mapc #'disable-theme custom-enabled-themes)
            (pcase (plist-get (mac-application-state) :appearance)
              ("NSAppearanceNameAqua" (load-theme 'doom-one-light t))
              ("NSAppearanceNameDarkAqua" (load-theme 'doom-one t))))
         (change-appearance)
         (add-hook 'mac-effective-appearance-change-hook #'change-appearance))
        (IS-MAC (use-package auto-dark
                  :config
                  (setq auto-dark-dark-theme 'doom-one)
                  (setq auto-dark-light-theme 'doom-one-light)
                  (auto-dark-mode t)))
        (t (load-theme 'doom-one t))))
  ;; (if IS-MAC
  ;;     (progn)
  ;;      
  ;;   
  ;;     ;; (add-hook 'mac-effective-appearance-change-hook
  ;;     ;;           #'(lambda (appearance)
  ;;     ;;               (mapc #'disable-theme custom-enabled-themes)
  ;;     ;;               (pcase appearance
  ;;     ;;                 ('light (load-theme 'doom-one-light t))
  ;;     ;;                 ('dark (load-theme 'doom-one t)))))
  ;;   (load-theme 'doom-one t)))

;; disable line-number
(setq display-line-numbers-type nil)
(when IS-MAC
  ;;   ;;(add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
  (add-to-list 'default-frame-alist '(undecorated . t))
;;   ;;(add-to-list 'default-frame-alist '(ns-appearance . dark))
  (add-to-list 'initial-frame-alist '(fullscreen . maximized)))
;;   (add-hook 'after-load-theme-hook
;;             (lambda ()
;;               (let ((bg (frame-parameter nil 'background-mode)))
;;                 (set-frame-parameter nil 'ns-appearance bg)
;;                 (setcdr (assq 'ns-appearance default-frame-alist) bg)))))




;;;======= font config

(defvar my-fonts '((default . ("IBM Plex Mono" "DejaVu Sans Mono" "JetBrains Mono" "Cascadia Code" "Fira Code" "SF Mono"))
                   (cjk . ("LXGW WenKai" "Source Han Serif SC" "PingFang SC" "Microsoft YaHei UI" "Sarasa Mono SC"))
                   (unicode . ("Apple Color Emoji" "Segoe UI Emoji" "Symbola"))
                   (fixed . ("Iosevka Fixed" "Sarasa Mono SC"))
                   (fixed-serif . ("Latin Modern Mono" "LM Mono 10" "Courier New"))
                   (variable . ("Bookerly" "Source Serif 4" "Times New Roman"))))
                   

(defvar my-font-size 18)   

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
 
(custom-theme-set-faces
  'user
  ;;'(fixed-pitch ((t (:family "SF Mono" :height 1.0))))
  ;;'(variable-pitch ((t (:family "Bookerly" :height 1.0))))
  ;;'(mode-line ((t (:inherit variable-pitch :height 1.0))))
  ;;'(mode-line-inactive ((t (:inherit variable-pitch :height 1.0))))
  '(Info-quoted ((t (:inherit fixed-pitch))))
  '(org-block ((t (:inherit fixed-pitch))))
  '(org-code ((t (:inherit (shadow fixed-pitch)))))
  '(org-document-info-keyword ((t (:inherit (shadow fixed-pitch)))))
  '(org-indent ((t (:inherit (org-hide fixed-pitch)))))
  '(org-meta-line ((t (:inherit (font-lock-comment-face fixed-pitch)))))
  '(org-property-value ((t (:inherit fixed-pitch))) t)
  '(org-special-keyword ((t (:inherit (font-lock-comment-face fixed-pitch)))))
  '(org-table ((t (:inherit fixed-pitch))))
  '(org-tag ((t (:inherit (shadow fixed-pitch-serif) :weight bold :height 1.0))))
  '(org-latex-and-related ((t (:inherit 'fixed-pitch-serif))))
  '(org-checkbox ((t :inherit 'fixed-pitch :box nil)))
  '(org-drawer ((t :inherit 'fixed-pitch)))
  '(org-verbatim ((t (:inherit (shadow fixed-pitch))))))

(use-package awesome-tray
  :vc (:fetcher github :repo "manateelazycat/awesome-tray")
  :commands awesome-tray-mode
  :config
 
  
  

  (defun awesome-tray-module-datetime-info ()
    (let ((system-time-locale "C"))
      (format-time-string "[%H:%M] %a")))


  (add-to-list 'awesome-tray-module-alist
               '("datetime" . (awesome-tray-module-datetime-info awesome-tray-module-date-face)))
  (add-to-list 'awesome-tray-module-alist
               '("meow" . (meow-indicator awesome-tray-module-evil-face)))

  (setq awesome-tray-location-info-top " <T>")
  (setq awesome-tray-location-info-bottom " <B>")
  
  (setq awesome-tray-active-modules '("meow"
                                      "git"
                                      "location"
                                      "mode-name"
                                      "parent-dir"
                                      "buffer-name"
                                      "buffer-read-only"
                                      "datetime")))

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

(use-package nerd-icons :defer t)
(use-package nerd-icons-ibuffer
  :hook (ibuffer-mode . nerd-icons-ibuffer-mode))
;; (use-package all-the-icons
;;   :init (unless (or IS-WINDOWS (font-installed-p "all-the-icons"))
;;           (all-the-icons-install-fonts t))
;;   :config
;;   (with-no-warnings
;;     (defun all-the-icons-reset ()
;;       "Reset the icons."
;;       (interactive)
;;       (dolist (func '(all-the-icons-icon-for-dir
;;                       all-the-icons-icon-for-file
;;                       all-the-icons-icon-for-mode
;;                       all-the-icons-icon-for-url
;;                       all-the-icons-icon-family-for-file
;;                       all-the-icons-icon-family-for-mode
;;                       all-the-icons-icon-family))
;;         (all-the-icons-cache func))
;;       (message "Reset all-the-icons"))))ls


(provide 'init-ui)
;;; init-ui.el ends here
