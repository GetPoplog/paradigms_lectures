- val cc = op ::;
  val cc = fn : 'a * 'a list -> 'a list
- (op ::);
  val it = fn : 'a * 'a list -> 'a list
- 
In file test1.ml, line 7:
Error: unbound variable
    null
  val null = fn : 'a list -> bool

In file test1.ml, line 8:
Error: unbound structure name
    l

In file test1.ml, line 8:
Error: missing argument to type constructor
    list

In file test1.ml, line 8:
Error: in expression
    if null l
    then 0
    else hd l + sum (<exp>)
The two alternatives have different types:
    0 : int
    hd l + sum (<exp>) : 'a
(unification would bind an explicit type variable)
  val sum = fn : int list -> int

In file test1.ml, line 8:
Error: unbound constructor
    sum
  val sum = fn : int list -> int

In file test1.ml, line 9:
Error: in expression
    hd l + sum (tl l)
Cannot apply function
    op + : 'a * 'a -> 'a
to argument
    (hd l, sum (<exp>)) : 'a * int
(unification would bind an explicit type variable)
  val sum = fn : int list -> int

In file test1.ml, line 15:
Error: cannot determine a type for overloaded identifier
    val + : 'A list * 'A list -> 'A list
  val maplist = fn : ('a -> 'b) * 'a list -> 'b list
  val maplist = fn : ('a -> 'b) -> 'a list -> 'b list
  val it = fn : real list -> real list
  val mapsin = fn : real list -> real list
- mapsin [0.0, 3.14159];
  val it = [0.0, 0.000003] : real list
-   val maphd = fn : 'a list list -> 'a list
- mapsin [0.0, 3.14159];
  val it = [0.0, 0.000003] : real list
- 
- 
- maphd [[0,2],[3,4]];
  val it = [0, 3] : int list
-   val reduce = fn : ('a -> 'b) -> ('b * 'c -> 'c) -> 'c -> 'a list ->
     'c
- 
- val sum = reduce (fn x => x) (op +) 0;
- 
- val sum = reduce (fn x => x) (op +) 0;
  val sum = fn : int list -> int
- sum [2,3,4];
  val it = 9 : int
- 
- 
-  fun fred(x,y) = x+y+2;
  val fred = fn : int * int -> int
- (2,3);
  val it = (2, 3) : int * int
- val p = (3,4);
  val p = (3, 4) : int * int
- 
- 
- fred p;
  val it = 9 : int
- val (add:int*int->int) = op +;

Error: cannot determine a type for overloaded identifier
    val + : 'A * 'A -> 'A

Setml
- val (add:int*int->int) = op +;
  val add = fn : int * int -> int
- add p;
  val it = 7 : int
- (4,5.6);
  val it = (4, 5.6) : int * real
- 
- 
-  val binding = [("x", 5), ("y", 6)] : (string * int) list
  exception Binding

In file test1.ml, line 25:
Error: unbound type variable
    'a
  eqtype 'a Binding = string * 'a
  val first = fn : 'a * 'b -> 'a
  val second = fn : 'a * 'b -> 'a
  val second = fn : 'a * 'b -> 'b

In file test1.ml, line 33:
Error: at or before reserved word
    ;
Expecting: "else"

In file test1.ml, line 32:
Error: missing argument to type constructor
    Binding

In file test1.ml, line 35:
Error: in expression
    first b
Cannot apply function
    first : 'A * 'B -> 'A
to argument
    b : 'C list

In file test1.ml, line 35:
Error: in expression
    second b
Cannot apply function
    second : 'A * 'B -> 'B
to argument
    b : (''C * 'D) list
  val lookup = fn : ''a -> (''a * 'b) list -> 'b
- 
- 
- 2.3 = 2.3;
  val it = true : bool
- 
- 
- lookup;
  val it = fn : ''a -> (''a * 'b) list -> 'b
- 
In file test1.ml, line 33:
Error: in expression
    null b
Cannot apply function
    null : 'A list -> bool
to argument
    b : 'a Binding
  eqtype 'a Binding = (string * 'a) list
  val lookup = fn : string -> 'a Binding -> 'a
