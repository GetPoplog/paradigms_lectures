

CMPSCI 287 Class Test   03NOV98

NAME

STUDENT ID

Test ID: 1,  ranseed = -399019137810921395


Question 1

Evaluate the following Scheme Expression

(define n 6)
 (let ((n 7) (q (* n 7)))
   (+ (* n 2) q))

Question 2

If these Scheme expressions are evaluated, what is the
result of the second?

(define adjs
  (mk_parser_kleene
    (mk_parser_singleton
       '(atavistic existential abstruse amorphous blue erudite indigent
     big))))

(adjs '(indigent abstruse blue computer))

Question 3
Evaluate the following Scheme Expression

(assoc 2 '((1 2) (2 5) (3 1) (4 3) (5 6) (6 4)))




CMPSCI 287 Class Test   7apr98

NAME

STUDENT ID

Test ID: 1,  ranseed = -877079840931861048


Question 1

Evaluate the following Scheme Expressions

(+ (car '(18 cat)) 8)

(cond
        ( (= 2 2) 9)
        ( (< 7 4) 2)
        ( (> 8 4) 9)
        (else 6)
)

)


Question 2

Evaluate the following Scheme Expressions


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
    '((2 apples) (8 bananas) (8 grapefruit) (8 oranges)  (8 strawberries))
    '((2 apples) (3 bananas) (4 grapefruit) (6 lemons) (4 oranges)  (3
     tangerines))
    )
