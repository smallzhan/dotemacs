;; -*- mode: lisp-interaction; coding: utf-8; -*-
;(set-default-font "WenQuanYi Micro Hei:pixelsize=14")
;(set-fontset-font (frame-parameter nil 'font)
;                 'han (font-spec :family "WenQuanYi Micor Hei" :size 16))
;(set-fontset-font (frame-parameter nil 'font)
;                 'symbol (font-spec :family "WenQuanYi Micro Hei" :size 16))
;(set-fontset-font (frame-parameter nil 'font)
;                 'cjk-misc (font-spec :family "WenQuanYi Micro Hei" :size 16))
;(set-fontset-font (frame-parameter nil 'font)
;                 'bopomofo (font-spec :family "WenQuanYi Micro Hei" :size 16))

(defconst  my-emacs-path "~/myEmacs/")
(defconst  my-emacs-dir "~/myEmacs/.emacs.d/")
;(defconst my-emacs-path "/media/Works/smallqiang/myEmacs/")
;(defconst my-emacs-dir "/media/Works/smallqiang/.emacs.d/")
(defconst  my-lisp-path (concat my-emacs-path "site-lisp/"))

(add-to-list 'load-path my-lisp-path)
(defconst my-conf-path (concat my-emacs-path "config/"))
(defconst my-config-dir (concat my-emacs-path "config/"))


(setq custom-theme-directory my-config-dir)
(setq bookmark-defaul-file (concat my-emacs-path ".emacs.bmk")) ;书签文件
(setq custom-file (concat my-config-dir "custom.el"))
(load custom-file 'noerror)


(setq package-user-dir (concat my-config-dir "elpa"))
(package-initialize)

(unless (fboundp 'org-babel-load-file)
  (require 'org)
  (require 'ob)
)

(org-babel-load-file (concat my-config-dir "config.org"))

(when (eq system-type 'darwin)
  (require 'prelude-osx))

(put 'dired-find-alternate-file 'disabled nil)
