

(use-package transient
  :defer t
  :commands (transient-define-prefix transient-define-suffix)
  :config
  (transient-bind-q-to-quit))

(use-package color-rg
  :quelpa (color-rg :fetcher github :repo "manateelazycat/color-rg")
  :commands (color-rg-search-symbol-in-project
             color-rg-search-input-in-project
             color-rg-search-input-in-current-file
             color-rg-search-symbol-in-current-file)
  :init 
  (setq color-rg-kill-temp-buffer-p nil
        color-rg-mac-load-path-from-shell nil)
  :config
  (setq color-rg-ignore-dir-list '("node_modules" "dist" "__pycache__" "straight" "elpa*" "history"))

  (setq rg-glob-fmt
        (if IS-WINDOWS
            "-g \"!%s\" "
          "-g '!%s' "))

  (setq color-rg-search-ignore-rules
        (mapconcat
         (lambda (x) (format rg-glob-fmt x)) color-rg-ignore-dir-list ""))
  
  (with-eval-after-load 'org
   (defun color-rg-search-in-org-roam ()
     "Search in org-roam directory"
     (interactive)
     (color-rg-search-input (color-rg-read-input) org-roam-directory))
   (define-key app-search-keymap (kbd "m") #'color-rg-search-in-org-roam)))

(use-package auto-save
  :quelpa (auto-save :fetcher github :repo "manateelazycat/auto-save")
  :init
  (setq auto-save-silent t)
  :config
  (auto-save-enable))

;; (use-package lazy-search
;;   :quelpa (lazy-search :fetcher github :repo "manateelazycat/lazy-search")
;;   :commands lazy-search)

(use-package delete-block
  :quelpa (delete-block :fetcher github :repo "manateelazycat/delete-block")
  :commands (delete-block-forward delete-block-backward))

(use-package thing-edit
  :quelpa (thing-edit :fetcher github :repo "manateelazycat/thing-edit")
  :bind ("C-c e e" . thing-edit-transient)
  :config
  (transient-define-prefix thing-edit-transient ()
    "Thing Edit Menu"
    ["Thing Edit Menu"
     ["Copy"
      ("cd" "Thing copy defun" thing-copy-defun)
      ("cl" "Thing copy line" thing-copy-line)
      ("ce" "Thing copy sexp" thing-copy-sexp)
      ("cw" "Thing copy word" thing-copy-word)
      ("cs" "Thing copy symbol" thing-copy-symbol)
      ("cf" "Thing copy filename" thing-copy-filename)
      ("ct" "Thing copy list" thing-copy-list)
      ("cc" "Thing copy sentence" thing-copy-sentence)
      ("cp" "Thing copy paragraph" thing-copy-paragraph)
      ("cg" "Thing copy page" thing-copy-page)
      ("cu" "Thing copy url" thing-copy-url)
      ("cm" "Thing copy email" thing-copy-email)
      ("cb" "Thing copy comment" thing-copy-whole-buffer)
      ("cn" "Thing copy number" thing-copy-number)
      ("ca" "Thing copy paren" thing-copy-parentheses)
      ("cr" "Thing copy region or line" thing-copy-region-or-line)]  
     ["Cut"
      ("xd" "Thing cut defun" thing-cut-defun)
      ("xl" "Thing cut line" thing-cut-line)
      ("xe" "Thing cut sexp" thing-cut-sexp)
      ("xw" "Thing cut word" thing-cut-word)
      ("xs" "Thing cut symbol" thing-cut-symbol)
      ("xf" "Thing cut filename" thing-cut-filename)
      ("xt" "Thing cut list" thing-cut-list)
      ("xc" "Thing cut sentence" thing-cut-sentence)
      ("xp" "Thing cut paragraph" thing-cut-paragraph)
      ("xg" "Thing cut page" thing-cut-page)
      ("xu" "Thing cut url" thing-cut-url)
      ("xm" "Thing cut email" thing-cut-email)
      ("xb" "Thing cut comment" thing-cut-whole-buffer)
      ("xn" "Thing cut number" thing-cut-number)
      ("xa" "Thing cut paren" thing-cut-parentheses)
      ("xr" "Thing cut region or line" thing-cut-region-or-line)]
     ["Replace"
      ("rd" "Thing replace defun" thing-replace-defun)
      ("rl" "Thing replace line" thing-replace-line)
      ("re" "Thing replace sexp" thing-replace-sexp)
      ("rw" "Thing replace word" thing-replace-word)
      ("rs" "Thing replace symbol" thing-replace-symbol)
      ("rf" "Thing replace filename" thing-replace-filename)
      ("rt" "Thing replace list" thing-replace-list)
      ("rc" "Thing replace sentence" thing-replace-sentence)
      ("rp" "Thing replace paragraph" thing-replace-paragraph)
      ("rg" "Thing replace page" thing-replace-page)
      ("ru" "Thing replace url" thing-replace-url)
      ("rm" "Thing replace email" thing-replace-email)
      ("rb" "Thing replace comment" thing-replace-whole-buffer)
      ("rn" "Thing replace number" thing-replace-number)
      ("ra" "Thing replace paren" thing-replace-parentheses)
      ("rr" "Thing replace region or line" thing-replace-region-or-line)]]))
 ;; (global-set-key (kbd "C-c e a") #'thing-edit-transient))
 
;; (use-package awesome-pair
;; :straight (:type git :host github :repo "manateelazycat/awesome-pair")
;; :bind (:map awesome-pair-mode-map
;;        ("(" . awesome-pair-open-round)
;;        ("[" . awesome-pair-open-bracket)
;;        ("{" . awesome-pair-open-curly)
;;        (")" . awesome-pair-close-round)
;;        ("]" . awesome-pair-close-bracket)
;;        ("}" . awesome-pair-close-curly)
;;        ("=" . awesome-pair-equal)
;; 
;;        ("%" . awesome-pair-match-paren)
;;        ("\"" . awesome-pair-double-quote)
;;        ("SPC" . awesome-pair-space)
;; 
;;        ("M-o" . awesome-pair-backward-delete)
;;        ("C-d" . awesome-pair-forward-delete)
;;        ("C-k" . awesome-pair-kill)
;; 
;;        ("M-\"" . awesome-pair-wrap-double-quote)
;;        ("M-[" . awesome-pair-wrap-bracket)
;;        ("M-{" . awesome-pair-wrap-curly)
;;        ("M-(" . awesome-pair-wrap-round)
;;        ("M-)" . awesome-pair-unwrap)
;;        ("M-p" . awesome-pair-jump-right)
;;        ("M-n" . awesome-pair-jump-left)
;;        ("M-:" . awesome-pair-jump-out-pair-and-newline))
;; 
;; :hook ((prog-mode ielm-mode minibuffer-inactive-mode sh-mode) . awesome-pair-mode))
;; (when IS-WINDOWS
;;   (use-package counsel-etags
;;     ;;:ensure t
;;     :bind (("M-]" . counsel-etags-find-tag-at-point))
;;     :init
;;     (add-hook 'prog-mode-hook
;;               (lambda ()
;;                 (add-hook 'after-save-hook
;;                           'counsel-etags-virtual-update-tags 'append 'local)))
;;     :config
;;     (setq counsel-etags-update-interval 60)
;;     (dolist (dir '("build" ".ccls-cache" "Debug" "Release" "rime" ".local"))
;;       (push dir counsel-etags-ignore-directories))
;;     (dolist (ext '("*.bin" "*.hex" "*.pdb"))
;;       (push ext counsel-etags-ignore-filenames))))

(use-package posframe :defer t)

(use-package sdcv
  :quelpa (sdcv :fetcher github :repo "manateelazycat/sdcv")
  :ensure nil
  :defer t
  :commands (sdcv-search-input sdcv-search-pointer+)
  :config
  ;;(set-face-foreground 'sdcv-tooltip-face "#51afef")
  (setq sdcv-program (executable-find "sdcv"))
  (setq sdcv-dictionary-simple-list '("牛津现代英汉双解词典"))
  (setq sdcv-dictionary-complete-list '("牛津现代英汉双解词典"
                                        "CEDICT汉英辞典"
                                        "朗道汉英字典5.0"
                                        "21世纪双语科技词典"
                                        "朗道英汉字典5.0"))
  (setq sdcv-dictionary-data-dir (expand-file-name "~/.stardict/dic")))

;;   (defun sdcv-translate-result (word dictionary-list)
;;     "Call sdcv to search word in dictionary list, return filtered
;; string of results."
;;     (let ((command-string
;;            (format "%s -x -n %s %s --data-dir %s"
;;                    sdcv-program
;;                    (mapconcat (lambda (dict)
;;                                 (concat "-u \"" dict "\""))
;;                               dictionary-list " ")
;;                    (format "\"%s\"" word)
;;                    sdcv-dictionary-data-dir)))
;;       ;; (message command-string)
;;       (sdcv-filter
;;        (shell-command-to-string command-string)))))
;; ;; Set LANG environment variable, make sure `shell-command-to-string' can handle CJK character correctly.

;; (use-package puni
;;    :defer t
;;    :hook ((prog-mode
;;            sgml-mode
;;            nxml-mode
;;            tex-mode
;;            eval-expression-minibuffer-setup) . puni-mode))
;;(unless IS-WINDOWS

  ;; Bind your frequently used commands.
  ;; (global-set-key (kbd "C-c c j") #'citre-jump)
  ;; (global-set-key (kbd "C-c c J") #'citre-jump-back)
  ;; (global-set-key (kbd "C-c c p") #'citre-ace-peek))

(defun meow-setup ()
  (setq meow-cheatsheet-layout meow-cheatsheet-layout-qwerty)
  (meow-motion-overwrite-define-key
   '("j" . meow-next)
   '("k" . meow-prev))
  (meow-leader-define-key
   ;; SPC j/k will run the original command in MOTION state.
   '("j" . meow-motion-origin-command)
   '("k" . meow-motion-origin-command)
   ;; Use SPC (0-9) for digit arguments.
   '("." . "M-.")
   '("," . "M-,")
   '(";" . comment-dwim)
   ;;'("k" . kill-this-buffer)
   '("p" . project-find-file)
   '("d" . dirvish)
   '("b" . consult-buffer)
   '("r" . elfeed-dashboard)
   ;; '("r" . deadgrep)
   ;;'("o" . "C-c o")
   ;;'("e" . "C-c e")
   ;;'("t" . "C-c t")
   ;;'("s" . "C-c s")
   '("a" . org-agenda)
   '("v" . magit-status)
   
   '("f" . find-file)
   '("i" . imenu)
   '("1" . meow-digit-argument)
   '("2" . meow-digit-argument)
   '("3" . meow-digit-argument)
   '("4" . meow-digit-argument)
   '("5" . meow-digit-argument)
   '("6" . meow-digit-argument)
   '("7" . meow-digit-argument)
   '("8" . meow-digit-argument)
   '("9" . meow-digit-argument)
   '("0" . meow-digit-argument)
   '("/" . meow-keypad-describe-key)
   '("?" . meow-cheatsheet))
  (meow-normal-define-key
   '("0" . meow-expand-0)
   '("9" . meow-expand-9)
   '("8" . meow-expand-8)
   '("7" . meow-expand-7)
   '("6" . meow-expand-6)
   '("5" . meow-expand-5)
   '("4" . meow-expand-4)
   '("3" . meow-expand-3)
   '("2" . meow-expand-2)
   '("1" . meow-expand-1)
   '("-" . negative-argument)
   '(";" . meow-reverse)
   '("," . meow-inner-of-thing)
   '("." . meow-bounds-of-thing)
   '("[" . meow-beginning-of-thing)
   '("]" . meow-end-of-thing)
   '("a" . meow-append)
   '("A" . meow-open-below)
   '("b" . meow-back-word)
   '("B" . meow-back-symbol)
   '("c" . meow-change)
   '("C" . meow-change-save)
   '("d" . meow-C-d)
   '("D" . meow-backward-delete)
   '("e" . meow-next-word)
   '("E" . meow-next-symbol)
   '("f" . meow-find)
   '("F" . meow-find-expand)
   '("g" . meow-cancel)
   '("G" . meow-grab)
   '("h" . meow-left)
   '("H" . meow-left-expand)
   '("i" . meow-insert)
   '("I" . meow-open-above)
   '("j" . meow-next)
   '("J" . meow-next-expand)
   '("k" . meow-prev)
   '("K" . meow-prev-expand)
   '("l" . meow-right)
   '("L" . meow-right-expand)
   '("m" . meow-join)
   '("n" . meow-search)
   '("N" . meow-pop-search)
   '("o" . meow-block)
   '("O" . meow-block-expand)
   '("p" . meow-yank)
   '("P" . meow-yank-pop)
   '("q" . meow-quit)
   '("Q" . meow-goto-line)
   '("r" . meow-replace)
   '("R" . meow-swap-grab)
   '("s" . meow-kill)
   '("t" . meow-till)
   '("T" . meow-till-expand)
   '("u" . meow-undo)
   '("U" . meow-undo-in-selection)
   '("v" . meow-visit)
   '("V" . meow-kmacro-matches)
   '("w" . meow-mark-word)
   '("W" . meow-mark-symbol)
   '("x" . meow-line)
   '("X" . meow-kmacro-lines)
   '("y" . meow-save)
   '("Y" . meow-sync-grab)
   '("z" . meow-pop-selection)
   '("Z" . meow-pop-all-selection)
   '("&" . meow-query-replace)
   '("%" . meow-query-replace-regexp)
   '("'" . repeat)
   '("\\" . quoted-insert)
   '("=" . split-window-vertically)
   '("/" . split-window-horizontally)  
   '("<escape>" . ignore)))



(use-package meow
  ;;:demand t
  :init
  (meow-global-mode 1)
  :config
  ;; meow-setup 用于自定义按键绑定，可以直接使用下文中的示例
  (meow-setup)
  ;; 如果你需要在 NORMAL 下使用相对行号（基于 display-line-numbers-mode）
  ;;(meow-setup-line-number)
  ;; 如果你需要自动的 mode-line 设置（如果需要自定义见下文对 `meow-indicator' 说明）
  ;;(meow-setup-indicator))
  (setq meow-replace-state-name-list '((normal . "[N]")
                                       (motion . "[M]")
                                       (keypad . "[K]")
                                       (insert . "[I]")
                                       (beacon . "[B]")))
  ;; (setq meow-replace-state-name-list
  ;;       '((normal . "🅝")
  ;;         (beacon . "🅑")
  ;;         (insert . "🅘")
  ;;         (motion . "🅜")
  ;;         (keypad . "🅚")))
  (add-to-list 'meow-mode-state-list '(color-rg-mode . motion))
  (add-to-list 'meow-mode-state-list '(lsp-bridge-ref-mode . motion))
  (add-to-list 'meow-mode-state-list '(elfeed-dashboard-mode . motion))
  (add-to-list 'meow-mode-state-list '(eaf-mode . motion))
  (add-to-list 'meow-mode-state-list '(snails-mode . motion))
  (add-to-list 'meow-mode-state-list '(blink-search-mode . motion)))
               
  

(use-package parinfer-rust-mode
  :when (bound-and-true-p module-file-suffix)
  :hook ((emacs-lisp-mode
          clojure-mode
          scheme-mode
          lisp-mode
          racket-mode
          hy-mode) . parinfer-rust-mode)
  :init
  (setq parinfer-rust-library
        (concat user-emacs-directory "parinfer-rust/"
                (cond (IS-MAC "parinfer-rust-darwin.so")
                      (IS-LINUX "parinfer-rust-linux.so")
                      (IS-WINDOWS "parinfer-rust-windows.dll")))
        parinfer-rust-auto-download t))
  ;; :config
  ;; (defun disable-elec-pair-mode()
  ;;   ;; (when (and (fboundp 'puni-mode)
  ;;   ;;            puni-mode)
  ;;   ;;     (puni-mode -1))
  ;;   (when electric-pair-mode
  ;;       (electric-pair-local-mode -1))
  ;;   (parinfer-rust-mode 1))
  ;; 
  ;; (dolist (hook '(emacs-lisp-mode-hook
  ;;                 clojore-mode-hook
  ;;                 scheme-mode-hook
  ;;                 lisp-mode-hook
  ;;                 racket-mode-hook
  ;;                 hy-mode-hook))
  ;;   (add-hook hook #'disable-elec-pair-mode)))

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
              ("M-:" . grammatical-edit-jump-out-pair-and-newline) ;跳出括号并换行
        ;; 向父节点跳动
              ("C-j" . grammatical-edit-jump-up))
  :hook ((prog-mode inferior-emacs-lisp-mode minibuffer-inactive-mode sh-mode) . grammatical-edit-mode)
  :config
  (defun my-indent-current ()
    (indent-for-tab-command))
  (advice-add #'grammatical-edit-open-curly :after #'my-indent-current))
  
     
  

(use-package format-all)

(use-package vundo
  ;;:quelpa (vundo :fetcher github :repo "casouri/vundo")
  :commands vundo)

(use-package autorevert
  :hook (after-init . global-auto-revert-mode))

;;(use-package elec-pair
  ;; :ensure nil
  ;; :hook (after-init . electric-pair-mode) 
  ;; :init (setq electric-pair-inhibit-predicate 'electric-pair-conservative-inhibit))
 
;; (use-package snails
;;  :quelpa (:fetcher github :repo "manateelazycat/snails" :build (:not compile))
;;  :commands snails
;;  :init 
;;  (setq snails-use-exec-path-from-shell nil
;;        snails-show-with-frame nil)
;;  :config 
;;  (setq snails-default-backends 
;;        '(snails-backend-buffer
;;          snails-backend-recentf
;;          snails-backend-bookmark
;;          snails-backend-directory-files)))

;; (use-package one-key
;;   :straight (:type git :host github :repo "manateelazycat/one-key")
;;   :config
;;   (one-key-create-menu
;;    "MAGIT"
;;    '(
;;      (("s" . "Magit status") . magit-status+)
;;      (("c" . "Magit checkout") . magit-checkout)
;;      (("C" . "Magit commit") . magit-commit)
;;      (("u" . "Magit push to remote") . magit-push-current-to-pushremote)
;;      (("p" . "Magit delete remote branch") . magit-delete-remote-branch)
;;      (("i" . "Magit pull") . magit-pull-from-upstream)
;;      (("r" . "Magit rebase") . magit-rebase)
;;      (("e" . "Magit merge") . magit-merge)
;;      (("l" . "Magit log") . magit-log-all)
;;      (("L" . "Magit blame") . magit-blame+)
;;      (("b" . "Magit branch") . magit-branch)
;;      (("B" . "Magit buffer") . magit-process-buffer)
;;      (("D" . "Magit discarded") . magit-discard)
;;      (("," . "Magit init") . magit-init)
;;      (("." . "Magit add remote") . magit-remote-add))
;;    
;;    t))
(use-package blink-search
  :load-path "~/.emacs.d/site-lisp/blink-search"
  :config
  (global-set-key (kbd "C-c l") 'blink-search)
  ;;(add-hook 'blink-search-mode-hook 'meow-insert-mode)
  (setq blink-search-search-backends '("Buffer List"
                                       "Common Directory"
                                       "Find File"
                                       "Recent File"
                                       "IMenu"
                                       "Elisp Symbol"))
  (setq blink-search-grep-file-ignore-dirs '("node_modules"
                                             "dist"
                                             "__pycache__"
                                             "straight"
                                             "history"))
  (setq blink-search-common-directory '(("HOME" "~/")
                                        ("PROJECTS" "~/Projects/")
                                        ("EMACS" "~/.emacs.d/lisp/")
                                        ("REPO" "~/.emacs.d/site-lisp/")
                                        ("ORG" "~/Notes/org")
                                        ("Notes" "~/Notes/org/notes")))
        
  (defun blink-search-open-file-dirvish (dir)
    (if (file-directory-p dir)
        (dirvish-dwim dir)
      (find-file dir)))

  (advice-add #'blink-search-open-file :override #'blink-search-open-file-dirvish))
  


(provide 'init-edit)
;;; init-edit.el ends here
