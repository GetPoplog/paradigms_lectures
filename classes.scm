
(define class_class (record-class 'class
    '(object         ; the class name
      object         ; its super-class
      object         ; its interfaces
      object         ; an association list for finding static methods.
      object         ; an association list for non-static methods.
      object         ; the static fields of the class
      object         ; the fields of the class
    )))


(define cons_class            (car class_class))
(define sel_class             (caddr class_class))
(define name_class            (car sel_class))
(define super_class           (cadr sel_class))
(define interfaces_class      (caddr sel_class))
(define static_methods_class  (cadddr sel_class))
(define methods_class         (caddddr sel_class))
(define fields_class          (cadddddr sel_class))
(define is_class              (cadddr class_class))



(define class_object
    (cons_class
        'object                          ; The class is called "object"
        #f                               ; it has no super-class
        '()                              ; it has no interfaces
        '()                              ; no static methods
        (list                            ; it has a "->string" method
            (list '->string ->string     ; which is the ->string
                ))                       ; function
        '()                              ; no static fields.
        '()                              ; no non-static fields.
        )
    )


(define class_person
    (cons_class
        'person         ; the class is called "person"
        class_object    ; its super-class is the object class
        #f              ; it implements no interfaces
       '()              ; it has (initially) no static methods
       '()              ; it has (initially) no non-static methods
       '()              ; it has (initially) no static fields
       '(name age sex)  ; the non-static fields
     ))
