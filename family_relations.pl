
parent(liz,charley).
parent(liz,anne).
parent(phil,charley).
parent(phil,anne).
parent(charley,will).
parent(charley,ed).
parent(di,will).
parent(di,ed).

male(charley).
male(phil).
male(ed).
male(will).


?-parent(P,ed).

grandparent(X,Y) :- parent(X,Z), parent(Z,Y).


?- grandparent(P,Q).

brother(X,Y) :- parent(F,X),parent(M,X),male(X),parent(F,Y),parent(M,Y),
                X\=Y, male(F), not(male(M)).

?- brother(B,P).

ancestor(X,Y) :- parent(X,Y).
ancestor(X,Y) :- parent(X,Z),ancestor(Z,Y).
ancestor(eve,P).
ancestor(adam,P).


?-ancestor(P,Q).
?-ancestor(X,charley).


?-print([1,2,3,4]).

member(X,[X|L]).

member(X,[Y|L]) :- member(X,L).

?- X is 2+3.

?- L = [1,2,3,4,5,6,7,8,9], member(X,L), member(Y,L), 5 is X+Y.

/*

Try:
   SEND
   MORE
-------
  MONEY

D+E = Y+10*C1

solution(S,E,N,D,M,O,R,Y) :-
    Digits=[0,1,2,3,4,5,6,7,8,9],
    member(D,Digits),
    member(E,Digits),
    member(Y,Digits),
    member(C1,[0,1]),
     0 is D+E - (Y+10*C1)

member

*/
