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
; Compile and load port package.
(compile-file (merge-pathnames "port.lisp" *load-truename*))
(load (merge-pathnames "port.lisp" *load-truename*))
; Compile and load path package.
(compile-file (merge-pathnames "path.lisp" *load-truename*))
(load (merge-pathnames "path.lisp" *load-truename*))
; Compile and load zpath package.
(compile-file (merge-pathnames "zpath.lisp" *load-truename*))
(load (merge-pathnames "zpath.lisp" *load-truename*))
; Compile and load query package.
(compile-file (merge-pathnames "query.lisp" *load-truename*))
(load (merge-pathnames "query.lisp" *load-truename*))
; Compile and load fragment package.
(compile-file (merge-pathnames "fragment.lisp" *load-truename*))
(load (merge-pathnames "fragment.lisp" *load-truename*))
; Compile and load mailto package.
(compile-file (merge-pathnames "mailto.lisp" *load-truename*))
(load (merge-pathnames "mailto.lisp" *load-truename*))
; Compile and load authority package.
(compile-file (merge-pathnames "authority.lisp" *load-truename*))
(load (merge-pathnames "authority.lisp" *load-truename*))
; Compile and load uri package.
(compile-file (merge-pathnames "uri.lisp" *load-truename*))
(load (merge-pathnames "uri.lisp" *load-truename*))
; Compile and load library interface.
(compile-file (merge-pathnames "interface.lisp" *load-truename*))
(load (merge-pathnames "interface.lisp" *load-truename*))
