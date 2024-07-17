


                    CMPSCI 287 --- FALL 98 --- Homework 2

             Due 23:59 hours,  29SEP98, as ~/cs287/hwk2.scm


You must document all your functions by a simple description of what
the function does and how it does it.

(1) Write a Scheme function solve for solving quadratic equations. Thus

    (solve a b c)

Will solve the quadratic equation

          2
        ax   +   bx + c = 0

returning a list of both roots. If you don't remember how to solve a quadratic
equation, the University has a library. The Encyclopaedia Brittannica has the
solution. To take the square-root in Scheme, use the function sqrt.

Write test cases for the equations:

          2
        x   +   2x + 1 = 0


          2
        4x   +   4x + 1 = 0


          2
         x   +   5x + 4 = 0

(2)

We can represent a relation as a list of pairs.  For example:

    (define parent  '((liz charley)  (phil charley) (liz anne) (charley ed)))

represents the fact that liz is the parent of charley, as is phil, and charley
is the parent of ed. Likewise:

    (define age    '((liz 70) (phil 73) (charley 48) (anne 46) (ed 23)))

represents the relationship between a person and their age.

(a) Write a function lookup for which the call

    (lookup x r)

will find the first pair in relation r whose car is x and return the second
member of the pair. Thus:

    (lookup 'liz parent)

will return 'charley

(b) Write a function lookup_all  for which the call

    (lookup_all x r)

will make a list of the second member of all pairs in relation r whose car is
x .

    (lookup_all 'liz parent)

will return

    (charley anne)
