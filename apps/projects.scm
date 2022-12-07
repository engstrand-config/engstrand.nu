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
  (flatten
   (list (index-builder)
         (project-builder site posts))))

(define (index-builder)
  (make-page "projects/index.html" (index-t) sxml->html))

(define (project-builder site posts)
  (map
   (lambda (post)
     (make-page (string-append %project-category (post-slug post) ".html")
                (project-t post)
                sxml->html))
   (filter (lambda (post) (post-category? post %project-category))
           posts)))
