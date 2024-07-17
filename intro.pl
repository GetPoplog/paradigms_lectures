parent(louis,phil).
parent(phil,anne).
parent(phil,charley).
parent(charley,will).

/*
?-parent(X,Y).
*/

:-listing(parent).

grandparent(X,Y) :- parent(X,S), parent(S,Y).

/*
:-spy parent.

?-grandparent(X,Y).
?-grandparent(X,anne).
?-grandparent(louis,anne).
*/

:-grandparent(X,Y).
:-grandparent(anne,anne).

member(X, [X | L]).
member(X, [Y | L]) :- member(X,L).

?- member(X, [1,2,3]).
?- member(X, [1,2,3]), member(Y, [1,2,3,4]),
    5 is X + Y.
