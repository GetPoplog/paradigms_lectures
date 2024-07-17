
Setml
- 234;
  val it = 234 : int
- it;
  val it = 234 : int
- ~234;
  val it = ~234 : int
- 
- ~23.45;
  val it = 23.45 : real
- ~23.45;
  val it = ~23.45 : real
- true;
  val it = true : bool
- "fred";
  val it = "fred" : string
- [1,2,3];
  val it = [1, 2, 3] : int list
- [1,2+3,5];
  val it = [1, 5, 5] : int list
- [];
  val it = [] : 'a list
- [2,3.4];

Error: in expression
    [2, 3.4]
Not all the list members have the same type:
    2 : int
    3.4 : real

Setml
- fn x => 2*x;
  val it = fn : int -> int
- 
- real 3;
  val it = 3.0 : real
- int 3.0;

Error: unbound variable
    int

Setml
- integer;

Error: unbound variable
    integer

Setml
- intof;

Error: unbound variable
    intof

Setml
- 
- 
- sin;
  val it = fn : real -> real
- 
- 2+3*4;
  val it = 14 : int
- 
- 
- fun double (x:int) = 2*x;
  val double = fn : int -> int
- fun double (x:int) = 2*x;
  val double = fn : int -> int
- 
- fun sum list = if List.null list then 0 else List.hd list + sum(List.tl list);
  val sum = fn : int list -> int
- 
- 
- val hd = List.hd;
- val hd = List.hd;
  val hd = fn : 'a list -> 'a
- val tl = List.tl;
  val tl = fn : 'a list -> 'a list
- val null = List.null;
  val null = fn : 'a list -> bool
- 
- 
- fun sum(list) = if null(list) then 0 else hd(list) + sum(tl(list));
  val sum = fn : int list -> int
- fun sum(list) = if null(list) then 0 else hd(list) + sum(tl(list));
  val sum = fn : int list -> int
- 
- 
- 
- 
- 23 :: [];
  val it = [23] : int list
- 23::45::[];
  val it = [23, 45] : int list
- 23::4;

Error: in expression
    23 :: 4
Cannot apply function
    op :: : int * int list -> int list
to argument
    (23, 4) : int * int

Setml
- 
- fun sum [] = 0
=   | sum (x::l) = x+sum l;
  val sum = fn : int list -> int
- 
