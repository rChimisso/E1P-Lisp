(defpackage scheme
	(:use :cl)
	(:export
		:machine
	)
)
(in-package scheme)
(defun delta (state char)
	(cond
		((and (or (string= state "empty") (string= state "scheme")) (utils:isIdentifierChar char)) "scheme")
		(t "error")
	)
)
(defun accept (chars state leftover)
	(if (and (char= (car chars) #\:) (string= state "scheme")) nil)
	(if (string/= (delta state (car chars)) "error")
		(append (list (car chars)) (accept (cdr chars) (delta state (car chars)) leftover))
	)
)
(defun machine (chars)
	(accept chars "empty" nil)
)

; Cannot handle wrong strings
; Cannot handle leftover (remove first char everytime a char is put in value)
; How to return leftover?
; Does not convert value to string
; In interface.lisp, uri:make-uri with scheme
