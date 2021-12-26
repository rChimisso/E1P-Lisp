(defclass uri () (
	(scheme
		:initarg :scheme
		:writer scheme
		:reader uri-scheme
	)
	(userinfo
		:initarg :userinfo
		:initform nil
		:writer userinfo
		:reader uri-userinfo
	)
	(host
		:initarg :host
		:initform nil
		:writer host
		:reader uri-host
	)
	(port
		:initarg :port
		:initform nil
		:writer port
		:reader uri-port
	)
	(path
		:initarg :path
		:initform nil
		:writer path
		:reader uri-path
	)
	(query
		:initarg :query
		:initform nil
		:writer query
		:reader uri-query
	)
	(fragment
		:initarg :fragment
		:initform nil
		:writer fragment
		:reader uri-fragment
	)
))
(defun make-uri (scheme &optional userinfo host (port 80) path query fragment)
	(make-instance
		'uri
		:scheme scheme
		:userinfo userinfo
		:host host
		:port port
		:path path
		:query query
		:fragment fragment
	)
)
(defmethod display-uri ((u uri) &optional (stream t))
	(format
		stream
		"~&Scheme: ~a~@
		Userinfo: ~a~@
		Host: ~a~@
		Port: ~d~@
		Path: ~a~@
		Query: ~a~@
		Fragment: ~a~%"
		(uri-scheme u)
		(uri-userinfo u)
		(uri-host u)
		(uri-port u)
		(uri-path u)
		(uri-query u)
		(uri-fragment u)
	)
	t
)
(defmethod print-object ((u uri) stream)
	(print-unreadable-object (u stream :type t) (uri-display u stream))
)
(defun uri-parse (string)
	(let
		(
			(scheme-machine (scheme:make-machine (coerce string 'list)))
			; (uri-machine (uri:make-machine (scheme:leftover (scheme-machine))))
		)
		(scheme:parse scheme-machine); uri-machine should be instantiated after this.
		(if (string/= (scheme:state scheme-machine) "error"); Check for errors also in uri-machine.
			(make-uri
				(coerce (scheme:value scheme-machine) 'string)
				;; (coerce (uri:userinfo uri-machine) 'string)
				;; (coerce (uri:host uri-machine) 'string)
				;; (coerce (uri:port uri-machine) 'string)
				;; (coerce (uri:path uri-machine) 'string)
				;; (coerce (uri:query uri-machine) 'string)
				;; (coerce (uri:fragment uri-machine) 'string)
			)
			nil
		)
	)
)
(defun uri-display (uri &optional (stream t))
	(cond
		((null uri) (princ nil) t)
		(t (display-uri uri stream))
	)
)
