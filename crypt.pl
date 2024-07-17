
/*
The problem is to find a mapping from the letters {S,E,N,D,M,O,R,Y} to
the digits {0...9} which transforms the following into a correct
addition

    S E N D
    M O R E
-----------
  M O N E Y

*/

member(X, [X | L]).
member(X, [Y | L]) :- member(X,L).


digit(D) :- member(D,[0,1,2,3,4,5,6,7,8,9]).


crypt(S,E,N,D,M,O,R,Y) :-
    digit(D),
    digit(E),
    D\=E,
    digit(Y), Y\=D, Y\= E,
    carry(C1),
    Y is D+E-C1,
    digit(N), not(member(N,[Y,D,E])),
    digit(R),



?- crypt(S,E,N,D,M,O,R,Y).
