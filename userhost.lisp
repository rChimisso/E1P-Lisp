(defpackage userhost
	(:use :cl)
	(:export
		:machine
		:make-machine
		:parse
		:host
		:userinfo
		:leftover
		:state
	)
)
(in-package userhost)
(defclass machine () (
	(host :initform nil :accessor host)
	(userinfo :initform nil :accessor userinfo)
	(current :initform nil :accessor current)
	(leftover :initarg :leftover :initform nil :accessor leftover)
	(state :initform "empty" :accessor state)
))
(defun make-machine (chars) (make-instance 'machine :leftover chars))
(defmethod final ((m machine))
	(or (string= (state m) "host") (string= (state m) "userinfo"))
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
	(if (string/= (state m) "userinfo")
		(setf (host m) (append (host m) (list (current m))))
		(setf (userinfo m) (append (userinfo m) (list (current m))))
	)
)
(defmethod consume ((m machine))
	(setf (current m) (car (leftover m)))
	(setf (leftover m) (cdr (leftover m)))
)
(defmethod restore ((m machine))
	(setf (leftover m) (append (list (current m)) (leftover m)))
)
(defmethod parse ((m machine))
	(consume m)
	(cond
		(
			(and
				(not (current m))
				(final m)
			)
			(move m "final")
		)
		(
			(and
				(current m)
				(string= (state m) "host")
				(char= (current m) #\:)
			)
			(move m "leftover")
		)
		(
			(and
				(current m)
				(string= (state m) "host")
				(char= (current m) #\/)
			)
			(move m "leftover")
		)
		(
			(and
				(current m)
				(string= (state m) "userinfo")
				(char= (current m) #\@)
			)
			(move m "at")
		)
		(
			(and
				(current m)
				(string= (state m) "host")
				(char= (current m) #\.)
			)
			(move m "separator")
		)
		(
			(delta m "empty" 'utils:isHostIdentifierChar)
			(move m "host")
		)
		(
			(delta m "host" 'utils:isHostIdentifierChar)
			(move m "host")
		)
		(
			(delta m "separator" 'utils:isHostIdentifierChar)
			(move m "host")
		)
		(
			(delta m "at" 'utils:isHostIdentifierChar)
			(move m "host")
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
		((string= (state m) "leftover") (restore m) t)
		((string= (state m) "at") (parse m))
		(t (save m) (parse m))
	)
)
