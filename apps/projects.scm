(define-module (apps projects)
  #:use-module (haunt html)
  #:use-module (haunt page)
  #:use-module (haunt post)
  #:use-module (haunt site)
  #:use-module (haunt utils)
  #:use-module (haunt reader)
  #:use-module (apps utils)
  #:use-module (apps templates projects)
  #:export (builder))

(define (builder site posts)
  "Return list of haunt pages for projects to display."
  (let ((project-posts (get-posts-by-category posts %project-category)))
    (flatten
     (list (index-builder site project-posts)
           (project-builder site project-posts)))))

(define (index-builder site posts)
  (make-page "projects.html" (index-t posts) sxml->html))

(define (project-builder site posts)
  (map
   (lambda (post)
     (make-page (string-append %project-category (post-slug post) ".html")
                (project-t posts post)
                sxml->html))
   posts))
