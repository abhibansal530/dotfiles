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

;; To apply any custom tag(s) to captured items.
;(defun abhi/tag-inbox-capture ()
;  (when (seq-contains '("c") (plist-get org-capture-plist :key))
;    (org-toggle-tag "PROTOCOL" 'on)))
;
;(add-hook 'org-capture-before-finalize-hook 'abhi/tag-inbox-capture)

(after! org
  (require 'find-lisp)
  (setq org-ditaa-jar-path "/usr/local/Cellar/ditaa/0.11.0_1/libexec/ditaa-0.11.0-standalone.jar")
  (setq org-startup-folded t)
  (setq org-todo-keywords
        '((sequence "TODO(t)" "NEXT(n)" "SOMEDAY(s)" "PROJECT(p)" "|" "DONE(d)")
          (sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)")))
  (setq abhi/org-agenda-directory "~/org/gtd/")

  ;; Alghout all of these are not required for agenda, but adding these allow for
  ;; searching tags across all these files.
  (setq org-agenda-files (append '("~/org/gtd/inbox.org" "~/org/gtd/life.org" "~/org/gtd/projects.org")
                                 (directory-files-recursively "~/org/resources" "\\.org$")))

  (setq org-complete-tags-always-offer-all-agenda-tags t)

  (setq org-refile-targets '(("~/org/gtd/projects.org" :maxlevel . 1)
                             ("~/org/gtd/life.org" :maxlevel . 3)))

  (setq org-capture-templates
        `(("i" "Inbox")

          ("iP" "Personal inbox" entry
           (file "~/org/gtd/inbox.org")
           (file "~/org/capture-templates/inbox.txt")
           :empty-lines-after 1)

          ("iW" "Work inbox" entry
           (file "~/org/gtd/work/inbox.org")
           (file "~/org/capture-templates/inbox.txt")
           :empty-lines-after 1)

          ("c" "org-protocol-capture" entry
           (file "~/org/gtd/inbox.org")
           (file "~/org/capture-templates/protocol.txt")
           :immediate-finish t)

          ("g" "GTD templates")

          ("gp" "Create a daily plan")

          ("gpP" "Daily plan private" plain
           (file+olp+datetree "~/org/gtd/planner.org")
           (file "~/org/capture-templates/daily-plan.txt")
           :immediate-finish t)

          ("gpW" "Daily plan work" plain
           (file+olp+datetree "~/org/gtd/work/planner.org")
           (file "~/org/capture-templates/daily-plan-work.txt")
           :immediate-finish t)

          ("gr" "Review templates")

          ("grd" "Daily review" plain
           (file+olp+datetree "~/org/gtd/life.org" "GTD" "Daily Review")
           (file "~/org/capture-templates/daily-review.txt")
           :immediate-finish t
           :jump-to-captured t)

          ("grw" "Weekly review" plain
           (file+olp+datetree "~/org/gtd/life.org" "GTD" "Weekly Review")
           (file "~/org/capture-templates/weekly-review.txt")
           :immediate-finish t
           :jump-to-captured t)

          ("r" "Capture a resource")

          ("rB" "Book" entry
           (file "~/org/resources/books.org")
           (file "~/org/capture-templates/book.txt")
           :empty-lines-after 2))))

(setq org-refile-allow-creating-parent-nodes 'confirm)

(add-to-list 'load-path "~/.emacs.d/.local/straight/repos/org-mode/lisp/org-protocol.el")
(require 'org-protocol)

(defun abhi/org-agenda-process-inbox-item ()
  "Process a single item in the org-agenda."
  (org-with-wide-buffer
   (org-agenda-set-tags)
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

(defun abhi/org-process-inbox ()
  "Called in org-agenda-mode, processes all inbox items."
  (interactive)
  (org-agenda-bulk-mark-regexp "new:")
  (abhi/bulk-process-entries))

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
                                              (org-agenda-skip-function '(org-agenda-skip-entry-if 'deadline 'scheduled))))))

                                     ("i" "Inbox"
                                      ((todo ""
                                            ((org-agenda-overriding-header "To Refile")
                                             (org-agenda-files '(,(concat abhi/org-agenda-directory "inbox.org"))))))))))

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

(eval-after-load "artist"
  '(define-key artist-mode-map [(down-mouse-3)] 'artist-mouse-choose-operation)
  )

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

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(safe-local-variable-values
   (quote
    ((whitespace-line-column . 80)
     (whitespace-style quote
                       (face lines-tail))))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; http://www.howardism.org/Technical/Emacs/getting-more-boxes-done.html
;; https://mollermara.com/blog/Fast-refiling-in-org-mode-with-hydras/

(defmacro my-org-make-refile-command (fn-suffix refile-targets)
  "Generate a command to call `org-refile' with modified targets."
  `(defun ,(intern (concat "my-org-refile-" (symbol-name fn-suffix))) ()
     ,(format "`org-refile' to %S" refile-targets)
     (interactive)
     (org-refile-cache-clear)
     (let ((org-refile-target-verify-function nil)
           (org-refile-history nil)
           (org-refile-targets ,refile-targets))
       (if (eq major-mode 'org-agenda-mode)
           (call-interactively 'org-agenda-refile)
         (call-interactively 'org-refile)))))

(my-org-make-refile-command book '(("~/org/resources/books.org" :maxlevel . 2)))
(my-org-make-refile-command course '(("~/org/resources/courses.org" :maxlevel . 1)))
(my-org-make-refile-command link '(("~/org/resources/links.org" :maxlevel . 1)))
(my-org-make-refile-command paper '(("~/org/resources/papers.org" :maxlevel . 1)))
(my-org-make-refile-command read '(("~/org/resources/readings.org" :maxlevel . 1)))
(my-org-make-refile-command watch '(("~/org/resources/watch.org" :maxlevel . 1)))
(my-org-make-refile-command project '(("~/org/gtd/projects.org" :maxlevel . 1)))
(my-org-make-refile-command people '(("~/org/resources/people.org" :maxlevel . 1)))

(defhydra my-org-refile-hydra (:hint nil :foreign-keys run)
  "
^Refile^            ^Goto^                     ^Dired^
------------------------------------------------------
_p_: Projects       _g j_: Last refile         _d r_: Resources
_P_: Papers         _g r_: To Read
_b_: Books          _g p_: Projects
_c_: Courses
_l_: Links
_r_: To Read
_w_: To Watch
_o_: People
_R_: Refile
"
  ("b" my-org-refile-book)
  ("c" my-org-refile-course)
  ("l" my-org-refile-link)
  ("p" my-org-refile-project)
  ("P" my-org-refile-paper)
  ("r" my-org-refile-read)
  ("w" my-org-refile-watch)
  ("o" my-org-refile-people)
  ("R" org-refile)
  ("g j" org-refile-goto-last-stored :exit t)
  ("g r" (find-file-other-window "~/org/resources/readings.org") :exit t)
  ("g p" (find-file-other-window "~/org/gtd/projects.org") :exit t)
  ("d r" (dired "~/org/resources") :exit t)
  ("q" nil "cancel"))

(global-set-key (kbd "<f9> r") 'my-org-refile-hydra/body)

(use-package! nov
  :mode ("\\.epub\\'" . nov-mode)
  :config
  (setq nov-save-place-file (concat doom-cache-dir "nov-places")))
