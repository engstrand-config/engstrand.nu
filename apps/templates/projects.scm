(define-module (apps templates projects)
  #:use-module (haunt post)
  #:use-module (apps utils)
  #:use-module (apps templates theme)
  #:use-module (apps templates components)
  #:export (
            index-t
            project-t))

(define* (index-buffer posts #:key
                       (small? #f)
                       (center? #f))
  (buffer
   #:small? small?
   #:center? center?
   #:filename "projects.html"
   #:content
   `((h1 "Our projects")
     ,(url-list posts %project-category))))

(define (index-t posts)
  (theme
   #:title '("Projects")
   #:content
   (window
    (list (index-buffer posts #:center? #t)))))

(define (project-t posts post)
  (theme
   #:title (list "Projects" (post-ref post 'title))
   #:content
   (window
    (list (index-buffer posts #:small? #t)
          (content-buffer post)))))
