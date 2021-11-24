;;;init-tex.el  -*- lexical-binding: t; -*-

(straight-use-package '(auctex :includes (latex tex reftex preview)))

(use-package reftex
  :commands turn-on-reftex
  :config
  (setq reftex-plug-into-AUCTeX t)
  (setq reftex-section-levels
        '(("part" . 0) ("chapter" . 1) ("section" . 2) ("subsection" . 3)
          ("frametitle" . 4) ("subsubsection" . 4) ("paragraph" . 5)
          ("subparagraph" . 6) ("addchap" . -1) ("addsec" . -2)))
  (add-hook 'TeX-mode-hook (lambda () (reftex-isearch-minor-mode))))

(use-package preview
  :hook (LateX-mode . LateX-preview-setup)
  :config
  (setq-default preview-scale 1.4
                peview-scale-function
                (lambda () (* (/ 10.0 (preview-document-pt)) preview-scale))))

(use-package cdlatex
  :hook (LaTeX-mode . cdlatex-mode)
  :hook (org-mode . turn-on-org-cdlatex))


(use-package latex
  :mode
  ("\\.tex" . latex-mode)
  :bind
  (:map LaTeX-mode-map
        ("C-c C-r" . reftex-query-replace-document)
        ("C-c C-g" . reftex-grep-document))
  
  :config  
  (setq-default TeX-master  t ; by each new fie AUCTEX will ask for a master fie.
                TeX-PDF-mode t
                TeX-engine 'xetex)     ; optional

  (setq TeX-auto-save t
        TeX-save-query nil       ; don't prompt for saving the .tex file
        TeX-parse-self t
        TeX-show-compilation nil         ; if `t`, automatically shows compilation log
        TeX-auto-local ".auctex-auto"
        TeX-style-local ".auctex-style"
        TeX-source-correlate-mode t
        TeX-source-correlate-method 'synctex
        ;; don't start the emacs server when correlating sources
        TeX-source-correlate-start-server nil
        ;; automatically insert braces after sub/superscript in math mode
        TeX-electric-sub-and-superscript t
        ;; just save, dont ask me before each compilation
        LaTeX-babel-hyphen nil) ; Disable language-specific hyphen insertion.
  
  ;;(add-hook 'TeX-mode-hook 'turn-on-reftex)

  (defvar beamer-frame-begin "^[ ]*\\\\begin{frame}"
    "Regular expression that matches the frame start")

  (defvar beamer-frame-end "^[ ]*\\\\end{frame}"
    "Regular expression that matches the frame start")


  (defun beamer-find-frame-begin ()
    "Move point to the \\begin of the current frame."
    (re-search-backward beamer-frame-begin))


  (defun beamer-find-frame-end ()
    "Move point to the \\end of the current environment."
    (re-search-forward beamer-frame-end))



  (defun beamer-mark-frame ()
    "Set mark to end of current frame and point to the matching begin.
The command will not work properly if there are unbalanced
begin-end pairs in comments and verbatim environments."
    (interactive)
    (let ((cur (point))
          beg end)
      (setq end (beamer-find-frame-end))
      (goto-char cur)
      (setq beg (beamer-find-frame-begin))
      (goto-char beg)
      (set-mark end)))

  ;; (defun beamer-mark-frame ()
  ;;   "beamer-mark-frame"
  ;;   (interactive)
  ;;   (let ((pos (point)))
  ;;     (when (re-search-backward "\\\\begin{frame}")
  ;;       (set-mark)
  ;;       (if (re-search-forward "\\\\end{frame}")
  ;; 		  (message "frame marked")
  ;; 		(message "not in frame")))))


  (defun beamer-indent-frame ()
    (interactive)
    (let ((pos (point))
          beg end)
      (setq beg (beamer-find-frame-begin))
      (goto-char pos)
      (setq end (beamer-find-frame-end))
      (indent-region beg end)
      (goto-char pos)))

  (defun beamer-narrow-to-frame ()
    (interactive)
    (let ((pos (point))
          beg end)
      (setq beg (beamer-find-frame-begin))
      (goto-char pos)
      (setq end (beamer-find-frame-end))
      (narrow-to-region beg end)
      (goto-char pos))))

(provide 'init-tex)
;;;init-tex.el ends here
