:- library(useful).

queen(R,(R,C)) :- member(C,[1,2,3,4,5,6,7,8]).

queens([Q1,Q2,Q3,Q4,Q5,Q6,Q7,Q8]) :-
    queen(1,Q1),
    queen(2,Q2), no_attack(Q1,Q2).


no_attack((R1,C1),(R2,C2)) :-
    R1\=R2, C1\=C2, DR is R1-R2, DC is C1-C2, DR\=DC, MDR is -DR, MDR\= DC.


no_attack_list(Q, []) :- !.
no_attack_list(Q1, [Q2 | QS]) :- no_attack(Q1,Q2), no_attack_list(Q1,QS).

?-current_op(N,A,+).

?-op(20, xfy,of ).

N of M :- X is N*M, print(X).

?- queens(QS).

/*


    -------------------------
|  1|    Q1                 |
    |-----------------------|
   2|       Q2              |
    |-----------------------|
   3|                       |
    |-----------------------|
   4|                       |
    |-----------------------|
   5|                       |
    |-----------------------|
   6|                       |
    |-----------------------|
   7|                       |
    |-----------------------|
   8|                       |
    |-----------------------|




*/


?-queens(L).
