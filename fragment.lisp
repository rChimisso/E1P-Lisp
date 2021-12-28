(defpackage fragment
	(:use :cl :gen-machine :utils)
	(:export :make-machine :parse :valid :value :leftover)
)
(in-package fragment)
(defclass machine (gen-machine) ())
(defun make-machine (chars) (make-instance 'machine :leftover chars))
(defmethod parse ((m machine))
	(consume m)
	(cond
		(
			(delta m "sharp" 'allowed-p)
			(move m "fragment")
		)
		(
			(delta m "fragment" 'allowed-p)
			(move m "fragment")
		)
		(
			(delta-final m "empty" #\#)
			(move m "sharp")
		)
		(
			(final m "empty" "fragment")
			(move m "final")
		)
		(t (move m "error"))
	)
	(cond
		((string= (state m) "error") nil)
		((string= (state m) "final") t)
		((string= (state m) "sharp") (parse m))
		(t (save m) (parse m))
	)
)
