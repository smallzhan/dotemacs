;; init-funcs.el --- Define functions.	-*- lexical-binding: t -*-

(require 'cl-lib)


(defvar socks-noproxy)
(defvar socks-server)

(declare-function async-inject-variables 'async)
(declare-function chart-bar-quickie 'chart)
(declare-function flycheck-buffer 'flycheck)
(declare-function flymake-start 'flymake)
(declare-function upgrade-packages 'init-package)

(unless (fboundp 'caadr)
  (defalias 'caadr #'cl-caadr))



;; Font
(defun font-installed-p (font-name)
  "Check if font with FONT-NAME is available."
  (find-font (font-spec :name font-name)))

;; Dos2Unix/Unix2Dos
(defun dos2unix ()
  "Convert the current buffer to UNIX file format."
  (interactive)
  (set-buffer-file-coding-system 'undecided-unix nil))

(defun unix2dos ()
  "Convert the current buffer to DOS file format."
  (interactive)
  (set-buffer-file-coding-system 'undecided-dos nil))

(defun delete-carrage-returns ()
  "Delete `^M' characters in the buffer.
Same as `replace-string C-q C-m RET RET'."
  (interactive)
  (save-excursion
    (goto-char 0)
    (while (search-forward "\r" nil :noerror)
      (replace-match ""))))

;; File and buffer
(defun revert-this-buffer ()
  "Revert the current buffer."
  (interactive)
  (unless (minibuffer-window-active-p (selected-window))
    (revert-buffer t t)
    (message "Reverted this buffer")))
;;(global-set-key (kbd "s-r") #'revert-this-buffer)

(defun delete-this-file ()
  "Delete the current file, and kill the buffer."
  (interactive)
  (unless (buffer-file-name)
    (error "No file is currently being edited"))
  (when (yes-or-no-p (format "Really delete '%s'?"
                             (file-name-nondirectory buffer-file-name)))
    (delete-file (buffer-file-name))
    (kill-this-buffer)))
;;(global-set-key (kbd "C-x K") #'delete-this-file)

(defun rename-this-file (new-name)
  "Renames both current buffer and file it's visiting to NEW-NAME."
  (interactive "sNew name: ")
  (let ((name (buffer-name))
        (filename (buffer-file-name)))
    (unless filename
      (error "Buffer '%s' is not visiting a file!" name))
    (progn
      (when (file-exists-p filename)
        (rename-file filename new-name 1))
      (set-visited-file-name new-name)
      (rename-buffer new-name))))

(defun browse-this-file ()
  "Open the current file as a URL using `browse-url'."
  (interactive)
  (let ((file-name (buffer-file-name)))
    (if (and (fboundp 'tramp-tramp-file-p)
             (tramp-tramp-file-p file-name))
        (error "Cannot open tramp file")
      (browse-url (concat "file://" file-name)))))

(defun copy-file-name ()
  "Copy the current buffer file name to the clipboard."
  (interactive)
  (if-let ((filename (if (equal major-mode 'dired-mode)
                         default-directory
                       (buffer-file-name))))
      (progn
        (kill-new filename)
        (message "Copied '%s'" filename))
    (warn "Current buffer is not attached to a file!")))


;; Reload configurations
(defun reload-init-file ()
  "Reload Emacs configurations."
  (interactive)
  (load user-init-file))

;; Misc
(defun create-scratch-buffer ()
  "Create a scratch buffer."
  (interactive)
  (switch-to-buffer (get-buffer-create "*scratch*"))
  (lisp-interaction-mode))

(defun save-buffer-as-utf8 (coding-system)
  "Revert a buffer with `CODING-SYSTEM' and save as UTF-8."
  (interactive "zCoding system for visited file (default nil):")
  (revert-buffer-with-coding-system coding-system)
  (set-buffer-file-coding-system 'utf-8)
  (save-buffer))

(defun save-buffer-gbk-as-utf8 ()
  "Revert a buffer with GBK and save as UTF-8."
  (interactive)
  (save-buffer-as-utf8 'gbk))


(defun recompile-site-lisp ()
  "Recompile packages in site-lisp directory."
  (interactive)
  (let ((temp-dir (locate-user-emacs-file "site-lisp")))
    (if (fboundp 'async-byte-recompile-directory)
        (async-byte-recompile-directory temp-dir)
      (byte-recompile-directory temp-dir 0 t))))


;; UI
(defvar after-load-theme-hook nil
  "Hook run after a color theme is loaded using `load-theme'.")
(defun run-after-load-theme-hook (&rest _)
  "Run `after-load-theme-hook'."
  (run-hooks 'after-load-theme-hook))
(advice-add #'load-theme :after #'run-after-load-theme-hook)


;; Network Proxy
(defun proxy-http-show ()
  "Show HTTP/HTTPS proxy."
  (interactive)
  (if url-proxy-services
      (message "Current HTTP proxy is `%s'" centaur-proxy)
    (message "No HTTP proxy")))

(defun proxy-http-enable ()
  "Enable HTTP/HTTPS proxy."
  (interactive)
  (setq url-proxy-services
        `(("http" . ,centaur-proxy)
          ("https" . ,centaur-proxy)
          ("no_proxy" . "^\\(localhost\\|192.168.*\\|10.*\\)")))
  (proxy-http-show))

(defun proxy-http-disable ()
  "Disable HTTP/HTTPS proxy."
  (interactive)
  (setq url-proxy-services nil)
  (proxy-http-show))

(defun proxy-http-toggle ()
  "Toggle HTTP/HTTPS proxy."
  (interactive)
  (if (bound-and-true-p url-proxy-services)
      (proxy-http-disable)
    (proxy-http-enable)))

(defun proxy-socks-show ()
  "Show SOCKS proxy."
  (interactive)
  (when (fboundp 'cadddr)                ; defined 25.2+
    (if (bound-and-true-p socks-noproxy)
        (message "Current SOCKS%d proxy is %s:%s"
                 (cadddr socks-server) (cadr socks-server) (caddr socks-server))
      (message "No SOCKS proxy"))))

(defun proxy-socks-enable ()
  "Enable SOCKS proxy."
  (interactive)
  (require 'socks)
  (setq url-gateway-method 'socks
        socks-noproxy '("localhost"))
  (let* ((proxy (split-string centaur-socks-proxy ":"))
         (host (car proxy))
         (port (cadr  proxy)))
    (setq socks-server `("Default server" ,host ,port 5)))
  (setenv "all_proxy" (concat "socks5://" centaur-socks-proxy))
  (proxy-socks-show))

(defun proxy-socks-disable ()
  "Disable SOCKS proxy."
  (interactive)
  (setq url-gateway-method 'native
        socks-noproxy nil
        socks-server nil)
  (setenv "all_proxy" "")
  (proxy-socks-show))

(defun proxy-socks-toggle ()
  "Toggle SOCKS proxy."
  (interactive)
  (if (bound-and-true-p socks-noproxy)
      (proxy-socks-disable)
    (proxy-socks-enable)))

(defun function-advices (function)
  "Return FUNCTION's advices.

URL https://emacs-china.org/t/advice/7566/16
Version 2022-06-29 00.01.07 +8000"
  (let ((flist (indirect-function function)) advices)
    (when (and (consp flist)
               (or (eq 'macro (car flist))
                   (and (autoloadp flist) (memq (nth 4 flist) '(macro t)))))
      (setq flist (cdr flist)))
    (while (advice--p flist)
      (setq advices `(,@advices ,(advice--car flist)))
      (setq flist (advice--cdr flist)))
    advices))

(define-advice describe-function-1 (:after (function) advice-remove-button)
  "Add a button to remove advice.

URL https://emacs-china.org/t/advice/7566/16
Version 2022-06-29 00.01.07 +8000"
  (when (get-buffer "*Help*")
    (with-current-buffer "*Help*"
      (save-excursion
        (goto-char (point-min))
        (let ((ad-list (function-advices function)))
          (while (re-search-forward "^\\(?:This \\(?:function\\|macro\\) has \\)?:[-a-z]+ advice: \\(.+\\)\\.?$" nil t)
            (let* ((name (string-trim (match-string 1) "[‘'`]" "[’']"))
                   (symbol (intern-soft name))
                   (advice (or symbol (car ad-list))))
              (when advice
                (when symbol
                  (cl-assert (eq symbol (car ad-list))))
                (let ((inhibit-read-only t))
                  (insert " \u00BB ")
                  (insert-text-button
                   "Remove"
                   'cursor-sensor-functions `((lambda (&rest _) (message "%s" ',advice)))
                   'help-echo (format "%s" advice)
                   'action
                   ;; In case lexical-binding is off
                   `(lambda (_)
                      (when (yes-or-no-p (format "Remove %s ? " ',advice))
                        (message "Removing %s of advice from %s" ',function ',advice)
                        (advice-remove ',function ',advice)
                        (revert-buffer nil t)))
                   'follow-link t))))
            (setq ad-list (cdr ad-list))))))))

(defun remember-init ()
  "Remember current position and setup."
  (interactive)
  (point-to-register 8)
  (message "Have remember one position"))

(defun remember-jump ()
  "Jump to latest position and setup."
  (interactive)
  (let ((tmp (point-marker)))
    (jump-to-register 8)
    (set-register 8 tmp))
  (message "Have back to remember position"))


(defun point-stack-push ()
  "Push current point in stack."
  (interactive)
  (message "Location marked.")
  (setq point-stack (cons (list (current-buffer) (point)) point-stack)))

(defun point-stack-pop ()
  "Pop point from stack."
  (interactive)
  (if (null point-stack)
      (message "Stack is empty.")
    (switch-to-buffer (caar point-stack))
    (goto-char (cadar point-stack))
    (setq point-stack (cdr point-stack)))) 

(defun my-copy (&optional arg)
  "if mark-active, copy the region, else mark current line"
  (interactive "P")
  (if mark-active
      (kill-ring-save (region-beginning) (region-end))
    (let ((beg (progn (back-to-indentation) (point)))
          (end (line-end-position arg)))
      (copy-region-as-kill beg end))))

(defun my-kill (&optional arg region)
  "`kill-region' if the region is active, otherwise `backward-kill-word'"
  (interactive
   (list (prefix-numeric-value current-prefix-arg) (use-region-p)))
  (if region (kill-region (region-beginning) (region-end))
	(backward-kill-word arg)))

(defun my-mark-line (&optional arg)
  "mark line, mark current line when first call, then mark to next line each call"
  (interactive "P")
  (if (region-active-p)
        (goto-char (line-end-position 2))
    (progn
      (back-to-indentation)
      (set-mark (point))
      (goto-char (line-end-position))))
  (setq arg (if arg (prefix-numeric-value arg)
              (if (< (mark) (point)) -1 1)))
  (if (and arg (> arg 1))
      (goto-char (line-end-position arg))))

(defun swap (LIST el1 el2)
  "in LIST swap indices EL1 and EL2 in place"
  (let ((tmp (elt LIST el1)))
    (setf (elt LIST el1) (elt LIST el2))
    (setf (elt LIST el2) tmp)))


(defun shuffle (LIST)
  "Shuffle the elements in LIST.
shuffling is done in place."
  (cl-loop for i in (reverse (number-sequence 1 (1- (length LIST))))
        do (let ((j (random (+ i 1))))
             (swap LIST i j)))
  LIST)


(provide 'init-funcs)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; init-funcs.el ends here
