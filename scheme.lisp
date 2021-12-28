(defpackage scheme
	(:use :cl :gen-machine :utils)
	(:export :make-machine :parse :valid :value :leftover)
)
(in-package scheme)
(defclass machine (gen-machine) ())
(defun make-machine (chars) (make-instance 'machine :leftover chars))
(defmethod parse ((m machine))
	(consume m)
	(cond
		(
			(delta m "empty" 'ident-p)
			(move m "scheme")
		)
		(
			(delta m "scheme" 'ident-p)
			(move m "scheme")
		)
		(
			(delta-final m "scheme" #\:)
			(move m "colon")
		)
		(t (move m "error"))
	)
	(cond
		((string= (state m) "error") nil)
		((string= (state m) "colon") t)
		(t (save m) (parse m))
	)
)
