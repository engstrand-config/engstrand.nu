(define-module (apps templates components)
  #:use-module (srfi srfi-1)
  #:use-module (haunt post)
  #:use-module (apps utils)
  #:export (
            window
            statusline
            tabs
            buffer
            content-buffer
            url-list))

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
    (section (@ (class "bar status active"))
             (div (@ (class "block block-primary mode"))
                  "NORMAL")
             (div (@ (class "block expand file"))
                  ,filename)
             (div (@ (class "block align-right info"))
                  ,(string-join (list "engstrand.nu" "utf-8" "html") " | "))
             (div (@ (class "block block-secondary align-right scroll"))
                  ;; Dynamically updated using JS
                  "0%")
             (div (@ (class "block block-secondary align-right position"))
                  "0:0"))
    (section (@ (class "bar status inactive"))
             (div (@ (class "block block-inactive file"))
                  ,filename)
             ;; Spacer
             (div (@ (class "block expand")))
             (div (@ (class "block block-inactive align-right scroll"))
                  ;; Dynamically updated using JS
                  "0%")
             (div (@ (class "block align-right position"))
                  "0:0"))
    (section (@ (class "bar commands"))
             (input (@ (id "command-input")
                       (class "expand")
                       (tabindex -1)))
             (p (@ (id "keybinding-display"))))))

(define* (tabs hrefs active-menu-item)
  "Return an SHTML element representing a list of tabs for a buffer."
  `(header (@ (class "bar")
              (id "tabbar"))
           ,@(map (lambda (pair)
                    (let ((index (number->string (car pair)))
                          (href (cadr pair)))
                      `((a (@ (href ,(string-append "/" href))
                              (class ,(string-join
                                       (append '("tab")
                                               (if (equal? href active-menu-item)
                                                   '("tab-active")
                                                   '()))))
                              (data-id ,index))
                           ,(string-join (list index href) " ")))))
                  (zip (iota (length hrefs) 1) hrefs))))

(define* (buffer #:key
                 (filename "")
                 (content '())
                 (small? #f)
                 (center? #f)
                 (tab-index 0))
  "Return an SHTML element representing a complete vim buffer,
including a list of tabs, and a statusline."
  `(div (@ (class ,(string-join (append '("buffer") (if small? '("small") '()))))
           (tabindex ,tab-index))
        (section (@ (class "buffer-content"))
                 ;; TODO: Make into component
                 (aside (@ (class "gutter")))
                 (div (@ (class ,(string-join (append '("buffer-text-wrapper")
                                                      (if center? '("center") '())))))
                      (div (@ (class "buffer-text"))
                           ,content)))
        ,(statusline filename)))

(define* (content-buffer post #:optional (tab-index 1))
  (buffer
   #:tab-index tab-index
   #:filename (string-append (post-slug post) ".html")
   #:content (post-with-metadata->sxml post)))

(define (url-list posts category)
  "Return an SHTML element representing an unordered list of
links to each post in POSTS in CATEGORY. The first link will
be automatically focused on "
  `(ul ,@(map
          (lambda (pair)
            (let* ((index (car pair))
                   (post (cadr pair))
                   (href (get-url (post-slug post) #:category category)))
              `((li
                 (a (@ ,@(if (eq? index 0)
                             `((href ,href) (autofocus ""))
                             `((href ,href))))
                    ,(post-ref post 'title))))))
          (zip (iota (length posts) 0) posts))))
