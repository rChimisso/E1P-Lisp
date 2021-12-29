(defpackage host
	(:use :cl :gen-machine :utils)
	(:export :make-machine :parse :valid :value :leftover)
)
(in-package host)
(defclass machine (gen-machine) ())
(defun make-machine (chars) (make-instance 'machine :leftover chars))
(defmethod parse ((m machine))
	(consume m)
	(cond
		(
			(delta m "empty" 'host-ident-p)
			(move m "host")
		)
		(
			(delta m "host" 'host-ident-p)
			(move m "host")
		)
		(
			(delta m "separator" 'host-ident-p)
			(move m "host")
		)
		(
			(delta-final m "host" #\.)
			(move m "separator")
		)
		(
			(delta-final m "host" #\:)
			(move m "final*")
		)
		(
			(delta-final m "host" #\/)
			(move m "final*")
		)
		(
			(final m "host")
			(move m "final")
		)
		(t (move m "error"))
	)
	(cond
		((string= (state m) "error") nil)
		((string= (state m) "final") t)
		((string= (state m) "final*") (unconsume m) t)
		(t (save m) (parse m))
	)
)
