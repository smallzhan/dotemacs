;; init-package-quelpa.el  -*- lexical-binding: t; -*- 

(require 'init-funcs)


(setq package-user-dir
      (expand-file-name (format "elpa-%s.%s" emacs-major-version emacs-minor-version)
                        user-emacs-directory))

(and (file-readable-p custom-file) (load custom-file))

(setq package-archives
      '(("gnu"    . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
        ("nongnu" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/nongnu/")
        ("melpa"  . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")
        ("m-stable"  . "http://mirrors.tuna.tsinghua.edu.cn/elpa/stable-melpa/")))
(setq package-archive-priorities
      '(("nongnu" . 10)
        ("gnu"     . 10)
        ("m-stable"     . 5)
        ("melpa"        . 0)))
; Initialize the emacs packaging system
;;
(when IS-WINDOWS (setq package-gnupghome-dir "elpa/gnupg"))
(unless (bound-and-true-p package--initialized)
  (setq package-enable-at-startup nil)
  (package-initialize))

;; Setup `use-package'
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-and-compile
  (setq use-package-always-ensure t)
  ;;(setq use-package-always-defer t)
  (setq use-package-expand-minimally t)
  (setq use-package-enable-imenu-support t))

(eval-when-compile
  (require 'use-package))

(use-package gnu-elpa-keyring-update)
(use-package quelpa
  :init (setq quelpa-update-melpa-p nil
              quelpa-checkout-melpa-p nil))

(use-package quelpa-use-package)


(provide 'init-package-quelpa)
;;; 
