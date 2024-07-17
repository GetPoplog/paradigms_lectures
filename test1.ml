
val rec sum = fn [] => 0 | (x::l) => x+sum l;

val hd   = List.hd; val tl = List.tl;
val null = List.null;


val rec (sum :int list -> int)
   = fn (l) => if null l then 0 else hd l + sum(tl l);


fun sum(l) = if null l then 0 else hd l + sum(tl l);


fun maplist f l = if null l then [] else f(hd l) :: maplist f (tl l);

val mapsin = maplist sin;
val maphd  = maplist hd;

fun reduce f acc base l
    = if null l then base else acc(f(hd l),reduce f acc base (tl l));

val binding = [("x",5), ("y",6)];

type 'a Binding = (string*'a)list;

fun first(x,y) = x;
fun second(x,y) = y;

exception Binding;

fun lookup var (b:'a Binding) =
   if null b then raise Binding
   else
        if first(hd b) = var then second(hd b)
        else lookup var (tl b)
   ;
