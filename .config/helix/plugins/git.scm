(require "helix/editor.scm")
(require (prefix-in helix. "helix/commands.scm"))
(require (prefix-in helix.static. "helix/static.scm"))
; (require-builtin helix/components)

(provide git-stage
         git-stage-all
         git-unstage
         git-unstage-all
         git-diff
         git-diff-all
         git-commit
         git-commit-apply
         git-insert-trailer-signed-off-by
         git-insert-trailer-reviewed-by
         git-insert-trailer-tested-by
         git-insert-trailer-acked-by
         git-insert-trailer-reported-by
         git-insert-trailer-co-authored-by
         git-insert-trailer-suggested-by)

(define (current-path)
  (let* ([focus (editor-focus)]
         [focus-doc-id (editor->doc-id focus)])
    (editor-document->path focus-doc-id)))

;;@doc
;; Stage
(define (git-stage)
  (helix.run-shell-command (string-append "git add " (current-path))))

;;@doc
;; Stage
(define (git-stage-all)
  (helix.run-shell-command "git add ."))

;;@doc
;; Unstage
(define (git-unstage)
  (helix.run-shell-command (string-append "git restore --staged " (current-path))))

;;@doc
;; Unstage
(define (git-unstage-all)
  (helix.run-shell-command "git restore --staged ."))

;;@doc
;; Opens a scratch buffer of the current files diff
(define (git-diff)
  (define curr (current-path))
  (helix.new)
  (helix.insert-output (string-append "git diff " curr))
  (helix.set-language "diff"))

;;@doc
;; Opens a scratch buffer of the diff
(define (git-diff-all)
  (helix.new)
  (helix.insert-output "git diff")
  (helix.set-language "diff"))

(define COMMIT_FP "/tmp/HX_COMMIT_EDITMSG")

;;@doc
;; Opens commit editor
(define (git-commit)
  (helix.run-shell-command (string-append "touch " COMMIT_FP))
  (helix.open COMMIT_FP)
  (helix.set-language "git-commit"))

;;@doc
;; Applies commit
(define (git-commit-apply)
  (helix.run-shell-command (string-append "git commit --no-edit --signoff --file=" COMMIT_FP))
  (helix.run-shell-command (string-append "rm " COMMIT_FP))
  (helix.buffer-close!))

(define *trailer-alist*
  (list (cons "s" "Signed-off-by")
        (cons "r" "Reviewed-by")
        (cons "t" "Tested-by")
        (cons "a" "Acked-by")
        (cons "b" "Reported-by")
        (cons "c" "Co-authored-by")
        (cons "u" "Suggested-by")))

;; resolve either a short code or spelled out trailer, allowing custom trailers
(define (resolve-trailer-name key)
  (define by-code (assoc key *trailer-alist*))
  (if by-code (cdr by-code) key))

;; shell expansion to get git name and email after trailer
(define (trailer-shell-command trailer-name)
  (string-append "echo \""
                 trailer-name
                 ": $(git config user.name) <$(git config user.email)>\""))

;;@doc
;; Insert a git trailer
(define (git-insert-trailer . args)
  (helix.insert-output (trailer-shell-command (resolve-trailer-name (car args)))))

;;@doc
;; Insert Signed-off-by trailer
(define (git-insert-trailer-signed-off-by)
  (git-insert-trailer "s"))

;;@doc
;; Insert Reviewed-by trailer
(define (git-insert-trailer-reviewed-by)
  (git-insert-trailer "r"))

;;@doc
;; Insert Tested-by trailer
(define (git-insert-trailer-tested-by)
  (git-insert-trailer "t"))

;;@doc
;; Insert an Acked-by trailer
(define (git-insert-trailer-acked-by)
  (git-insert-trailer "a"))

;;@doc
;; Insert Reported-by trailer
(define (git-insert-trailer-reported-by)
  (git-insert-trailer "b"))

;;@doc
;; Insert Co-authored-by trailer
(define (git-insert-trailer-co-authored-by)
  (git-insert-trailer "c"))

;;@doc
;; Insert Suggested-by trailer
(define (git-insert-trailer-suggested-by)
  (git-insert-trailer "u"))
