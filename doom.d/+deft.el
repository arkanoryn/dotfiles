;; $DOOMDIR/+deft.el -*- lexical-binding: t; -*-

(setq deft-directory "~/.doom.d/org/"
      deft-extensions '("txt" "tex" "org" "md")
      deft-recursive t
      deft-use-filename-as-title t
      deft-file-naming-rules
      '((noslash . "-")
        (nospace . "-")
        (case-fn . downcase)))
