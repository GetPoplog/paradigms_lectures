
(+ (car '(19 dog)) 6)

(cond
        ( (= 1 2) 3)
        ( (< 9 8) 6)
        ( (> 3 9) 9)
        (else 6)
)


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
    '((2 apples) (9 bananas) (4 grapefruit) (7 oranges)  (2 strawberries))
    '((10 apples) (3 bananas) (9 grapefruit) (4 lemons) (1 oranges)  (3
     tangerines))
    )
