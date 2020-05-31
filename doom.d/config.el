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
(setq doom-font (font-spec :family "monospace" :size 14))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

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

(defun abhi/tag-inbox-capture ()
  (when (seq-contains '("i" "c") (plist-get org-capture-plist :key))
    (org-toggle-tag "INBOX" 'on)))

(add-hook 'org-capture-before-finalize-hook 'abhi/tag-inbox-capture)

(after! org
  (require 'find-lisp)
  (setq abhi/org-agenda-directory "~/org/gtd/")
  (setq org-agenda-files
        (find-lisp-find-files abhi/org-agenda-directory "\.org$")))

(after! org (add-to-list 'org-capture-templates
      `("i" "inbox" entry (file ,(concat abhi/org-agenda-directory "inbox.org"))
           "* TODO %?")))

(after! org (add-to-list 'org-capture-templates
             `("c" "org-protocol-capture" entry (file ,(concat abhi/org-agenda-directory "inbox.org"))
               "* TODO [[%:link][%:description]]\n\n %i"
               :immediate-finish t)))

(setq org-refile-allow-creating-parent-nodes 'confirm)
(setq org-refile-targets '(("next.org" :level . 0)
                           ("someday.org" :level . 0)
                           ("reading.org" :level . 1)
                           ("projects.org" :maxlevel . 1)))

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
