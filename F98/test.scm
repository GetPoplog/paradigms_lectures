From Robin Popplestone Tue Nov  3 11:32:22 EST 1998
To: skonan@ecs.umass.edu



(define e2
   '(   +
        x
        (* 2 (+ 3 z))
    ))

(car e2)

(define funof car)
(define arg1  cadr)
(define arg2  caddr)

; Note - you need to swap the calls of display_mult_expr
; and display_add_expr to get the correct associativity.

(define (display_add_expr e)
    (cond
       ((atom? e) (display_mult_expr e))
       ((equal? (funof e) '+ )
            (begin
                (display_mult_expr (arg1 e))
                (display '+)
                (display_add_expr  (arg2 e))))

       ((equal? (funof e) '- )
            (begin
                (display_mult_expr (arg1 e))
                (display '-)
                (display_add_expr  (arg2 e))))
       (else (display_mult_expr e))
    )
)


(define display_mult_expr display)

(display_add_expr 'x)
(display_add_expr '(* 8 9))
(display_add_expr e2)
