
sorted([]).

sorted([A]).

sorted([A,B|L]) :- A < B, sorted([B|L]).

?- sorted(L).


?- sorted([3,5,9]).
?- sorted([3,9,5]).

member(X,[X|L]).

member(X,[Y|L]) :- member(X,L).


sorted(L1,L2) :- eq_set(L1,L2),sorted(L2).

?-sorted([1,3,2],[1,2,3]).

/*
eq_set(L1,L2) :- subset(L1,L2), subset(L2,L1),length(L1,N),length(L2,N).


eq_set(L1,L2) :- subset(L2,L1), subset(L1,L2),length(L1,N),length(L2,N).

subset([],L).

subset([X|L1],L2) :- not(member(X,L1)), member(X,L2), subset(L1,L2).
*/


/*
?-subset([1,2,3],L).
?-subset(L,[1,2,3]).
?-eq_set([1,2,3],L).
?-eq_set([1,2,3],[3,2,1]).

?-sorted([3,2,1],L).
*/

/*Built in
length([],0).
length([X|L],A) :- length(L,B), A is 1+B.
*/

eq_set([],[]).
eq_set([X|L1],L2) :- member(X,L2), delete(X,L2,L3), eq_set(L1,L3).

delete(X,[],[]).
delete(X,[X|L1],L2) :- delete(X,L1,L2).
delete(X,[Y|L1],[Y|L2]) :- X\=Y, delete(X,L1,L2).

?-delete(3,[2,3,5,9,3,4],Y).


?-length([1,2],N).
