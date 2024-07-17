

signature Set = sig
  eqtype elt;
  type set
  val adjoin : elt -> set -> set
  val empty : set
  val equal : set -> set -> bool
  val included_in : set -> set -> bool
  val intersect : set -> set -> set
  val list_to : elt list -> set
  val member : elt -> set -> bool
  val set_to_list : set -> elt list
end

signature Equality = sig
    eqtype eq;
end;

functor Set_uol(e:Equality):Set = struct
   type elt = e.eq;
   type set = elt list;
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


structure Int:Equality = struct
    type eq = int;
end;


structure Set_int = Set_uol(Int);


Set_int.empty;

val s1 = Set_int.list_to [1,1,2,3];
val s2 = Set_int.list_to [4,3,1];
val s3 = Set_int.intersect s1 s2;

signature Ordered = sig
    eqtype elt
    val  < : (elt * elt) -> bool;
end;


structure OInt:Ordered = struct
    type elt = int;
    val op < = op < :int*int->bool;
end;


functor OrderedListSet(o : Ordered) : Set =
struct
    type elt = o.elt;
    type set = o.elt list;
    val op < = o.<;
    fun adjoin x [] = [x]
      | adjoin x (y::l) =
            if x=y then (y::l)
            else
              if x<y then x::y::l else y:: (adjoin x l);
end
