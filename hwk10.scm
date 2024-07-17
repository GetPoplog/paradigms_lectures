
         --------------------------------------------------------
         | CS287 HOMEWORK 10   Fall97   Due THU 4DEC97 at 11:59 |
         --------------------------------------------------------

In homework 9 you made use  of the interpreter for a Scheme-like  language.
In this homework you are asked to  make use of this interpreter as a  means
of discovering  whether  a  sentence of  the  Propositional  Calculus  is a
tautology.

-----------------------------------------------------------------------------

[1] Add the propositional  connectives and or not  -> <-> to the  language.
You do not need to treat these as special forms, just as primitives. Also,
you can assume that all the connectives are ______binary [so you will not
encounter  (and  b1 b2...bn) ]

------------------------------------------------------------------------------

[2] Write  a  function  tautology? which  checks  whether  a  propositional
formula is a tautology.  The call (tautology?  V S) will  return #t if  the
sentence S containing the propositional variables V is a tautology.

(example
    '(tautology? '(p q) '(-> (and p q) (and q p)))
    #t)

(example
    '(tautology? '(p q) '(-> (-> p q) (-> q p)))
    #f)
