(use-package hideshow
  
 :config
 ;; 支持 hideshow 时，显示小箭头以及隐藏的行数。 stoken from elpy
 (setq elpy-folding-fringe-indicators t)
 (when (fboundp 'define-fringe-bitmap)
   (define-fringe-bitmap 'elpy-folding-fringe-marker
     (vector #b00000000
             #b00000000
             #b00000000
             #b11000011
             #b11100111
             #b01111110
             #b00111100
             #b00011000)))
  
 (defface elpy-folding-fringe-face
   '((t (:inherit 'font-lock-comment-face
                  :box (:line-width 1 :style released-button))))
   "Face for folding bitmaps appearing on the fringe."
   :group 'elpy)



 (defface elpy-folding-face
   '((t (:inherit 'font-lock-comment-face :box t)))
   "Face for the folded region indicator."
   :group 'elpy)

 
 (defun elpy-folding--display-code-line-counts (ov)
  "Display a folded region indicator with the number of folded lines.

Meant to be used as `hs-set-up-overlay'."
  (let* ((marker-string "*fringe-dummy*")
         (marker-length (length marker-string)))
    (cond
     ((eq 'code (overlay-get ov 'hs))
      (let* ((nmb-line (count-lines (overlay-start ov) (overlay-end ov)))
             (display-string (format "(%d)..." nmb-line)))
        ;; fringe indicator
        (when elpy-folding-fringe-indicators
          (put-text-property 0 marker-length 'display
                             (list 'left-fringe 'elpy-folding-fringe-marker
                                   'elpy-folding-fringe-face)
                             marker-string)
          (overlay-put ov 'before-string marker-string)
          (overlay-put ov 'elpy-hs-fringe t))
        ;; folding indicator
        (put-text-property 0 (length display-string)
                           'face 'elpy-folding-face display-string)
        (put-text-property 0 (length display-string)
                           'mouse-face 'highlight display-string)
        (overlay-put ov 'display display-string)
        (overlay-put ov 'elpy-hs-folded t)))
     ;; for docstring and comments, we don't display the number of line
     ((or (eq 'docstring (overlay-get ov 'hs))
          (eq 'comment (overlay-get ov 'hs)))
      (let ((display-string "..."))
        (put-text-property 0 (length display-string)
                           'mouse-face 'highlight display-string)
        (overlay-put ov 'display display-string)
        (overlay-put ov 'elpy-hs-folded t))))))


 ;; Mouse interaction
 (defun elpy-folding--click-fringe (event)
   "Hide or show block on fringe click."
   (interactive "e")
   (hs-life-goes-on
    (when elpy-folding-fringe-indicators
      (mouse-set-point event)
      (let* ((folded (save-excursion
                       (end-of-line)
                       (cl-remove-if-not (lambda (ov)
                                           (overlay-get ov 'elpy-hs-folded))
                                         (overlays-at (point)))))
             (foldable (cl-remove-if-not (lambda (ov)
                                           (overlay-get ov 'elpy-hs-foldable))
                                         (overlays-at (point)))))
        (if folded
            (hs-show-block)
          (if foldable
              (hs-hide-block)))))))

 (defun elpy-folding--click-text (event)
   "Show block on click."
   (interactive "e")
   (hs-life-goes-on
    (save-excursion
      (let ((window (posn-window (event-end event)))
            (pos (posn-point (event-end event))))
        (with-current-buffer (window-buffer window)
          (goto-char pos)
          (when (hs-overlay-at (point))
            (hs-show-block)
            (deactivate-mark)))))))
 
 (setq hs-set-up-overlay #'elpy-folding--display-code-line-counts)
 ;;(add-hook 'prog-mode-hook 'hs-minor-mode)
 
 (define-key hs-minor-mode-map [left-fringe mouse-1]
       'elpy-folding--click-fringe)
 (define-key hs-minor-mode-map (kbd "<mouse-1>") 'elpy-folding--click-text)
 
 (defun hs-cycle (&optional level)
  (interactive "p")
  (let (message-log-max
        (inhibit-message t))
    (if (= level 1)
        (pcase last-command
          ('hs-cycle
           (hs-hide-level 1)
           (setq this-command 'hs-cycle-children))
          ('hs-cycle-children
           ;; TODO: Fix this case. `hs-show-block' needs to be
           ;; called twice to open all folds of the parent
           ;; block.
           (save-excursion (hs-show-block))
           (hs-show-block)
           (setq this-command 'hs-cycle-subtree))
          ('hs-cycle-subtree
           (hs-hide-block))
          (_
           (if (not (hs-already-hidden-p))
               (hs-hide-block)
             (hs-hide-level 1)
             (setq this-command 'hs-cycle-children))))
      (hs-hide-level level)
      (setq this-command 'hs-hide-level))))

 (defun hs-global-cycle ()
     (interactive)
     (pcase last-command
       ('hs-global-cycle
        (save-excursion (hs-show-all))
        (setq this-command 'hs-global-show))
       (_ (hs-hide-all))))
 
 :bind (:map hs-minor-mode-map
             ("C-c /" . hs-hide-all)
             ("C-c \\" . hs-show-all)
             ("C-<tab>" . hs-toggle-hiding)
             ("C-c -" . (lambda() (interactive) (hs-cycle 1)))
              
              
             ("<mouse-1>" . elpy-folding--click-text))
 :hook (prog-mode . hs-minor-mode))
    
(defun hs-cycle (&optional level)
  (interactive "p")
  (let (message-log-max
        (inhibit-message t))
    (if (= level 1)
        (pcase last-command
          ('hs-cycle
           (hs-hide-level 1)
           (setq this-command 'hs-cycle-children))
          ('hs-cycle-children
           ;; TODO: Fix this case. `hs-show-block' needs to be
           ;; called twice to open all folds of the parent
           ;; block.
           (save-excursion (hs-show-block))
           (hs-show-block)
           (setq this-command 'hs-cycle-subtree))
          ('hs-cycle-subtree
           (hs-hide-block))
          (_
           (if (not (hs-already-hidden-p))
               (hs-hide-block)
             (hs-hide-level 1)
             (setq this-command 'hs-cycle-children))))
      (hs-hide-level level)
      (setq this-command 'hs-hide-level))))

(defun hs-global-cycle ()
    (interactive)
    (pcase last-command
      ('hs-global-cycle
       (save-excursion (hs-show-all))
       (setq this-command 'hs-global-show))
      (_ (hs-hide-all))))
(provide 'init-hs)
;;; init-hs.el ends here
