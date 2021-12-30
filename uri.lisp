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
); REMOVE
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
(defun package-key (pack) (read-from-string (concatenate 'string ":" pack)))
(defun package-call (pack symb arg) (funcall (find-symbol symb pack) arg))
(defmethod recur-parse ((m machine) leftover packages &key authority path zpath query fragment)
	(if packages
		(let
			(
				(pack (first packages))
				(machine (package-call (first packages) "MAKE-MACHINE" leftover))
			)
			(package-call pack "PARSE" machine)
			(if (package-call pack "VALID" machine)
				(recur-parse m
					(package-call pack "LEFTOVER" machine)
					(cdr packages)
					(package-key pack) (package-call pack "VALUE" machine)
					:authority authority
					:path path
					:zpath zpath
					:query query
					:fragment fragment
				)
			)
		)
		(setv m
			:userinfo (first authority)
			:host (second authority)
			:port (third authority)
			:path (append path zpath); At least one of these will always be nil.
			:query query
			:fragment fragment
		)
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
			(recur-parse m (leftover m) '("AUTHORITY" "ZPATH" "QUERY" "FRAGMENT"))
		)
		(
			t
			(recur-parse m (leftover m) '("AUTHORITY" "PATH" "QUERY" "FRAGMENT"))
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
