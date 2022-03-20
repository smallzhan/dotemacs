;;; lang/python/config.el -*- lexical-binding: t; -*-

(defvar +python-ipython-command '("ipython" "-i" "--simple-prompt" "--no-color-info")
  "Command to initialize the ipython REPL for `+python/open-ipython-repl'.")

(defvar +python-jupyter-command '("jupyter" "console" "--simple-prompt")
  "Command to initialize the jupyter REPL for `+python/open-jupyter-repl'.")

;; (after! projectile
;;   (pushnew! projectile-project-root-files "setup.py" "requirements.txt"))


;;
;;; Packages

(use-package python
  :mode ("[./]flake8\\'" . conf-mode)
  :mode ("/Pipfile\\'" . conf-mode)
  :init
  (setq python-shell-completion-native-enable nil
        python-indent-guess-indent-offset-verbose nil)


  :config

  (when (and (executable-find "python3")
             (string= python-shell-interpreter "python"))
    (setq python-shell-interpreter "python3"))
  (define-key python-mode-map (kbd "DEL") nil))

;;(use-package live-py-mode :defer t)
(use-package pyimport :defer t
  :bind (:map python-mode-map
              ("M-RET" . pyimport-insert-missing)
              ("M-_" . pyimport-remove-unused)))

(use-package py-isort :defer t)

(use-package python-mls
  :config
  (python-mls-setup))

(provide 'init-python)
;;; init-python.el ends here
