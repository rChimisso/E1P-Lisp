(defpackage gen-machine
	(:use :cl)
	(:export
		:gen-machine
		:value
		:current
		:leftover
		:state
		:delta
		:delta-final
		:final
		:valid
		:move
		:save
		:consume
		:unconsume
	)
)
(in-package gen-machine)
(defclass gen-machine () (
	(value :initform nil :accessor value)
	(current :initform nil :accessor current)
	(leftover :initarg :leftover :accessor leftover)
	(state :initform "empty" :accessor state)
))
(defmethod delta ((m gen-machine) state checker)
	(and
		(current m)
		(string= (state m) state)
		(funcall checker (current m))
	)
)
(defmethod delta-final ((m gen-machine) state char)
	(and
		(current m)
		(string= (state m) state)
		(char= (current m) char)
	)
)
(defmethod final ((m gen-machine) &rest states)
	(and
		(not (current m))
		(member (state m) states :test #'string=)
	)
)
(defmethod valid ((m gen-machine)) (string/= (state m) "error"))
(defmethod move ((m gen-machine) new-state) (setf (state m) new-state))
(defmethod save ((m gen-machine))
	(setf (value m) (append (value m) (list (current m))))
)
(defmethod consume ((m gen-machine))
	(setf (current m) (car (leftover m)))
	(setf (leftover m) (cdr (leftover m)))
)
(defmethod unconsume ((m gen-machine))
	(if (current m) (setf (leftover m) (cons (current m) (leftover m))))
)
