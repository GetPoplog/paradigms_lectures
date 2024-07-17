(* 14 OCT 98 Honors Section of cs287 *)


(* Assignment: write mk_parser_singleton, mk_parser_seq
and implement an English parser corresponding to the notes *)

datatype  'a maybe = NotSo | OK of 'a;

datatype  ('tree, 'tok)  parse = Parse of 'tree * 'tok list;

type ('tree, 'tok) parser = 'tok list -> ('tree, 'tok) parse maybe;

(* type for mk_parser_singleton *)
(* Unlike the Scheme case, we need a builder for mk_parser_singleton *)

type ('tree,''tok) parser_maker_sing =
        ''tok list ->             (* the class of tokens to be recognised   *)
        (''tok -> 'tree) ->       (* a builder to convert a token to a tree *)
        ('tree,''tok) parser;     (* the resulting parser                   *)

(* type for mk_parser_seq *)

type ('tree1,'tree2,'tree,'tok) parser_maker_seq  =
    ('tree1, 'tok) parser ->           (* the first parser *)
    ('tree2, 'tok) parser ->           (* the second parser *)
    ('tree1 * 'tree2 -> 'tree) ->      (* the builder *)
    ('tree, 'tok) parser;              (* the resulting parser *)

(* WRITE YOUR CODE FOR THE TWO PARSER-MAKERS HERE *)





(* Your functions should satisfy the following type-constraints *)

mk_parser_singleton : ('tree,''tok)parser_maker_sing;

mk_parser_seq  : ('tree, 'tok) parser_maker_seq;



(* Examples of types of tree you might produce *)

(* This one suits the mathematical expression parser application *)

datatype 'tok expr = Tip of 'tok | Apply of 'tok expr  * 'tok expr list;


(* This one suits the english language parser *)

datatype determiner = Det of string;
datatype noun       = Noun of string;
datatype nounphrase = NP of determiner * noun;

(* and you'll have to add new ones for verbphrase and sentence *)

(* Examples of token-types *)

type token_english = string; (* we can input a sentence as a list of strings*)

(* ["the", "cat", "eats", "the", "canary"] *)

(* However we can't do the same in the maths case, because we will
want to treat the numbers as numbers and not as strings *)

datatype token_math =
        V of string
    |   R of real
    |   I of int;

(*  x + 2 * y  gets input as [V "x", V "+", I 2, V "*", I y] *)
(* we could then write a function which converted "x+2*y" to the above form*)




(*  Note that you can put type-constraints into your ML
    for example *)

sin : real -> real;

                                                                                        (*  You can use such type-constraints to check that functions you
    are writing do indeed have the types specified above *)

(* So, for example we can make examples of the English datatypes: *)

    val d = Det "the";

(* creates a determiner record, while *)

    val n = Noun("cat");

(* creates a noun record. Given these two, we can make a noun-phrase record:*)

    val np = NP(d,n);

(*If we had mk_parser_singleton, we could use it to make a noun-parser
thus:*)

    val nouns = ["cat","canary","parrot"];

    val parse_noun = mk_parse_singleton nouns Noun;

(*Likewise if we had mk_parser_seq, we could use it to make a noun-phrase
parser by*)

    val parse_np = mk_parser_seq parse_det parse_noun NP;
