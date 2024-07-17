To: barrington@cs.umass.edu

(* An example of parametric sorting in SML *)

(* First we define some function types Type variables are prefixed by a
single quote *)

type 'a order  =  'a * 'a -> bool;
type 'a equiv  =  'a * 'a -> bool;
type 'a sorter =  'a list -> 'a list;

(* Next let's do some list hacking.  cons is written as infix "::" in
SML and POP-11 *)

fun select i j []             = []
  | select 1 1 (x::list)      = [x]
  | select 1 n (x::list)      = x :: (select 1 (n-1) list)
  | select i j (x::list)      = select (i-1) (j-1) list;

(* So let's make sure this works *)

select 2 3 [1,2,3,4,5] = [2,3];

(* Now we'll raid the List structure for the length function *)

val length = List.length;

(* and define functions to split a list in two *)

fun first_half  list =
    select
        1
        ((length list) div 2)
        list;

fun second_half list = select (1+(length list) div 2) (1 + length list) list;

(* Let's check these - remember that "@" is an infixed concatenate operator*)

first_half [1,2,3,4,5] @ second_half [1,2,3,4,5] = [1,2,3,4,5];
first_half [1,2,3,4,5,6] @ second_half [1,2,3,4,5,6] = [1,2,3,4,5,6];

(* now we can define a merge function for lists *)

fun merge ord eqv [] list = list
  | merge ord eqv list [] = list
  | merge ord eqv (x1::list1) (x2::list2) =
     if ord(x1,x2) then
        x1 :: (merge ord eqv list1 (x2::list2))
     else
        if eqv(x1,x2) then x1:: (merge ord eqv list1 list2)
        else x2 :: (merge ord eqv (x1::list1) list2)
;

(* ML ascribes to merge the type

 ('a * 'a -> bool) -> ('a * 'a -> bool)
        -> 'a list -> 'a list -> 'a list

*)

(* now we can define merge_sort *)

fun merge_sort ord eqv [] = []
  | merge_sort ord eqv [x] = [x]
  | merge_sort ord eqv list =
    merge
        ord
        eqv
        (merge_sort ord eqv (first_half list))
        (merge_sort ord eqv (second_half list))
;


(* merge_sort gets the type

    ('a * 'a -> bool) -> ('a * 'a -> bool)
    -> 'a list -> 'a list
*)

(* And we can check this by putting in the type-constraint *)

merge_sort : 'a order -> 'a equiv -> 'a sorter;

(* Now we "partially apply" merge_sort to get a sort function
for integers - the type constraints are necessary because "<" is
overloaded in ML, as is equality.*)

val sort_ints = merge_sort (op < : int*int->bool) (op = :int*int->bool);

(* We can check the type *)

sort_ints : int sorter;

sort_ints [3,4,1,2] = [1,2,3,4];

(* and a sort function for reals *)

val sort_real = merge_sort (op < : real*real->bool) (op = :real*real->bool);

sort_real : real sorter;

(* Now let's introduce a type of numbers, either integers or reals *)

datatype number = I of int | R of real;

fun eq_num ((I i), (I j)) = i=j
  | eq_num ((R x), (R y)) = x=y
  | eq_num (n1,     n2)   = false


fun less_num ((I i), (I j)) = i=j
  | less_num ((R x), (R y)) = x=y
  | less_num ((I i), (R x)) = (real i) < x
  | less_num ((R x), (I i)) = x < (real i);

val sort_num = merge_sort less_num eq_num;

sort_num : number sorter;

sort_num( [I(1), R(0.5)])  =  [R(0.5), I(1)];
