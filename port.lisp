(defpackage port
  (:use :cl :gen-machine)
  (:export :make-machine :parse :valid :value :leftover))
(in-package port)
(defclass machine (gen-machine) ())
(defun make-machine (chars) (make-instance 'machine :leftover chars))
(defmethod finalize ((m machine))
  (if (value m)
      (setf (value m) (parse-integer (coerce (value m) 'string)))
      (setf (value m) 80)))
(defmethod parse ((m machine))
  (consume m)
  (cond
   ((delta m "colon" 'digit-char-p)
    (move m "port"))
   ((delta m "port" 'digit-char-p)
    (move m "port"))
   ((delta-final m #\: "empty")
    (move m "colon"))
   ((delta-final m #\/ "empty" "port")
    (move m "final*"))
   ((final m "empty" "port")
    (move m "final"))
   (t (move m "error")))
  (cond
   ((string= (state m) "error") nil)
   ((string= (state m) "final") (finalize m) t)
   ((string= (state m) "final*") (finalize m) (unconsume m) t)
   ((string= (state m) "colon") (parse m))
   (t (save m) (parse m))))
