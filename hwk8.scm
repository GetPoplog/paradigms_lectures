
                      CMPSCI 287 FALL 1997 Homework 8
                      Due Thursday 13 NOV at 11:59 PM.
         Put  your answers in your cs287 directory as hwk8.lscm

-----------------------------------------------------------------------------

(3) A __________polynomial is an expression of the form

             m  +  m   + ..  m
              1     2         k

Where m_1....m_k are monomials with distinct power products arranged in
lexicographical order. For example:

    '(+
        (* 7 (* (^ x 2) (^ z 1)))
        (* 5 (* (^ x 2)))
     )

is a Scheme representation of a polynomial.
----------------------------------------------------------------------------
(a) Write a function +_poly, which adds two polynomials using merge_general.
[Hint this is much the same as *_pp].

(define p1
    '(+
       (* 5 (* (^ x 3)))
       (* 7 (* (^ x 2) (^ z 1)))
       ))

(define p2
    '(+
       (* 7 (* (^ x 2) (^ z 1)))
       (* 6 (* (^ x 1)))
       ))

(example
    '(+_poly p1 p2)
    '(+ (* 5 (* (^ x 3))) (* 14 (* (^ x 2) (^ z 1))) (* 6 (* (^ x 1))))

)

(define p3
    '(+
       (* 2 (* (^ x 2)))
       (* 7 (* (^ x 1) (^ z 1)))
       ))

(example
    '(+_poly p3 p1)
    '(+
        (* 5 (* (^ x 3)))
        (* 7 (* (^ x 2) (^ z 1)))
        (* 2 (* (^ x 2)))
        (* 7 (* (^ x 1) (^ z 1)))
        ))

(example
    '(equal? (+_poly p3 p1) (+_poly p1 p3))
    #t)

(b) Write a function *_mono_poly, using map, which multiplies a monomial  by a
polynomial. (Note - the lexicographical ordering is guaranteed to be preserved
by  a  straightforward  implementation  of   this  function.  See  B   Mishra,
___________Algorithmic _______Algebra pub. Springer-Verlag)

(define m1  '(* 14 (* (^ x 2) (^ z 1)))  )

(example
    '(*_mono_poly m1 p2)
    '(+ (* 98 (* (^ x 4) (^ z 2))) (* 84 (* (^ x 3) (^ z 1))))
)
-----------------------------------------------------------------------------
(c) Write a function *_poly,  which multiplies two polynomials.

(example
    '(*_poly p1 p2)
    '(+
       (* 35 (* (^ x 5) (^ z 1)))
       (* 49 (* (^ x 4) (^ z 2)))
       (* 30 (* (^ x 4)))
       (* 42 (* (^ x 3) (^ z 1)))
       )
    )
-----------------------------------------------------------------------------
(d) Write a function  polynomial which converts an arbitrary expression
involving just symbols, numbers and the functions + and  * into a polynomial.
[Hint: work out how to express a number n and a symbol v as polynomials, and
then just use your polynomial addition and multiplication functions to
generate the final result. ]

(example
    '(polynomial
        '(* (+ x 1) (+ x 1)) )

    '(+
       (* 1 (* (^ x 2)))
       (* 2 (* (^ x 1)))
       (* 1 (*))
       )
    )

(example
    '(polynomial
        '(* (+ x y) (+ x (* 2 y))) )
    '(+
       (* 1 (* (^ x 2)))
       (* 3 (* (^ x 1) (^ y 1)))
       (* 2 (* (^ y 2)))
       )
    )
