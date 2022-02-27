;; -*- lexical-binding: t; -*-
(require 'transient)
(defvar org-tempo-special-expand-alist
    '(("o" . "<q")
      ("m" . ("<s" "emacs-lisp"))
      ("p" . ("<s" "python :results output"))
      ("S" . ("<s" "sh"))
      ("r" . ("<s" "rust"))
      ("g" . ("<s" "go :imports '\(\"fmt\"\)"))
      ("u" . ("<s" "plantuml :file CHANGE.png"))
      ("y" . ("<s" "jupyter-python :session python :exports both :results raw drawer\n$0"))
      ("d" . ("<s" "dot :exports both"))))

(transient-define-suffix one-key-expand ()
   :description "ascii"
   :key "a"
   (interactive)
   (if-let ((key (key-description (this-command-keys-vector)))
            (expand (assoc key org-tempo-special-expand-alist)))
       (apply 'hot-expand (cdr expand))
     (hot-expand (concat "<" key))))
    
(transient-define-prefix my/org-tempo-transient ()
   "Org Templates"
   ["Org Templates"
    ["Basic"
     (one-key-expand :key "a" :description "ascii")
     (one-key-expand :key "c" :description "center")
     (one-key-expand :key "C" :description "comment")
     (one-key-expand :key "e" :description "example")
     (one-key-expand :key "E" :description "export")
     (one-key-expand :key "h" :description "html")
     (one-key-expand :key "l" :description "latex")
     (one-key-expand :key "n" :description "note")
     (one-key-expand :key "o" :description "quote")
     (one-key-expand :key "v" :description "verse")]
    ["Head"
     (one-key-expand :key "i" :description "index")
     (one-key-expand :key "A" :description "ASCII")
     (one-key-expand :key "I" :description "INCLUDE")
     (one-key-expand :key "H" :description "HTML")
     (one-key-expand :key "L" :description "LATEX")]
    ["Source"
     (one-key-expand :key "s" :description "src")
     (one-key-expand :key "m" :description "emacs-lisp")
     (one-key-expand :key "p" :description "python")
     (one-key-expand :key "S" :description "sh")
     (one-key-expand :key "r" :description "rust")
     (one-key-expand :key "g" :description "golang")]
    ["Misc"
     (one-key-expand :key "u" :description "plantuml")
     (one-key-expand :key "y" :description "jupyter")
     (one-key-expand :key "d" :description "dot")
     ("<" "ins" self-insert-command)]])
  
(defun my--insert-org-template ()
  "Insert org template"
  (interactive)
  (if (or (region-active-p) (looking-back "^\s*" 1))
      (my/org-tempo-transient)
    (self-insert-command 1)))

(define-key org-mode-map (kbd "<") #'my--insert-org-template)
 
(provide 'init-org+transient)
;;; init-org+transient.el ends here 
