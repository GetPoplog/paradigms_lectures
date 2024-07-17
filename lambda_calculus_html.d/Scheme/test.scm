"the fat cat"

'( '(3 4))

(+
;funny
2 3)

'(+ 2 3)

(+ 2 3)

(case 1
  ( (1) (display 'one) )
  ( else (display 'else)))


(case 3
  ( (1) (display 'one) )
  ( (2 3) (display 'twothree) )
  ( else (display 'else)))


(case 3
  ( (1) (display 'one) )
  ( (2 3) (display 'twothree) ))

equal?

  (trace display)
    (newline)
    (display "example: ")
    (display expr)


(trace eval)
(eval 3 "dummy")

(define (test x) (+ x 10))
(test 4)

'()

'(2 . 3)


;;;'(2 . 3 4)

(define (cube x) (* x x x))

(cube 3)


(define (mystery x n)
    ;what does it do?
    (cond
        ( (= n 0) 1)
        ( (= (remainder n 2) 0 )
	   (let ((m (mystery x (quotient n 2))))
           (* m m)))
        (  else
            (let ((m (mystery x (quotient (- n 1) 2))))
               (* m m x)))))


(mystery 3 4)


'(3 '(4 5))

(define add +)
(add 3 4)
add
(map add (cons 5 '()))
(+ 22)

;(- 5 4 7)  channels not implemented.

;(display "cat" "dog")     wrong anyway

add
test

(define (len x) (if (atom? x) 0 3))
(define (len x) (if (pair? x) (+ 1 (len (cdr x))) 0 ))
(len '(1 2))
(len 1)
(pair? '())

(trace len pair?)

(define (test x) x)
test;

(lambda (x) (+ 2 x))

(define (fact x) (if (= x 0) 1 (* x (fact (- x 1)))))
 fact
(fact 0)
(fact 5)

(car ''33)
;quote

'fred
(list 1 2 3)
(list 'fred 44 55)
#f
`fred

`(2 3)

`(2 ,(+ 3 4))

;   ,a This (correctly) gives an error.

`(2 ,@(list (+ 3 7) 4 5))

`(2 ,(list (+ 3 7) 4 5))

(cadr '(1 2))
(trace cadr)
(trace car)

(macro swap
  (lambda (code)
    (let ((x (cadr code)) (y (caddr code))  )
        `(begin (set! temp ,y) (set! ,y ,x) (set! ,x temp) ) ) )))


(swap p q)

;(freddy p y)

;needs letrec
;(let ((len (lambda (x) (if (pair? x) (+ 1 (len (cdr x))) 0)) )) (len '(1 2)))


(letrec
((len (lambda (x) (if (pair? x) (+ 1 (len (cdr x))) 0)) ))
      (display "ok")   (len '(1 2 3 4)))

 (display "ok")
  (pair? 3)


(set! xx 23)

xx

(lambda (x) x)

display

#f

(define (test x)
  (cond ( (= x 3) 1)


   )
)

(test 22)
"Undefined from cond"
