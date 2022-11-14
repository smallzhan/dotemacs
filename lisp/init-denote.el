;; -*- lexical-binding: t; init-denote.el -*-

(use-package denote
  :init
  (setq denote-directory (expand-file-name "notes" +my-org-dir))
  (setq denote-known-keywords '("emacs" "programming" "reading" "learning" "misc" "work"))
  (setq denote-infer-keywords t)
  (setq denote-sort-keywords t)
  (setq denote-file-type nil) ; Org is the default, set others here
  (setq denote-prompts '(title keywords))
  :config

 ;; Remember to check the doc strings of those variables.
 



 ;; Pick dates, where relevant, with Org's advanced interface:
  (setq denote-date-prompt-use-org-read-date t)


 ;; Read this manual for how to specify `denote-templates'.  We do not
 ;; include an example here to avoid potential confusion.


 ;; We allow multi-word keywords by default.  The author's personal
 ;; preference is for single-word keywords for a more rigid workflow.
  (setq denote-allow-multi-word-keywords t)

  (setq denote-date-format nil) ; read doc string

 ;; By default, we fontify backlinks in their bespoke buffer.
  (setq denote-link-fontify-backlinks t)

   ;; Also see `denote-link-backlinks-display-buffer-action' which is a bit
   ;; advanced.
  
   ;; If you use Markdown or plain text files (Org renders links as buttons
   ;; right away)
   ;;(add-hook 'find-file-hook #'denote-link-buttonize-buffer)
  
   ;; We use different ways to specify a path for demo purposes.
   ;; (setq denote-dired-directories
   ;;       (list denote-directory
   ;;             (thread-last denote-directory (expand-file-name "attachments"))
   ;;             (expand-file-name "~/Documents/books")))
  
   ;; Generic (great if you rename files Denote-style in lots of places):
   ;; (add-hook 'dired-mode-hook #'denote-dired-mode)
   ;;
   ;; OR if only want it in `denote-dired-directories':
   ;; (add-hook 'dired-mode-hook #'denote-dired-mode-in-directories)
  
   ;; Here is a custom, user-level command from one of the examples we
   ;; showed in this manual.  We define it here and add it to a key binding
   ;; below.
  (defun my-denote-journal ()
    "Create an entry tagged 'journal', while prompting for a title."
    (interactive)
    (denote
     (denote--title-prompt)
     '("journal")))
  
  (defun my-denote-blog ()
    "Create an entry in sub directory 'blog', while prompting for a title and keywords."
    (interactive)
    (let ((denote-date-format "%Y-%m-%d")
          (denote-id-format "%Y-%m-%d-T%H%M%S"))
     (denote
      (denote--title-prompt)
      (denote-keywords-prompt)
      'blog
      (expand-file-name "blog" denote-directory))))
     

  (setq denote-blog-front-matter
        (concat "#+title:      %1$s"
                "\n#+date:       %2$s"
                "\n#+filetags:   %3$s"
                "\n#+identifier: %4$s"
                "\n#+BEGIN_EXPORT html"
                "\n---"
                "\nlayout: post"
                "\ntitle: %1$s"
                "\ncomments: t"
                "\ndate: %2$s"
                "\nexcerpt:"
                "\ncategories:"
                "\n  - %3$s"
                "\ntags:"
                "\n  - %3$s"
                "\n---"
                "\n#+END_EXPORT"
                "\n"))
 
 ;; (defvar denote-file-type-blog (plist-put (alist-get 'org denote-file-types) :front-matter 'denote-blog-front-matter))
  (add-to-list 'denote-file-types '(blog
                                    :extension ".org"
                                    :front-matter denote-blog-front-matter
                                    :title-key-regexp "^#\\+title\\s-*:"
                                    :title-value-function identity
                                    :title-value-reverse-function denote-trim-whitespace
                                    :keywords-key-regexp "^#\\+filetags\\s-*:"
                                    :keywords-value-function denote-format-keywords-for-text-front-matter
                                    :keywords-value-reverse-function denote-extract-keywords-from-front-matter) t) 
   ;; Denote DOES NOT define any key bindings.  This is for the user to
   ;; decide.  For example:
  
  (defvar my-denote-blog-dir (expand-file-name "blog/" denote-directory))
  (defvar my-denote-blog-publish-dir (expand-file-name "~/Projects/smallzhan.github.io/_posts/"))
  (with-eval-after-load 'org
   (add-to-list 'org-publish-project-alist
                `("smallzhan-github-io" ;; settings for cute-jumper.github.io
                  :base-directory , my-denote-blog-dir
                  :base-extension "org"
                  :publishing-directory , my-denote-blog-publish-dir
                  :recursive t
                  ;;         :publishing-function org-html-publish-to-html
                  :publishing-function org-gfm-publish-to-gfm
                  :with-toc nil
                  :headline-levels 4
                  :auto-preamble nil
                  :auto-sitemap nil
                  :html-extension "html"
                  :body-only t))

   (add-to-list 'org-publish-project-alist
                '("blog" :components ("smallzhan-github-io"))))

     ;; Key bindings specifically for Dired.
  (let ((map dired-mode-map))
    (define-key map (kbd "C-c C-d C-i") #'denote-link-dired-marked-notes)
    (define-key map (kbd "C-c C-d C-r") #'denote-dired-rename-marked-files)
    (define-key map (kbd "C-c C-d C-R") #'denote-dired-rename-marked-files-using-front-matter))
  
  (with-eval-after-load 'org-capture
    (setq denote-org-capture-specifiers "%l\n%i\n%?")
    (add-to-list 'org-capture-templates
                 '("n" "New note (with denote.el)" plain
                   (file denote-last-path)
                   #'denote-org-capture
                   :no-save t
                   :immediate-finish nil
                   :kill-buffer t
                   :jump-to-captured t))))
  
  ;; Also check the commands `denote-link-after-creating',
  ;; `denote-link-or-create'.  You may want to bind them to keys as well.

(use-package consult-notes
 :commands (consult-notes
             consult-notes-search-in-all-notes
             consult-notes-org-roam-find-node
             consult-notes-org-roam-find-node-relation)
 :config
 (with-eval-after-load 'denote
  (consult-notes-denote-mode))
 (setq consult-notes-sources nil)) ;; Set notes dir(s), see below
  ;;(consult-notes-org-roam-mode)) ;; Set org-roam integration)
(provide 'init-denote)
;;; init-denote.el ends here
