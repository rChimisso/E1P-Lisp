(defpackage query
	(:use :cl :gen-machine :utils)
	(:export :make-machine :parse :valid :value :leftover)
)
(in-package query)
(defclass machine (gen-machine) ())
(defun make-machine (chars) (make-instance 'machine :leftover chars))
(defmethod parse ((m machine))
	(consume m)
	(cond
		(
			(delta m "question" 'query-p)
			(move m "query")
		)
		(
			(delta m "query" 'query-p)
			(move m "query")
		)
		(
			(delta-final m "empty" #\?)
			(move m "question")
		)
		(
			(delta-final m "empty" #\#)
			(move m "sharp")
		)
		(
			(delta-final m "query" #\#)
			(move m "sharp")
		)
		(
			(final m "empty" "query")
			(move m "final")
		)
		(t (move m "error"))
	)
	(cond
		((string= (state m) "error") nil)
		((string= (state m) "final") t)
		((string= (state m) "sharp") (unconsume m) t)
		((string= (state m) "question") (parse m))
		(t (save m) (parse m))
	)
)
