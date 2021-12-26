(defpackage scheme
	(:use :cl)
	(:export
		:machine
		:make-machine
		:parse
		:value
		:leftover
		:state
	)
)
(in-package scheme)
(defclass machine () (
	(value :initform nil :accessor value)
	(current :initform nil :accessor current)
	(leftover :initarg :leftover :initform nil :accessor leftover)
	(state :initform "empty" :accessor state)
))
(defun make-machine (chars) (make-instance 'machine :leftover chars))
(defmethod move ((m machine) new-state) (setf (state m) new-state))
(defmethod save ((m machine) value)
	(setf (value m) (append (value m) (list (current m))))
)
(defmethod consume ((m machine))
	(setf (current m) (car (leftover m)))
	(setf (leftover m) (cdr (leftover m)))
)
(defmethod parse ((m machine))
	(consume m)
	(cond
		(
			(and
				(current m)
				(char= (current m) #\:)
			)
			(move m "colon")
		)
		(
			(and
				(current m)
				(string= (state m) "empty")
				(utils:isIdentifierChar (current m))
			)
			(move m "scheme")
		)
		(
			(and
				(current m)
				(string= (state m) "scheme")
				(utils:isIdentifierChar (current m))
			)
			(move m "scheme")
		)
		(t (move m "error"))
	)
	(cond
		((string= (state m) "error") (setf (value m) nil))
		((string/= (state m) "colon") (save m (current m)) (parse m))
		((string= (state m) "colon") t)
	)
)
