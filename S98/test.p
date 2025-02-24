

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


define exam1(n);
    let i in
        pr('\^L');
        for i from 1 to n do
            pr('\n\n\nCMPSCI 287 Class Test   24FEB98\n\nNAME\n\nSTUDENT ID\n\n');
            printf('Test ID: %p,  ranseed = %p\n\n\n', [%i,ranseed%]);

            pr('Question 1\n\n');
            pr('Evaluate the following Scheme Expression\n\n');
            lvars a = random(10);
            printf('(define a %p)\n (let ((a %p) (b (+ a %p)))\n   (* a b))\n\n',
                [%a, a+random(3), random(12) %]);

            pr('Question 2\n');
            pr('\nWith the definition of cycles_of_alist from assignment 1\n');
            pr('evaluate the following Scheme Expression\n\n');
            pr('(cycles_of_alist \''); pr_scm(perm_random()); pr(")");
            nl(4);
            pr('\^L');
        endfor
    endlet
enddefine;

true -> pop_longstrings;

lconstant mapl =
'
(define map_list
    (lambda (f l)
        (if (null? l)
            \'()
            (cons
                (f (car l))
                (map_list f (cdr l))
                )
            ); end if
        )    ; end lambda
    )        ; end define
';

lconstant q1 =
'(%p (%p \'( (%p %p) (%p %p) (%p) )))\n\n';

lconstant q2 =
  '(map_list\n    %p\n    \'%p)\n\n';

exam1(1);
.setpop;

define exam2(n);
    let i in
        pr('\^L');
        for i from 1 to n do
            pr('\n\n\nCMPSCI 287 Class Test   5MAR98\n\nNAME\n\nSTUDENT ID\n\n');
            printf('Test ID: %p,  ranseed = %p\n\n\n', [%i,ranseed%]);

            pr('Question 1\n');
            pr('Evaluate the following Scheme Expression\n\n');

            printf(q1, [% oneof([car cdr]), oneof([car cdr]),
                          random(10), random(10),random(10), random(10),
                          random(10)%]);

            pr('Question 2\n');

            pr('With the definition of *_perm from assignment 2\n');
            pr('evaluate the following Scheme Expression\n\n');
            pr('(*_perm\n    \''); pr_scm(perm_random());
            pr('\n    \'');
            pr_scm(perm_random());
            pr(")");
            nl(2);

            pr('Question 3\n');
            pr('Evaluate the following Scheme Expression\n\n');
            printf('(+\n    (caar \'%p) \n    (cadar \'%p))\n\n',
                [%perm_random(), perm_random()%]);


            pr('Question 4\n');
            pr('Recall the definition of map_list');
            pr(mapl);

            pr('Evaluate the following Scheme Expression\n\n');

            printf(q2, [% oneof([car cadr '(lambda (x) (+ (car x) 1))']),
                      perm_random()    %]);

            pr('\^L');
        endfor
    endlet
enddefine;


lconstant q31 =
'(%p (%p \'( (%p %p) (%p %p) (%p) )))\n\n';

lconstant q34 =
  '(reduce\n    (lambda (x) (%p  (car x) (cadr x)))\n    %p\n    %p\n    \'%p)\n\n';


lconstant reducel =
'\n\n(define (reduce f acc base l)
   (if (null? l)
       base
       (acc (f (car l)) (reduce f acc base (cdr l)))))\n';


define choose_random(l,n);
    if n=0 then []
    else
        let x = oneof(l)
        in
           x :: choose_random(delete(x,l),n-1)
        endlet
    endif;
enddefine;

;;; choose_random([the fat cat],2) =>

lconstant nouns =
    [cat dog elephant man woman goat donkey banana canary computer

    ];


