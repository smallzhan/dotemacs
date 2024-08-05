;; -*- lexical-binding: t; -*-

(use-package rust-mode
  :commands (rust-compile rust-run rust-check rust-run-clippy)
  :config
  (setq rust-cargo-bin (executable-find "cargo")
        rust-rustfmt-bin (executable-find "rustfmt")))
 

(with-eval-after-load 'rust-ts-mode
   (with-eval-after-load 'transient
    (transient-define-prefix my-rust-transient ()
      "Rust/Cargo Command"
      ["Rust Cargo Command"
       ("b" "Cargo Build" rust-compile)
       ("B" "Cargo Build --release" rust-compile-release)
       ("c" "Cargo Check" rust-check)
       ("f" "Rust Format" rust-format-buffer)
       ("F" "Rust Goto Format Problem" rust-goto-format-problem)
       ("k" "Cargo Check clippy" rust-run-clippy)
       ("r" "Cargo Run" rust-run)
       ("R" "Cargo Run --release" rust-run-release)
       ("t" "Cargo test" rust-test)]))
  (define-key rust-ts-mode-map (kbd "C-c C-c") #'my-rust-transient))
  


;;(use-package cargo)

;; (use-package cargo-transient
;;   :defer t
;;   :ensure nil
;;   :load-path "~/.emacs.d/site-lisp/cargo-transient"
;;   :commands cargo-transient
;;   :custom
;;   (cargo-transient-buffer-name-function #'project-prefixed-buffer-name))
;; 
;; (with-eval-after-load "rust-ts-mode"
;;  (define-key rust-ts-mode-map (kbd "C-c C-c") #'cargo-transient))

;; (use-package cargo
;;   :hook
;;   (rust-ts-mode . cargo-minor-mode)
;;   :config
;;   (setq cargo-process--custom-path-to-bin
;;         (file-name-directory (executable-find "cargo"))))

(use-package rust-playground
  :defer t
  :commands rust-playground
  :config
  (setq rust-playground-basedir "~/Projects/Rust/playground"))
(provide 'init-rust)

