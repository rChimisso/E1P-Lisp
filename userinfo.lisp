(defpackage userinfo
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
(in-package userinfo)
(defclass machine () (
	(value :initform nil :accessor value)
	(current :initform nil :accessor current)
	(leftover :initarg :leftover :initform nil :accessor leftover)
	(state :initform "empty" :accessor state)
))
(defun make-machine (chars) (make-instance 'machine :leftover chars))
(defmethod final ((m machine))
	(and (not (current m)) (string= (state m) "userinfo"))
)
(defmethod delta ((m machine) state checker)
	(and
		(current m)
		(string= (state m) state)
		(funcall checker (current m))
	)
)
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
		((final m) (move m "final"))
		(
			(and
				(current m)
				(string= (state m) "userinfo")
				(char= (current m) #\@)
			)
			(move m "at")
		)
		(
			(delta m "empty" 'utils:isIdentifierChar)
			(move m "userinfo")
		)
		(
			(delta m "userinfo" 'utils:isIdentifierChar)
			(move m "userinfo")
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
