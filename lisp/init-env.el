;;; init-env.el  -*- lexical-binding: t; -*- 
;;; this file is borrowed from spacemacs...

(require 'load-env-vars)

(defvar my-env-vars-file
  (expand-file-name ".emacs.env" user-emacs-directory))


(defvar my-ignored-env-variables
  '(
    "DBUS_SESSION_BUS_ADDRESS"
    "GPG_AGENT_INFO"
    "SSH_AGENT_PID"
    "SSH_AUTH_SOCK"
    "DISPLAY")
  
  "Ignored environments variables.
Environment variables with names matching these regexps are not
imported into the `.emacs.env' file.")

(defvar my-env-loaded-p nil)

(defun my/init-env (&optional force)
  "Attempt to fetch the environment variables from the users shell.
This solution is far from perfect and we should not rely on this function
a lot. We use it only to initialize the env file when it does not exist
yet.
If FORCE is non-nil then force the initialization of the file, note that the
current contents of the file will be overwritten."
  (when (or force (not (file-exists-p my-env-vars-file)))
    (with-temp-file my-env-vars-file
      (let ((shell-command-switches (cond
                                     ((or (eq system-type 'darwin)
                                          (eq system-type 'cygwin)
                                          (eq system-type 'gnu/linux))
                                      ;; execute env twice, once with a
                                      ;; non-interactive login shell and
                                      ;; once with an interactive shell
                                      ;; in order to capture all the init
                                      ;; files possible.
                                      '("-lc" "-ic"))
                                     ((eq system-type 'windows-nt) '("-c"))))
            (tmpfile (make-temp-file my-env-vars-file))
            (executable (cond ((or(eq system-type 'darwin)
                                  (eq system-type 'cygwin)
                                  (eq system-type 'gnu/linux)) "env")
                              ((eq system-type 'windows-nt) "set"))))
        (insert
         (concat
          "# ---------------------------------------------------------------------------\n"
          "#                    Emacs environment variables\n"
          "# ---------------------------------------------------------------------------\n"))
        
        (let ((process-environment initial-environment)
              (env-point (point)))
          (dolist (shell-command-switch shell-command-switches)
            (call-process-shell-command
             (concat executable " > " (shell-quote-argument tmpfile)))
            (insert-file-contents tmpfile))
          (delete-file tmpfile)
          ;; sort the environment variables
          (sort-regexp-fields nil "^.*$" ".*?=" env-point (point-max))
          ;; remove adjacent duplicated lines
          (delete-duplicate-lines env-point (point-max) nil t)
          ;; remove ignored environment variables
          (dolist (v my-ignored-env-variables)
            (flush-lines v env-point (point-max))))))))


(defun my/force-init-env ()
  "Forces a rinitialization of environment variables."
  (interactive)
  (my/init-env t))

(defun my/edit-env ()
  "Open the `.emacs.env' file for editing."
  (interactive)
  (if (and my-env-loaded-p
           (file-exists-p my-env-vars-file))
      (progn (find-file my-env-vars-file)
             (when (fboundp 'dotenv-mode)
               (dotenv-mode)))
    (message "env file not loaded")))

(defun my/load-env (&optional force)
  "Load the  environment variables from the `.emacs.env' file."
  (interactive "P")
  (setq my-env-loaded-p t)
  (when (or force (display-graphic-p))
    (my/init-env force)
    (load-env-vars my-env-vars-file)))

;;(my/load-env)
(provide 'init-env)
;;; init-env.el ends here
