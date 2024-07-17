
What is an object? Es



(define class_class
    (record-class
        'class
        '(full   ; methods
          full   ; super-class
          full   ; interfaces
         )))

(define cons_class   (car class_class))      ; The constructor for nodes
(define sel_class    (caddr class_class))
(define methods_class           (car sel_class))
(define super_class             (cadr sel_class))
(define interfaces_class        (caddr sel_class))


; For example   p1.less(p2) in Java is implemented as
;
;    ((get-method p1 'less) p2)

(define (call-method obj name_method)
        (lookup name_method (method-table obj)))


; An object is a record which has a data-section and a method-table.


(define class_object
    (record-class
        'class
        '(full   ; the data
          full   ; the method-table
         )))



(call-method p 'x)
