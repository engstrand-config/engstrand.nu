(define-module (apps utils)
  #:use-module (ice-9 regex)
  #:use-module (haunt post)
  #:export (
            %root-url

            %about-category
            %project-category
            %blog-category

            get-url
            post-category?
            get-posts-by-category))

(define %root-url "https://engstrand.nu")

(define %about-category "about/")
(define %project-category "projects/")
(define %blog-category "blog/")

(define* (get-url #:optional (subpath "")
                  #:key (category ""))
  (string-append "/" category subpath ".html"))

(define (post-category? post category)
  (string-match category
                ;; Remove "post/" prefix
                (substring (post-file-name post) 5)))

(define (get-posts-by-category posts category)
   (filter (lambda (post) (post-category? post category))
           posts))
