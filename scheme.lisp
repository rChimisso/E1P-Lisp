(defpackage scheme
	(:use :cl :gen-machine)
	(:export :make-machine :parse)
)
(in-package scheme)
(defclass machine (gen-machine) ())
(defun make-machine (chars) (make-instance 'machine :leftover chars))
(defmethod parse ((m machine))
	(consume m)
	(cond
		(
			(delta m "empty" 'utils:identifier-p)
			(move m "scheme")
		)
		(
			(delta m "scheme" 'utils:identifier-p)
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
