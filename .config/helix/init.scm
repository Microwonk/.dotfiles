(require "helix/keymaps.scm")
(require "helix/configuration.scm")

(define-lsp "steel-language-server" (command "steel-language-server") (args '()))
(define-language "scheme"
  (language-servers '("steel-language-server")))

(require "oil/oil.scm")
(oil-configure! #true #true)
(keymap (global)
  (normal
    (space
      (o
        (o ":oil")
        (e ":oil-enter")
        (u ":oil-up")
        (g ":oil-root")
        (s ":oil-save")
        (r ":oil-refresh")
        (q ":oil-close")
        (h ":oil-toggle-hidden")
        (i ":oil-toggle-git-ignored")
        (m
          (y ":oil-yank")
          (x ":oil-cut")
          (p ":oil-paste")
          (c ":oil-clipboard-clear"))))))

(require "forest/forest.scm")
(forest-configure! 'left #:ignore (list ".git" "target"))
(forest-set-style! 'mini)

(keymap (global)
  (normal (space (E ":forest-open"))))

(require "plugins/git.scm")

(keymap (global)
  (normal
    (space
      (g
        (d ":git-diff")
        (D ":git-diff-all")
        (s
          (a ":git-stage")
          (A ":git-stage-all")
          (u ":git-unstage")
          (U ":git-unstage-all"))))))
