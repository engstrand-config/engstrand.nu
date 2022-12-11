(define-module (apps about)
  #:use-module (haunt html)
  #:use-module (haunt page)
  #:use-module (haunt post)
  #:use-module (haunt site)
  #:use-module (haunt utils)
  #:use-module (haunt reader)
  #:use-module (apps utils)
  #:use-module (apps templates about)
  #:export (builder))

(define (builder site posts)
  "Return list of haunt pages for projects to display."
  (let ((project-posts (get-posts-by-category posts %about-category)))
    (flatten
     (list (index-builder site project-posts)
           (about-builder site project-posts)))))

(define (index-builder site posts)
  (make-page "about.html" (index-t posts) sxml->html))

(define (about-builder site posts)
  (map
   (lambda (post)
     (make-page (string-append %about-category (post-slug post) ".html")
                (about-t posts post)
                sxml->html))
   posts))
