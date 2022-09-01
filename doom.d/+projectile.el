;;; $DOOMDIR/+projectile.el -*- lexical-binding: t; -*-

;; setup the default search path for projectile
(after! projectile
  (setq projectile-cache-file (concat doom-cache-dir "projectile.cache")
        projectile-enable-caching (not noninteractive)
        projectile-known-projects-file (concat doom-cache-dir "projectile.projects")
        projectile-require-project-root nil
        projectile-globally-ignored-files '(".DS_Store" "Icon" "TAGS")
        projectile-globally-ignored-file-suffixes '(".elc" ".pyc" ".o")
        projectile-ignored-projects '("~/" "/tmp")
        projectile-project-search-path '("~/projects/")
        ))
