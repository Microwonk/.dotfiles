(require "helix/editor.scm")
(require (prefix-in helix. "helix/commands.scm"))
(require (prefix-in helix.static. "helix/static.scm"))

(provide git-stage
         git-stage-all
         git-unstage
         git-unstage-all
         git-diff
         git-diff-all)

(define (current-path)
  (let* ([focus (editor-focus)]
         [focus-doc-id (editor->doc-id focus)])
    (editor-document->path focus-doc-id)))

;;@doc
;; Stages the current file to git
(define (git-stage)
  (helix.run-shell-command (string-append "git add " (current-path))))

;;@doc
;; Stages all files to git
(define (git-stage-all)
  (helix.run-shell-command "git add ."))

;;@doc
;; Stages the current file to git
(define (git-unstage)
  (helix.run-shell-command (string-append "git restore --staged " (current-path))))

;;@doc
;; Stages all files to git
(define (git-unstage-all)
  (helix.run-shell-command "git restore --staged ."))

;; @doc
;; Opens a scratch buffer of the current files diff
(define (git-diff)
      (define curr (current-path))
      (helix.new)
      (helix.insert-output (string-append "git diff " curr))
      (helix.set-language "diff"))

;; @doc
;; Opens a scratch buffer of the diff
(define (git-diff-all)
      (helix.new)
      (helix.insert-output "git diff")
      (helix.set-language "diff"))
