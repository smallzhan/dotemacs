;;;init-dired.el  -*- lexical-binding: t; -*- 

(use-package dired
  ;;:straight (:type built-in)
  :defer t
  :commands dired-jump
  :bind (:map dired-mode-map
         ("C-c C-p" . wdired-change-to-wdired-mode))
  :config
  ;; Always delete and copy recursively
  (setq dired-recursive-deletes 'always
        dired-dwim-target t
        dired-hide-details-hide-symlink-targets nil
        dired-create-destination-dirs 'ask
        dired-recursive-copies 'always)
  (when IS-MAC
    ;; Suppress the warning: `ls does not support --dired'.
    (setq dired-use-ls-dired nil)

    (when (executable-find "gls")
      ;; Use GNU ls as `gls' from `coreutils' if available.
      (setq insert-directory-program "gls")))

  (when (or (and IS-MAC (executable-find "gls"))
            (and (not IS-MAC) (executable-find "ls")))
    ;; Using `insert-directory-program'
    (setq ls-lisp-use-insert-directory-program t)

    ;; Show directory first
    (setq dired-listing-switches "-alh --group-directories-first")))
    
  ;; Show git info in dired
(use-package dired-git-info
  :bind (:map dired-mode-map
         (")" . dired-git-info-mode)))

  ;; Allow rsync from dired buffers
(use-package dired-rsync
  :defer t
  :bind (:map dired-mode-map
         ("C-c C-r" . dired-rsync)))

  ;; Colourful dired
(use-package diredfl
  :hook (dired-mode . diredfl-mode))

  ;; Shows icons
(use-package all-the-icons-dired
  :hook (dired-mode . all-the-icons-dired-mode)
  :init (setq all-the-icons-dired-monochrome nil)
  :config
  (with-no-warnings
    (defun my-all-the-icons-dired--refresh ()
      "Display the icons of files in a dired buffer."
      (all-the-icons-dired--remove-all-overlays)
      ;; NOTE: don't display icons it too many items
      (if (<= (count-lines (point-min) (point-max)) 1000)
          (save-excursion
            (goto-char (point-min))
            (while (not (eobp))
              (when (dired-move-to-filename nil)
                (let ((case-fold-search t))
                  (when-let* ((file (dired-get-filename 'relative 'noerror))
                              (icon (if (file-directory-p file)
                                        (all-the-icons-icon-for-dir
                                         file
                                         :face 'all-the-icons-dired-dir-face
                                         :height 0.9
                                         :v-adjust all-the-icons-dired-v-adjust)
                                      (apply #'all-the-icons-icon-for-file
                                             file
                                             (append
                                              '(:height 0.9)
                                              `(:v-adjust ,all-the-icons-dired-v-adjust)
                                              (when all-the-icons-dired-monochrome
                                                `(:face ,(face-at-point))))))))
                    (if (member file '("." ".."))
                        (all-the-icons-dired--add-overlay (point) "   \t")
                      (all-the-icons-dired--add-overlay (point) (concat " " icon "\t"))))))
              (forward-line 1)))
        (message "Not display icons because of too many items.")))
    (advice-add #'all-the-icons-dired--refresh :override #'my-all-the-icons-dired--refresh)))

  ;; Extra Dired functionality
   
(use-package dired-aux :defer t
  ;;:straight (:type built-in)
  :config
   (setq dired-create-destination-dirs 'ask
         dired-vc-rename-file t))

;; ;; `find-dired' alternative using `fd'
;; (when (executable-find "fd")
;;   (use-package fd-dired))

(use-package dired-x
  ;;:straight (:type built-in)
  :hook (dired-mode . dired-omit-mode)
  :config
  (setq dired-omit-verbose nil
        dired-omit-files
        (concat dired-omit-files
                "\\|^\\.DS_Store\\'"
                "\\|^\\.project\\(?:ile\\)?\\'"
                "\\|^\\.\\(?:svn\\|git\\)\\'"
                "\\|^\\.ccls-cache\\'"
                "\\|^__pycache__\\'"
                "\\|\\(?:\\.js\\)?\\.meta\\'"
                "\\|\\.\\(?:elc\\|o\\|pyo\\|swp\\|class\\)\\'"))
  ;; Disable the prompt about whether I want to kill the Dired buffer for a
  ;; deleted directory. Of course I do!
  (setq dired-clean-confirm-killing-deleted-buffers nil)
  ;; Let OS decide how to open certain files
  (when-let (cmd (cond (IS-MAC "open")
                       (IS-LINUX "xdg-open")
                       (IS-WINDOWS "start")))
    (setq dired-guess-shell-alist-user
          `(("\\.\\(?:docx\\|pdf\\|djvu\\|eps\\)\\'" ,cmd)
            ("\\.\\(?:jpe?g\\|png\\|gif\\|xpm\\)\\'" ,cmd)
            ("\\.\\(?:xcf\\)\\'" ,cmd)
            ("\\.csv\\'" ,cmd)
            ("\\.tex\\'" ,cmd)
            ("\\.\\(?:mp4\\|mkv\\|avi\\|flv\\|rm\\|rmvb\\|ogv\\)\\(?:\\.part\\)?\\'" ,cmd)
            ("\\.\\(?:mp3\\|flac\\)\\'" ,cmd)
            ("\\.html?\\'" ,cmd)
            ("\\.md\\'" ,cmd)))))
  

(provide 'init-dired)
;;; init-dired.el ends here
