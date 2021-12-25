(defun uri-parse () t)
(defun uri-display (uri &optional (stream t))
	(cond
		((null uri)(princ nil)(return-from uri-display t))
		(t (uri:uri-display uri stream))
	)
)
