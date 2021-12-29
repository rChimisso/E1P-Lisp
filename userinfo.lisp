(defpackage userinfo
	(:use :cl :gen-machine :utils)
	(:export :make-machine :parse :valid :value :leftover :state)
)
(in-package userinfo)
(defclass machine (gen-machine) ())
(defun make-machine (chars) (make-instance 'machine :leftover chars))
(defmethod parse ((m machine))
	(consume m)
	(cond
		(
			(delta m "empty" 'utils:ident-p)
			(move m "userinfo")
		)
		(
			(delta m "userinfo" 'utils:ident-p)
			(move m "userinfo")
		)
		(
			(delta-final m #\@ "userinfo")
			(move m "at")
		)
		(
			(final m "userinfo")
			(move m "final")
		)
		(t (move m "error"))
	)
	(cond
		((string= (state m) "error") nil)
		((string= (state m) "final") t)
		((string= (state m) "at") t)
		(t (save m) (parse m))
	)
)
