

                    CMPSCI 287 --- SPRING 98 --- Homework 2

             Due 23:59 hours,  24FEB98, as ~/cs287/hwk2.scm


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


(3) Remember how in homework 2 we represented a permutation either as
a an association list of attribute-value pairs or a list of cycles.
If P is a permutation represented as an association list, then
for any given i there is unique pair (i j) in P. We have:

    P(i)=j

The product of two permutations P1 and P2 is defined as follows:
if  P = P1*P2 then  P(i) = P1(P2(i))

(a) Write a Scheme function *_map which finds the product of two
permutations each represented as an association list.

(example

    '(*_map '((1 2) (2 3) (3 1) (4 5) (5 4))
        '((1 2) (2 1) (3 3) (4 5) (5 4)))

    '((1 3) (2 2) (3 1) (4 4) (5 5)))


(b) Write a Scheme function *_perm which finds the product of two
permutations each represented as a list of cycles.
