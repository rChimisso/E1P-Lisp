; Compile and load utils package.
(compile-file (merge-pathnames "utils.lisp" *load-truename*))
(load (merge-pathnames "utils.lisp" *load-truename*))
; Compile and load uri package.
(compile-file (merge-pathnames "uri.lisp" *load-truename*))
(load (merge-pathnames "uri.lisp" *load-truename*))
; Compile and load scheme package.
(compile-file (merge-pathnames "scheme.lisp" *load-truename*))
(load (merge-pathnames "scheme.lisp" *load-truename*))
; Compile and load library interface.
(compile-file (merge-pathnames "interface.lisp" *load-truename*))
(load (merge-pathnames "interface.lisp" *load-truename*))
