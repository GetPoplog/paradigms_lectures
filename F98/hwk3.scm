



                    CMPSCI 287 --- FALL 98 --- Homework 3

             Due 23:59 hours, Tuesday 6OCT98  , as ~/cs287/hwk3.scm


(1) Write a Scheme function intersect which finds the intersection of two sets
represented as lists, using the equal?  function (indirectly)
to compare the elements.  The
following example illustrates  the most likely  result, though it  is not  the
only one since (3 2) is acceptable.

(intersect '(2 3 4) '(1 3 2 5))

==> '(2 3)

(2) Write  a  Scheme  function  union  which  finds  the  union  of  two  sets
represented as lists, using the equal? function to compare the elements.
The following example illustrates the most likely result, though it is not
the only one (any permutation of (1 2 3 4 5) is acceptable).

(union '(2 3 4) '(1 3 2 5))

==> '(4 1 3 2 5)



(3) Remember how in homework 2 we represented a (binary) relation as a list of
pairs. If R1 and R2 are two relations, we define their (relational) product to
be   R3, where (x,z) is in R3 if and only if there is a y such that (x,y) is
in R1 and (y,z) is in R2.

Write a Scheme function *_rel which finds the product of two relations.
For example, if we define parent as:

(define parent
    '((liz charley)  (phil charley) (liz anne) (phil anne)
     (charley ed) (charley will) (di ed) (di will)
     )
    )

and

(define grandparent (*_rel parent parent))

then grandparent is some permutation of

    ((liz ed) (liz will) (phil ed) (phil will))
