


datatype 'a Maybe = NotSo | OK of 'a;


datatype Token =
    I of int  |
    R of real |
    V of string ;


(* This is a Scheme-style definition of term *)

datatype Term = B of Token | Ap of Term * Term list;

B (I 23);
Ap( B(V("fred")),  [B(I(23)), B(R(3.4))]);

datatype 'a Parse = Parse of 'a * Token list;

type 'a Parser = Token list -> 'a Parse Maybe;

type 'a Builder2 = 'a * 'a -> 'a;
type 'a Builder1 = Token -> 'a;

val member = List.member;


(*

fun mk_parser_singleton
        (class_of_toks:Token list)
        (bld:'a Builder1)
        (list_toks:Token list)

**** Finish this definition ****

fun mk_parser_seq
        (p1: 'a Parser)
        (p2: 'a Parser)
        (bld: 'a Builder2)
        (toks  = Token list)

**** Finish this definition ****


*)
