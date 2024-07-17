signature Set = sig
  type elt;
  type  set
  val adjoin : ''a ->  set ->  set
  val empty :  set
  val equal :  set ->  set -> bool
  val included_in :  set ->  set -> bool
  val intersect :  set ->  set ->  set
  val list_to : ''a list ->  set
  val member : ''a ->  set -> bool
  val set_to_list :  set -> ''a list
end

structure Set_uol:Set = struct
   type ''a set = ''a list;
   fun adjoin x s = if List.member x s then s else x::s;
   val empty = [];
   fun included_in s1 s2 = List.all (fn x => List.member x s2) s1;
   fun equal s1 s2 = included_in s1 s2 andalso included_in s2 s1
   fun intersect s1 s2 = List.filter (fn x => List.member x s2) s1;
   val member = List.member;
   fun list_to [] = []
     | list_to (x::l) = adjoin x (list_to l);
   fun set_to_list s = s;
end;

signature Ordered = sig
    eqtype ord
    val  < : (ord * ord) -> bool;
end;


structure OInt:Ordered = struct
    type ord = int;
    val op < = op < :int*int->bool;
end;


functor OrderedListSet(o : Ordered) : Set =
struct
    type ''a set = o.ord list;
    val op < = o.<;
    fun adjoin x [] = [x]
      | adjoin x (y::l) =
            if x=y then (y::l)
            else
              if x<y then x::y::l else y:: (adjoin x l);
end
