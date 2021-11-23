;; init-package.el -*- lexical-binding: t; -*-

;;(require 'init-const)
;;(require 'init-custom)
(require 'init-funcs)


;;(setq package-enable-at-startup nil)
(and (file-readable-p custom-file) (load custom-file))
(setq comp-deferred-compilation-deny-list ())
(setq straight-vc-git-default-clone-depth 1)

(setq straight-disable-native-compile
      (when (fboundp 'native-comp-available-p)
        (not (native-comp-available-p))))

(setq straight-use-package-by-default t
      straight-build-dir (format "build-%s" emacs-version))

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'use-package)

(use-package bind-key)

(provide 'init-package)
