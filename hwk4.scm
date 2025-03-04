

              CS287 HOMEWORK 4   Fall97   Due 9OCT97 at 11:59

In submitting  this  work  you  should make  use  of  the  definition  of a
parse-record given in the notes.

    (define class_parse (record-class 'parse '(full full)))

    (define cons_parse   (car class_parse))
    (define sel_parse    (caddr class_parse))
    (define tree_parse   (car sel_parse))
    (define rest_parse   (cadr sel_parse))

The context for  this assignment and  subsequent ones will  be an  extended
project in which  we create a  system with some  capability for  performing
algebra symbolically.

(1) Write a parser parse_variable which  recognises a Scheme symbol at  the
beginning of a list of tokens.  [This takes 6-8 lines of Scheme,  depending
on how you lay it out]

FOR EXAMPLE

    (example
        '(parse_variable '(x + y))
        (cons_parse 'x '(+ y)))


    (example
        '(parse_variable '(1 2 3))
        #f)


(2) Write a parser parse_number which recognises a number at the  beginning
of a list of tokens. [This takes 6-8 lines of Scheme, depending on how  you
lay it out]

FOR EXAMPLE

    (example
        '(parse_number '(2 3 4))
        (cons_parse '2 '(3 4)))


    (example
        '(parse_number '(x + y))
        #f)


(3) Write a function mk_parser_or for which making the definition:

(define p3    (mk_parser_or p1 p2))

takes two parsers p1, p2 and creates a parser p3 which parses sentences
according to the grammar

    p3 -> p1
    p3 -> p2


That is p3 recognises those sentences which are recognised ______either
by parser p1 __or by parser p2.  [This takes 6-10 lines of Scheme depending
on layout]

FOR EXAMPLE

(define parse_primitive (mk_parser_or parse_number parse_variable))


    (example
        '(parse_primitive '(2 3 4))
        (cons_parse '2 '(3 4)))


    (example
        '(parse_primitive '(x + y))
        (cons_parse 'x '(+ y)))



    (example
        '(parse_primitive '(#f + y))
        #f)


(4) Write a parser parser_lambda which recognises the empty sequence,
returning #t as the parse-tree. [2-3 lines of Scheme code]

(define (parser_lambda ltoks)
   (cons_parse #t ltoks))

    (example '(parser_lambda '(the fat cat))
        (cons_parse #t '(the fat cat)))
