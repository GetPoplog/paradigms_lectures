
;;; MISHAP - idw: ILLEGAL DECLARATION OF WORD (missing ; after vars?)
;;; INVOLVING:  (
;;; FILE     :  /users/users2/cs287/cs287/public_html/S98/test.p   LINE
     NUMBER:  334
;;; DOING    :  mishap_GDB ident_declare define ( lconstant runproc charin
     read_sexpr compile_Scheme schemecompile scheme_compile pop_setpop_compile
    r
Type of error = Statement_RT

;;; MISHAP - mei: MISPLACED EXPRESSION ITEM
;;; INVOLVING:  FOUND lconstant READING TO (,' ')' ';' '<termin>)
;;; FILE     :  /users/users2/cs287/cs287/public_html/S98/test.p   LINE
     NUMBER:  333
;;; DOING    :  mishap_GDB lconstant runproc charin read_sexpr compile_Scheme
     schemecompile scheme_compile pop_setpop_compiler
Type of error = Statement_RT



CMPSCI 287 Class Test   7apr98

NAME

STUDENT ID

Test ID: 1,  ranseed = <false>


Question 1

Evaluate the following Scheme Expressions

(cons (car '(7 dog)) 9)

(cond
        ( (equal? 2 5) 9)
        ( (symbol? 5) 8)
        ( 8 7)
        (else 9)
)
Question 2

Evaluate the following Scheme Expressions


(define (cmp x y)
    (cond
        ((< x y) '<)
        ((= x y) '=)
        (else '>)
        )
    )

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

(define ledger '(
    (1043 1 1)
    (1196 4 5)
    (2037 10 6)
    (3045 1 9)
    (9089 3 4)
)

(define transactions '(
   (1043 5
;;; MISHAP - ITEM LIST FOR printf TOO SHORT
;;; FILE     :  /users/users2/cs287/cs287/public_html/S98/test.p   LINE
     NUMBER:  410
;;; DOING    :  mishap_GDB appdata printf exam6 runproc charin read_sexpr
     compile_Scheme schemecompile scheme_compile pop_setpop_compiler
Type of error = Statement_RT

;;; MISHAP - uts: UNTERMINATED STRING OR CHARACTER CONSTANT
;;; INVOLVING:  ');

           printf(q621,

                [%random(2), random(10), random(10),
                  random(10), random(10), random(10),random(10),
                  random(10), random(10), random(10),random(10) %]);


        endfor
    endlet
enddefine;

exam6(1);
'
;;; FILE     :  /users/users2/cs287/cs287/public_html/S98/test.p   LINE
     NUMBER:  413
;;; COMPILING:  exam6
;;; DOING    :  mishap_GDB null readitem [ ( [ ( for lblock define runproc
     charin read_sexpr compile_Scheme schemecompile scheme_compile pop_setpop_
    compiler
Type of error = Statement_RT



CMPSCI 287 Class Test   7apr98

NAME

STUDENT ID

Test ID: 1,  ranseed = 327509528349643527


Question 1


Evaluate the following Scheme Expressions

(cons (car '(elephant 19)) '(likes fish))

(cond
        ( (equal? 1 1) 9)
        ( (symbol? 1) 3)
        ( 1 3)
        (else 6)
)
Question 2

Evaluate the following Scheme Expressions


(define (cmp x y)
    (cond
        ((< x y) '<)
        ((= x y) '=)
        (else '>)
        )
    )

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

(define ledger '(
    (1043 1 3)
    (1196 6 3)
    (2037 1 10)
    (3045 9 5)
    (9089 2 9)
)

(define transactions '(
   (1043 1
;;; MISHAP - ITEM LIST FOR printf TOO SHORT
;;; FILE     :  /users/users2/cs287/cs287/public_html/S98/test.p   LINE
     NUMBER:  412
;;; DOING    :  mishap_GDB appdata printf exam6 runproc charin read_sexpr
     compile_Scheme schemecompile scheme_compile pop_setpop_compiler
Type of error = Statement_RT
