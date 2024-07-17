
define exam(n);
    repeat n times
        exam1();
        exam2();
        exam3();
        exam4();
        exam5();
    endrepeat
enddefine;


true -> pop_longstrings;

define perm_random_any(l);
    let i,n = length(l)
    in
        [%for i from 1 to n do
                let j = oneof(l) in
                    delete(j,l)->l;
                    j
                endlet
            endfor%]
    endlet
enddefine;



define perm_random();
    let i,l = [1 2 3 4 5 6]
    in
        [%for i from 1 to 6 do
                let j = oneof(l) in
                    delete(j,l)->l;
                    [%i,j%]
                endlet
            endfor%]
    endlet
enddefine;


;;;perm_random_any([the fat cat]) =>

lconstant q1 =
'(%p (%p \'( (%p %p) (%p %p) (%p) )))\n\n';

vars q12 =
'
(list
        (equal? %p %p)
        (+ %p 5)
        (boolean? %p)
        (* %p 9)
        (- %p %p)
        (cons  %p \'(6 7 8)) )\n
';

define exam1();

    pr('\^L');

    pr('\n\n\nCMPSCI 287 FINAL EXAM 17MAY99\n\nNAME\n\nSTUDENT ID\n');
    pr('You may separate the pages of this exam, but please ensure it
        is re-stapled at the end\n\n');

    pr('QUESTION 1\n');
    pr('Evaluate the following Scheme Expressions\n\n[a]\n    ');

    printf(q1, [% oneof([car cdr]), oneof([car cdr]),
            random(10), random(10),random(10), random(10),
            random(10)%]);


    pr('[b]\n');
    lvars a = random(10);
    printf('
        (define a %p)\n
        (let* ((a %p) (b (+ a %p)))
            (* a b))\n\n',
        [%a, a+random(3), random(10) %]);

    pr('[c]\n');

    pr( '
        (map_list  (lambda (x) (* 10 (car x)))' );
    pr('\n         \'');
    pr_scm(perm_random()); pr(")");
    nl(2);

    pr('[d]\n');

    printf('
        (append \'(%p %p (%p %p)) \'(%p %p))\n\n',
        [%random(5), random(5), oneof([cat dog elephant mouse]), random(5),
          random(5), random(5)%]);

    pr('[e]\n');

    printf('
        (assoc %p \'', [%random(6)%]);
       pr_scm(perm_random()); pr(')\n\n');

enddefine;



vars q20 =
'
\^L

QUESTION 2

Code the following grammar in Scheme. You may assume that the
higher order functions  mk_parser_seq, mk_parser_singleton, mk_parser_or
and mk_parser_kleene are available to you.

<verb> ->  tha

<noun> -> balach
<noun> -> nighean
<noun> -> ron
<noun> -> traigh
<noun> -> bo

<nounphrase> -> an <noun>
<nounphrase> -> <noun>

<adjective>  -> fion
<adjective>  -> mor
<adjective>  -> beg

<sentence>  -> <verb> <noun> <adjective>
\^L Space for the answer to question 2

';

define exam2();
    pr(q20);
enddefine;


vars q30 =

'QUESTION 3

Evaluate the following Scheme expressions (a definition of unify
is given overleaf)

(unify %p %p \'())

(unify \'(? %p) \'(+ %p %p) \'())

(unify \'(+ %p %p) \'(+ %p (? %p)) \'())

(unify \'(? %p) \'(+ (? %p) %p) \'(((? %p) . %p)))


(unify \'(+ (? %p) %p) \'(+ %p %p) \'(((? %p) . %p)))

(unify \'(+ (? %p) %p) \'(+ %p %p) \'(((? %p) . %p)))';

vars q31 =
'(define =_constant? equal?)
(define constant? atom?)
(define (var? e)
    (and (pair? e) (eq? (car e) \'?))
    )


(define make-binding cons)

(define binding-in-frame assoc)

(define binding-value cdr)

(define (extend var val frame)
    (cons (make-binding var val) frame))


(define (unify p1 p2 frame)
    (cond
        ((eq? frame #f) #f)                             ;[1]
        ((var? p1) (unify_var p1 p2 frame))             ;[2]
        ((var? p2) (unify_var p2 p1 frame))             ;[3]
        ((constant? p1)                                 ;[4]
         (if (constant? p2)
             (if (=_constant? p1 p2) frame #f)
             #f))
        ((constant? p2) #f)                             ;[5]
        (else                                           ;[6]
            (unify (cdr p1)                             ;[6.1]
                (cdr p2)
                (unify                                  ;[6.2]
                    (car p1)
                    (car p2)
                    frame)))))



(define (unify_var var val frame)
    (if (equal? var val)                                    ;[1]
        frame                                               ;[1.1]
        (let ((value-cell (binding-in-frame var frame)))    ;[2]
            (if (not value-cell)                            ;[3]
                (if (freefor? var val frame)                ;[3.1]
                    (extend var val frame)                  ;[3.2]
                    #f)                                     ;[3.3]
                (unify (binding-value value-cell)           ;[4]
                    val
                    frame)))))


(define (freefor? var exp frame)
    (letrec
        (
         (freewalk
             (lambda (e)
                 (cond
                     ((constant? e) #t)                            ;[1]
                     ((var? e)                                     ;[2]
                      (if (equal? var e) #f                        ;[2.1]
                          (let ((b (binding-in-frame e frame)))    ;[2.2]
                              (if (not b) #t                       ;[2.3]
                                  (freewalk (binding-value b)))))) ;[2.4]
                     ( (freewalk (car e)) (freewalk (cdr e)))      ;[3]
                     (else #f))                                    ;[4]
                 )  ;end lambda
             ) ; end freewalk binding
         ) ;end letrec bindings
        (freewalk exp)
        ) ;end letrec
    )
';


define exam3();
    let a = random(8), b=random(8), x = oneof([p q r x y z])
    in
        pr('\^L');

        printf(q30,
            [% a,b,
               x,a,b,
               a,b,a,x,
               x,x,a,x,b,
               x,b,a,b,x,a,
               x,b,a,b,x,b %]);
        pr('\^L');
        pr(q31);
    endlet
enddefine;



vars q40 =
'QUESTION 4

Recall the definition of reduce:

(define (reduce f acc base l)
   (if (null? l)
       base
       (acc (f (car l)) (reduce f acc base (cdr l)))))

The function curry takes a lambda expression and converts it into "curried
form" of a function that can be given its arguments one at a time. For
example

(curry \'(lambda (x y) (+ x (* 2 y))))

evaluates to the expression that prints as:

  (lambda (x)
       (lambda (y) (+ x (* 2 y))) )


Here is a definition of curry, bereft of its helper functions:

(define (curry lexpr)
    (let* ( (formals (get_formals lexpr) )
            (body    (get_body lexpr))
          )
     (car
        (reduce
            (lambda (x) x)
            acc_curry
            body
            formals))
    ))

';

vars q411 =
'
[a] Which of the following definitions of get_formals is correct?\n
';

vars q412 =
[
'(define (get_formals lex) (car lex))'

'(define get_formals cadr)'

'(define (get_formals lex)  (cdr (car lex)))'

'(define get_formals caddr)'

'(define (get_formals lex1 lex2)  (cons lex1 lex2))'
];

vars q420 =
'
[b] Which of the following definitions of get_body is correct?\n
';

vars q421 =
[
'(define (get_body lex) (cadr lex))'

'(define get_body cadar)'

'(define (get_body lex)  (cdr (cdr lex)))'

'(define get_body caddr)'

'(define (get_body lex1 lex2)  (append lex1 lex2))'
];

vars q430 =
'
[c] Which of the following definitions of acc_curry is correct?\n
';

vars q431 =
[
'
    (define (acc_curry var lex)
       (list (append (list \'lambda (list var) ) lex)) )'


'
    (define acc_curry cons)'

'
    (define (acc_curry var lex)
       (cons \'lambda var lex))'


'
    (define (acc_curry var lex)
       (lambda (var) lex))'

'
    (define acc_curry append)'

];



define exam4();
    let i,j,q in
        pr('\^L');
            printf(q40,[]);
            printf(q411,[]);
            for q in perm_random_any(q412) do
                sp(4); pr(q); nl(2);
            endfor ;

            printf(q420,[]);
            for q in perm_random_any(q421) do
                sp(4); pr(q); nl(2);
            endfor;

            printf(q430,[]);
            for q in perm_random_any(q431) do
                sp(4); pr(q); nl(2);
            endfor;


    endlet
enddefine;



vars q51 =

'QUESTION 5

Having made the definition:


(define (y e) (lambda (x) ((e (y e)) x)))


[a] Exactly ONE of the definitions below is a correct definition of
the factorial function. Which?\n\n';

vars q52 =
[

'(define fact
    (y
       (lambda (n)
           (lambda(f) (if (= n 0) 1 (* n (f (- n 1))))))))'





'(define fact
    (lambda (f)
        (y
           (lambda(n) (if (= n 0) 1 (* n (f (- n
                            1))))))))'




'(define fact
    (y
       (lambda (f)
           (lambda(n) (if (= n 0) 1 (* n (f (- n 1))))))))'



'(define fact
    (lambda (n)
        (y
           (lambda(f) (if (= n 0) 1 (* n (f (- n 1))))))))'





'(define fact
    (lambda (f)
        (lambda(n)
            (y (if (= n 0) 1 (* n (f (- n 1))))))))'

 ];

vars q53 =
'
[b]Recall that we said:

Thus, to sum up, to perform

     (apply_env!  \'(closure L E_c) E)

we evaluate the lambda-expression L with the environment E_c extended
by the global environment at the end and by the frame ((x1 . v1) ....)
at the front.

Also recall the definitions:

    (define vars_lambda cadr)
    (define body_lambda cddr)

    (define (eval_sequence seq env)
        (cond
          ((null? seq) (error "cannot evaluate null seqence"))
          ((null? (cdr seq)) (eval_env! (car seq) env))
          (else
            (eval_env! (car seq) env)
            (eval_sequence (cdr seq) env)
            ) ) )


Which of the following definitions of apply_closure is correct?
';

vars q54 =
[
'(define (apply_closure  L E_c args)
    (let ((E_cg (append E_c the-global-environment)))
        (eval_sequence
            (body_lambda L)
            (cons
                (map cons (vars_lambda L) args)
                E_cg)
            )
        ) ; end let
    ) ; end define'

'(define (apply_closure  L E_c args)
    (let ((E_cg (cons E_c the-global-environment)))
        (eval_sequence
            (body_lambda L)
            (cons
                (map append (vars_lambda L) args)
                E_cg)
            )
        ) ; end let
    ) ; end define'


'(define (apply_closure  L E_c args)
    (let ((E_cg (append E_c the-global-environment)))
        (eval_sequence
            (body_lambda L)
            (cons
                (map + (vars_lambda L) args)
                E_cg)
            )
        ) ; end let
    ) ; end define'



'(define (apply_closure  L E_c args)
    (let ((E_cg (append E_c the-global-environment)))
        (eval_sequence
            (cons
                (map cons (vars_lambda L) args)
                E_cg)
            )
            (body_lambda L)
        ) ; end let
    ) ; end define'


'(define (apply_closure  L E_c args)
    (let ((E_cg (append E_c the-global-environment)))
        (eval_sequence
            (body_lambda L)
            (append
                (map cons (vars_lambda L) args)
                E_cg)
            )
        ) ; end let
    ) ; end define'



] ;


define exam5();
    let i,j,q in
        pr('\^L');
        printf(q51,[]);
        for q in perm_random_any(q52) do
            npr(q); nl(2);
        endfor;

        printf(q53,[]);nl(1);
        for q in perm_random_any(q54) do
            npr(q); nl(2);
        endfor;


    endlet
enddefine;


exam(60);
