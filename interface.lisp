(defun uri-parse (string)
	(scheme:machine (coerce string 'list))
)
(defun uri-display (uri &optional (stream t))
	(cond
		((null uri) (princ nil) t)
		(t (uri:uri-display uri stream))
	)
)
