;; -*- lexical-binding: t; -*-
(require 'ox-latex)
(setq org-latex-listings t)
(setq org-latex-compiler "xelatex")
(setq org-preview-latex-default-process 'dvisvgm)
(setq org-highlight-latex-and-related '(latex))
(setq org-format-latex-options (plist-put org-format-latex-options :scale 1.5))

;; (setq org-latex-preview-numbered t)
;; 
;; (plist-put org-latex-preview-options :zoom 1.25)
;; (plist-put org-latex-preview-options :scale 1.0)
;; (let ((pos (assoc 'dvisvgm org-latex-preview-process-alist)))
;;   (plist-put (cdr pos) :image-converter '("dvisvgm --page=1- --optimize --clipjoin --relative --no-fonts --bbox=preview -o %B-%%9p.svg %f")))

(add-to-list 'org-latex-classes
             `("my-beamer"
               ,(concat
                 "\\documentclass[presentation]{beamer}"
                 "\n\\usepackage[utf8]{ctex}"
                 "\n\\mode<presentation> {"
                 "\n\\setbeamercovered{transparent}"
                 "\n\\setbeamertemplate{theorems}[numbered]"
                 "\n\\usefonttheme[onlymath]{serif}"
                 "\n}"
                 "\n\\usepackage{amsmath, amssymb}"
                 "\n\\usepackage{hyperref}"
                 "\n\\usepackage[english]{babel}"
                 "\n\\usepackage{tikz}"
                 "\n\\setbeamerfont{smallfont}{size=\\small}"
                 "\n[no-default-packages]"
                 "\n[no-packages]"
                 "\n[extra]")
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")))
               
(add-to-list 'org-latex-classes
             `("my-article"
               ,(concat
                 "\\documentclass{ctexart}"
                 "\n\\usepackage{hyperref}"
                 "\n[no-default-packages]"
                 "\n[packages]"
                 "\n[extra]")
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\paragraph{%s}" . "\\paragraph*{%s}")
               ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

(provide 'init-org+latex)
;;; init-org+latex.el ends here
