

human(socrates).

mortal(X) :- human(X).

parent(liz,charlie).
parent(phil,charlie).
parent(liz,anne).
parent(phil,anne).
parent(charlie,will).
parent(charlie,ed).
male(charlie).
female(liz).
male(phil).
male(ed).

mother(M,X) :- parent(M,X), female(M).
