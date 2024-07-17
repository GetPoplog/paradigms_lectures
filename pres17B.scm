

 Lecture 17 Implementing the Substitutional Model of Functions.

  3.4   Defining apply_eager  to implement the application of a function.
      ... Applying primitives such as +, *, car, cons, cdr
      ... The implementation of apply_eager
      ... Examples of the use of apply_eager

  3.5   Implementing the application of a compound function to arguments
      ... Implementing the application of a function of the form (Y- e)
      ... Implementing the application of a lambda expression
      ... Implementing the substitution of  values for variables
      ... Making a substitution in a lambda-expression

  4   Shonfinkel's Combinators enable us to dispense with lambda




Our   understanding   of   the    purely
functional use of  Scheme was  expressed
in terms  of the  substitution model  of
evaluation. This substitution model says


    "To  apply  a  lambda-expression  to
    actual parameters, substitute the
    actual  parameters  for  the  formal
    parameters in the body of the
    lambda-expression, and evaluate  the
    resulting body."



     '(eval_eager '(if #t 3 4))

        3

    '(eval_eager '(if #f 3 4))

        4

'(eval_eager '(lambda (x) (+ x 5)))

    '(lambda (x) (+ x 5))

    (eval_eager
    '(Y- (lambda (x) (+ x 5))))

    '(Y- (lambda (x) (+ x 5))))

     '(eval_eager ''x)

        ''x

     '(eval_eager ''(1 2 3))

    ''(1 2 3))
 



(define (apply_prm f args) (apply f args))


; f will be 'car 'cdr ...

(define (apply_prm_q f l)
     (requote (apply f (map de_quote l)))
    )



(define (requote x)
    (if (or
            (pair? x)
            (null? x)
            (symbol? x))
        (list 'quote x)
        x) )

(define (de_quote l)
    (if (and (pair? l)
            (eq? (car l) 'quote))
        (cadr l)
        l) )




(define (apply_eager f args)
    (cond
        ((symbol? f)
         (cond
             ((eq? f '+)     (apply_prm + args))
             ((eq? f '-)     (apply_prm - args))
             ((eq? f '*)     (apply_prm * args))
             ((eq? f '/)     (apply_prm / args))
             ((eq? f 'null?) (apply_prm_q null? args))
             ((eq? f 'car)   (apply_prm_q car args))
             ((eq? f 'cdr)   (apply_prm_q cdr args))
             ((eq? f 'cons)  (apply_prm_q cons args))
             (else (cons f args))
             )
         )
        ((pair? f)
         (apply_compound f (car f) (cdr f) args)
         ; end cond
         )
        (else  (error
                "illegal object applied to arguments"
                f args))
        )
    )




(example '(apply_eager '+ '(2 3)) 5)
(example '(apply_eager '* '(2 3)) 6)
(example '(apply_eager 'car '('(2 3))) 2)
(example '(apply_eager 'cdr '('(2 3))) ''(3))
(example '(apply_eager 'cdr '('(3))) ''())
(example '(apply_eager 'cons '(2 3)) ''(2 . 3))
(example '(apply_eager 'null? '('(2 3))) #f)
(example '(apply_eager 'f '(2 3)) '(f 2 3))


[1]     If     we     are     applying a
lambda-expression, then  we  must  apply
the  rule  that  we  substitute   actual
parameters for formal parameters in  the
body,  stripping  off  the  lambda   and
formal parameters.


[2] If we are applying something of  the
form (Y- e)  then we will  use the  fact
that

      (Y- e) = (e (Y- e))

The reason for treating things this  way
is that it  ensures that <tt>Y</tt>  has
something to get its teeth into!



[3] If we have neither a lambda nor a Y-
expression we will evaluate f and  apply
it to its arguments. Note that we  could
have a non-terminating computation here,
since there is no guarantee that f  will
evaluate  to   anything   simpler   than
itself. However, if  the user's  program
is  correct,   f  should   evaluate   to
something that can be  applied in a  way
that leads to termination, e.g. a lambda
expression.

(define (apply_compound  f fn_f rest_f args)
    (cond

        ((eq? fn_f 'lambda)
         (apply_lambda
             (car rest_f)
             args
             (cdr rest_f)
             ))

        ((eq? fn_f 'Y-)
         (apply_y f rest_f args))

        (else  (apply_eager
                (eval_eager f)
                args)
            )
        )
    )


(define msg_Y   "Y-combinator takes one argument")

(define (apply_y ye list_e args)
    (if (= (length list_e) 1)
        (let ((e (car list_e)))
            (eval_eager
                (cons (list e ye) args)
                )
            )
        (error msg_Y args_y args)
        )  ; end if
    )



(define (apply_lambda vars args body)
    (if (= (length body) 1)
        (eval_eager
            (multi_subst
                (map cons vars args)
                (car body)))
        (error "multi-expr body"
            args body);
        )
    )

(define (multi_subst alist expr)
    (cond
        ( (symbol? expr)
         (let ((pair (assoc expr alist)))
             (if pair (cdr pair) expr)
             )
         )
        ( (pair? expr)
         (if (eq? (car expr) 'lambda)
             (multi_subst_lambda
                 alist (cadr expr) (cddr expr))
             (cons (multi_subst alist (car expr))
                 (multi_subst alist (cdr expr)))
             )
         )
        (else expr)
        )
    )

HEALTH WARNING - FREE VARIABLES...


(multi_subst
    '((x . 7) (y . 4))
    '((+ y (* 5 x))))


    '((+ 4 (* 5 7)))


(apply_eager '(lambda (x) (* 5 x)) '(7)  )

35


 '(eval_eager '((lambda (x) (* 5 x)) 7)  )

35

(eval_eager
    '((lambda (x y )
         (+ y (* 5 x)))
     7 4)  )

39

(define (multi_subst_lambda alist vars body)
    (list 'lambda vars
        (multi_subst
            (delete_alist vars alist)
            (car body))
        )
    )



(define (delete_alist vars alist)
    (if (null? alist) '()
        (if (memq (caar alist) vars)
            (delete_alist vars (cdr alist))
            (cons (car alist)
                (delete_alist vars (cdr alist)))
            )
        )
    )

(example
    (delete_alist '(x y z)
      '((x . 2 ) (a . 4) (y . 3) (p . 7)))

    '((a . 4) (p . 7))



