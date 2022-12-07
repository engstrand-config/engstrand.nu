(define-module (apps templates projects)
  #:use-module (haunt post)
  #:use-module (apps templates theme)
  #:export (
            index-t
            project-t))

(define (index-t)
  (theme
   #:title '("Projects")
   #:content
   `(main
     (h1 "Projects"))))

(define (project-t post)
  (let ((title (post-ref post 'title)))
    (theme
     #:title (list "Projects" title)
     #:content
     `(main
       (h1 ,title)
       ,(post-sxml post)))))
