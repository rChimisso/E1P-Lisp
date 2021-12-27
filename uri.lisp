(defpackage uri
	(:use :cl)
	(:export
		:machine
		:make-machine
		:parse
		:scheme
		:host
		:userinfo
		:port
		:path
		:query
		:fragment
		:leftover
	)
)
(in-package uri)
(defclass machine () (
	(host :initform nil :accessor host)
	(userinfo :initform nil :accessor userinfo)
	(port :initform 80 :accessor port)
	(path :initform nil :accessor path)
	(query :initform nil :accessor query)
	(fragment :initform nil :accessor fragment)
	(scheme :initarg :scheme :reader scheme)
	(leftover :initarg :leftover :initform nil :accessor leftover)
))
(defun make-machine (chars scheme) (make-instance 'machine :leftover chars :scheme scheme))
(defun format-value (value)
	(if value
		(coerce value 'string)
		nil
	)
)
(defmethod parse ((m machine))
	(cond
		((not (leftover m)) t)
		(
			(string= (scheme m) "mailto")
			(let
				(
					(userhost-machine (userhost:make-machine (leftover m)))
				)
				(userhost:parse userhost-machine)
				(if	(and (string/= (userhost:state userhost-machine) "error") (userhost:userinfo userhost-machine) (not (userhost:leftover userhost-machine)))
					(progn
						(setf (host m) (userhost:host userhost-machine))
						(setf (userinfo m) (userhost:userinfo userhost-machine))
						(setf (leftover m) nil)
					)
				)
			)
		)
		(
			(string= (scheme m) "news")
			(let
				(
					(userhost-machine (userhost:make-machine (leftover m)))
				)
				(userhost:parse userhost-machine)
				(if	(and (string/= (userhost:state userhost-machine) "error") (not (userhost:userinfo userhost-machine)) (not (userhost:leftover userhost-machine)))
					(progn
						(setf (host m) (userhost:host userhost-machine))
						(setf (leftover m) nil)
					)
				)
			)
		)
		(
			(or (string= (scheme m) "tel") (string= (scheme m) "fax"))
			(let
				(
					(userhost-machine (userhost:make-machine (leftover m)))
				)
				(userhost:parse userhost-machine)
				(if	(and (string/= (userhost:state userhost-machine) "error") (not (userhost:host userhost-machine)) (not (userhost:leftover userhost-machine)))
					(progn
						(setf (userinfo m) (userhost:userinfo userhost-machine))
						(setf (leftover m) nil)
					)
				)
			)
		)
	)
	(setf (host m) (format-value (host m)))
	(setf (userinfo m) (format-value (userinfo m)))
)
