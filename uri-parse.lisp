; Compile and load utils package.
(compile-file (merge-pathnames "utils.lisp" *load-truename*))
(load (merge-pathnames "utils.lisp" *load-truename*))
; Compile and load general machine interface.
(compile-file (merge-pathnames "gen-machine.lisp" *load-truename*))
(load (merge-pathnames "gen-machine.lisp" *load-truename*))
; Compile and load scheme package.
(compile-file (merge-pathnames "scheme.lisp" *load-truename*))
(load (merge-pathnames "scheme.lisp" *load-truename*))
; Compile and load host package.
(compile-file (merge-pathnames "host.lisp" *load-truename*))
(load (merge-pathnames "host.lisp" *load-truename*))
; Compile and load userinfo package.
(compile-file (merge-pathnames "userinfo.lisp" *load-truename*))
(load (merge-pathnames "userinfo.lisp" *load-truename*))
; Compile and load mailto package.
(compile-file (merge-pathnames "mailto.lisp" *load-truename*))
(load (merge-pathnames "mailto.lisp" *load-truename*))
; Compile and load uri package.
(compile-file (merge-pathnames "uri.lisp" *load-truename*))
(load (merge-pathnames "uri.lisp" *load-truename*))
; Compile and load library interface.
(compile-file (merge-pathnames "interface.lisp" *load-truename*))
(load (merge-pathnames "interface.lisp" *load-truename*))
