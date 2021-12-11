;; -*- lexical-binding: t; -*-
(use-package with-editor
  :defer t)

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
    (remove-hook 'magit-status-sections-hook 'magit-insert-unpushed-to-upstream-or-recent)))


(with-eval-after-load 'ediff
  (setq ediff-diff-options "-w" ; turn off whitespace checking
        ediff-split-window-function #'split-window-horizontally
        ediff-window-setup-function #'ediff-setup-windows-plain)
  (add-hook 'ediff-after-quit-hook-internal 'winner-undo))


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

(provide 'init-git)
;;; init-git.el ends here
