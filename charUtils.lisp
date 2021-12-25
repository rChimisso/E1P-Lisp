(defpackage charUtils
	(:use :cl)
	(:export
		:isAllowedChar
		:isQueryChar
		:isIdentifierChar
		:isHostIdentifierChar
		:isDigitChar
		:isAlphaChar
		:isAlnumChar
	)
)
(in-package charUtils)
(defun isAllowedChar (char) (isAllowedCode (char-code char)))
(defun isAllowedCode (code)
	(and
		(> code 32)
		(< code 127)
		(/= code 34 37 60 62 92 94 96 123 124 125)
	)
)
(defun isQueryChar (char) (isQueryCode (char-code char)))
(defun isQueryCode (code) (and (isAllowedCode code) (/= code 35)))
(defun isIdentifierChar (char) (isIdentifierCode (char-code char)))
(defun isIdentifierCode (code) (and (isQueryCode code) (/= code 47 58 63 64)))
(defun isHostIdentifierChar (char) (isHostIdentifierCode (char-code char)))
(defun isHostIdentifierCode (code) (and (isQueryCode code) (/= code 46)))
(defun isDigitChar (char) (and (digit-char-p char) (isAllowedChar char)))
(defun isAlphaChar (char) (and (alpha-char-p char) (isAllowedChar char)))
(defun isAlnumChar (char) (and (alphanumericp char) (isAllowedChar char)))
