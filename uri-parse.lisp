; Compile and load charUtils package.
(compile-file (merge-pathnames "charUtils.lisp" *load-truename*))
(load (merge-pathnames "charUtils.lisp" *load-truename*))
; Compile and load uri package.
(compile-file (merge-pathnames "uri.lisp" *load-truename*))
(load (merge-pathnames "uri.lisp" *load-truename*))
; Compile and load library interface.
(compile-file (merge-pathnames "interface.lisp" *load-truename*))
(load (merge-pathnames "interface.lisp" *load-truename*))
