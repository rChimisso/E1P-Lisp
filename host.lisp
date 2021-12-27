(defpackage host
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
(in-package host)
(defclass machine () (
	(value :initform nil :accessor value)
	(current :initform nil :accessor current)
	(leftover :initarg :leftover :initform nil :accessor leftover)
	(state :initform "empty" :accessor state)
))
(defun make-machine (chars) (make-instance 'machine :leftover chars))
(defmethod final ((m machine))
	(and (not (current m)) (string= (state m) "host"))
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
		;; (
		;; 	(and
		;; 		(current m)
		;; 		(string= (state m) "host")
		;; 		(char= (current m) #\:)
		;; 	)
		;; 	(move m "leftover")
		;; )
		;; (
		;; 	(and
		;; 		(current m)
		;; 		(string= (state m) "host")
		;; 		(char= (current m) #\/)
		;; 	)
		;; 	(move m "leftover")
		;; )
		(
			(and
				(current m)
				(string= (state m) "host")
				(char= (current m) #\.)
			)
			(move m "separator")
		)
		(
			(delta m "separator" 'utils:isHostIdentifierChar)
			(move m "host")
		)
		(
			(delta m "empty" 'utils:isHostIdentifierChar)
			(move m "host")
		)
		(
			(delta m "host" 'utils:isHostIdentifierChar)
			(move m "host")
		)
		(t (move m "error"))
	)
	(cond
		((string= (state m) "error") nil)
		((string= (state m) "final") t)
		(t (save m) (parse m))
	)
)
