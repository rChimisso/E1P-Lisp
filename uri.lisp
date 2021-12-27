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
					(mailto-machine (mailto:make-machine (leftover m)))
				)
				(mailto:parse mailto-machine)
				(if (mailto:state mailto-machine)
					(progn
						(setf (host m) (mailto:host mailto-machine))
						(setf (userinfo m) (mailto:userinfo mailto-machine))
						(setf (leftover m) nil)
					)
				)
			)
		)
		(
			(string= (scheme m) "news")
			(let
				(
					(host-machine (host:make-machine (leftover m)))
				)
				(host:parse host-machine)
				(if	(and (host:valid host-machine) (not (host:leftover host-machine)))
					(progn
						(setf (host m) (host:value host-machine))
						(setf (leftover m) nil)
					)
				)
			)
		)
		(
			(or (string= (scheme m) "tel") (string= (scheme m) "fax"))
			(let
				(
					(userinfo-machine (userinfo:make-machine (leftover m)))
				)
				(userinfo:parse userinfo-machine)
				(if	(and (userinfo:valid userinfo-machine) (string/= (userinfo:state userinfo-machine) "at"))
					(progn
						(setf (userinfo m) (userinfo:value userinfo-machine))
						(setf (leftover m) nil)
					)
				)
			)
		)
	)
	(setf (host m) (format-value (host m)))
	(setf (userinfo m) (format-value (userinfo m)))
)
