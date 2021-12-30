(defpackage zpath
	(:use :cl :gen-machine)
	(:import-from :utils :alpha-p :alnum-p)
	(:export :make-machine :parse :valid :value :leftover)
)
(in-package zpath)
(defclass machine (gen-machine) (
	(id44 :initform nil :accessor id44)
	(id8 :initform nil :accessor id8)
))
(defun make-machine (chars) (make-instance 'machine :leftover chars))
(defmethod save-and-check ((m machine))
	(save m)
	(cond
		(
			(or (string= (state m) "id44") (string= (state m) "separator"))
			(setf (id44 m) (append (id44 m) (list (current m))))
		)
		(
			(string= (state m) "id8")
			(setf (id8 m) (append (id8 m) (list (current m))))
		)
	)
	(if (or (> (list-length (id44 m)) 44) (> (list-length (id8 m)) 8))
		(move m "error")
	)
)
(defmethod parse ((m machine))
	(consume m)
	(cond
		(
			(delta m "slash" 'alpha-p)
			(move m "id44")
		)
		(
			(delta m "id44" 'alnum-p)
			(move m "id44")
		)
		(
			(delta m "separator" 'alnum-p)
			(move m "id44")
		)
		(
			(delta m "open-id8" 'alpha-p)
			(move m "id8")
		)
		(
			(delta m "id8" 'alnum-p)
			(move m "id8")
		)
		(
			(delta-final m #\/ "empty")
			(move m "slash")
		)
		(
			(delta-final m #\. "id44")
			(move m "separator")
		)
		(
			(delta-final m #\( "id44")
			(move m "open-id8")
		)
		(
			(delta-final m #\) "id8")
			(move m "path")
		)
		(
			(delta-final m #\? "slash" "id44" "path")
			(move m "final*")
		)
		(
			(delta-final m #\# "slash" "id44" "path")
			(move m "final*")
		)
		(
			(final m "slash" "id44" "path")
			(move m "final")
		)
		(t (move m "error"))
	)
	(cond
		((string= (state m) "error") nil)
		((string= (state m) "final") t)
		((string= (state m) "final*") (unconsume m) t)
		((string= (state m) "slash") (parse m))
		(t (save-and-check m) (parse m))
	)
)
