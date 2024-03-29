;; -*- lexical-binding: t; -*-


(use-package tree-sitter
  :defer t
  :hook (prog-mode . tree-sitter-mode)
  :hook (tree-sitter-after-on . tree-sitter-hl-mode)
  :config
  (require 'tree-sitter-langs)
  
  (defun doom-tree-sitter-fail-gracefully-a (orig-fn &rest args)
    "Don't break with errors when current major mode lacks tree-sitter support."
    :around #'tree-sitter-mode
    (condition-case e
        (apply orig-fn args)
      (error
       (unless (string-match-p (concat "^Cannot find shared library\\|"
                                       "^No language registered\\|"
                                       "cannot open shared object file")
                               (error-message-string e))
         (signal (car e) (cadr e))))))
  
  
  (tree-sitter-load 'elisp "elisp")
  (add-to-list 'tree-sitter-major-mode-language-alist '(emacs-lisp-mode . elisp)))
