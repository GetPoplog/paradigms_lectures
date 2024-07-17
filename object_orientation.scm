

(define class_class (record-class 'class
    '(object            ; the class name
      object            ; its super-class
      object            ; its interfaces
      object            ; an association list for finding methods.
      object            ; its fields
    )))



(define cons_class       (car class_class))
(define sel_class        (caddr class_class))
(define name_class       (car sel_class))
(define super_class      (cadr sel_class))
(define interfaces_class (caddr sel_class))
(define alist_class      (cadddr sel_class))
(define fields_class     (caddddr sel_class))


(define class_object
    (cons_class
        'object                             ; The class is called "object"
        #f                                  ; it has no super-class
        '()                                 ; it has no interfaces
        (list                               ; it has a "tostring" method
            (list 'tostring ->string
                ))
        '()
        )
    )

(make_class 'person class_object '()
    (list
        ('tostring
         (lambda (this)
             (append_string
                 "name: "
                 (send (send this 'name) 'tostring)
                 "age: "
                 (send (send this 'age)  'tostring)
                 "sex: "
                 (send (send this 'sex)  'tostring))
             )
         )
        )
    )

(define (make_class name super interfaces alist_methods fields)
    (let (
         (class
             (cons_class
                 name
                 super
                 interfaces
                 (add_field_methods alist_methods fields)
                 fields
                 ))
         (capabilities
             (record-class class  (map caddr fields))
             ))
        (set! (alist_class class)
            (make_class_alist name fields capabilities))

        )
    )


;To make the alist of the class


(define (make_class_alist name fields capabilities)


)
