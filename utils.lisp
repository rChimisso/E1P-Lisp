(defpackage utils
  (:use :cl)
  (:export
   :allowed-p
   :query-p
   :ident-p
   :host-ident-p
   :alpha-p
   :alnum-p
   :evaluate))
(in-package utils)
(defun allowed-p (char) (allowed-code-p (char-code char)))
(defun allowed-code-p (code)
  (and
   (> code 31)
   (< code 127)
   (/= code 92)))
(defun query-p (char) (query-code-p (char-code char)))
(defun query-code-p (code) (and (allowed-code-p code) (/= code 35)))
(defun ident-p (char) (ident-code-p (char-code char)))
(defun ident-code-p (code) (and (query-code-p code) (/= code 47 58 63 64)))
(defun host-ident-p (char) (host-ident-p-code-p (char-code char)))
(defun host-ident-p-code-p (code) (and (ident-code-p code) (/= code 46)))
(defun alpha-p (char) (and (alpha-char-p char) (allowed-p char)))
(defun alnum-p (char) (and (alphanumericp char) (allowed-p char)))
(defun octet (char)
  (cond
   ((char= char #\Space) '(#\% #\2 #\0))
   ((char= char #\") '(#\% #\2 #\2))
   ((char= char #\%) '(#\% #\2 #\5))
   ((char= char #\<) '(#\% #\3 #\C))
   ((char= char #\>) '(#\% #\3 #\E))
   ((char= char #\^) '(#\% #\5 #\E))
   ((char= char #\`) '(#\% #\6 #\0))
   ((char= char #\{) '(#\% #\7 #\B))
   ((char= char #\|) '(#\% #\7 #\C))
   ((char= char #\}) '(#\% #\7 #\D))
   (t (list char))))
(defun convert (chars)
  (if (car chars) (append (octet (car chars)) (convert (cdr chars)))))
(defun evaluate (chars) (if chars (coerce (convert chars) 'string)))
