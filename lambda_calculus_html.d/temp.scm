


CMPSCI 287 Class Test   10MAR98

NAME

STUDENT ID

Test ID: 1,  ranseed = 328604369717919356


Question 1
Evaluate the  Scheme Expression

(car (cdr '( (6 7) (5 6) (8) )))

Question 2

If these Scheme expressions are evaluated, what is the
result of the second?

(define noun (mk_parser_singleton '(donkey man elephant computer canary
     banana dog cat)))

(noun '(donkey goat banana))

Question 3
Evaluate the following Scheme Expression

(+
    (caar '((1 5) (2 1) (3 4) (4 6) (5 3) (6 2)))
    (cadar '((1 2) (2 3) (3 4) (4 1) (5 6) (6 5))))

Question 4
Recall the definition of reduce

(define (reduce f acc base l)
   (if (null? l)
       base
       (acc (f (car l)) (reduce f acc base (cdr l)))))

Evaluate the following Scheme Expression

(reduce
    (lambda (x) (+  (car x) (cadr x)))
    +
    10
    '((1 3) (2 6) (3 2) (4 1) (5 4) (6 5)))




CMPSCI 287 Class Test   10MAR98

NAME

STUDENT ID

Test ID: 2,  ranseed = -338776756650905693


Question 1
Evaluate the  Scheme Expression

(car (cdr '( (3 6) (7 1) (1) )))

Question 2

If these Scheme expressions are evaluated, what is the
result of the second?

(define noun (mk_parser_singleton '(cat woman goat banana donkey dog computer
     canary)))

(noun '(computer man canary))

Question 3
Evaluate the following Scheme Expression

(+
    (caar '((1 4) (2 2) (3 1) (4 6) (5 3) (6 5)))
    (cadar '((1 4) (2 3) (3 1) (4 6) (5 2) (6 5))))

Question 4
Recall the definition of reduce

(define (reduce f acc base l)
   (if (null? l)
       base
       (acc (f (car l)) (reduce f acc base (cdr l)))))

Evaluate the following Scheme Expression

(reduce
    (lambda (x) (+  (car x) (cadr x)))
    +
    10
    '((1 3) (2 4) (3 1) (4 2) (5 5) (6 6)))




CMPSCI 287 Class Test   10MAR98

NAME

STUDENT ID

Test ID: 3,  ranseed = 115075692167116134


Question 1
Evaluate the  Scheme Expression

(car (car '( (2 3) (1 10) (3) )))

Question 2

If these Scheme expressions are evaluated, what is the
result of the second?

(define noun (mk_parser_singleton '(woman donkey dog goat man cat elephant
     banana)))

(noun '(computer donkey man))

Question 3
Evaluate the following Scheme Expression

(+
    (caar '((1 4) (2 2) (3 1) (4 3) (5 5) (6 6)))
    (cadar '((1 3) (2 1) (3 4) (4 5) (5 2) (6 6))))

Question 4
Recall the definition of reduce

(define (reduce f acc base l)
   (if (null? l)
       base
       (acc (f (car l)) (reduce f acc base (cdr l)))))

Evaluate the following Scheme Expression

(reduce
    (lambda (x) (*  (car x) (cadr x)))
    +
    1
    '((1 3) (2 1) (3 6) (4 5) (5 2) (6 4)))


