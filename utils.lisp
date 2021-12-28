(defpackage utils
	(:use :cl)
	(:export
		:allowed-p
		:query-p
		:identifier-p
		:host-identifier-p
		:alpha-p
		:alnum-p
	)
)
(in-package utils)
(defun allowed-p (char) (allowed-code-p (char-code char)))
(defun allowed-code-p (code)
	(and
		(> code 32)
		(< code 127)
		(/= code 34 37 60 62 92 94 96 123 124 125)
	)
)
(defun query-p (char) (query-code-p (char-code char)))
(defun query-code-p (code) (and (allowed-code-p code) (/= code 35)))
(defun identifier-p (char) (identifier-code-p (char-code char)))
(defun identifier-code-p (code) (and (query-code-p code) (/= code 47 58 63 64)))
(defun host-identifier-p (char) (host-identifier-code-p (char-code char)))
(defun host-identifier-code-p (code) (and (identifier-code-p code) (/= code 46)))
(defun alpha-p (char) (and (alpha-char-p char) (allowed-p char)))
(defun alnum-p (char) (and (alphanumericp char) (allowed-p char)))
; Add octets.
