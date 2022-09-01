;;; $DOOMDIR/+org.el -*- lexical-binding: t; -*-
;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/.doom.d/org/")

;;  _____ _   _  _____ _____ _____ _____         _______ _____ ____  _   _  _____
;; |_   _| \ | |/ ____|  __ \_   _|  __ \     /\|__   __|_   _/ __ \| \ | |/ ____|
;;   | | |  \| | (___ | |__) || | | |__) |   /  \  | |    | || |  | |  \| | (___
;;   | | | . ` |\___ \|  ___/ | | |  _  /   / /\ \ | |    | || |  | | . ` |\___ \
;;  _| |_| |\  |____) | |    _| |_| | \ \  / ____ \| |   _| || |__| | |\  |____) |
;; |_____|_| \_|_____/|_|   |_____|_|  \_\/_/    \_\_|  |_____\____/|_| \_|_____/
;; Tutorials
;; https://www.i3s.unice.fr/~malapert/emacs_orgmode.html --> might have interesting config
;; https://yannesposito.com/posts/0020-cool-looking-org-mode/index.html

;;  ______ ____  _   _ _______
;; |  ____/ __ \| \ | |__   __|
;; | |__ | |  | |  \| |  | |
;; |  __|| |  | | . ` |  | |
;; | |   | |__| | |\  |  | |
;; |_|    \____/|_| \_|  |_|
;; use the pitch-font for org-mode
(use-package! mixed-pitch
  :hook
  (org-mode . mixed-pitch-mode))

;; after loading org's configuration
(after! org
  (org-indent-mode)

  ;; (setq org-hide-emphasis-markers t)  ; hides the emphasis markers
  (setq org-cycle-separator-lines -1     ;
        org-tags-column -180             ; push the tags on the far right
        org-ellipsis "⤵"                ; Repace elipsis
        org-log-done 'time)              ; logs the time at which the tasks is closed

  ;;  ______      _____ ______  _____
  ;; |  ____/\   / ____|  ____|/ ____|
  ;; | |__ /  \ | |    | |__  | (___
  ;; |  __/ /\ \| |    |  __|  \___ \
  ;; | | / ____ \ |____| |____ ____) |
  ;; |_|/_/    \_\_____|______|_____/
  (custom-set-faces
   '(org-block-begin-line
     ((t (:underline "#A7A6AA" :foreground "#008ED1" :background "#EAEAFF" :extend t))))
   '(org-block
     ((t (:background "#434652" :extend t))))
   '(org-block-end-line
     ((t (:overline "#A7A6AA" :foreground "#008ED1" :background "#EAEAFF" :extend t))))
   )
  (set-face-attribute 'org-level-1 nil
                      :font (font-spec :family "Overpass" :weight 'bold)
                      :background nil
                      :height 1.4)
  (set-face-attribute 'org-level-2 nil
                      ;; :weight 'bold
                      :background nil
                      :height 1.2)
  (set-face-attribute 'org-level-3 nil
                      :weight 'regular
                      :background nil
                      :height 1.1)
  (set-face-attribute 'org-level-4 nil
                      :weight 'regular
                      :background nil
                      :height 1.1)
  (set-face-attribute 'org-level-5 nil
                      :weight 'regular
                      :background nil
                      :height 1.1)
  (set-face-attribute 'org-level-6 nil
                      :background nil
                      :height 1.0
                      :weight 'thin)
  (set-face-attribute 'org-todo nil
                      :font (font-spec :family "Input Mono" :weight 'black)
                      :height 1.0)
  (set-face-attribute 'org-done nil
                      :background nil
                      :height 0.9
                      :strike-through t)
  (set-face-attribute 'org-headline-done nil
                      :font (font-spec :family "Fira Sans")
                      :background nil
                      :weight 'regular
                      :height 0.9
                      :strike-through t)
  (set-face-attribute 'org-scheduled nil
                      :background nil
                      :height 0.5)

  ;;  ______ __  __ _____  _    _           _____ _____  _____
  ;; |  ____|  \/  |  __ \| |  | |   /\    / ____|_   _|/ ____|
  ;; | |__  | \  / | |__) | |__| |  /  \  | (___   | | | (___
  ;; |  __| | |\/| |  ___/|  __  | / /\ \  \___ \  | |  \___ \
  ;; | |____| |  | | |    | |  | |/ ____ \ ____) |_| |_ ____) |
  ;; |______|_|  |_|_|    |_|  |_/_/    \_\_____/|_____|_____/
  (setq org-emphasis-alist
  '(("*" (bold :slant italic)) ;; this make bold both italic and bold, but not color change
    ("/" (italic)) ;; italic text, the text will be "dark salmon"
    ("_"  underline) ;; underlined text, color is "cyan"
    ("=" (:foreground "dark orange")) ;; background of text is "snow1" and text is "deep slate blue"
    ("~" (bold :background "gray10" :foreground "orange"))
    ("+" (:strike-through t))))

  ;;  _______        _____ _  __ _____
  ;; |__   __|/\    / ____| |/ // ____|
  ;;    | |  /  \  | (___ | ' /| (___
  ;;    | | / /\ \  \___ \|  <  \___ \
  ;;    | |/ ____ \ ____) | . \ ____) |
  ;;    |_/_/    \_\_____/|_|\_\_____/
  (setq org-todo-keywords
        '((sequence "TODO(t)" "MEET(m)" "INPROGRESS(i)" "PROJECT(p)" "|" "DONE(d)" "MET(f)" "CANCELED(c)")
          (sequence "[ ](T)" "[-](S)" "[?](W)" "|" "[X](X)")))

  (setq org-todo-keyword-faces
        '(("TODO" :foreground "#f2b23a" :weight 'bold)
          ("PROJECT" :foreground "#7ebffc" :weight 'bold :underline t)
          ("MEET" :foreground "#fff564" :weight 'bold)
          ("CANCELED" :foreground "#ff6480" :strike-through t)
          ("DONE" :foreground "#64ff90" :strike-through t)))

  ;;  _____  ______ ______ _____ _      ______
  ;; |  __ \|  ____|  ____|_   _| |    |  ____|
  ;; | |__) | |__  | |__    | | | |    | |__
  ;; |  _  /|  __| |  __|   | | | |    |  __|
  ;; | | \ \| |____| |     _| |_| |____| |____
  ;; |_|  \_\______|_|    |_____|______|______|
  (setq org-refile-allow-creating-parent-nodes 'confirm
        org-outline-path-complete-in-steps nil
        org-refile-use-outline-path 'file)

 ;;       _  ____  _    _ _____  _   _          _
 ;;      | |/ __ \| |  | |  __ \| \ | |   /\   | |
 ;;      | | |  | | |  | | |__) |  \| |  /  \  | |
 ;;  _   | | |  | | |  | |  _  /| . ` | / /\ \ | |
 ;; | |__| | |__| | |__| | | \ \| |\  |/ ____ \| |____
 ;;  \____/ \____/ \____/|_|  \_\_| \_/_/    \_\______|
  (setq org-journal-date-prefix "#+TITLE: "
        org-journal-time-prefix "* "
        org-journal-date-format "%a, %Y-%m-%d"
        org-journal-file-format "%Y-%m-%d.org")
  )
