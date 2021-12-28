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
(defmethod setv ((m machine) &key host userinfo (port 80) path query fragment)
	(setf
		(values
			(host m)
			(userinfo m)
			(port m)
			(path m)
			(query m)
			(fragment m)
			(valid m)
		)
		(values host userinfo port path query fragment t)
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
					(setv m :host (host:value host-machine))
				)
			)
		)
		(
			(or (scheme-equal m "tel") (scheme-equal m "fax"))
			(let
				(
					(user-machine (userinfo:make-machine (leftover m)))
				)
				(userinfo:parse user-machine)
				(if	(and (userinfo:valid user-machine) (string/= (userinfo:state user-machine) "at"))
					(setv m :userinfo (userinfo:value user-machine))
				)
			)
		)
		(
			(scheme-equal m "mailto")
			(let ((mailto-machine (mailto:make-machine (leftover m))))
				(mailto:parse mailto-machine)
				(if (mailto:valid mailto-machine)
					(setv m
						:host (mailto:host mailto-machine)
						:userinfo (mailto:userinfo mailto-machine)
					)
				)
			)
		)
	)
	(setv m
		:host (evaluate (host m))
		:userinfo (evaluate (userinfo m))
		:port (evaluate (port m))
		:path (evaluate (path m))
		:query (evaluate (query m))
		:fragment (evaluate (fragment m))
	)
)
