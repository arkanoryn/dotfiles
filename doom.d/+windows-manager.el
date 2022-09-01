;;; $DOOMDIR/+windows-manager.el -*- lexical-binding: t; -*-

(setq evil-vsplit-window-right t
      evil-split-window-below t)

;; ask which buffer should be open on split
;; (defadvice! prompt-for-buffer (&rest _)
;;   :after '(evil-window-split evil-window-vsplit)
;;   (consult-buffer))

;; (map! :map evil-window-map
;;       "SPC" #'rotate-layout
;;       ;; Navigation
;;       "<left>"     #'evil-window-left
;;       "<down>"     #'evil-window-down
;;       "<up>"       #'evil-window-up
;;       "<right>"    #'evil-window-right
;;       ;; Swapping windows
;;       "C-M-<left>"       #'+evil/window-move-left
;;       "C-M-<down>"       #'+evil/window-move-down
;;       "C-M-<up>"         #'+evil/window-move-up
;;       "C-M-<right>"      #'+evil/window-move-right)

(setq +zen-text-scale 0.8) ; put zen-zoom to 80% as it is too big when at 100
