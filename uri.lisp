(defpackage uri
	(:use :cl :utils)
	(:export
		:make-machine
		:parse
		:scheme
		:host
		:userinfo
		:port
		:path
		:query
		:fragment
		:valid
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
	(valid :initform nil :accessor valid)
	(leftover :initarg :leftover :reader leftover)
	(scheme :initarg :scheme :reader scheme)
))
(defun make-machine (chars scheme) (make-instance 'machine :leftover chars :scheme scheme))
(defmethod scheme-equal ((m machine) scheme)
	(or
		(string-equal (scheme m) scheme)
		(not (member
			(scheme m)
			'("news" "tel" "fax" "mailto" "zos" "http" "https")
			:test #'string-equal
		))
	)
)
(defmethod parse ((m machine))
	(cond
		((not (leftover m)) (setf (valid m) t))
		(
			(scheme-equal m "news")
			(let
				(
					(host-machine (host:make-machine (leftover m)))
				)
				(host:parse host-machine)
				(if	(and (host:valid host-machine) (not (host:leftover host-machine)))
					(progn
						(setf (host m) (host:value host-machine))
						(setf (valid m) t)
					)
				)
			)
		)
		(
			(or (scheme-equal m "tel") (scheme-equal m "fax"))
			(let
				(
					(userinfo-machine (userinfo:make-machine (leftover m)))
				)
				(userinfo:parse userinfo-machine)
				(if	(and (userinfo:valid userinfo-machine) (string/= (userinfo:state userinfo-machine) "at"))
					(progn
						(setf (userinfo m) (userinfo:value userinfo-machine))
						(setf (valid m) t)
					)
				)
			)
		)
		(
			(scheme-equal m "mailto")
			(let ((mailto-machine (mailto:make-machine (leftover m))))
				(mailto:parse mailto-machine)
				(if (mailto:valid mailto-machine)
					(progn
						(setf (host m) (mailto:host mailto-machine))
						(setf (userinfo m) (mailto:userinfo mailto-machine))
						(setf (valid m) t)
					)
				)
			)
		)
	)
	(setf (host m) (evaluate (host m)))
	(setf (userinfo m) (evaluate (userinfo m)))
)
