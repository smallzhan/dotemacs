;;; -*- lexical-binding: t; -*-
(use-package rime
  :init
  (when IS-MAC
      (setq rime-librime-root "~/Projects/librime/dist"))
    
  :config
  ;; (if IS-WINDOWS ;; windows set msys librime-data                        
  ;;    (setq rime-share-data-dir "~/.emacs.d/rime/rime-data"))
  ;;(setq rime-user-data-dir "~/.emacs.d/rime"
  (setq rime--module-path (expand-file-name (concat "lib/librime-emacs" module-file-suffix) rime-user-data-dir))
  (setq rime-posframe-properties
        (list :background-color "#333333"
              :foreground-color "#dcdccc"
              ;;:font "SF Mono-14" 
              :internal-border-width 10))

  (setq default-input-method "rime"
        rime-show-preedit t
        rime-preedit-face '(t (:underline t))
        rime-show-candidate 'posframe
        rime-inline-ascii-holder ?a
        rime-cursor "|"
        window-min-height 1
        rime-title "")

  ;;(setq rime-preedit-face '(:underline t))

;;   (defun +rime--posframe-display-content-a (args)
;;     "给 `rime--posframe-display-content' 传入的字符串加一个全角空
;; 格，以解决 `posframe' 偶尔吃字的问题。"
;;     (cl-destructuring-bind (content) args
;;       (let ((newresult (if (string-blank-p content)
;;                            content
;;                          (concat content "　"))))
;;         (list newresult))))

;;   (if (fboundp 'rime--posframe-display-content)
;;       (advice-add 'rime--posframe-display-content
;;                   :filter-args
;;                   #'+rime--posframe-display-content-a)
;;     (error "Function `rime--posframe-display-content' is not available."))


  (defun +rime-force-enable ()
    "[ENHANCED] Force into Chinese input state.
If current input method is not `rime', active it first. If it is
currently in the `evil' non-editable state, then switch to
`evil-insert-state'."
    (interactive)
    (let ((input-method "rime"))
      (unless (string= current-input-method input-method)
        (activate-input-method input-method))
      (when (rime-predicate-evil-mode-p)
        (if (= (1+ (point)) (line-end-position))
            (evil-append 1)
          (evil-insert 1)))
      (rime-force-enable)))

  (defun +rime-convert-string-at-point ()
    "Convert the string at point to Chinese using the current input scheme.
First call `+rime-force-enable' to active the input method, and
then search back from the current cursor for available string (if
a string is selected, use it) as the input code, call the current
input scheme to convert to Chinese."
    (interactive)
    (+rime-force-enable)
    (let ((string (if mark-active
                      (buffer-substring-no-properties
                       (region-beginning) (region-end))
                    (buffer-substring-no-properties
                     (point) (max (line-beginning-position) (- (point) 80)))))
          code
          length)
      (cond ((string-match "\\([a-z]+\\|[[:punct:]]\\)[[:blank:]]*$" string)
             (setq code (replace-regexp-in-string
                         "^[-']" ""
                         (match-string 0 string)))
             (setq length (length code))
             (setq code (replace-regexp-in-string " +" "" code))
             (if mark-active
                 (delete-region (region-beginning) (region-end))
               (when (> length 0)
                 (delete-char (- 0 length))))
             (when (> length 0)
               (setq unread-command-events
                     (append (listify-key-sequence code)
                             unread-command-events))))
            (t (message "`+rime-convert-string-at-point' did nothing.")))))

  (defun +rime-predicate-button-at-point-p ()
    "Determines whether the point is a button.
\"Button\" means that positon is not editable.
Can be used in `rime-disable-predicates' and `rime-inline-predicates'."
    (button-at (point)))


  (defun +translate-symbol-to-rime ()
    (interactive)
    (let* ((input (thing-at-point 'symbol))
           (beg (car (bounds-of-thing-at-point 'symbol)))
           (end (point)))
      (delete-region beg end)
      (toggle-input-method)
      (dolist (c (string-to-list input))
        (rime-lib-process-key c 0))
      (rime--redisplay)))

  (setq-default rime-disable-predicates
                '(;;meow-normal-mode-p
                  ;;meow-motion-mode-p
                  ;;meow-keypad-mode-p
                  +rime-predicate-button-at-point-p
                  rime-predicate-prog-in-code-p
                  rime-predicate-punctuation-line-begin-p
                  rime-predicate-tex-math-or-command-p
                  rime-predicate-punctuation-after-space-cc-p
                  rime-predicate-after-ascii-char-p
                  minibufferp))
                  ;;rime-predicate-after-alphabet-char-p
                  ;;rime-predicate-auto-english-p
                  
  (with-eval-after-load 'meow
    (add-to-list 'rime-disable-predicates 'meow-normal-mode-p)
    (add-to-list 'rime-disable-predicates 'meow-motion-mode-p)
    (add-to-list 'rime-disable-predicates 'meow-keypad-mode-p))
  
  (setq-default rime-inline-predicates
                '(rime-predicate-space-after-cc-p
                  rime-predicate-current-uppercase-letter-p))
  (require 'im-cursor-chg)
  (cursor-chg-mode 1)
  :bind
  ("M-L" . #'+rime-convert-string-at-point)
  (:map rime-active-mode-map
   ("<tab>" . #'rime-inline-ascii)
   ("M-L" . #'+rime-convert-string-at-point))
  (:map rime-mode-map
   ("M-L" . #'+rime-convert-string-at-point)
   ("M-J" . #'rime-force-enable)))


(use-package pinyinlib
  :commands (pinyinlib-build-regexp-string)
  :init
  (with-no-warnings
    (defun my-pinyinlib-build-regexp-string (str)
      "Build a pinyin regexp sequence from STR."
      (cond ((equal str ".*") ".*")
            (t (pinyinlib-build-regexp-string str t))))

    (defun my-pinyin-regexp-helper (str)
      "Construct pinyin regexp for STR."
      (cond ((equal str " ") ".*")
            ((equal str "") nil)
            (t str)))

    (defun pinyin-to-utf8 (str)
      "Convert STR to UTF-8."
      (cond ((equal 0 (length str)) nil)
            ((equal (substring str 0 1) ";")
             (mapconcat
              #'my-pinyinlib-build-regexp-string
              (remove nil 
                      (mapcar
                       #'my-pinyin-regexp-helper
                       (split-string
                        (replace-regexp-in-string ";" "" str)
                        "")))
              ""))
            (t nil)))

    (with-eval-after-load 'orderless
      (defun completion--regex-pinyin (str)
        (orderless-regexp (pinyinlib-build-regexp-string str)))
      (add-to-list 'orderless-matching-styles 'completion--regex-pinyin))))


(provide 'init-chinese)
;;; init-chinese.el ends here
