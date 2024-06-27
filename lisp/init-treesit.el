
(use-package treesit-auto
  :config
  (setq treesit-auto-install 'prompt)
  (global-treesit-auto-mode))


(add-hook 'emacs-lisp-mode-hook #'(lambda () (treesit-parser-create 'elisp)))
(setq c-ts-mode-indent-style 'bsd)
(setq c-ts-mode-indent-offset 4)

(use-package fingertip
  ;;:after tree-sitter
  ;;:load-path "~/.emacs.d/site-lisp/fingertip"
  :quelpa (fingertip :fetcher git :url "https://github.com/manateelazycat/fingertip")
  :commands fingertip-mode
  :bind (:map fingertip-mode-map
              ;; 移动
              ("M-n" . fingertip-jump-left)
              ("M-p" . fingertip-jump-right)
              ;; 符号插入
              ("%" . fingertip-match-paren)       ;括号跳转
              ("(" . fingertip-open-round)        ;智能 (
              ("[" . fingertip-open-bracket)      ;智能 [
              ("{" . fingertip-open-curly)        ;智能 {
              (")" . fingertip-close-round)       ;智能 )
              ("]" . fingertip-close-bracket)     ;智能 ]
              ("}" . fingertip-close-curly)       ;智能 }
              ("\"" . fingertip-double-quote)     ;智能 \"
              ("'" . fingertip-single-quote)      ;智能 '
              ("=" . fingertip-equal)             ;智能 =
              ;;("SPC" . fingertip-space)           ;智能 space
              ;;("RET" . fingertip-newline)         ;智能 newline
              ;; 删除
              ("M-o" . fingertip-backward-delete) ;向后删除
              ("C-d" . fingertip-forward-delete)  ;向前删除
              ("C-k" . fingertip-kill)            ;向前kill
              ;; 包围
              ("M-\"" . fingertip-wrap-double-quote) ;用 " " 包围对象, 或跳出字符串
              ("M-'" . fingertip-wrap-single-quote) ;用 ' ' 包围对象, 或跳出字符串
              ("M-[" . fingertip-wrap-bracket)      ;用 [ ] 包围对象
              ("M-{" . fingertip-wrap-curly)        ;用 { } 包围对象
              ("M-(" . fingertip-wrap-round)        ;用 ( ) 包围对象
              ("M-)" . fingertip-unwrap)            ;去掉包围对象
              ;; 跳出并换行缩进
              ("C-j" . fingertip-jump-out-pair-and-newline) ;跳出括号并换行
              ;; 向父节点跳动
              ("M-:" . fingertip-jump-up))
  :config
  (defun my-indent-current ()
    (indent-for-tab-command))
  (advice-add #'fingertip-open-curly :after #'my-indent-current))

(dolist (hook (list
               ;; 'prog-mode-hook
               ;; 'c-mode-common-hook
               ;; 'c-mode-hook
               ;; 'c++-mode-hook
               ;; 'java-mode-hook
               ;; 'haskell-mode-hook
               'emacs-lisp-mode-hook
               ;; 'lisp-interaction-mode-hook
               ;; 'lisp-mode-hook
               ;; 'maxima-mode-hook
               ;; 'ielm-mode-hook
               ;; 'sh-mode-hook
               ;; 'makefile-gmake-mode-hook
               ;; 'php-mode-hook
               ;; 'python-mode-hook
               ;; 'js-mode-hook
               ;; 'go-mode-hook
               ;; 'qml-mode-hook
               ;; 'jade-mode-hook
               ;; 'css-mode-hook
               ;; 'ruby-mode-hook
               ;; 'coffee-mode-hook
               ;; 'rust-mode-hook
               ;; 'qmake-mode-hook
               ;; 'lua-mode-hook
               ;; 'swift-mode-hook
               ;; 'minibuffer-inactive-mode-hook
               ;; 'typescript-mode-hook

               'c-ts-mode-hook
               'c++-ts-mode-hook
               'cmake-ts-mode-hook
               'toml-ts-mode-hook
               'css-ts-mode-hook
               'js-ts-mode-hook
               'json-ts-mode-hook
               'python-ts-mode-hook
               'bash-ts-mode-hook
               'typescript-ts-mode-hook
               'php-ts-mode-hook
               'rust-ts-mode-hook))

  (add-hook hook #'(lambda () (fingertip-mode 1))))

(use-package treesit-fold
  :quelpa (treesit-fold :fetcher git :url "https://github.com/emacs-tree-sitter/treesit-fold")

  :commands (treesit-fold-open treesit-fold-toggle))

(provide 'init-treesit)
