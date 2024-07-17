



                                 Homework 6
                             CMPSCI 287 SPRING 1998
                      Due Tuesday 7 APR at 11:59 PM.

         Put  your answers in your cs287 directory as hwk8.scm



(1) Power products form  what algebraists would  call a commutative
semigroup with identity. In general a set S with operation * and a
distinguished element 1 is a semigroup with identity if and only if, for
all x,y,z in S:

                1*x = x
                x*(y*z) = (x*y) * z
                x*y = y*x

Write a  Scheme  function  laws_power_product which  checks  for  given  x,y,z
whether the laws for a commutative semigroup are satisfied by power  products,
with the * operation being *_pp.




(2)
Using the following functions which generate random power-products on the
variables w, x, y, z, and your laws_power_product  function, write a test
program for checking out that your implementation of *_pp actually satisfies
the laws by running through 100 random power products.

(define (random_pp)
    (cons '* (help_random_pp '(u v w x y z)))
    )

(define (help_random_pp vars)
    (cond
        ((null? vars) '())
        ((= (random 2) 0) (help_random_pp (cdr vars)))
        (else (cons
                (list '^ (car vars) (+ 1 (random 5)))
                (help_random_pp (cdr vars))
                )
            )
        )
    )

(3)
In algorithmic algebra, a  monomial is an expression of  the form (* k  p)
where k is a number called the coefficient, and p is a power-product.

(a) Write Scheme  functions cons_mono, coef_mono,  pp_mono which  respectively
build a  monomial  out  of a  coefficient  and  a power  product,  select  the
coefficient  component  of  a  monomial  and  select  the  power-product  of a
monomial.

(b) Write a Scheme function *_mono which multiplies two monomials.

(example
    '(*_mono
        '(* 2 (* (^ x 2)))
        '(* 3 (* (^ x 3) (^ z 6)))
        )
    '(* 6 (* (^ x 5) (^ z 6)))
    )

(c)  The  lexicographical  comparison  of  monomials  is  determined  by   the
comparison of their power products only. Define a Scheme function compare_mono
which compares two monomials.



(d) Monomials also form a commutative semigroup. Adapt your laws_power_product
function to a laws_monomial function which expresses the fact that monomials
are a commutative semigroup, write a function for creating random  monomials,
and check out you *_mono function with 100 trials.
