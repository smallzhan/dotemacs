;; -*- lexical-binding: t; -*-
;; (use-package with-editor
;;   :defer t)

(defvar my-prefer-lightweight-magit t)

(use-package magit
  :defer t
  :commands magit-status
  :init
  (setq magit-auto-revert-mode nil)

  :config
  (when my-prefer-lightweight-magit
    (remove-hook 'magit-status-sections-hook 'magit-insert-tags-header)
    (remove-hook 'magit-status-sections-hook 'magit-insert-status-headers)
    (remove-hook 'magit-status-sections-hook 'magit-insert-unpushed-to-pushremote)
    (remove-hook 'magit-status-sections-hook 'magit-insert-unpulled-from-pushremote)
    (remove-hook 'magit-status-sections-hook 'magit-insert-unpulled-from-upstream)
    (remove-hook 'magit-status-sections-hook 'magit-insert-unpushed-to-upstream-or-recent))
  (global-set-key (kbd "C-c e g") #'magit-status))


(with-eval-after-load 'ediff
  (defvar my--ediff-saved-wconf nil)
  (setq ediff-diff-options "-w" ; turn off whitespace checking
        ediff-split-window-function #'split-window-horizontally
        ediff-window-setup-function #'ediff-setup-windows-plain))
  
;; (use-package git-timemachine
;;   :config
;;   (defun my-git-timemachine-show-selected-revision ()
;;     "Show last (current) revision of file."
;;     (interactive)
;;     (let* ((collection 
;;             (mapcar (lambda (rev)
;;                       ;; re-shape list for the ivy-read
;;                       (cons (concat (substring-no-properties (nth 0 rev) 0 7) "|" (nth 5 rev) "|" (nth 6 rev)) rev))
;;                     (git-timemachine--revisions))))
;;       (completing-read "commits:"
;;                        collection
;;                        :action (lambda (rev)
;;                                  ;; compatible with ivy 8+ and later ivy version
;;                                  (unless (string-match-p "^[a-z0-9]*$" (car rev))
;;                                    (setq rev (cdr rev)))
;;                                  (git-timemachine-show-revision rev)))))
;; 
;;   (defun my-git-timemachine ()
;;     "Open git snapshot with the selected version."
;;     (interactive)
;;     ;;(my-ensure 'git-timemachine)
;;     (git-timemachine--start #'my-git-timemachine-show-selected-revision)))
;; ;; }})

;;; Git Gutter
;;Git gutter is great for giving visual feedback on changes, but it doesn't play well
;;with org-mode using org-indent. So I don't use it globally.
(use-package git-gutter
  :defer t
  :hook ((markdown-mode . git-gutter-mode)
         (prog-mode . git-gutter-mode)
         (conf-mode . git-gutter-mode))
  :init
  :config
  (setq git-gutter:disabled-modes '(org-mode asm-mode image-mode)
        git-gutter:update-interval 2
        git-gutter:window-width 2
        git-gutter:ask-p nil)
  
  (defun my-git-gutter-first-hunk ()
    (interactive)
    (goto-char (point-min))
    (git-gutter:next-hunk 1))
  
  (defun my-git-gutter-last-hunk ()
    (interactive)
    (goto-char (point-max))
    (git-gutter:previous-hunk 1))
    
  (defun my-git-gutter-quit ()
    (interactive)
    (git-gutter-mode -1)
    (sit-for 0.1)
    (git-gutter:clear))
 
  (transient-define-prefix git-gutter-transient()
    "Git Gutter Settings"
    ["Git Gutter Commands"
     ["Move"
      ("j" "next hunk" git-gutter:next-hunk)
      ("k" "previous hunk" git-gutter:previous-hunk)
      ("h" "first hunk" my-git-gutter-first-hunk)
      ("l" "last hunk" my-git-gutter-last-hunk)]
     ["Operation"
      ("s" "stage hunk" git-gutter:stage-hunk)
      ("r" "revert hunk" git-gutter:revert-hunk)
      ("p" "popup hunk" git-gutter:popup-hunk)
      ("R" "set start revision" git-gutter:set-start-revision)]
     ["Quit"
      ("Q" "Quit git-gutter" my-git-gutter-quit)]])
    
  (global-set-key (kbd "C-c e v") 'git-gutter-transient))
     
 ;;  (defhydra hydra-git-gutter (:body-pre (git-gutter-mode 1)
 ;;                              :hint nil)
 ;;   "
 ;; Git gutter:
 ;;   _j_: next hunk        _s_tage hunk     _q_uit
 ;;   _k_: previous hunk    _r_evert hunk    _Q_uit and deactivate git-gutter
 ;;   ^ ^                   _p_opup hunk
 ;;   _h_: first hunk
 ;;   _l_: last hunk        set start _R_evision
 ;; "
 ;;   ("j" git-gutter:next-hunk)
 ;;   ("k" git-gutter:previous-hunk)
 ;;   ("h" (progn (goto-char (point-min))
 ;;               (git-gutter:next-hunk 1)))
 ;;   ("l" (progn (goto-char (point-min))
 ;;               (git-gutter:previous-hunk 1)))
 ;;   ("s" git-gutter:stage-hunk)
 ;;   ("r" git-gutter:revert-hunk)
 ;;   ("p" git-gutter:popup-hunk)
 ;;   ("R" git-gutter:set-start-revision)
 ;;   ("q" nil :color blue)
 ;;   ("Q" (progn (git-gutter-mode -1)
 ;;               ;; git-gutter-fringe doesn't seem to
 ;;               ;; clear the markup right away
 ;;               (sit-for 0.1)
 ;;               (git-gutter:clear))
 ;;        :color blue))
 ;;  (define-key global-map (kbd "C-c e v") #'hydra-git-gutter/body))

(use-package git-gutter-fringe
  :diminish git-gutter-mode
  :after git-gutter)
  ;:demand fringe-helper
  ;; :config
  ;; ;; subtle diff indicators in the fringe
  ;; ;; places the git gutter outside the margins.
  ;; (setq-default fringes-outside-margins t)
  ;; ;; thin fringe bitmaps
  ;; (define-fringe-bitmap 'git-gutter-fr:added
  ;;  [224] nil nil '(center repeated))
  ;; (define-fringe-bitmap 'git-gutter-fr:modified
  ;;  [224] nil nil '(center repeated))
  ;; (define-fringe-bitmap 'git-gutter-fr:deleted
  ;;  [128 192 224 240]
  ;;  nil nil 'bottom))

(provide 'init-git)
;;; init-git.el ends here