;;  ______ _   _ _____                      ______ _______ ______ _____     _  ____  _____   _____
;; |  ____| \ | |  __ \               /\   |  ____|__   __|  ____|  __ \   ( )/ __ \|  __ \ / ____|
;; | |__  |  \| | |  | |  ______     /  \  | |__     | |  | |__  | |__) |  |/| |  | | |__) | |  __
;; |  __| | . ` | |  | | |______|   / /\ \ |  __|    | |  |  __| |  _  /     | |  | |  _  /| | |_ |
;; | |____| |\  | |__| |           / ____ \| |       | |  | |____| | \ \     | |__| | | \ \| |__| |
;; |______|_| \_|_____/           /_/    \_\_|       |_|  |______|_|  \_\     \____/|_|  \_\\_____|

;;   _____ _    _ _____  ______ _____              _____ ______ _   _ _____
;;  / ____| |  | |  __ \|  ____|  __ \       /\   / ____|  ____| \ | |  __ \   /\
;; | (___ | |  | | |__) | |__  | |__) |     /  \ | |  __| |__  |  \| | |  | | /  \
;;  \___ \| |  | |  ___/|  __| |  _  /     / /\ \| | |_ |  __| | . ` | |  | |/ /\ \
;;  ____) | |__| | |    | |____| | \ \    / ____ \ |__| | |____| |\  | |__| / ____ \
;; |_____/ \____/|_|    |______|_|  \_\  /_/    \_\_____|______|_| \_|_____/_/    \_\
(use-package! org-super-agenda
  :after org-agenda
  :init
  (setq org-agenda-skip-scheduled-if-done t
        org-agenda-skip-deadline-if-done t
        org-agenda-include-deadlines t
        org-agenda-block-separator "======================"
        org-agenda-start-day nil ;; i.e. today
        org-agenda-span 10
        org-agenda-start-on-weekday 1)

  (setq org-super-agenda-groups '((:name "Today"
                                   :time-grid t
                                   :scheduled today)
                                  (:name "Due today"
                                   :deadline today)
                                  (:name "Important"
                                   :priority "A")
                                  (:name "Overdue"
                                   :deadline past)
                                  (:name "Due soon"
                                   :deadline future)
                                  (:name "Big Outcomes"
                                   :tag "bo")))

  (setq org-agenda-custom-commands
        '(("c" "Super view"
           ((agenda "" ((org-agenda-overriding-header "")
                        (org-super-agenda-groups
                         '((:name "Today"
                            :time-grid t
                            :date today
                            :order 1)))))
            (alltodo "" ((org-agenda-overriding-header "")
                         (org-super-agenda-groups
                          '((:log t)
                            (:name "To refile"
                             :file-path "refile\\.org")
                            (:name "Next to do"
                             :todo "NEXT"
                             :order 1)
                            (:name "Important"
                             :priority "A"
                             :order 6)
                            (:name "Today's tasks"
                             :file-path "journal/")
                            (:name "Due Today"
                             :deadline today
                             :order 2)
                            (:name "Scheduled Soon"
                             :scheduled future
                             :order 8)
                            (:name "Overdue"
                             :deadline past
                             :order 7)
                            (:name "Meetings"
                             :and (:todo "MEET" :scheduled future)
                             :order 10)
                            (:discard (:not (:todo "TODO")))))))))))
  :config
  (org-super-agenda-mode))

;; C O N F I G - Fancy Priorities
;; (use-package org-fancy-priorities)
(after! org-fancy-priorities
  (setq org-fancy-priorities-list '("⚡" "⬆" "⬇" "☕")))
;; (add-hook org-mode org-fancy-priorities-mode)
;; (add-hook 'org-agenda-mode-hook 'org-fancy-priorities-mode)
