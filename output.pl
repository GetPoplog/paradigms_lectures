?- mortal(socrates).
yes

?- mother(liz,charlie).
yes

?- mother(liz,P).
P = charlie ? ;
no

?- 

Setprolog
?- 
?- member(3,[2,5,4]).
yes

?- member(3,[2,5,4]).
no

?- member(X,[2,3,4]).
X = 2 ? ;
X = 3 ? ;
X = 4 ? ;
no

?- member(4,[3,X,Y]).
X = 4
Y = _1 ? ;

X = _2
Y = 4 ? ;

no

?- member(X,[1,2,3]), member(Y,[1,2,3]), 5 is X+Y.
X = 2
Y = 3 ? ;

X = 3
Y = 2 ? ;

no

?- 

Setprolog
?- X is 3 div 4.
X = 0 ? 
yes

?- X is 12 mod 10.
X = 2 ? 
yes

?- 
?- L = [1, _1, _2, _3, _4, _5, _6, _7]
? ;
L = [2, _1, _2, _3, _4, _5, _6, _7] ? ;
L = [3, _1, _2, _3, _4, _5, _6, _7] ? 
;;; [execution aborted]
L = [1, 2, _1, _2, _3, _4, _5, _6] ? ;
L = [1, 3, _1, _2, _3, _4, _5, _6] ? ;
L = [1, 4, _1, _2, _3, _4, _5, _6] ? ;
L = [1, 5, _1, _2, _3, _4, _5, _6] ? ;
L = [1, 6, _1, _2, _3, _4, _5, _6] ? ;
L = [1, 7, _1, _2, _3, _4, _5, _6] ? ;
L = [1, 8, _1, _2, _3, _4, _5, _6] ? ;
L = [2, 1, _1, _2, _3, _4, _5, _6] ? ;
L = [2, 3, _1, _2, _3, _4, _5, _6] ? ;
L = [2, 4, _1, _2, _3, _4, _5, _6] ? ;
L = [2, 5, _1, _2, _3, _4, _5, _6] ? a
L = [2, 6, _1, _2, _3, _4, _5, _6] ? 
yes

?- 
?- 
?- 
?- 
?- 
?- 
?- 
?- 
?- 
?- 
?- 
?- functor(a+b,F,A).
F = +
A = 2 ? 

yes

?- functor([2,3],F,A).
F = .
A = 2 ? .

no

?- arg(
?- functor([2,3],F,A).
F = .
A = 2 ? 

yes

?- 
?- arg(1,[2,3],A).
A = 2 ? ;
no

?- arg(2,[2,3,4],A).
A = [3, 4] ? 
yes

?- functor((3,4,5),F,N).
F = ,
N = 2 ? 

yes

?- functor((3,4,5),F,N).
F = ,
N = 2 ? 

yes

?- QS = [1, 2, _1, _2, _3, _4, _5, _6]
? 
yes

QS = [(1, 1), (2, 3), _1, _2, _3, _4, _5, _6] ? ;
QS = [(1, 1), (2, 4), _1, _2, _3, _4, _5, _6] ? ;
QS = [(1, 1), (2, 5), _1, _2, _3, _4, _5, _6] ? ;
QS = [(1, 1), (2, 6), _1, _2, _3, _4, _5, _6] ? 
;;; [execution aborted]

;;; PROLOG SYNTAX ERROR - OPERATOR, ',', OR ')'
     EXPECTED
;;; FOUND  : xfy
;;; READING: :- op ( of <<HERE>> xfy
;;; FILE   : /courses/cs200/cs287/cs287/public_html/
    eight_qeeens.pl     LINE NUMBER: 18

;;; [execution aborted]

;;; PROLOG ERROR - ILLEGAL OPERATOR PRECEDENCE
;;; INVOLVING:  of
;;; FILE     :  /courses/cs200/cs287/cs287/public_ht
    ml/eight_qeeens.pl   LINE NUMBER:  18
;;; DOING    :  op/3

;;; [execution aborted]
N = 21
A = fx ? ;

N = 31
A = yfx ? ;

no

yes

?- 
?- 4 of 5.
no

?- 4 of 5.
20yes

?- X is fact 10.

;;; PROLOG SYNTAX ERROR - EXPECTED '.' AT END OF
     CLAUSE
;;; FOUND  : 10
;;; READING: X is fact <<HERE>> 10

?- Y is fact(10).
?- Y is fact(10).
DECLARING VAR fact
Current file: charin

;;; PROLOG ERROR - enp: EXECUTING NON-PROCEDURE
;;; INVOLVING:  <undef fact>
;;; DOING    :  (Sys$-Exec_nonpd) is/2

;;; [execution aborted]

Setprolog
?- Y is fact(10).
Y = 3628800 ? 
yes

?- 
?- 
