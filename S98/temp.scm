
(define (reduce f acc base l)
   (if (null? l)
       base
       (acc (f (car l)) (reduce f acc base (cdr l)))))

(reduce
    (lambda (x) (+  (car x) (cadr x)))
    +
    10
    '((1 6) (2 5) (3 3) (4 4) (5 1) (6 2)))

(define a 7)
 (let ((a 10) (b (+ a 2)))
   (* a b))
