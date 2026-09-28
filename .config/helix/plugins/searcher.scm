(require "helix/editor.scm")
(require "helix/misc.scm")
(require (prefix-in helix. "helix/commands.scm"))
(require (prefix-in helix.static. "helix/static.scm"))

(provide search-duckduckgo)

(define URL_PREFIX "https://duckduckgo.com/?q=")

;; RFC 3986 unreserved characters, which never need escaping
(define (unreserved-byte? b)
  (or (and (>= b 48) (<= b 57))
      (and (>= b 65) (<= b 90))
      (and (>= b 97) (<= b 122))
      (member b '(45 46 95 126))))

(define (percent-encode-byte b)
  (define hex (string-upcase (number->string b 16)))
  (string-append "%" (if (< b 16) "0" "") hex))

;; Encode on UTF-8 bytes so non-ASCII selections survive the round trip
(define (url-encode str)
  (apply string-append
         (map (lambda (b)
                (if (unreserved-byte? b)
                    (string (integer->char b))
                    (percent-encode-byte b)))
              (bytes->list (string->bytes str)))))

;; Detach the browser and drop its output, otherwise it would draw over the editor
(define (open-url url)
  (spawn-process
    (command "sh" (list "-c" "setsid -f xdg-open \"$1\" >/dev/null 2>&1" "sh" url))))

;;@doc
;; Search the current cursor selection in a new tab in the default browser.
(define (search-duckduckgo)
  (define query (trim (helix.static.current-highlighted-text!)))
  (if (string=? query "")
      (set-error! "Nothing selected to search for")
      (begin
        (open-url (string-append URL_PREFIX (url-encode query)))
        (set-status! (string-append "Searching DuckDuckGo for: " query)))))
