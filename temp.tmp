

                    CMPSCI 287 --- SPRING 99 --- Homework 3

             Due 23:59 hours,  2MAR99, as ~/cs287/hwk3.scm


(1) Write a Scheme function match which takes two lists as arguments. The
first list can contain either symbols or numbers. The second list can
contain just numbers. The function should return an association list
which specifies what substitutions of values for variables would make the
two lists identical. If no such substitution exists, the function should
return #f.

(example
    '(match  '(23 x 42 y)   '(23 94 42 28))
     '((x 94) (y 28)))


(example
    '(match  '(23 x 42 y)   '(23 94 4 28))
     #f)

(example
    '(match  '(23 x 42 x)   '(23 94 42 28))
     #f)

(example
    '(match  '(23 x 42 x)   '(23 94 42 94))
     '((x 94) ))





(2) Remember how in homework 2 we represented a permutation either as
a an association list of attribute-value pairs or a list of cycles.
If P is a permutation represented as an association list, then
for any given i there is unique pair (i j) in P. We have:

    P(i)=j

The domain of a permutation is the set of values it maps.  For example the
domain of the permutation represented by the association-list

     '((1 2) (2 3) (3 1) (4 5) (5 4))

is represented by the list '(1 2 3 4 5).

If P is a permutation, then a permutation Q is said to be the inverse
of P if   Q(P(i)) = i  for all i in the domain of P.



(a) Write a Scheme function inv_map which finds the inverse of a
permutation represented as an association list.



(b) Write a Scheme function inv_perm which finds the inverse of a
permutation represented as a list of cycles.
