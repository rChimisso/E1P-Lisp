(defpackage scheme
	(:use :cl)
	(:export
		:machine
		:make-machine
		:parse
		:value
		:leftover
		:state
		:valid
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
(defmethod delta ((m machine) state checker)
	(and
		(current m)
		(string= (state m) state)
		(funcall checker (current m))
	)
)
(defmethod valid ((m machine)) (string/= (state m) "error"))
(defmethod move ((m machine) new-state) (setf (state m) new-state))
(defmethod save ((m machine))
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
				(string= (state m) "scheme")
				(char= (current m) #\:)
			)
			(move m "colon")
		)
		(
			(delta m "empty" 'utils:isIdentifierChar)
			(move m "scheme")
		)
		(
			(delta m "scheme" 'utils:isIdentifierChar)
			(move m "scheme")
		)
		(t (move m "error"))
	)
	(cond
		((string= (state m) "error") nil)
		((string= (state m) "colon") t)
		(t (save m) (parse m))
	)
)
