(defpackage path
	(:use :cl :gen-machine)
	(:import-from :utils :ident-p)
	(:export :make-machine :parse :valid :value :leftover)
)
(in-package path)
(defclass machine (gen-machine) ())
(defun make-machine (chars) (make-instance 'machine :leftover chars))
(defmethod parse ((m machine))
	(consume m)
	(cond
		(
			(delta m "slash" 'ident-p)
			(move m "path")
		)
		(
			(delta m "path" 'ident-p)
			(move m "path")
		)
		(
			(delta m "separator" 'ident-p)
			(move m "path")
		)
		(
			(delta-final m #\/ "empty")
			(move m "slash")
		)
		(
			(delta-final m #\/ "path")
			(move m "separator")
		)
		(
			(delta-final m #\? "slash" "path")
			(move m "final*")
		)
		(
			(delta-final m #\# "slash" "path")
			(move m "final*")
		)
		(
			(final m "empty" "slash" "path")
			(move m "final")
		)
		(t (move m "error"))
	)
	(cond
		((string= (state m) "error") nil)
		((string= (state m) "final") t)
		((string= (state m) "final*") (unconsume m) t)
		((string= (state m) "slash") (parse m))
		(t (save m) (parse m))
	)
)
