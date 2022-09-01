;; $DOOMDIR/+magit.el -*- lexical-binding: t; -*-
;;
;; magit default commit msg
(defvar +magit-project-commit-templates-alist nil
  "Alist of toplevel dirs and template strings/functions.")
(after! magit
  (defun +magit-fill-in-commit-template ()
    "Insert template from `+magit-fill-in-commit-template' if applicable."
    (when-let ((template (and (save-excursion (goto-char (point-min)) (string-match-p "\\`\\s-*$" (thing-at-point 'line)))
                              (cdr (assoc (file-name-base (directory-file-name (magit-toplevel)))
                                          +magit-project-commit-templates-alist)))))
      (goto-char (point-min))
      (insert (if (stringp template) template (funcall template)))
      (goto-char (point-min))
      (end-of-line)))
  (add-hook 'git-commit-setup-hook #'+magit-fill-in-commit-template 90))

;; To avoid conflict between magit and evil-snipe
(add-hook 'magit-mode-hook 'turn-off-evil-snipe-override-mode)
