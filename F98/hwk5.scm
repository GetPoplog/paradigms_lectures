


                                 Homework 5.
                             CMPSCI 287 FALL 1998
                      Due  12 November 98 at 23:59 hours.

         Put  your answers in your cs287 directory as hwk5.scm

-----------------------------------------------------------------------------

The   text    of    merge_general    is    to    be    found    on-line,    in
$popscheme/merge_general.scm.

(1) In algorithmic algebra, a _____power _______product is an expression of the form

         i_1  i_2        i_m
        x    x  ...... x
         1    2         m

Where i_1....i_m are integer exponents greater than zero, and x_1...x_m are
variables. In Scheme, having executed

    (define ^ expt)

to  make the symbol '^ act as the exponent function.

we can represent a power-product as:

       (* (^ x_1 i_1) (^ x_2 i_2) ... (^x_m i_m))

Note that the identity power product, denoting 1, can be represented as '(*)

We shall refer to an individual component of a power product as a ______power. Thus
in Scheme notation, (^ x n) is a power.

The powers which constitute a power product are kept in _______________lexicographical _____order
of their variables, that is to say, the order they would have in the
dictionary.

(a) Define cons_power, var_power and expt_power  to create a power and  access
its variable and exponent. Do ___not use record-class to do this. [Remark -  this
highlights a  dilemma  for data-structure  design  -  do we  want  to  support
alternative _____views  of a  data-structure. In  the case  of algorithmic  algebra
systems it is quite useful to regard a form such as a power-product as  either
a data-type in its own right or as a kind of expression].


(example '(cons_power 'y 2) '(^ y 2))
(example '(var_power  '(^ z 3))  'z)
(example '(expt_power '(^ p 4))  4)

(b) Define a Scheme function *_pp, using merge_general, that will multiply two
power products, preserving the lexicographical order. You may use the
(non-standard) built-in function symbol<? and symbol>? as a basic ordering
relation on symbols.

(example '(*_pp '(* (^ x 2)) '(* (^ x 3) (^ z 6))) '(* (^ x 5) (^ z 6)))

(example '(*_pp '(* (^ a 2) (^ z 4)) '(* (^ x 3) (^ z 6)))
         '(* (^ a 2) (^ x 3) (^ z 10)))

If (symbol<? s1 s2) we say that s1 precedes s2.

(c) Define a Scheme  function compare_pp (not  using merge_general) that  will
act as  a compare  function in  the lexicographical  comparison of  two  power
products. For  this  lexicographical  comparison,  of pp1  with  pp2,  if  the
variable v1 of the first power pp1 precedes the variable v2 of the first power
of pp2 then the result is '<. Conversely, if v2 precedes v1 then the result is
'>.

If the variables of the two powers are the same and the exponent of the  first
power of pp1 is greater than the exponent  of the first power of pp2 then  the
result is  '<, and  likewise if  the exponent  of the  first power  of pp2  is
greater than that of the second power of pp1 then the result is '>.

If both variables and exponents of the first powers are equal, then the result
is obtained by comparing the remaining powers.



(example '(compare_pp '(* (^ x 2)) '(*)) '<)
(example '(compare_pp '(* (^ x 2)) '(* (^ x 2)))  '=)
(example '(compare_pp '(* (^ x 2)) '(* (^ x 2) (^ z 1)))  '>)
(example '(compare_pp '(* (^ x 2)) '(* (^ x 3) (^ z 6))) '>)
(example '(compare_pp '(* (^ x 3) (^ z 6))  '(* (^ x 2))   ) '<)
(example '(compare_pp '(* (^ a 2) (^ z 4)) '(* (^ x 3) (^ z 6))) '<)
