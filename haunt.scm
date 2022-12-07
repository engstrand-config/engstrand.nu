(use-modules (haunt asset)
             (haunt builder blog)
             (haunt builder atom)
             (haunt builder assets)
             (haunt reader)
             (haunt reader commonmark)
             (haunt site)
             ((apps projects) #:prefix projects:))

(site #:title "Engstrand.nu"
      #:domain "engstrand.nu"
      #:default-metadata
      '((author . "Fredrik and Johan Engstrand")
        (email  . "contact@engstrand.nu"))
      #:readers (list html-reader commonmark-reader)
      #:builders (list projects:builder
                       (static-directory "static")))
