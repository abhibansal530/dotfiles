;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Abhishek Bansal"
      user-mail-address "abhibansal530@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 14))
;; (setq doom-font (font-spec :family "Source Code Pro" :size 18))
(setq doom-font (font-spec :family "Meslo LG S for Powerline" :size 18))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'gruvbox-dark-soft)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c g k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c g d') to jump to their definition and see how
;; they are implemented.

;; My custom keybindings
;; (map! :n ";" ":")
;; (define-key evil-normal-state-map ";" ":")
;; (define-key evil-motion-state-map ";" 'evil-ex)

;; (load-theme 'gruvbox-dark-soft-theme t)

(defun abhi/tag-inbox-capture ()
  (when (seq-contains '("i" "c") (plist-get org-capture-plist :key))
    (org-toggle-tag "INBOX" 'on)))

(add-hook 'org-capture-before-finalize-hook 'abhi/tag-inbox-capture)

(after! org
  (require 'find-lisp)
  (setq org-todo-keywords
        '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")
          (sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)")))
  (setq abhi/org-agenda-directory "~/org/gtd/")
  (setq org-agenda-files '("~/org/gtd/inbox.org"
                           "~/org/gtd/projects.org"
                           "~/org/gtd/next.org"))
  (setq org-refile-targets '(("~/org/gtd/next.org" :level . 0)
                             ("~/org/gtd/someday.org" :level . 0)
                             ("~/org/gtd/reading.org" :level . 1)
                             ("~/org/gtd/watch.org" :level . 1)
                             ("~/org/gtd/projects.org" :maxlevel . 1)))
  (add-to-list 'org-capture-templates
        `("i" "inbox" entry (file ,(concat abhi/org-agenda-directory "inbox.org"))
             "* TODO %?"))
  (add-to-list 'org-capture-templates
               `("c" "org-protocol-capture" entry (file ,(concat abhi/org-agenda-directory "inbox.org"))
                 "* TODO [[%:link][%:description]]\n\n %i"
                 :immediate-finish t)))

(setq org-refile-allow-creating-parent-nodes 'confirm)

(add-to-list 'load-path "~/.emacs.d/.local/straight/repos/org-mode/lisp/org-protocol.el")
(require 'org-protocol)

;; Taken from https://github.com/jethrokuan/dots/blob/master/.doom.d/config.el
(defvar abhi/org-agenda-bulk-process-key ?f
  "Default key for bulk processing inbox items.")

(defun abhi/org-process-inbox ()
  "Called in org-agenda-mode, processes all inbox items."
  (interactive)
  (org-agenda-bulk-mark-regexp "inbox:")
  (abhi/bulk-process-entries))

(defvar abhi/org-current-effort "1:00"
  "Current effort for agenda items.")

(defun abhi/my-org-agenda-set-effort (effort)
  "Set the effort property for the current headline."
  (interactive
   (list (read-string (format "Effort [%s]: " abhi/org-current-effort) nil nil abhi/org-current-effort)))
  (setq abhi/org-current-effort effort)
  (org-agenda-check-no-diary)
  (let* ((hdmarker (or (org-get-at-bol 'org-hd-marker)
                       (org-agenda-error)))
         (buffer (marker-buffer hdmarker))
         (pos (marker-position hdmarker))
         (inhibit-read-only t)
         newhead)
    (org-with-remote-undo buffer
      (with-current-buffer buffer
        (widen)
        (goto-char pos)
        (org-show-context 'agenda)
        (funcall-interactively 'org-set-effort nil abhi/org-current-effort)
        (end-of-line 1)
        (setq newhead (org-get-heading)))
      (org-agenda-change-all-lines newhead hdmarker))))

(defun abhi/org-agenda-process-inbox-item ()
  "Process a single item in the org-agenda."
  (org-with-wide-buffer
   (org-agenda-set-tags)
   (org-agenda-priority)
   (call-interactively 'abhi/my-org-agenda-set-effort)
   (org-agenda-refile nil nil t)))

(defun abhi/bulk-process-entries ()
  (if (not (null org-agenda-bulk-marked-entries))
      (let ((entries (reverse org-agenda-bulk-marked-entries))
            (processed 0)
            (skipped 0))
        (dolist (e entries)
          (let ((pos (text-property-any (point-min) (point-max) 'org-hd-marker e)))
            (if (not pos)
                (progn (message "Skipping removed entry at %s" e)
                       (cl-incf skipped))
              (goto-char pos)
              (let (org-loop-over-headlines-in-active-region) (funcall 'abhi/org-agenda-process-inbox-item))
              ;; `post-command-hook' is not run yet.  We make sure any
              ;; pending log note is processed.
              (when (or (memq 'org-add-log-note (default-value 'post-command-hook))
                        (memq 'org-add-log-note post-command-hook))
                (org-add-log-note))
              (cl-incf processed))))
        (org-agenda-redo)
        (unless org-agenda-persistent-marks (org-agenda-bulk-unmark-all))
        (message "Acted on %d entries%s%s"
                 processed
                 (if (= skipped 0)
                     ""
                   (format ", skipped %d (disappeared before their turn)"
                           skipped))
                 (if (not org-agenda-persistent-marks) "" " (kept marked)")))))

(map! :map org-agenda-mode-map
      "r" #'abhi/org-process-inbox)

;; Org agenda.
(use-package! org-agenda
  :init
  :config
  (setq org-columns-default-format "%40ITEM(Task) %Effort(EE){:} %CLOCKSUM(Time Spent) %SCHEDULED(Scheduled) %DEADLINE(Deadline)")
  (setq org-agenda-custom-commands `(("c" "Agenda"
                                      ((agenda ""
                                               ((org-agenda-span 'week)
                                                (org-deadline-warning-days 365)))
                                       (todo "TODO"
                                             ((org-agenda-overriding-header "To Refile")
                                              (org-agenda-files '(,(concat abhi/org-agenda-directory "inbox.org")))))
                                       (todo "NEXT"
                                             ((org-agenda-overriding-header "In Progress")
                                              (org-agenda-files '(,(concat abhi/org-agenda-directory "projects.org")
                                                                  ,(concat abhi/org-agenda-directory "next.org")))
                                              ))
                                       (todo "TODO"
                                             ((org-agenda-overriding-header "Projects")
                                              (org-agenda-files '(,(concat abhi/org-agenda-directory "projects.org")))
                                              ))
                                       (todo "TODO"
                                             ((org-agenda-overriding-header "One-off Tasks")
                                              (org-agenda-files '(,(concat abhi/org-agenda-directory "next.org")))
                                              (org-agenda-skip-function '(org-agenda-skip-entry-if 'deadline 'scheduled)))))))))

(use-package! org-roam
  :hook
  (after-init . org-roam-mode)
  :config
  (setq org-roam-ref-capture-templates
        '(("r" "ref" plain (function org-roam-capture--get-point)
           "%?"
           :file-name "${slug}"
           :head "#+TITLE: ${title}
    #+ROAM_KEY: ${ref}
    #+ROAM_TAGS: Website
    - source :: ${ref}"
           :unnarrowed t)))
  (setq +org-roam-open-buffer-on-find-file nil))

;; (use-package! org-roam-protocol
;;   :after org-protocol)

;; Org jounral.
(use-package org-journal
  :custom
  (org-journal-dir (concat org-roam-directory "/journal"))
  (org-journal-date-prefix "#+TITLE: ")
  (org-journal-file-format "%Y-%m-%d.org")
  (org-journal-date-format "%A, %d %B %Y"))

;; Deft.
(use-package deft
      :after org
      :custom
      (deft-recursive t)
      (deft-use-filter-string-for-filename t)
      (deft-default-extension "org")
      (deft-directory org-roam-directory))
