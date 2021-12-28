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
	(let ((scheme-machine (scheme:make-machine (coerce string 'list))))
		(scheme:parse scheme-machine)
		(if (scheme:valid scheme-machine)
			(let ((uri-machine (uri:make-machine (scheme:leftover scheme-machine) (utils:evaluate (scheme:value scheme-machine)))))
				(uri:parse uri-machine)
				(if (uri:valid uri-machine)
					(make-uri
						(uri:scheme uri-machine)
						(uri:userinfo uri-machine)
						(uri:host uri-machine)
						(uri:port uri-machine)
						(uri:path uri-machine)
						(uri:query uri-machine)
						(uri:fragment uri-machine)
					)
					nil
				)
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
