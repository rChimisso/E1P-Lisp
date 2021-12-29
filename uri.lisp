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
(defmethod setv ((m machine) &key userinfo host (port (port m)) path query fragment)
	(setf
		(values
			(userinfo m)
			(host m)
			(port m)
			(path m)
			(query m)
			(fragment m)
			(valid m)
		)
		(values userinfo host port path query fragment t)
	)
)
(defmethod parse ((m machine))
	(cond
		((not (leftover m)) (setf (valid m) t))
		(
			(string-equal (scheme m) "news")
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
			(or (string-equal (scheme m) "tel") (string-equal (scheme m) "fax"))
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
			(string-equal (scheme m) "mailto")
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
		(
			(string-equal (scheme m) "zos")
			nil ; TODO: authority - zpqf
		)
		(
			t
			(let
				(
					(authority-machine (authority:make-machine (leftover m)))
					(path-machine (path:make-machine nil))
					(query-machine (query:make-machine nil))
					(frag-machine (fragment:make-machine nil))
				)
				(authority:parse authority-machine)
				(if (authority:valid authority-machine)
					(progn
						(setf (path:leftover path-machine) (authority:leftover authority-machine))
						(path:parse path-machine)
						(if (path:valid path-machine)
							(progn
								(setf (query:leftover query-machine) (path:leftover path-machine))
								(query:parse query-machine)
								(if (query:valid query-machine)
									(progn
										(setf (fragment:leftover frag-machine) (query:leftover query-machine))
										(fragment:parse frag-machine)
										(if (fragment:valid frag-machine)
											(setv m
												:userinfo (authority:userinfo authority-machine)
												:host (authority:host authority-machine)
												:port (authority:port authority-machine)
												:path (path:value path-machine)
												:query (query:value query-machine)
												:fragment (fragment:value frag-machine)
											)
										)
									)
								)
							)
						)
					)
				)
				(print (authority:current authority-machine))
				(print (authority:leftover authority-machine))
				(print (authority:state authority-machine))
			)
		)
	)
	(if (valid m)
		(setv m
			:host (evaluate (host m))
			:userinfo (evaluate (userinfo m))
			:path (evaluate (path m))
			:query (evaluate (query m))
			:fragment (evaluate (fragment m))
		)
	)
)
