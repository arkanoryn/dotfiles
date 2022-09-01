;; $DOOMDIR/+company.el -*- lexical-binding: t; -*-

;; [[file:~/.config/doom/config.org::*Company][Company:1]]
(after! company
  (setq company-idle-delay 0.2
        company-minimum-prefix-length 2)
  (setq company-show-quick-access t)
  (add-hook 'evil-normal-state-entry-hook #'company-abort)) ;; make aborting less annoying.
;; Company:1 ends here

;; [[file:~/.config/doom/config.org::*Company][Company:2]]
;; (setq-default history-length 1000)
;; (setq-default prescient-history-length 1000)
;; Company:2 ends here
