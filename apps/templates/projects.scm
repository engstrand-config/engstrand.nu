(define-module (apps templates projects)
  #:use-module (haunt post)
  #:use-module (apps utils)
  #:use-module (apps templates theme)
  #:use-module (apps templates components)
  #:export (
            index-t
            project-t))

(define (index-buffer posts)
  (buffer
   #:filename "projects.html"
   #:content
   `((h1 "Our projects")
     (ul ,@(map
            (lambda (post)
              `((li
                 (a (@ (href ,(get-url (post-slug post) #:category %project-category)))
                    ,(post-ref post 'title)))))
            posts)))))

(define (project-buffer post)
  (buffer
   #:filename (string-append (post-slug post) ".html")
   #:content (post-sxml post)))

(define (index-t posts)
  (theme
   #:title '("Projects")
   #:content
   (window
    (list (index-buffer posts)))))

(define (project-t posts post)
  (theme
   #:title (list "Projects" (post-ref post 'title))
   #:content
   (window
    (list (index-buffer posts)
          (project-buffer post)))))
