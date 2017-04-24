(declaim (optimize (speed 3) (debug 0) (safety 0))
	 (ftype (function (*) t) read-lisp)
	 (ftype (function (* *) t) vec-pars)
	 (ftype (function (* *) t) print-module)
	 (ftype (function (*) t) module-pars)
	 (ftype (function (*) t) if-exist)
	 (ftype (function (*) t) module-aux)
	 (ftype (function (*) t) verilog-pars)
	 (ftype (function (*) t) parser)
	 (ftype (function (* &optional *) t) main)
	 (ftype (function () t) compile-main)
	 (ftype (function () t) compile-lisplog))
	 
(defparameter *types* '(input wire output reg))
(defparameter *type-stack* nil)
(defparameter *var-stack* nil)
(defparameter *flag* t)
(defparameter *version* '0.01)
(defparameter *creator* "Lucas Guerra Borges")
(defparameter *school* "Faculdade de Engenharia Eletrica")
(defparameter *university* "Federal University of Uberlândia")
(defparameter *lab* "Natural and Artificial Inteligence Laboratory")


(defmacro v-format (opc &optional string &rest body)
  `(format ,opc ,string ,@body))

;;This will make a list of lisp tokens
(defun read-lisp (file-name)
  (let ( (*readtable* (copy-readtable nil)))
    (setf (readtable-case *readtable*) :preserve)
    (with-open-file (flag file-name)
		    (loop for lines = (read flag nil :eof)
			  until (equal lines :eof)
			  collect lines))))

;;Parser for (vec - - - - ) list
(defun vec-pars (lst type)
  (let* ( (from (cadr lst))
	 (to (caddr lst))
	 (names (cdddr lst))
	 (str (format nil"~a [~a:~a]" type from to)))
    (mapcar (lambda (x)
	      (if (member x *var-stack*) nil
		  (push x *var-stack*))
	      (push (cons str  (string x))  *type-stack*)) names)))


(defun print-module (cur next)
  (if (null next) (v-format *flag* "~a~%" cur)
      (progn (v-format *flag* "~a, ~%" cur)
	     (print-module (car next) (cdr next)) )))

;;Verilog "module" parser
;;(module name ----- ) 
(defun module-pars (lst)
  (let ( (module-name (car lst))
	(module-body (cdr lst)))
    (v-format *flag* "module ~a (~%" module-name)
    (mapcar #'module-aux module-body)
    (print-module (car *var-stack*) (cdr *var-stack*))
    (v-format *flag* ");~%~%")
    (mapcar (lambda (x) (v-format *flag* "~&~a ~a ;~%" (car x) (cdr x)))
	    *type-stack*)))

;;Check if the 'elem' is inside of the var-stack
(defun if-exist (elem)
  (if (member elem *var-stack*) nil
      (push elem *var-stack*)))

;;Auxiliar function for module parser
(defun module-aux (lst)
  (let ( (type (car lst))
	(body (cdr lst)))
    (loop for item in body
       do
	 (if (consp item) (vec-pars item type)
	     (progn (if-exist  item)
		    (push (cons (string type) (string item)) *type-stack*)))) ))

(defun verilog-pars (str)
  (v-format *flag* "~a~%" (car str)))

;;Main parser
(defun parser (lisp-list)
  (let ( (head (car lisp-list))
	(body (cdr lisp-list)))
    (format t "body ~A ~%" body)
	 
    (cond ( (equal (string-downcase head) "module") (module-pars body))
	  ( (equal (string-downcase head) "verilog") (verilog-pars body))
	  ( t nil))))

;;Main function
(defun main (input-file &optional (output-file nil))
  (let ( (lisp-list (read-lisp input-file)))
    (if  (null output-file) (mapcar #'parser lisp-list)
	     (with-open-file (stream output-file :direction :output
				 :if-exists :supersede
				 :if-does-not-exist :create)
	   (setf *flag* stream)
	   (mapcar #'parser lisp-list))) ))


(defun compile-main ()
  (let ( (input-file (cadr *posix-argv*))
	(output-file (caddr *posix-argv*)))
    (main input-file output-file)))
	   

(defun compile-lisplog ()
  (format t "LispLog VERSION ~a~%" *version*)
  (format t "CREATED BY :~a~%" *creator*)
  (format t "~a ~%~a~%" *university* *school*)
  (format t "~a ~%" *lab*)
  (format t "Feel free to use and change w/e you want~%")
  (format t "-----------------------------------------~%~%~%")
  (sb-ext:save-lisp-and-die "lisplog"
			    :executable t
			    :toplevel #'compile-main
			    ))

