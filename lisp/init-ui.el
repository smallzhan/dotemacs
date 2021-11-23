;;; init-ui.el -*- lexical-binding: t; -*-

;; theme
;; cycle by +my/toggle-cycle-theme, binding SPC t t
(straight-use-package 'doom-themes)
(load-theme 'doom-one)

;; disable line-number
(setq display-line-numbers-type nil)
(when IS-MAC
  (add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
  (add-to-list 'default-frame-alist '(ns-appearance . dark))
  (add-to-list 'initial-frame-alist '(fullscreen . maximized))
  (add-hook 'after-load-theme-hook
            (lambda ()
              (let ((bg (frame-parameter nil 'background-mode)))
                (set-frame-parameter nil 'ns-appearance bg)
                (setcdr (assq 'ns-appearance default-frame-alist) bg)))))




(defvar default-fonts '("JetBrains Mono" "Fira Code" "SF Mono"))
;;font
(if IS-MAC
    (set-face-attribute 'default nil :font (nth (random (length default-fonts)) default-fonts))
  (set-face-attribute 'default nil :font  "DejaVu Sans Mono"))
(set-face-attribute 'default nil :height (cond (IS-MAC 130)
                                               (IS-WINDOWS 110)
                                               (t 120)))

;;(setq doom-unicode-font (font-spec :family "Sarasa Mono SC" :size 14))
                                        ;(set-default-font "Sarasa Mono SC 14")
(set-face-attribute 'fixed-pitch nil
                    :family "Sarasa Mono SC"
                    :inherit '(default))

(catch 'loop
  (dolist (font '("Apple Color Emoji" "Symbola"))
    (when (member font (font-family-list))
      (set-fontset-font t 'unicode font nil 'prepend)
      (throw 'loop t))))

(defun find-fonts (fontlist)
  (let ((font (car fontlist))
        (other (cdr fontlist)))
    (if (null font)
        nil
      (if (find-font (font-spec :name font))
          font
        (find-fonts other)))))

(defvar chinese-fonts '("PingFang SC" "Microsoft YaHei" "Sarasa Mono SC"))


(run-at-time "2sec" nil
             (lambda ()
               (let ((font (find-fonts chinese-fonts)))
                 (dolist (charset '(kana han cjk-misc bopomofo))
                   (set-fontset-font t charset font)))))


(use-package awesome-tray
  :straight (awesome-tray :type git :host github :repo "manateelazycat/awesome-tray")
  :config
  (defvar modeline-backup-format nil)
  (defun enable-awesome-tray-mode()
    (interactive)
    (setq modeline-backup-format mode-line-format
          mode-line-format "")
    (setq awesome-tray-mode-line-active-color (face-attribute 'highlight :background))
    (awesome-tray-mode +1))
  (defun disable-awesome-tray-mode()
    (interactive)
    (setq mode-line-format modeline-backup-format
          modeline-backup-format nil)
    (awesome-tray-mode -1))

  (add-hook 'emacs-startup-hook #'enable-awesome-tray-mode)

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
