
(define (unify p1 p2 frame)
    (cond
        ((eq? frame #f) #f)                             ;[1]
        ((var? p1) (unify_var p1 p2 frame))             ;[2]
        ((var? p2) (unify_var p2 p1 frame))             ;[3]
        ((constant? p1)                                 ;[4]
         (if (constant? p2)
             (if (=_constant? p1 p2) frame #f)
             #f))
        ((constant? p2) #f)                             ;[5]
        (else                                           ;[6]
            (unify (cdr p1)                             ;[6.1]
                (cdr p2)
                (unify                                  ;[6.2]
                    (car p1)
                    (car p2)
                    frame)))))



(define (unify_var var val frame)
    (if (equal? var val)                                    ;[1]
        frame                                               ;[1.1]
        (let ((value-cell (binding-in-frame var frame)))    ;[2]
            (if (not value-cell)                            ;[3]
                (if (freefor? var val frame)                ;[3.1]
                    (extend var val frame)                  ;[3.2]
                    #f)                                     ;[3.3]
                (unify (binding-value value-cell)           ;[4]
                    val
                    frame)))))

(define (freefor? var exp frame)
    (letrec
        (
         (freewalk
             (lambda (e)
                 (cond
                     ((constant? e) #t)                            ;[1]
                     ((var? e)                                     ;[2]
                      (if (equal? var e) #f                        ;[2.1]
                          (let ((b (binding-in-frame e frame)))    ;[2.2]
                              (if (not b) #t                       ;[2.3]
                                  (freewalk (binding-value b)))))) ;[2.4]
                     ( (freewalk (car e)) (freewalk (cdr e)))      ;[3]
                     (else #f))                                    ;[4]
                 )  ;end lambda
             ) ; end freewalk binding
         ) ;end letrec bindings
        (freewalk exp)
        ) ;end letrec
    )

(define make-binding cons)

(define binding-in-frame assoc)

(define binding-value cdr)

(define (extend var val frame)
    (cons (make-binding var val) frame))

(define =_constant? equal?)


(define (var? e)
    (and (pair? e) (eq? (car e) '?))
    )

(define constant? atom?)
