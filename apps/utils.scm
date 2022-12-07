(define-module (apps utils)
  #:use-module (ice-9 regex)
  #:use-module (haunt post)
  #:export (
            %root-url

            %about-category
            %project-category

            get-url
            post-category?))

(define %root-url "https://engstrand.nu")

(define %about-category "about/")
(define %project-category "projects/")

(define* (get-url #:optional (subpath ""))
  (string-append %root-url subpath))

(define (post-category? post category)
  (string-match category
                ;; Remove "post/" prefix
                (substring (post-file-name post) 5)))
