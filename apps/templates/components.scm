(define-module (apps templates components)
  #:use-module (srfi srfi-1)
  #:use-module (haunt post)
  #:use-module (apps utils)
  #:export (
            window
            statusline
            tabs
            buffer
            content-buffer))

(define (window buffers)
  "Return an SHTML element representing a window containing one
or more vim buffers."
  `(div (@ (class "window"))
        ,@buffers))

;; TODO: Add arg for unique id
(define* (statusline filename #:key
                     (domain "engstrand.nu")
                     (encoding "utf-8")
                     (language "html"))
  "Return an SHTML element representing a vim statusline."
  `(footer
    (section (@ (class "bar status"))
             (div (@ (class "block block-primary mode"))
                  "NORMAL")
             (div (@ (class "block file"))
                  ,filename)
             (div (@ (class "block expand align-right info"))
                  ,(string-join (list "engstrand.nu" "utf-8" "html") " | "))
             (div (@ (class "block block-secondary align-right scroll"))
                  ;; Dynamically updated using JS
                  "0%")
             (div (@ (class "block block-secondary align-right position"))
                  "0:0"))
    (section (@ (class "bar commands"))
             (input (@ (id "command-input")
                       (class "expand")))
             (p (@ (id "keybinding-display"))))))

(define* (tabs hrefs)
  "Return an SHTML element representing a list of tabs for a buffer.
HREFS should be a list of strings or a list of tuples with the href
as key, and as a value a boolean value indicating whether the tab
is currently active.

@example
(tabs (list (\"tab-1\" . #t) \"tab-2\" \"tab-3\"))
@end example"
  `(header (@ (class "bar")
              (id "tabbar"))
           ,@(map (lambda (pair)
                    (let ((index (number->string (car pair)))
                          (href (cadr pair)))
                      (if (pair? href)
                          `((a (@ (href ,(car href))
                                 (class (string-join
                                         (list "tab" ,(if (cadr href) "tab-active" ""))
                                         " "))
                                 (data-id ,index))
                              ,(string-join (list index (car href)) " ")))
                          `((a (@ (href ,href)
                                 (class "tab")
                                 (data-id ,index))
                              ,(string-join (list index href) " "))))))
                  (zip (iota (length hrefs) 0) hrefs))))

(define* (buffer #:key
                 (filename "")
                 (hrefs '())
                 (content '()))
  "Return an SHTML element representing a complete vim buffer,
including a list of tabs, and a statusline."
  `(div (@ (class "buffer"))
        ,(tabs hrefs)
        (section (@ (class "buffer-content"))
                 ;; TODO: Make into component
                 (aside (@ (class "gutter")))
                 (div (@ (class "buffer-text"))
                      ,content))
        ,(statusline filename)))

(define (content-buffer post)
  (buffer
   #:filename (string-append (post-slug post) ".html")
   #:content (post-sxml post)))
