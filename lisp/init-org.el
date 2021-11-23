;; -*- lexical-binding: t; -*-
(use-package ox-gfm
  :defer t)


(use-package cdlatex
  :defer t
  :hook (org-mode . turn-on-org-cdlatex))


(use-package org-pomodoro
  :defer t
  :init (when IS-MAC
          (setq org-pomodoro-audio-player "/usr/bin/afplay")))


(use-package pretty-hydra)
;; (use-package! notdeft
;;   :defer t
;;   :commands notdeft
;;   :config
;;   (setq notdeft-extension "org")
;;   ;;(setq notdeft-secondary-extensions '("md" "org" "muse"))
;;   (setq notdeft-directories `(,(concat +my-org-dir "research")
;;                               ,(concat +my-org-dir "deft")
;;                               ,(concat +my-org-dir "roam")))
;;   ;;,(expand-file-name (concat +my-org-dir "../blog/_posts"))
;;   ;;,(expand-file-name (concat +my-org-dir "../source"))
;;
;;   (setq notdeft-sparse-directories `(("~" . (,(concat +my-org-dir "webclip.org")))))
;;   (setq notdeft-allow-org-property-drawers t)
;;   (setq notdeft-xapian-program (executable-find "notdeft-xapian"))
;;   :bind (:map notdeft-mode-map
;;          ("C-q" . notdeft-quit)
;;          ("C-r" . notdeft-refresh)))


;; (use-package! org-pdftools
;;   :init (setq org-pdftools-link-prefix "pdftools")
;;   :defer t
;;   :hook (org-load . org-pdftools-setup-link))
;;
;;
;; (use-package! org-noter
;;   :commands org-noter
;;   :defer t
;;   :after org
;;   :config
;;   (setq org-noter-default-notes-file-names '("notes.org")
;;         org-noter-notes-search-path `(,(concat +my-org-dir "research"))
;;         org-noter-separate-notes-from-heading t))
;;
;;
;; (use-package! org-noter-pdftools
;;   :after org-noter
;;   :config
;;   (with-eval-after-load 'pdf-annot
;;     (add-hook 'pdf-annot-activate-handler-functions #'org-noter-pdftools-jump-to-note)))

(use-package org
  :straight (org :type built-in)
  :commands (org-dynamic-block-define)
  :init
  (setq org-directory +my-org-dir
      org-agenda-directory (concat +my-org-dir "agenda/")
      org-agenda-diary-file (concat  org-directory "diary.org")
      org-default-notes-file (concat org-directory "note.org")
      org-roam-directory (file-truename (concat org-directory "roam"))
      ;;org-mobile-directory "~/Dropbox/应用/MobileOrg/"
      ;;org-mobile-inbox-for-pull (concat org-directory "inbox.org")
      org-agenda-files `(,(concat org-agenda-directory "planning.org")
                         ,(concat org-agenda-directory "notes.org")
                         ,(concat org-agenda-directory "work.org")))

  :config
  (require 'org-helper-funcs)
  (setq auto-coding-alist
        (append auto-coding-alist '(("\\.org\\'" . utf-8))))

  (setq org-agenda-span 'week
        org-agenda-start-on-weekday nil
        org-agenda-start-day nil)
  ;;:config
  (setq org-log-redeadline 'note
        org-log-reschedule 'note
        org-log-into-drawer "LOGBOOK"
        org-deadline-warning-days 14 ;; two weeks enough
        org-agenda-compact-blocks t
        org-agenda-start-on-weekday nil
        org-agenda-insert-diary-extract-time t

        org-agenda-skip-scheduled-if-done t
        org-agenda-skip-deadline-if-done t
        org-agenda-skip-timestamp-if-done t
        org-agenda-skip-timestamp-if-deadline-is-shown t
        org-agenda-skip-deadline-prewarning-if-scheduled t
        org-agenda-skip-scheduled-if-deadline-is-shown t)

  (setq org-todo-keywords
        '((sequence "TODO(t)" "ACTIVE(a)" "|" "DONE(d)")
          (sequence "WAIT(w@/!)" "HOLD(h@/!)"
                    "|" "CANCEL(c@/!)" "MEETING" "PHONE")))

  (setq org-todo-state-tags-triggers
        '(("CANCEL" ("CANCEL" . t)) ;; t means add this tag
          ("WAIT" ("WAIT" . t))
          ("HOLD" ("WAIT" . t) ("HOLD" . t))
          (done ("WAIT") ("HOLD"))
          ("TODO" ("WAIT") ("CANCEL") ("HOLD")) ;; no t means remove this tag
          ("ACTIVE" ("WAIT") ("CANCEL") ("HOLD"))
          ("DONE" ("WAIT") ("CANCEL") ("HOLD"))))

  (setq org-columns-default-format "%70ITEM(Task) %10Effort(Effort){:} %20CLOCKSUM")
  (setq org-agenda-log-mode-items '(closed state))

  (setq org-tag-alist '((:startgroup)
                        ("@Work" . ?w)
                        ("@Self" . ?e)
                        ("@Home" . ?h)
                        ("@Outer" . ?o)
                        (:endgroup)
                        ("IDEA" . ?i)
                        ("NOTE" . ?n)
                        ("TIPS" . ?t)
                        ("READING" . ?r)
                        ("WRITE" . ?W)
                        ("PROG" . ?p)
                        ("MEETING" . ?m)
                        ("STUDY" . ?d)
                        ("OTHER" . ?o)
                        ("MARK" . ?M)
                        ("TEAM" . ?T)
                        ("LEARN" . ?l)
                        ("PROJ" . ?j)))

  (setq org-emphasis-regexp-components
        '(
          "：，。、  \t('\"{"            ;pre
          "- ：，。、 \t.,:!?;'\")}\\"   ;post
          " \t\r\n,\"'"                  ;border *forbidden*
          "."                            ;body-regexp
          1))                              ; newline


  ;; Allow setting single tags without the menu
  (setq org-fast-tag-selection-single-key 'expert)
  (setq org-tags-column -77)
  ;; For tag searches ignore tasks with scheduled and deadline dates
  (setq org-agenda-tags-todo-honor-ignore-options t)

  (setq org-hide-leading-stars nil)
  (setq org-cycle-separator-lines 0)
  (setq org-blank-before-new-entry '((heading)
                                     (plain-list-item . auto)))
  (setq org-insert-heading-respect-content nil)
  (setq org-startup-truncated nil)

  ;;(add-hook! org-mode-hook (lambda () (yas-minor-mode -1)))
  (setq org-capture-templates
        '(("s" "scheduled task" entry
           (file+headline "agenda/planning.org" "Task List")
           "* TODO %?\nSCHEDULED: %^t\n"
           :clock-in nil)
          ("t" "todo" entry
           (file+headline  "agenda/planning.org" "Task List")
           "* TODO %?\n:PROPERTIES:\n:CATEGORY: task\n:END:\n"
           :clock-in t :clock-resume t)
          ("r" "respond" entry
           (file  "agenda/notes.org")
           "* TODO Respond to %:from on %:subject\n:PROPERTIES:\n:CATEGORY: task\n:END:\n%a\n"
           :clock-in t :clock-resume t :immediate-finish t)
          ("n" "note" entry
           (file+headline  "agenda/notes.org" "Notes")
           "* %? :NOTE:\n%a\n"
           :clock-in t :clock-resume t)
          ("j" "Journal" entry
           (file+olp+datetree  "diary.org")
           "* %?\n%U\n"
           :clock-in t :clock-resume t)
          ;; ("l" "org-protocol" plain ;;(file+function "notes.org" org-capture-template-goto-link)
          ;;  ;;"%?\n%i\n%U\n %:initial" :immediate-finish t)
          ;;  (file+function "notes.org" org-capture-template-goto-link)
          ;;  " %:initial\n%U\n"
          ;; :empty-lines 1)
          ("w" "Link" entry
           (file+headline "agenda/planning.org" "Idea List")
           "* TODO %:annotation\n:PROPERTIES:\n:CATEGORY: link\n:END:\n%i\n"
           :immediate-finish t :kill-buffer t)
          ("m" "Meeting" entry (file+headline "agenda/notes.org" "Temporary")
           "* MEETING with %? :MEETING:\n%U" :clock-in t :clock-resume t)
          ("p" "Phone call" entry (file+headline "agenda/notes.org" "Temporary")
           "* PHONE %? :PHONE:\n%U" :clock-in t :clock-resume t)
          ("h" "Habit" entry
           (file+headline  "agenda/notes.org" "Habit")
           "* ACTIVE %?\n%U\n%a\nSCHEDULED: %t .+1d/3d\n:PROPERTIES:\n:STYLE: habit\n:REPEAT_TO_STATE: ACTIVE\n:END:\n")))

  ;; Targets include this file and any file contributing to the agenda - up to 9 levels deep
  ;; (setq org-refile-targets '((nil :maxlevel . 9)
  ;;                            (org-agenda-files :maxlevel . 9)))

  ;; Use full outline paths for refile targets - we file directly with IDO
  ;; (setq org-refile-use-outline-path t)

  ;; Targets complete directly with IDO
  ;; (setq org-outline-path-complete-in-steps nil)

  ;; Allow refile to create parent tasks with confirmation
  (setq org-refile-allow-creating-parent-nodes 'confirm)

  (setq org-refile-target-verify-function 'bh/verify-refile-target)


  (setq org-enforce-todo-dependencies t)

  ;; Rebuild the reminders everytime the agenda is displayed
  (add-hook 'org-finalize-agenda-hook 'bh/org-agenda-to-appt 'append)
  (add-hook 'org-clock-out-hook 'bh/clock-out-maybe 'append)

  ;; If we leave Emacs running overnight - reset the appointments one minute after midnight
  (run-at-time "24:01" nil 'bh/org-agenda-to-appt)

  (setq org-export-with-timestamps nil)

  (setq org-agenda-exporter-settings
        '((ps-number-of-columns 1)
          (ps-landscape-mode t)
          (htmlize-output-type 'css)))

  (defadvice org-kill-line (after fix-cookies activate)
    (myorg-update-parent-cookie))

  (defadvice kill-whole-line (after fix-cookies activate)
    (myorg-update-parent-cookie))

  (setq org-agenda-text-search-extra-files '(agenda-archives))

  ;;(set-face-attribute 'org-table nil :family "Sarasa Mono SC")

  (setq org-global-properties
        '(("Effort_ALL" .
           "0:15 0:30 0:45 1:00 2:00 3:00 4:00 5:00 6:00 0:00")))

  (setq org-publish-project-alist '())

  (setq-default system-time-locale "C")

  (pretty-hydra-define
    org-hydra
    (:title "Org Templates"
     :color blue :quit-key "q")
    ("Basic"
     (("a" (hot-expand "<a") "ascii")
      ("c" (hot-expand "<c") "center")
      ("C" (hot-expand "<C") "comment")
      ("e" (hot-expand "<e") "example")
      ("E" (hot-expand "<E") "export")
      ("h" (hot-expand "<h") "html")
      ("l" (hot-expand "<l") "latex")
      ("n" (hot-expand "<n") "note")
      ("o" (hot-expand "<q") "quote")
      ("v" (hot-expand "<v") "verse"))
     "Head"
     (("i" (hot-expand "<i") "index")
      ("A" (hot-expand "<A") "ASCII")
      ("I" (hot-expand "<I") "INCLUDE")
      ("H" (hot-expand "<H") "HTML")
      ("L" (hot-expand "<L") "LaTeX"))
     "Source"
     (("s" (hot-expand "<s") "src")
      ("m" (hot-expand "<s" "emacs-lisp") "emacs-lisp")
      ("y" (hot-expand "<s" "python :results output") "python")
      ("p" (hot-expand "<s" "perl") "perl")
      ("r" (hot-expand "<s" "ruby") "ruby")
      ("S" (hot-expand "<s" "sh") "sh")
      ("g" (hot-expand "<s" "go :imports '\(\"fmt\"\)") "golang"))
     "Misc"
     (("u" (hot-expand "<s" "plantuml :file CHANGE.png") "plantuml")
      ("Y" (hot-expand "<s" "jupyter-python :session python :exports both :results raw drawer\n$0") "jupyter")
      ("P" (progn
             (insert "#+HEADERS: :results output :exports both :shebang \"#!/usr/bin/env perl\"\n")
             (hot-expand "<s" "perl")) "Perl tangled")
      ("<" self-insert-command "ins"))))


  ;;(if (featurep! +jekyll) (load! "+jekyll"))
  ;;(if (featurep! +latex) (load! "+latex"))
  ;;(if (featurep! +html) (load! "+html"))
  ;;(if (featurep! +dragndrop) (load! "~/.emacs.d/modules/lang/org/contrib/dragndrop"))
  ;;(if (featurep! +jupyter) (load! "~/.emacs.d/modules/lang/org/contrib/jupyter"))

  ;;(load! "+protocol")
  ;;  (load! "next-spec-day")
  (require 'next-spec-day)

  (defvar bh/keep-clock-running nil)

  (defvar bh/organization-task-id "c77749b4-b094-4c8e-8d22-a52608adc113")

  (bh/org-agenda-to-appt)
  (appt-activate t)

  :bind (:map org-mode-map
         ("<" . (lambda ()
                  "Insert org template."
                  (interactive)
                  (if (or (region-active-p) (looking-back "^\s*" 1))
                      (org-hydra/body)
                    (self-insert-command 1))))))


(use-package org-protocol
  :straight (org-protocol :type built-in)
  :after org)

(straight-use-package '(org-contrib :includes org-expiry))
(use-package org-expiry
  :after org
  :config
  (setq org-expiry-created-property-name "CREATED"
       org-expiry-inactive-timestamps t)

  (add-hook 'org-after-todo-state-change-hook
            (lambda ()
              (when (string= org-state "TODO")
                (save-excursion
                  (org-back-to-heading)
                  (org-expiry-insert-created))))))

(use-package org-clock                 ;built-in
  :straight (org-clock :type built-in)
  :commands org-clock-save
  :init
  (setq org-clock-persist-file (concat user-emacs-directory "org-clock-save.el"))
  ;; (defadvice +org--clock-load-a (&rest _)
  ;;   "Lazy load org-clock until its commands are used."
  ;;   :before '(org-clock-in
  ;;             org-clock-out
  ;;             org-clock-in-last
  ;;             org-clock-goto
  ;;             org-clock-cancel)
  ;;   (org-clock-load))
  :config
  (setq  org-clock-persist t
         ;; Resume when clocking into task with open clock
         org-clock-in-resume t
         org-clock-out-remove-zero-time-clocks t
         org-clock-in-switch-to-state #'my-switch-state-on-clock-in
         org-clock-persist-query-resume nil
         org-clock-report-include-clocking-task t)
  (add-hook 'kill-emacs-hook #'org-clock-save))

(use-package org-crypt ; built-in
  :straight (org-crypt :type built-in)
  :commands org-encrypt-entries org-encrypt-entry org-decrypt-entries org-decrypt-entry
  :hook (org-reveal-start . org-decrypt-entry)
  :preface
  ;; org-crypt falls back to CRYPTKEY property then `epa-file-encrypt-to', which
  ;; is a better default than the empty string `org-crypt-key' defaults to.
  (defvar org-crypt-key nil)
  (with-eval-after-load 'org
    (add-to-list 'org-tags-exclude-from-inheritance "crypt")))
    ;;(add-hook! 'org-mode-hook
    ;;  (add-hook 'before-save-hook 'org-encrypt-entries nil t))))

(use-package org-super-agenda
  :after org
  :config
  (org-super-agenda-mode 1)
  (setq org-agenda-custom-commands
        '(("z" "Super agenda view"
           ((agenda
             ""
             ((org-agenda-span 'day)
              (org-super-agenda-groups
               '((:name "Today"
                  :time-grid t
                  :date today
                  :todo "TODAY"
                  :scheduled today
                  :order 1)
                 (:name "Planned"
                  :time-grid t
                  :todo t
                  :order 2)
                 (:name "Work"
                  :category "dingtalk"
                  :order 3)))))

            (alltodo
             ""
             ((org-agenda-overriding-header "")
              (org-super-agenda-groups
               '((:name "Next"
                  :and (:scheduled nil
                        :deadline nil
                        :category ("task" "link" "capture"))
                  :date today
                  :order 1)

                 (:name "Important"
                  :tag "Important"
                  :priority "A"
                  :order 6)
                 (:name "Due Today"
                  :deadline today
                  :order 2)
                 (:name "Due Soon"
                  :deadline future
                  :order 8)
                 (:name "Overdue"
                  :deadline past
                  :order 7)
                 (:name "Issues"
                  :tag "Issue"
                  :order 12)
                 (:name "Projects"
                  :tag "PROJ"
                  :order 14)
                 (:name "Emacs"
                  :tag "Emacs"
                  :order 13)
                 (:name "Research"
                  :tag ("LEARN" "STUDY")
                  :order 15)
                 (:name "To read"
                  :and (:tag "READING"
                        :not (:tag ("HOLD" "WAIT")))
                  :order 16)

                 (:name "SomeDay"
                  :priority<= "C"
                  :tag ("WAIT" "HOLD")
                  :todo ("SOMEDAY")
                  :order 90))))))))))


(use-package org-superstar
  :hook (org-mode . org-superstar-mode))


(use-package valign
  :hook
  (org-mode . valign-mode))

;; (use-package org-clock-budget
;;   :commands (org-clock-budget-report)
;;   :defer t
;;   :init
;;   (defun my-buffer-face-mode-org-clock-budget ()
;;     "Sets a fixed width (monospace) font in current buffer"
;;     (interactive)
;;     (setq buffer-face-mode-face '(:family "Iosevka" :height 1.0))
;;     (buffer-face-mode)
;;     (setq-local line-spacing nil))
;;   :config
;;   (map! :map org-clock-budget-report-mode-map
;;         :nm "h" #'org-shifttab
;;         :nm "l" #'org-cycle
;;         :nm "e" #'org-clock-budget-report
;;         :nm "s" #'org-clock-budget-report-sort
;;         :nm "d" #'org-clock-budget-remove-budget
;;         :nm "q" #'quit-window)
;;   (add-hook! 'org-clock-budget-report-mode-hook
;;     (toggle-truncate-lines 1)
;;     (my-buffer-face-mode-org-clock-budget)))

;; (use-package! gkroam
;;   :hook (org-load . gkroam-mode)
;;   :init
;;   (setq gkroam-root-dir (expand-file-name "roam" +my-org-dir))
;;   (setq gkroam-prettify-p nil
;;         gkroam-show-brackets-p t
;;         gkroam-use-default-filename t
;;         gkroam-window-margin 4)

;;   :bind
;;   (:map gkroam-mode-map
;;    ("C-c k I" . gkroam-index)
;;    ("C-c k d" . gkroam-daily)
;;    ("C-c k D" . gkroam-delete)
;;    ("C-c k f" . gkroam-find)
;;    ("C-c k i" . gkroam-insert)
;;    ("C-c k n" . gkroam-dwim)
;;    ("C-c k c" . gkroam-capture)
;;    ("C-c k e" . gkroam-link-edit)
;;    ("C-c k u" . gkroam-show-unlinked)
;;    ("C-c k p" . gkroam-toggle-prettify)
;;    ("C-c k t" . gkroam-toggle-brackets)
;;    ("C-c k R" . gkroam-rebuild-caches)
;;    ("C-c k g" . gkroam-update)))


(use-package org-roam
  ;;:hook (org-load . org-roam-setup)
  :defer t
  :commands (org-roam-capture org-roam-node-find)
  ;;:after org
  :init
  (setq org-roam-v2-ack t)
  ;;(setq org-roam-directory (file-truename (concat org-directory "roam")))

  :config
  (org-roam-db-autosync-mode)
  ;; If using org-roam-protocol
  (require 'org-roam-protocol)
  (add-to-list 'org-roam-capture-ref-templates
              '("a" "Annotation" plain ;;(function org-roam-capture--get-point)
                "%U ${body}\n"
                :target (file+head "${slug}.org" "#+title: ${title}\n")
                ;;:file-name "${slug}"
                ;;:head "#+title: ${title}\n#+roam_ref: ${ref}\n#+roam_aliases:\n"
                :immediate-finish t
                :unnarrowed t))
  (add-to-list 'display-buffer-alist
                 '("\\*org-roam\\*"
                    (display-buffer-in-direction)
                    (direction . right)
                    (window-width . 0.33)
                    (window-height . fit-window-to-buffer))))


;; (use-package! org-roam-bibtex
;;   :after org-roam
;;   :config
;;   (require 'org-ref))


(use-package elfeed-dashboard
  :defer t
  :after elfeed
  :commands elfeed-dashboard
  :config
  (setq elfeed-dashboard-file (concat org-directory "elfeed-dashboard.org"))
  ;; update feed counts on elfeed-quit
  (advice-add 'elfeed-search-quit-window :after #'elfeed-dashboard-update-links))

(use-package org-caldav
  :after org
  :load-path "~/.doom.d/extensions/org-caldav"
  :config
  (setq org-caldav-url "https://calendar.dingtalk.com/dav/u_kxmc6elm"
        org-caldav-calendar-id "primary"
        org-caldav-uuid-extension ""
        org-caldav-sync-direction 'twoway
        org-caldav-delete-calendar-entries 'never
        org-caldav-inbox (concat org-directory "agenda/dingtalk.org"))
  (setq org-caldav-files (list org-caldav-inbox))
  (add-to-list 'org-agenda-files org-caldav-inbox))


;; Set bibliography paths so they are the same.
(use-package bibtex
   :config
   (setq bibtex-file-path (expand-file-name "bib/" +my-org-dir)
         bibtex-files '("ref.bib")
         bibtex-notes-path (expand-file-name "notes/" bibtex-file-path)

         my/bibtex-files (mapcar (lambda (file) (concat bibtex-file-path file)) bibtex-files)
         bibtex-align-at-equal-sign t
         bibtex-autokey-titleword-separator "-"
         bibtex-autokey-year-title-separator "-"
         bibtex-autokey-name-year-separator "-"
         bibtex-dialect 'biblatex))

;; (use-package! bibtex-completion
;;   ;;:ensure t
;;   :defer t
;;   :config
;;   (setq bibtex-autokey-year-length 4
;;         bibtex-completion-additional-search-fields '(keywords)
;;         bibtex-completion-bibliography my/bibtex-files
;;         bibtex-completion-library-path (concat bibtex-file-path "pdfs/")
;;         bibtex-completion-notes-path bibtex-notes-path
;;         bibtex-completion-pdf-field "file"
;;         bibtex-completion-pdf-open-function 'org-open-file))

(use-package citar
  :defer t
  :init
  (setq org-cite-insert-processor 'citar
        org-cite-follow-processor 'citar
        org-cite-activate-processor 'citar)

  :config
  (setq citar-at-point-function 'embark-act
        citar-bibliography my/bibtex-files
        citar-library-paths `(,(concat bibtex-file-path "pdfs/"))
        citar-notes-paths `(,bibtex-notes-path)))


(use-package oc
  :straight (oc :type built-in)
  :defer t
  :commands org-cite-insert
  :config
  (setq ;;org-cite-activate-processor nil
        org-cite-global-bibliography my/bibtex-files))

;;(use-package! citeproc
;;  :defer t)

;; (use-package! oc-bibtex-actions
;;   ;;:defer t
;;   :after (oc)
;;   :config
;;   (setq org-cite-insert-processor 'oc-bibtex-actions
;;         org-cite-follow-processor 'oc-bibtex-actions
;;         org-cite-activate-processor 'oc-bibtex-actions))

;; Use consult-completing-read for enhanced interface.
;; (advice-add #'completing-read-multiple :override #'consult-completing-read-multiple)

(use-package ebib
  :commands ebib
  :defer t
  :config
  (setq ebib-default-directory bibtex-file-path
        ebib-bib-search-dirs `(,bibtex-file-path)
        ebib-file-search-dirs `(,(concat bibtex-file-path "pdfs/"))
        ebib-notes-directory bibtex-notes-path
        ebib-reading-list-file (concat bibtex-file-path "notes.org")

        ebib-bibtex-dialect bibtex-dialect
        ebib-file-associations '(("pdf" . "open"))
        ebib-index-default-sort '("timestamp" . descend)
        ebib-notes-template (concat ":PROPERTIES:"
                                    "\n :ID:         %K"
                                    "\n:ROAM_REFS: @%K"
                                    "\n:END:"
                                    "\n#+title: %T"
                                    "\n#+description: %D"
                                    "\n#+date: %S"
                                    "\n %%?")
        ebib-notes-template-specifiers '((?K . ebib-create-key)
                                         (?T . ebib-create-org-title)
                                         (?D . ebib-create-org-description)
                                         (?L . ebib-create-org-link)
                                         (?S . ebib-create-org-time-stamp))
        ebib-preload-bib-files bibtex-files
        ebib-use-timestamp t)

  (defun ebib-create-key (key _db)
    "Return the KEY in DB for an Org mode note."
    (format "%s" key))

  (defun ebib-create-org-time-stamp (_key _db)
    "Create timestamp for an Org mode note."
    (format "%s" (with-temp-buffer (org-insert-time-stamp nil))))

  (defcustom ebib-zotero-translation-server "https://translate.manubot.org"
    "The address of Zotero translation server."
    :group 'ebib
    :type 'string)

  (defun ebib-zotero-import-url (url)
    "Fetch a BibTeX entry from `ebib-zotero-translation-server' by its URL.
 The entry is stored in the current database."
    (interactive "MURL: ")
    (let ((export-format (downcase (symbol-name (intern-soft bibtex-dialect)))))
      (with-temp-buffer
        (insert
         (shell-command-to-string
          (format "curl -s -d '%s' -H 'Content-Type: text/plain' '%s/web' | curl -s -d @- -H 'Content-Type: application/json' '%s/export?format=%s'" url ebib-zotero-translation-server ebib-zotero-translation-server export-format)))
        (ebib-import-entries ebib--cur-db)))))

;; (use-package ebib-biblio
;;  :commands ebib-biblio-import-doi)

(provide 'init-org)
;;; init-org.el ends here
