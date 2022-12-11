(define-module (apps templates about)
  #:use-module (haunt post)
  #:use-module (apps utils)
  #:use-module (apps templates theme)
  #:use-module (apps templates components)
  #:export (
            index-t
            about-t))

(define (index-buffer posts)
  (buffer
   #:filename "about.html"
   #:content
   `((h1 "About us")
     ,(url-list posts %about-category))))

(define (index-t posts)
  (theme
   #:title '("About us")
   #:content
   (window
    (list (index-buffer posts)))))

(define (about-t posts post)
  (theme
   #:title (list "About" (post-ref post 'title))
   #:content
   (window
    (list (index-buffer posts)
          (content-buffer post)))))
