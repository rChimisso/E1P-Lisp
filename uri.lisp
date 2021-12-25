(defpackage uri
	(:use :cl)
	(:export
		:make-uri
		:uri-display
		:print-object
	)
)
(in-package uri)
(defclass uri () (
	(scheme :initarg :scheme :writer scheme :reader uri-scheme)
	(userinfo
		:initarg :userinfo
		:initform nil
		:writer userinfo
		:reader uri-userinfo
	)
	(host :initarg :host :initform nil :writer host :reader uri-host)
	(port :initarg :port :initform nil :writer port :reader uri-port)
	(path :initarg :path :initform nil :writer path :reader uri-path)
	(query :initarg :query :initform nil :writer query :reader uri-query)
	(fragment
		:initarg :fragment
		:initform nil
		:writer fragment
		:reader uri-fragment
	)
))
(defun make-uri (scheme &key userinfo host (port 80) path query fragment)
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
(defun uri-display (uri &optional (stream t))
	(format
		stream
		"~&Scheme: ~a~@
		Userinfo: ~a~@
		Host: ~a~@
		Port: ~d~@
		Path: ~a~@
		Query: ~a~@
		Fragment: ~a~%"
		(uri-scheme uri)
		(uri-userinfo uri)
		(uri-host uri)
		(uri-port uri)
		(uri-path uri)
		(uri-query uri)
		(uri-fragment uri)
	)
	t
)
(defmethod print-object ((obj uri) stream)
	(print-unreadable-object (obj stream :type t) (uri-display obj stream))
)

;; (defun uri-scheme (uri) (scheme uri))
;; (defun uri-userinfo (uri) (userinfo uri))
;; (defun uri-host (uri) (host uri))
;; (defun uri-port (uri) (port uri))
;; (defun uri-path (uri) (path uri))
;; (defun uri-query (uri) (query uri))
;; (defun uri-fragment (uri) (fragment uri))