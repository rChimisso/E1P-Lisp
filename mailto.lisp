(defpackage mailto
	(:use :cl)
	(:export
		:machine
		:make-machine
		:parse
		:host
		:userinfo
		:state
	)
)
(in-package mailto)
(defclass machine () (
	(host :initform nil :accessor host)
	(userinfo :initform nil :accessor userinfo)
	(leftover :initarg :leftover :reader leftover)
	(state :initform t :accessor state)
))
(defun make-machine (chars) (make-instance 'machine :leftover chars))
(defmethod parse ((m machine))
	(let
		(
			(userinfo-machine (userinfo:make-machine (leftover m)))
			(host-machine (host:make-machine nil))
		)
		(userinfo:parse userinfo-machine)
		(if (string= (userinfo:state userinfo-machine) "at")
			(progn
				(setf (host:leftover host-machine) (userinfo:leftover userinfo-machine))
				(host:parse host-machine)
			)
		)
		(if (and (host:valid host-machine) (userinfo:valid userinfo-machine) (not (host:leftover host-machine)))
			(progn
				(setf (host m) (host:value host-machine))
				(setf (userinfo m) (userinfo:value userinfo-machine))
			)
			(setf (state m) nil)
		)
	)
)
