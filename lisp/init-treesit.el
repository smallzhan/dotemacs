
(use-package treesit-auto
  :config
  (setq treesit-auto-install 'prompt)
  (global-treesit-auto-mode))

;; ;;; Require
;; (require 'treesit)
;; 
;; ;;; Code:
;; 
;; ;; M-x `treesit-install-language-grammar` to install language grammar.
;; (setq treesit-language-source-alist
;;       '((bash . ("https://github.com/tree-sitter/tree-sitter-bash"))
;;         (c . ("https://github.com/tree-sitter/tree-sitter-c"))
;;         (cpp . ("https://github.com/tree-sitter/tree-sitter-cpp"))
;;         (css . ("https://github.com/tree-sitter/tree-sitter-css"))
;;         (cmake . ("https://github.com/uyha/tree-sitter-cmake"))
;;         (csharp     . ("https://github.com/tree-sitter/tree-sitter-c-sharp.git"))
;;         (dockerfile . ("https://github.com/camdencheek/tree-sitter-dockerfile"))
;;         (elisp . ("https://github.com/Wilfred/tree-sitter-elisp"))
;;         (go . ("https://github.com/tree-sitter/tree-sitter-go"))
;;         (gomod      . ("https://github.com/camdencheek/tree-sitter-go-mod.git"))
;;         (html . ("https://github.com/tree-sitter/tree-sitter-html"))
;;         (java       . ("https://github.com/tree-sitter/tree-sitter-java.git"))
;;         (javascript . ("https://github.com/tree-sitter/tree-sitter-javascript"))
;;         (json . ("https://github.com/tree-sitter/tree-sitter-json"))
;;         (lua . ("https://github.com/Azganoth/tree-sitter-lua"))
;;         (make . ("https://github.com/alemuller/tree-sitter-make"))
;;         (markdown . ("https://github.com/MDeiml/tree-sitter-markdown" nil "tree-sitter-markdown/src"))
;;         (ocaml . ("https://github.com/tree-sitter/tree-sitter-ocaml" nil "ocaml/src"))
;;         (org . ("https://github.com/milisims/tree-sitter-org"))
;;         (python . ("https://github.com/tree-sitter/tree-sitter-python"))
;;         (php . ("https://github.com/tree-sitter/tree-sitter-php"))
;;         (typescript . ("https://github.com/tree-sitter/tree-sitter-typescript" nil "typescript/src"))
;;         (tsx . ("https://github.com/tree-sitter/tree-sitter-typescript" nil "tsx/src"))
;;         (ruby . ("https://github.com/tree-sitter/tree-sitter-ruby"))
;;         (rust . ("https://github.com/tree-sitter/tree-sitter-rust"))
;;         (sql . ("https://github.com/m-novikov/tree-sitter-sql"))
;;         (vue . ("https://github.com/merico-dev/tree-sitter-vue"))
;;         (yaml . ("https://github.com/ikatyang/tree-sitter-yaml"))
;;         (toml . ("https://github.com/tree-sitter/tree-sitter-toml"))
;;         (zig . ("https://github.com/GrayJack/tree-sitter-zig"))))
;; 
;; (setq major-mode-remap-alist
;;       '((c-mode          . c-ts-mode)
;;         (c++-mode        . c++-ts-mode)
;;         (cmake-mode      . cmake-ts-mode)
;;         (conf-toml-mode  . toml-ts-mode)
;;         (css-mode        . css-ts-mode)
;;         (js-mode         . js-ts-mode)
;;         (js-json-mode    . json-ts-mode)
;;         (python-mode     . python-ts-mode)
;;         (sh-mode         . bash-ts-mode)
;;         (typescript-mode . typescript-ts-mode)))

(add-hook 'emacs-lisp-mode-hook #'(lambda () (treesit-parser-create 'elisp)))

(use-package fingertip
  ;;:after tree-sitter
  :quelpa (fingertip :fetcher github :repo "manateelazycat/fingertip")
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
               'prog-mode-hook
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
               'typescript-ts-mode-hook))

  (add-hook hook #'(lambda () (fingertip-mode 1))))


(provide 'init-treesit)
