

(1) Write a function to convert a let-expression to the equivalent form in
which a lambda-expression is applied to arguments.


(convert_let '(let ((x 2) (y (+ a 1))) (+ x y))


===>   ((lambda (x y) (+ x y))  2 (+ a 1))


(2) Write a grammar for English numerals.

Write a parser to parse English numerals, returning the numeric value as
the tree_parse part of the parse record.

(parse_number

    '(one hundred and twenty thousand nine hundred and forty three))

===> <parse 120943 '()>
