
3+4;

val n = 4;

val sq = fn (x:int) => x*x;

sq 4;

sq 3.4;

val dbl = fn x => 2.0*x;

[2,3,4];

fun sq (x:int) = x*x;

fun sum [] = 0
  | sum(x::l) = x+sum l;

sum [1,2,3];

val hd = List.hd;
val tl = List.tl;

fun sum l = if l=[] then 0 else  l + sum(tl l);
[];

2=3;
