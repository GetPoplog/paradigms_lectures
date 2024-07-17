(* CMPSCI 287 Honors Assignment Number 1. Due date  19 FEB 99 *)

(* Copy this file into your cs287 directory and edit in your answers *)



(* We begin with necessary type declarations *)

(* An association list in SML has the following type *)

type ('a,'b) alist = ('a * 'b) list;


(* We use the maybe type to indicate success or failure of a computation *)

datatype 'a maybe = NotSo | OK of 'a;

(* The lookup function should have this type *)

type (''a,'b) looker_up = ''a -> (''a,'b) alist -> 'b maybe;

(* Write your code for lookup here *)






(* it should satisfy this type-constraint *)


 lookup : (''a,'b) looker_up;

type 'a perm_as_cycles = 'a list list;

(* Write your code for alist_of_cycles here
 note that the infix operator "@" can be used to append lists

    [2,4]@[3,5] = [2,4,3,5]

*)





(* it should satisfy this type-constraint *)

alist_of_cycles : ''a perm_as_cycles -> (''a,''a) alist;




(* write your function for cycles_of_alist here *)







(* this is the answer RJP got, but yours may be different...*)

cycles_of_alist  [(1,2),(2,3),(3,1),(4,5),(5,4)] = [[2, 3, 1], [5, 4]];

(* However it must satisfy this type-constraint *)

cycles_of_alist : (''a,''a) alist -> ''a perm_as_cycles;
