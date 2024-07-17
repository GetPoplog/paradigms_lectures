

(define (factorial n)
   (if (= n 0)
       1
       (* n (factorial (- n 1)))))



(define (fact_iter n product)
    (if (= n 0)
        product
        (fact_iter (- n 1) (* n product) )
        )
    )

(define (fact_1 n) (fact_iter n 1))






Both are recursive functions.  factorial
__is _a ______linear _________recursive ________process, that  is,
there  are  deferred  computations  that
grow linearly in n

fact_1 is  an _________iterative  _______process.  There
are no  deferred computations.  It  is a
linear iterative process.


A function, written  recursively, is  an
_________iterative _______process if each recursive call
occurs   at   the    top   level    of a
conditional.

This arises from the fact that there  is
no  need  to  defer  a  computation,  or
alternatively, the working-space to hold
the values of variables can be reused.





    (factorial 4)
  ==> (* 4 (factorial 3))
  ==> (* 4 (* 3 (factorial 2)))
  ==> (* 4 (* 3 (* 2  (factorial 1))))
  ==> (* 4 (* 3 (* 2  1)))
  ==> 24





    (fact_1 4))
    ==> (fact_iter 4 1)
    ==> (fact_iter 3 4)
    ==> (fact_iter 2 12)
    ==> (fact_iter 1 24)
    ==> (fact_iter 0 24)
    ==> 24






Theorem

For all integers  n>=0, (factorial  n) =
(fact_iter n 1)

    Proof: by induction on n


    Base case: n=0


(fact_iter  0  m)  =  m

=   (* (factorial 0) m)



Inductive Step:

Suppose for some k, all m


(fact_iter k m) = (*  (factorial k) m)

      Consider:

(fact_iter (+ k 1) m)

    = (fact_iter  k (* (+ k  1) m))

by definition of fact_iter

    = (* (factorial k) (* (+ k 1) m))



by inductive hypothesis

    = (* (* (factorial k) (+ k 1)) m)

by associativity

    = (*  (factorial  (+  k  1))  m)

by definition of factorial and
commutativity of *

So the result  holds for (+ k 1)


Hence by induction, the result holds
for all m.

Hence the Lemma holds.




Proof of Theorem:


    (fact_1 n) = (fact_iter n 1)

by definition of fact_1

    = (* (factorial n) 1)

by Lemma

    = (factorial n)

by rules of algebra.


Proof  of   the  inductive   step   in a
notation  closer   to  the   traditional
mathematical notation

Suppose for some k, all m

    fact_iter(k,m) = k!*m



Consider:

fact_iter(k+1,m)

    = fact_iter(k, (k+1)*m)

by definition of fact_iter

    = k! * ((k+1) * m)

by inductive hypothesis

    = (k! * (k+1)) * m

by associativity of multiplication

    = (k+1)! * m

by definition of factorial,
commutativity of multiplication.




The first  two Fibonacci  numbers  are 0
and 1.

Each Fibonacci number (after the second)
is  the   sum  of   the  two   preceding
Fibonacci numbers.

(define (fib n)
    (if (< n 2)
        n
        (+ (fib (- n 1)) (fib (- n 2)))
        )
    )


    (fib 5)
 (+ (fib 4) (fib 3))
 (+ (+ (fib 3) (fib 2))
        (+ (fib 2) (fib 1)))
 (+ (+ (+ (fib 2) (fib 1))
        (+ (fib 1) (fib 0)))
         (+ (+ (fib 1) (fib 0)) 1))

 (+ (+ (+ (+ (fib 1) (fib 0)) 1) (+ 1 0))
                           (+ (+ 1 0) 1))

 (+ (+ (+ (+ 1 0) 1) (+ 1 0))
                           (+ (+ 1 0) 1))

 5



(define (fib_it n acc1 acc2)
    (if (= n 1) acc2
        (fib_it (- n 1) acc2 (+ acc1 acc2))
        )
    )



(define (fib_2 n)
    (if (= n 0) 0
        (fib_it n 0 1)
        )
    )






  (fib_2 5)
==> (fib_it 5 0 1)
==> (fib_it 4 1 1)
==> (fib_it 3 1 2)
==> (fib_it 2 2 3)
==> (fib_it 1 3 5)
==> 5



We could also improve the performance of
fib by ___________memoisation

    (define fib (memoise fib))






(define curried_+
    (lambda (m)
        (lambda (n) (+ m n))))




(define add_2 (curried_+ 2))
(define add_3 (curried_+ 3))



(add_2 56)  ==> 58
(add_3 4)   ==> 7

 


  (apply f x1 x2....xn l)

is equivalent to


  (f x1 x2.....xn l1 l2 .. lm))
