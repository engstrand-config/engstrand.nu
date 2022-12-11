;;; GNU Guix web site
;;; Public domain 2020 Luis Felipe López Acevedo
;;; Initially written by sirgazil who waives all
;;; copyright interest on this file.

(define-module (apps templates theme)
  #:use-module (apps utils)
  #:use-module (apps navigation)
  #:use-module (apps templates components)
  #:export (theme))

(define* (theme #:key
                (title '())
                (description "")
                (keywords '())
                (active-menu-item "index.html")
                (css '())
                (scripts '())
                (crumbs '())
                (hrefs %main-navigation)
                (content '(div "")))
  "Return an SHTML document using the website's theme.

   TITLE (list)
     A list of strings to form the value of the title element of the
     document. The elements of the list are joined together with em
     dashes as separators between them. For example, a list with two
     strings like 'Hello', and 'Blog' will result in a title like
     'Hello — Blog — Engstrand.nu'.

   DESCRIPTION (string)
     The description of the document. This is the value used for the
     description meta element.

   KEYWORDS (list)
     A list of keyword strings that will be used as the value for
     the keywords meta element of the document.

   ACTIVE-MENU-ITEM (string)
     The label of the menu item in the navigation bar that should be
     highlighted to indicate the current section of the website that
     is being browsed. If not provided, the value defaults to 'index.html'.

   CSS (list)
     A list of strings that represent absolute URL paths to additional
     style sheets. For example: '/static/app/css/style.css'. If not
     provided, the value defaults to an empty list.

   SCRIPTS (list)
     A list of strings that represent absolute URL paths to additional
     script files. For example: '/static/app/js/builds.js'. If not
     provided, the value defaults to an empty list.

   CONTENT (SHTML)
     A main element with the content of the page. For example:
     '(main (h2 'Hello World!') (p 'Once upon a time...'))."
  `((doctype "html")

    (html
     (@ (lang "en"))

     (head
      ,(if (null? title)
           `(title "Engstrand.nu")
           `(title ,(string-join (append title '("Engstrand.nu"))
                                 " — ")))
      (meta (@ (charset "UTF-8")))
      (meta (@ (name "keywords") (content ,(string-join keywords ", "))))
      (meta (@ (name "description") (content ,description)))
      (meta (@ (name "viewport") (content "width=device-width, initial-scale=1.0")))

      ;; Main CSS file
      (link (@ (rel "stylesheet") (href "/static/main.css")))

      ;; Additional CSS.
      ,@(map (lambda (style-sheet)
               `(link (@ (rel "stylesheet") (href ,style-sheet))))
             css)

      ;; Additional scripts.
      ,@(map (lambda (script)
               `(script (@ (src ,script)) ""))
             scripts))

     (body
      ,(tabs hrefs active-menu-item)
      ,content))))
