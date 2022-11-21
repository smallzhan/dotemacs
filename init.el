;;; init.el -*- lexical-binding: t; -*-

;;(setq user-emacs-directory (expand-file-name "Projects/dotemacs" (getenv "HOME")))

(defun update-load-path (&rest _)
  "Update `load-path'."
  (dolist (dir '("site-lisp" "lisp"))
    (push (expand-file-name dir user-emacs-directory) load-path)))

(defun add-subdirs-to-load-path (&rest _)
  "Add subdirectories to `load-path'."
  (let ((default-directory (expand-file-name "site-lisp" user-emacs-directory)))
    (normal-top-level-add-subdirs-to-load-path)))

(update-load-path)

;;(setq custom-theme-directory my-config-dir)
;;(setq bookmark-default-file (concat user-emacs-directory ".emacs.bmk")) ;书签文件

(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.5)
(add-hook 'emacs-startup-hook
          (lambda ()
            "Recover GC values after startup."
            (setq gc-cons-threshold 800000
                  gc-cons-percentage 0.1)))

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
;;(load custom-file 'noerror)


(defconst IS-WINDOWS (eq system-type 'windows-nt))

(defconst IS-MAC (eq system-type 'darwin))

(defconst IS-LINUX (eq system-type 'gnu/linux))

(defconst EMACS28+ (> emacs-major-version 27))

(defconst +my-org-dir (file-truename (expand-file-name "~/Nutstore/Notes/org/")))


(require 'init-defaults)
(require 'init-package-quelpa)
(require 'init-basic)
(require 'init-ui)
(require 'init-binding) 
(require 'init-project) 

(require 'init-vertico)
(require 'init-edit)
(require 'init-chinese)
;;(require 'init-company)
(require 'init-org)
(require 'init-denote)

(require 'init-lsp)
(require 'init-cc)
(require 'init-rust)
(require 'init-python)
(require 'init-tex)
(require 'init-go)

(require 'init-git)
(require 'init-highlight)
(require 'init-hs)
;;(require 'init-flycheck)

;;(require 'init-dired) 
(require 'init-window)
(require 'init-eaf)
(require 'init-dict)


(require 'init-server)