lconstant q321 =
'\nIf these Scheme expressions are evaluated, what is the\n'<>
'result of the second?\n\n(define noun (mk_parser_singleton \'';
lconstant q322 =
'))\n
(noun \'';

lconstant q323 =
')\n\n';

define exam3(n);
    let i in
        for i from 1 to n do
            pr('\^L');
            pr('\n\n\nCMPSCI 287 Class Test   24MAR98\n\nNAME\n\nSTUDENT ID\n\n');
            printf('Test ID: %p,  ranseed = %p\n\n\n', [%i,ranseed%]);

            pr('Question 1\n');
            pr('Evaluate the  Scheme Expression\n\n');

            printf(q1, [% oneof([car cdr]), oneof([car cdr]),
                          random(10), random(10),random(10), random(10),
                          random(10)%]);

            pr('Question 2\n');
            pr(q321);
            pr_scm(choose_random(nouns,8));
            pr(q322);
            pr_scm(choose_random(nouns,3));
            pr(q323);

            pr('Question 3\n');
            pr('Evaluate the following Scheme Expression\n\n');
            printf('(+\n    (caar \'%p) \n    (cadar \'%p))\n\n',
                [%perm_random(), perm_random()%]);


            pr('Question 4\n');
            pr('Recall the definition of reduce');
            pr(reducel);

            pr('\nEvaluate the following Scheme Expression\n\n');

            printf(q34,
               [% oneof([+ *]), oneof([+]),
                    oneof([1 10 100]), perm_random()%]);

            pr('\^L');
        endfor
    endlet
enddefine;

lconstant adjectives =
[big blue indigent erudite existential abstruse amorphous atavistic];



lconstant q421 =
'\nIf these Scheme expressions are evaluated, what is the\n'<>
'result of the second?\n\n(define adjs\n  (mk_parser_kleene\n    (mk_parser_singleton\n       \'';
lconstant q422 =
')))\n
(adjs \'';

lconstant q423 =
')\n\n';



define exam4(n);
    let i in

        for i from 1 to n do
            pr('\^L');
            pr('\n\n\nCMPSCI 287 Class Test   26MAR98\n\nNAME\n\nSTUDENT ID\n\n');
            printf('Test ID: %p,  ranseed = %p\n\n\n', [%i,ranseed%]);

            pr('Question 1\n\n');
            pr('Evaluate the following Scheme Expression\n\n');
            lvars a = random(10);
            printf('(define n %p)\n (let ((n %p) (q (* n %p)))\n   (+ (* n %p) q))\n\n',
                [%a, a+random(3), random(12), random(3) %]);

            pr('Question 2\n');
            pr(q421);
            pr_scm(choose_random(adjectives,8));
            pr(q422);
            pr_scm(choose_random(adjectives,3)<>choose_random(nouns,1));
            pr(q423);

            pr('Question 3\n');
            pr('Evaluate the following Scheme Expression\n\n');
            printf('(assoc %p \'%p)\n\n',
                [%random(7), perm_random()%]);

        endfor
    endlet
enddefine;




lconstant q511 =
'(+ (car \'(%p %p)) %p)
';



lconstant q512 =
'
(cond
        ( (= %p %p) %p)
        ( (< %p %p) %p)
        ( (> %p %p) %p)
        (else %p)
)

)';

lconstant q521 =
'
(define (cmp x y)
    (cond
        ((symbol<? x y) \'<)
        ((= x y) \'=)
        (else \'>)
        )
    )

(define (cmb x y mg)
    (cons (list (+ (car x) (car y)) (cadr x)) mg) )



(merge_general cadr cmp cmb cons (lambda (l) l) (lambda (l) l)
    \'((%p apples) (%p bananas) (%p grapefruit) (%p oranges)  (%p strawberries))
    \'((%p apples) (%p bananas) (%p grapefruit) (%p lemons) (%p oranges)  (%p tangerines))
    )



';

define exam5(n);
    let i in

        for i from 1 to n do
            pr('\^L');
            pr('\n\n\nCMPSCI 287 Class Test   7apr98\n\nNAME\n\nSTUDENT ID\n\n');
            printf('Test ID: %p,  ranseed = %p\n\n\n', [%i,ranseed%]);

            pr('Question 1\n\n');
            pr('Evaluate the following Scheme Expressions\n\n');

            printf(q511,
                [%random(20), oneof([cat dog elephant]), random(10)%]);

            printf(q512,
                [%random(2), random(10), random(10),
                  random(10), random(10), random(10),
                  random(10), random(10), random(10),random(10) %]);

            pr('Question 2\n\n');
            pr('Evaluate the following Scheme Expressions\n\n');

           printf(q521,

                [%random(2), random(10), random(10),
                  random(10), random(10), random(10),random(10),
                  random(10), random(10), random(10),random(10) %]);


        endfor
    endlet
enddefine;



lconstant q611 =
'(cons (car \'(%p %p)) %p)
';



lconstant q612 =
'
(list
        (equal? %p %p)
        (+ %p 5)
        (symbol? %p)
        (* %p 9)
        (- %p %p)
        (cons  %p \'(6 7 8)) )\n
';

lconstant q621 =
'
(define (cmp x y)
    (cond
        ((< x y) \'<)
        ((= x y) \'=)
        (else \'>)
        ))

(define cust_num car)
(define cust_name cadr)
(define balance  caddr)

(define amount  cadr)

(define (cmb ledger_item transaction mg)
    (cons (list
                (cust_num  ledger_item)
                (cust_name ledger_item)
                (+ (balance ledger_item) (amount transaction))
           )
           mg ))

(define ledger \'(
    (1043 "%p" %p)
    (1196 "%p" %p)
    (2037 "%p" %p)
    (3045 "%p" %p)
    (9089 "%p" %p)   ))

(define transactions \'(
   (1043 %p)
   (3045 %p)   ))

(merge_general car cmp cmb cons (lambda (l) l) (lambda (l) l)
    ledger
    transactions
    )

';

lconstant q613 =
['\'x' '"t"' '\'the' '\'+' '+' '\'y34' '\'34y'];

lconstant q622 =
['Sir John Falstaff' 'Jane Eyre' 'Jeremy Bentham' 'Ebenezer Scrooge'
'David Copperfield' 'Bishop Proudie' 'Beckie Sharp' 'Peter Abelard'
'John Knox' 'Duns Scotus' 'Jean Redpath' 'Maxim Gorky'
'Martin Chuzzlewit' 'Winston Churchill' 'Clement Atlee' 'John Major'
'Margaret Thatcher' 'Ramsay Macdonald' 'James Baldwin' 'Thomas Acquinas'
'Adam Bede' 'Brian Boru' 'Hugh O\'Neil'
];

define aname; oneof(q622); enddefine;

define exam6(n);
    let i in

        for i from 1 to n do
            pr('\^L');
            pr('\n\n\nCMPSCI 287 Class Test   14apr98\n\nNAME\n\nSTUDENT ID\n\n');
            printf('Test ID: %p,  ranseed = %p\n\n\n', [%i,ranseed%]);

            pr('Question 1: ');
            pr('Evaluate the following Scheme Expressions\n\n');

            printf(q611,
                [%oneof([cat dog elephant]), random(20),
                oneof(['\'(likes fish)' '\'(eats bones)' '\'(is a pachyderm)'])
                %]);

            printf(q612,
                [%random(2),  random(10), random(10),
                  oneof(q613), random(10),
                  random(10), random(10), random(10) %]);

            pr('\nQuestion 2: ');
            pr('Evaluate the last of the following Scheme Expressions\n');

           printf(q621,

                [%
                  aname(), random(1000)+200,
                  aname(), random(1000)+200,
                  aname(), random(1000)+200,
                  aname(), random(1000)+200,
                  aname(), random(1000)+200,
                  random(190),
                  random(190),
                  random(190),
                %])
        endfor
    endlet
enddefine;






lconstant q711 =
'
(define list1 \'(%p %p %p))
(define list2 list1)
(set-car! (cdr list1) \'%p)
list2
';



lconstant q712 =
'
(define list3 (append (cons %p \'(%p %p)) \'(%p %p)))
list3

';

lconstant q721 =
'
(define (reduce f acc base l)
   (if (null? l)
       base
       (acc (f (car l)) (reduce f acc base (cdr l)))))

;with sets represented as unordered lists

(define (mystery s1 s2)
    (reduce
        (lambda (x) x)                   ;f
        (lambda (x s)                    ;acc
            (if (member_set? x s2)
                (adjoin x s)
                s)
            )
        empty_set                        ;base
        (set->list s1)                   ;list
        ))

(mystery \'(%p %p %p %p) \'(%p %p %p %p))

';





define exam7(n);
    let i
         r1 = random(10),
         r2 = r1 + random(2),
    in

        for i from 1 to n do
            pr('\^L');
            pr('\n\n\nCMPSCI 287 Class Test   21apr98\n\nNAME\n\nSTUDENT ID\n\n');
            printf('Test ID: %p,  ranseed = %p\n\n\n', [%i,ranseed%]);

            pr('Question 1: ');
            pr('Write down the final values of list2 and list3 in\n\n');

            printf(q711,
                [%oneof([cat dog elephant]), random(20),
                oneof(['(likes fish)' '(eats bones)' '(is a pachyderm)']),
                oneof([donkey elephant banana])
                %]);

            printf(q712,
                [%random(2),  random(10), random(10),
                  random(10),
                  random(10), random(10), random(10) %]);

            pr('\nQuestion 2: ');
            pr('Evaluate the last of the following Scheme Expressions\n');


           printf(q721,

                [%
                    r1, r1+random(2), r1+2+random(2), r1+4+random(2),
                    r1, r1+random(2), r1+2+random(2), r1+4+random(2),
                %])
        endfor
    endlet
enddefine;



lconstant q811 =
'
(define list1 \'(%p %p %p))
(define list2 (cons \'%p list1))
(set-car! list2 \'%p)
list1
';


lconstant q812 =
'
(define list3 (cons (append \'(%p %p) \'(%p %p)) \'(%p %p)))
list3

';

lconstant q821 =
'
(define vars_lambda cadr)
(map
    cons
    (vars_lambda \'(lambda (%p %p %p) (+ %p (* %p %p))))
    \'(%p %p %p))

';


define exam8(n);
    let i

    in

        for i from 1 to n do
            pr('\^L');
            pr('\n\n\nCMPSCI 287 Class Test   21apr98\n\nNAME\n\nSTUDENT ID\n\n');
            printf('Test ID: %p,  ranseed = %p\n\n\n', [%i,ranseed%]);

            pr('Question 1: ');
            pr('Write down the final values of list2 and list3 in\n\n');

            printf(q811,
                [%oneof([bill hillary newt]), random(20),
                oneof(['(likes fish)' '(eats humble pie)' '(is a pachyderm)']),
                oneof([donkey elephant banana]),
                random(20),
                %]);

            printf(q812,
                [%
                  random(2),  random(10), random(10),
                  random(10),
                  random(10), random(10), random(10) %]);

            pr('\nQuestion 2: ');
            pr('Evaluate the last of the following Scheme Expressions\n');


           printf(q821,

                [%
                    oneof([a b c]),
                    oneof([p q r]),
                    oneof([x y z]),
                    oneof([a b c]),
                    oneof([p q r]),
                    oneof([x y z]),
                    random(10),random(10),random(10),
                %])
        endfor
    endlet
enddefine;





lconstant q911 =
'
(define list1 \'(%p %p %p))
(define list2 (list (car list1) (cons (cadr list1) (caddr list1))))
list2
';


lconstant q912 =
'
(define (mystery x)
    (if (null? x) \'()
        (append (mystery (cdr x)) (cons (car x) \'()))))

(define list3 (mystery \'(%p %p %p)))

';


lconstant q920 =
'
(unify \'(+ %p %p) \'(+ %p %p) \'())

';
lconstant q921 =
'
(unify \'(+ %p %p) \'(+ %p %p) \'())

';

lconstant q922 =
'
(unify \'(+ %p (* %p %p)) \'(+ %p (* %p %p)) \'())

';


define exam9(n);
    let i

    in

        for i from 1 to n do
            pr('\^L');
            pr('\n\n\nCMPSCI 287 Class Test   05MAY98\n\nNAME\n\nSTUDENT ID\n\n');
            printf('Test ID: %p,  ranseed = %p\n\n\n', [%i,ranseed%]);

            pr('Question 1: ');
            pr('Write down the final values of list2 and list3 in\n\n');

            printf(q911,
                [%
                oneof(['(the big black dog)'
                       '(the hungry alligator)'
                       '(fifteen hungry rattlesnakes)']),
                oneof([eat liked fed aggravated]),
                oneof(['(the green parrot)'
                       '(the art of fugue)'
                       '(the noisy donkey)'])
                %]);

            printf(q912,
                [%
                  random(2),  random(10), random(10),
                  random(10),
                  random(10), random(10), random(10) %]);

            pr('\nQuestion 2: ');
            pr('Evaluate all of the following Scheme Expressions\n');

           let v1 = oneof([a b c]), v2 = oneof([p q r]), n1=random(10)
           in

           printf(q921,

                [%
                      random(10),random(10),random(10),random(10)
                %]);

           printf(q921,

                [%
                      v1,random(10),v1,v2
                %]);

           printf(q922,

                [%
                      v1,random(10),v2,n1,v2,n1
                %])
           endlet
        endfor
    endlet
enddefine;

exam9(1);
