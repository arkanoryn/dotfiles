;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; ASCII text are done on https://patorjk.com/software/taag/#p=display&f=Big
;; Using the BIG font

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Ark'Anoryn"
      user-mail-address "arkanoryn@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!
;; (setq my-org-font
;;       '((doom-font (font-spec :family "Product Sans" :size 14))
;;         (doom-variable-pitch-font (font-spec :family "Product Sans" :size 14)) ; inherits `doom-font''s :size
;;         (doom-unicode-font (font-spec :family "Input Mono Narrow" :size 14))
;;         (doom-big-font (font-spec :family "Fira Mono" :size 18))))

(setq doom-font (font-spec :family "Input Mono Narrow" :size 14)
      ;; doom-variable-pitch-font (font-spec :family "Product Sans" :size 13) ; inherits `doom-font''s :size
      ;; doom-variable-pitch-font (font-spec :family "Fira Sans" :weight 'thin :size 14) ; inherits `doom-font''s :size
      doom-variable-pitch-font (font-spec :family "Overpass" :weight 'regular :size 14) ; inherits `doom-font''s :size
      doom-unicode-font (font-spec :family "Input Mono Narrow" :size 14)
      doom-big-font (font-spec :family "Fira Mono" :size 18))

;; (setq doom-font (font-spec :family "Input Mono Narrow" :size 13 :weight 'light)
;;       ;; doom-variable-pitch-font (font-spec :family "Fira Sans" :size 14) ; inherits `doom-font''s :size
;;       doom-variable-pitch-font (font-spec :family "Product Sans" :size 14) ; inherits `doom-font''s :size
;;       doom-unicode-font (font-spec :family "Input Mono Narrow" :size 14)
;;       doom-big-font (font-spec :family "Fira Mono" :size 18))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-vibrant)
;; (setq doom-theme 'doom-dark+)
;; (setq doom-theme 'doom-spacegrey)

;; Corrects (and improves) org-mode's native fontification.
;;
;; 1. Re-set `org-todo' & `org-headline-done' faces to make them respect
;;    underlying faces (i.e. don't override the :height or :background of
;;    underlying faces).
;; 2. Make statistic cookies respect underlying faces.
;; 3. Fontify item bullets (make them stand out)
;; 4. Fontify item checkboxes (and when they're marked done), like TODOs that are
;;    marked done.
;; 5. Fontify dividers/separators (5+ dashes)
;; 6. Fontify #hashtags and @at-tags, for personal convenience; see
;;    `doom-org-special-tags' to disable this.
(doom-themes-org-config)

(after! doom-themes
  (remove-hook 'doom-load-theme-hook 'doom-themes-neotree-config)
  (setq doom-themes-treemacs-theme "doom-colors"))


;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;;  __  __  __     __    _____    ______   ______
;; |  \/  | \ \   / /   |  __ \  |  ____| |  ____|
;; | \  / |  \ \_/ /    | |  | | | |__    | |__
;; | |\/| |   \   /     | |  | | |  __|   |  __|
;; | |  | |    | |      | |__| | | |____  | |
;; |_|  |_|    |_|      |_____/  |______| |_|

(defvar doom-bin-dir (concat "/Users/sormani/.emacs.d/" "bin/"))

;; C O N F I G - Doom Modeline
(setq doom-modeline-height 30                     ; If the actual char height is larger, it respects the actual height. How tall the mode-line should be. It's only respected in GUI.
      doom-modeline-bar-width 10                  ; How wide the mode-line bar should be. It's only respected in GUI.
      doom-modeline-major-mode-icon t)            ; Whether display the icon for `major-mode'. It respects `doom-modeline-icon'.

;; C O N F I G
(setq initial-frame-alist '(
                            (top . 0.5)
                            (left . 0.5)
                            (width . 212)
                            (height . 80)))       ; put the frame in the middle
(setq confirm-kill-emacs nil)                     ; Remove the confirm-kill message


(setq-default
 fill-column 100                                  ; ruler line at x char
 major-mode 'org-mode                             ; use org-mode by default on new buffer
 x-stretch-cursor t                               ; Stretch cursor to the glyph width
 line-spacing 2)                                  ; set a space between each line

(setq undo-limit 80000000                         ; Raise undo-limit to 80Mb
      evil-want-fine-undo t                       ; By default while in insert all changes are one big blob. Be more granular
      auto-save-default t                         ; Nobody likes to loose work, I certainly don't
      truncate-string-ellipsis "â€¦"              ; Unicode ellispis are nicer than "...", and also save /precious/ space
      which-key-idle-delay 0.2                    ; reduce the amount of time before the menu get display to 0.2s
      scroll-margin 8)                            ; It's nice to maintain a little margin

(global-subword-mode 1)                           ; Iterate through CamelCase words

(display-time-mode 1)                             ; Enable time in the mode-line
(unless (string-match-p "^Power N/A" (battery))   ; On laptops...
  (display-battery-mode 1))                       ; it's nice to know how much power you have

 ;;  ________      _______ _          _____ _   _ _____ _____  ______
 ;; |  ____\ \    / /_   _| |        / ____| \ | |_   _|  __ \|  ____|
 ;; | |__   \ \  / /  | | | |  _____| (___ |  \| | | | | |__) | |__
 ;; |  __|   \ \/ /   | | | | |______\___ \| . ` | | | |  ___/|  __|
 ;; | |____   \  /   _| |_| |____    ____) | |\  |_| |_| |    | |____
 ;; |______|   \/   |_____|______|  |_____/|_| \_|_____|_|    |______|
  (setq evil-snipe-smart-case t
        evil-snipe-scope 'buffer)

 ;;      __      ____     __
 ;;     /\ \    / /\ \   / /
 ;;    /  \ \  / /  \ \_/ /
 ;;   / /\ \ \/ /    \   /
 ;;  / ____ \  /      | |
 ;; /_/    \_\/       |_|
(setq avy-all-windows t) ; allows to move to any windows from `gs` searches

;;  __  __  __     __     _____   _    _    _____   _______    ____    __  __    _____
;; |  \/  | \ \   / /    / ____| | |  | |  / ____| |__   __|  / __ \  |  \/  |  / ____|
;; | \  / |  \ \_/ /    | |      | |  | | | (___      | |    | |  | | | \  / | | (___
;; | |\/| |   \   /     | |      | |  | |  \___ \     | |    | |  | | | |\/| |  \___ \
;; | |  | |    | |      | |____  | |__| |  ____) |    | |    | |__| | | |  | |  ____) |
;; |_|  |_|    |_|       \_____|  \____/  |_____/     |_|     \____/  |_|  |_| |_____/

(load! "+company")
(load! "+deft")
(load! "+magit")
(load! "+org")
(load! "+projectile")
(load! "+windows-manager")
