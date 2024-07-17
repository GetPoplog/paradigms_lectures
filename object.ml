
type 'a cd =  (string *('a->unit)) list;




datatype 'a object = Ob of 'a cd * 'a;


fun call (s:string) (Ob(cd,bod)) = (lookup s cd) bod;

fun myprint (a:string,b:int,c:string) = (print a; print b; print c; ());

val person_class = [("print", myprint)];


val fred = Ob(person_class, ("fred",23,"male"));

call "print" fred;
