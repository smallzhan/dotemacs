;;; private/rust/config.el  -*- lexical-binding: t; -*-

(use-package rustic
  :mode ("\\.rs$" . rustic-mode)
  :init
  (setq rustic-lsp-setup-p nil)
  (with-eval-after-load 'org-src
    (defalias 'org-babel-execute:rust #'org-babel-execute:rustic)
    (add-to-list 'org-src-lang-modes '("rust" . rustic)))
  :config
  (setq rustic-indent-method-chain t)

 ;; (set-docsets! 'rustic-mode "Rust")
 ;; (set-popup-rule! "^\\*rustic-compilation" :vslot -1)

  ;; Leave automatic reformatting to the :editor format module.
  (setq rustic-babel-format-src-block nil
        rustic-format-trigger nil
        rustic-lsp-client 'eglot))

  ;; HACK `rustic-flycheck' adds all these hooks in disruptive places. Instead,
  ;;      leave it to our :checkers syntax module to do all the set up properly.
  ;;(remove-hook 'rustic-mode-hook #'flycheck-mode)
        ;;(remove-hook 'rustic-mode-hook #'flymake-mode-off)
  ;; (defun +rustic-setup-nox()
  ;;  (setq rustic-lsp-client 'nox)
  ;;  (require 'nox)
  ;;  (nox-ensure))
  ;; (add-hook 'rustic-mode-hook #'+rustic-setup-nox))

  ;; (map! :map rustic-mode-map
  ;;       :localleader
  ;;       (:prefix ("b" . "build")
  ;;        ;;:desc "cargo audit"      "a" #'+rust/cargo-audit
  ;;        :desc "cargo build"      "b" #'rustic-cargo-build
  ;;        :desc "cargo bench"      "B" #'rustic-cargo-bench
  ;;        :desc "cargo check"      "c" #'rustic-cargo-check
  ;;        :desc "cargo clippy"     "C" #'rustic-cargo-clippy
  ;;        :desc "cargo doc"        "d" #'rustic-cargo-build-doc
  ;;        :desc "cargo doc --open" "D" #'rustic-cargo-doc
  ;;        :desc "cargo fmt"        "f" #'rustic-cargo-fmt
  ;;        :desc "cargo new"        "n" #'rustic-cargo-new
  ;;        :desc "cargo outdated"   "o" #'rustic-cargo-outdated
  ;;        :desc "cargo run"        "r" #'rustic-cargo-run)
  ;;       (:prefix ("t" . "cargo test")
  ;;        :desc "all"          "a" #'rustic-cargo-test
  ;;        :desc "current test" "t" #'rustic-cargo-current-test)
(provide 'init-rust)
;;; init-rust.el ends here
