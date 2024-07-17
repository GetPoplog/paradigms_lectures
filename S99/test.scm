

(define (cmp x y)
    (cond
        ((symbol<? x y) '<)
        ((= x y) '=)
        (else '>)
        )
    )

(define (cmb x y mg)
    (cons (list (+ (car x) (car y)) (cadr x)) mg) )



(merge_general cadr cmp cmb cons (lambda (l) l) (lambda (l) l)
    '((2 apples) (9 bananas) (10 grapefruit) (5 oranges)  (2 strawberries))
    '((7 apples) (2 bananas) (6 grapefruit) (5 lemons) (4 oranges)  (2
     tangerines))
    )
