(require "helix/editor.scm")
(require "helix/misc.scm")
(require (prefix-in helix. "helix/commands.scm"))
(require (prefix-in helix.static. "helix/static.scm"))

(provide rust-analyzer-expand-macro)

(define RUST_ANALYZER "rust-analyzer")

(define (current-path)
  (let* ([focus (editor-focus)]
         [focus-doc-id (editor->doc-id focus)])
    (editor-document->path focus-doc-id)))

;; rust-analyzer client attached to the current buffer, or #false
(define (find-rust-analyzer)
  (let loop ([clients (get-active-lsp-clients)])
    (cond
      [(null? clients) #false]
      [(equal? (lsp-client-name (car clients)) RUST_ANALYZER) (car clients)]
      [else (loop (cdr clients))])))

;; LSP positions count characters in the offset encoding negotiated with the server
(define (current-lsp-position client)
  (hash "line" (helix.static.get-current-line-number)
        "character" (helix.static.get-current-line-character
                      (or (lsp-client-offset-encoding client) "utf-16"))))

(define (show-expansion result)
  (if (hash? result)
      (begin
        (helix.new)
        (set-scratch-buffer-name! (string-append "[expand] " (hash-ref result 'name)))
        (helix.set-language "rust")
        (helix.static.insert_string (hash-ref result 'expansion))
        (helix.static.goto_file_start))
      (set-status! "No macro to expand at cursor")))

;;@doc
;; Recursively expand the macro under the cursor into a scratch buffer
(define (rust-analyzer-expand-macro)
  (define client (find-rust-analyzer))
  (define path (current-path))
  (cond
    [(not client) (set-error! "rust-analyzer is not attached to this buffer")]
    [(not path) (set-error! "Buffer has no path")]
    [else
     (send-lsp-command RUST_ANALYZER
                       "rust-analyzer/expandMacro"
                       (hash "textDocument" (hash "uri" (string-append "file://" path))
                             "position" (current-lsp-position client))
                       show-expansion)]))
