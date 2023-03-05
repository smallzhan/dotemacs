;; -*- lexical-binding: t; -*-

(use-package tree-sitter-langs :defer t)

(use-package tree-sitter
  :defer t
  :hook (prog-mode . tree-sitter-mode)
  :hook (tree-sitter-after-on . tree-sitter-hl-mode)
  :config
  (require 'tree-sitter-langs)
  (defun tree-sitter-fail-gracefully-a (orig-fn &rest args)
    "Don't break with errors when current major mode lacks tree-sitter support."
    (condition-case e
        (apply orig-fn args)
      (error
       (unless (string-match-p (concat "^Cannot find shared library\\|"
                                       "^No language registered\\|"
                                       "cannot open shared object file")
                               (error-message-string e))
         (signal (car e) (cadr e))))))
  (advice-add 'tree-sitter-mode :around #'tree-sitter-fail-gracefully-a)
  (add-to-list 'tree-sitter-load-path 
               (expand-file-name "tree-sitter/bin/" user-emacs-directory))
  (tree-sitter-load 'elisp "elisp")
  (dolist (mode '(emacs-lisp-mode
                  inferior-emacs-lisp-mode
                  lisp-interaction-mode))
   (add-to-list 'tree-sitter-major-mode-language-alist `(,mode . elisp))))



  
(use-package grammatical-edit
  ;;:after tree-sitter
  :quelpa (grammatical-edit :fetcher github :repo "manateelazycat/grammatical-edit")
  :bind (:map grammatical-edit-mode-map
              ;; 移动
              ("M-n" . grammatical-edit-jump-left)
              ("M-p" . grammatical-edit-jump-right)
              ;; 符号插入
              ("%" . grammatical-edit-match-paren)       ;括号跳转
              ("(" . grammatical-edit-open-round)        ;智能 (
              ("[" . grammatical-edit-open-bracket)      ;智能 [
              ("{" . grammatical-edit-open-curly)        ;智能 {
              (")" . grammatical-edit-close-round)       ;智能 )
              ("]" . grammatical-edit-close-bracket)     ;智能 ]
              ("}" . grammatical-edit-close-curly)       ;智能 }
              ("\"" . grammatical-edit-double-quote)     ;智能 \"
              ("'" . grammatical-edit-single-quote)      ;智能 '
              ("=" . grammatical-edit-equal)             ;智能 =
              ;;("SPC" . grammatical-edit-space)           ;智能 space
              ;;("RET" . grammatical-edit-newline)         ;智能 newline
              ;; 删除
              ("M-o" . grammatical-edit-backward-delete) ;向后删除
              ("C-d" . grammatical-edit-forward-delete)  ;向前删除
              ("C-k" . grammatical-edit-kill)            ;向前kill
              ;; 包围
              ("M-\"" . grammatical-edit-wrap-double-quote) ;用 " " 包围对象, 或跳出字符串
              ("M-'" . grammatical-edit-wrap-single-quote) ;用 ' ' 包围对象, 或跳出字符串
              ("M-[" . grammatical-edit-wrap-bracket)      ;用 [ ] 包围对象
              ("M-{" . grammatical-edit-wrap-curly)        ;用 { } 包围对象
              ("M-(" . grammatical-edit-wrap-round)        ;用 ( ) 包围对象
              ("M-)" . grammatical-edit-unwrap)            ;去掉包围对象
        ;; 跳出并换行缩进
              ("C-j" . grammatical-edit-jump-out-pair-and-newline) ;跳出括号并换行
        ;; 向父节点跳动
              ("M-:" . grammatical-edit-jump-up))
  :hook ((prog-mode inferior-emacs-lisp-mode minibuffer-inactive-mode sh-mode) . grammatical-edit-mode)
  :config
  (defun my-indent-current ()
    (indent-for-tab-command))
  (advice-add #'grammatical-edit-open-curly :after #'my-indent-current))


(provide 'init-tree-sitter)  
