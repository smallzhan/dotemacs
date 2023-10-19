;; -*- lexical-binding: t; -*-

;;(use-package rust-mode)
;;(use-package cargo)

(use-package cargo-transient
  :defer t
  :commands cargo-transient
  :custom
  (cargo-transient-buffer-name-function #'project-prefixed-buffer-name))

(with-eval-after-load "rust-ts-mode"
 (define-key rust-ts-mode-map (kbd "C-c C-c") #'cargo-transient))
 
(use-package rust-playground
  :defer t
  :commands rust-playground
  :config
  (setq rust-playground-basedir "~/Projects/Rust/playground"))
(provide 'init-rust)

