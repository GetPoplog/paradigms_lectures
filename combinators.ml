
fun S f g x = (f x) (g x);
fun K c x = c;
val I  = S K K;
fun Y e x = (e (Y e)) x;   (* we need the x to stop infinite recursion *)
val fact  = (Y (fn f => fn n => if n=0 then 1 else n*(f(n-1))));

I 34;
