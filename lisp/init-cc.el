;; -*- init-cc.el lexical-binding: t; -*-

(with-eval-after-load 'cc-mode
  ;; (defconst my-c-style
  ;;   '((c-basic-offset . 4)
  ;;     (c-recognize-knr-p . nil)
  ;;     (c-tab-always-indent . t)
  ;;     (c-comment-only-line-offset . 0)
  ;;     ;;(indent-tabs-mode . nil)
  ;;     (c-hanging-braces-alist . ((substatement-open after)
  ;;                                (brace-list-open)))
  ;;     (c-cleanup-list . (comment-close-slash
  ;;                        empty-defun-braces
  ;;                        list-close-comma
  ;;                        compact-empty-funcall))
  ;;     (c-offsets-alist . ((substatement-open . 0)
  ;;                         (innamespace . 0) 
  ;;                         (case-label  . +) 
  ;;                         (access-label . -)
  ;;                         (inline-open . 0) 
  ;;                         (block-open  . 0))))
  ;;   "My Cpp Coding Style")
  ;; (c-add-style "my-c-style" my-c-style)       

  (c-add-style "my-style"
               '("stroustrup"
                 (c-tab-always-indent . t)
                 (c-hanging-braces-alist . ((substatement-open after)
                                            (brace-list-open)))
                 (c-cleanup-list . (comment-close-slash
                                    empty-defun-braces
                                    list-close-comma
                                    compact-empty-funcall))
                 (c-offset-alist . ((innamespace . 0)
                                    (case-label . +)
                                    (access-label . -)
                                    (inline-open . 0)
                                    (block-open . 0)))))
                 
  (defun my-c-mode-common-hook ()
    "my c mode define"
    (interactive)
    (c-set-style "my-style")
    (c-toggle-auto-newline 1))

  (add-hook 'c-mode-common-hook 'my-c-mode-common-hook)

  (defun my-c-initialization-hook ()
    (define-key c-mode-base-map "\C-m" 'c-context-line-break))
  
  (add-hook 'c-initialization-hook 'my-c-initialization-hook))


(provide 'init-cc)
;;; init-cc.el ends here
