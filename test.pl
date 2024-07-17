
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





member(X,[X|L]).

member(X,[Y|L]) :- member(X,L).
