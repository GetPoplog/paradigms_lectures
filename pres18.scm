
  1   The substitution model is inefficient, does not support set!

  2   The environment model eliminates substitution.

  3   Implementing (eval_env! expr env) to evaluate in an environment
      3.1   Implementing the environment - the lookup  function.
      3.2   Methods for special forms
      3.3   eval_compound! evaluates special forms, and any applicatio
            ... Defining the method to evaluate the special form lambda
            ... An abstract characterisation of closures.
            ... Defining the method to evaluate closures
            ... Defining the method to evaluate the special form if
            ... Defining the method for quoted constants
            ... And we can now implement set!
            ... Testing out eval_env!
      3.4   Defining apply_eager  to implement the application of a function.
            ... We put primitives in the global environment
            ... Applying a closure to arguments

  4   Doing top-level recursion in the Environment Model
      4.1   Implementing the define special form
      4.2   Making it easy to add new special forms
      4.3   Implementing the begin special form.
      4.4   Testing out the "banking" example.

  5   The substitution model & environment model in computer languages



(define (make_account balance)
    (lambda (amount)
        (if (>= balance amount)
            (begin (set! balance (- balance amount))
                (list 'balance balance)
                )
            "Insufficient funds"
            )
        )
    )



    (make_account 34)
                                                                          
as evaluating to:                                                         
--------------------------------------------------------------------------
|     Substitution makes nonsense in the Imperative Paradigm             |
|------------------------------------------------------------------------|
|   (lambda (amount)                                                     |
|       (if (>= 34 amount)                                               |
|           (begin (set! 34 (- 34 amount))                               |
|               (list '34 34)                                            |
|               )                                                        |
|           "Insufficient funds"                                         |
|           )                                                            |
|       )                                                                |
--------------------------------------------------------------------------
 



An  environment  is  simply  a  list  of
association lists, each association list
holding the values of variables for  one
function  call,  except  for  the  last,
which is called the ______global  ___________environment,
and which  holds  the values  of  system
variables such as car, cons, cdr and  of
user-defined global variables.



[1]    Because    we    remember     the
substitutions (in effect  the values  of
variables) in the environment, we do not
have   to    copy    the    bodies    of
lambda-abstractions making substitutions
as we did in the substitution model,  we
only have to scan through these  bodies,
once      per      application      of a
lambda-abstraction to  a given  list  of
arguments. This saves a lot of time.

[2] The set! operation can be  supported
because we can  change the  environment.
For example:

    (set! x 34)

will change the appropriate entry in  an
environment, perhaps:

      (... (...(x . 90)...)...)

to

      (... (...(x . 34)...)...)




What we'd like:

(eval_env! '(+ x (* 2 y))  '(((x . 3) (y . 5)) '()))

Let's start:

(define (eval_env! expr env)
    (if (pair? expr)
        (eval_compound! (car expr) (cdr expr) env)
        (if (symbol? expr)
            (lookup expr env)
            expr )
        )
    )


(example '(eval_env! 34 '()) 34)



(define (lookup var env)
    (if (null? env) var
        (let ((pair (assoc var (car env))))
            (if pair
                (cdr pair)
                (lookup var (cdr env)))
            )
        )
    )
 

(example '(eval_env!
    'x
     '(
       ((a . 16) (b . 7))
       ((x . 44) (y . 2))
       ((pi . 3.141593))
      ))
    44)


(example '(eval_env! 'x '()) 'x)




(define (method f)
    (let ((pair (assoc f alist_method)))
        (if pair (cdr pair) pair )
        )
    )



(define (eval_compound! f args env)
    (let ((m (method f)))
        (if m
            (m args env)
            (apply_env! f
                (map (lambda (e)
                        (eval_env! e env))
                    args)
                env
                )
            )
        )
    )


Evaluating a  lambda expression  becomes
more complicated. Consider:

    (lambda (x) (+ x b))

evaluated with  the  environment  '((b .
2)).  Since   the  environment   holds a
substitution that ______should ____have ____been  ____made
according to the substitution model,  we
must  ensure  that  b  has  the  value 2
whenever   the    body   of    of    the
lambda-expression is evaluated.  However
this evaluation will  take place in  the
future, when  the current  binding  of b
may have  been  lost.  For  example,  in
Scheme we might have

(define inc_b
    (lambda (b)
        (lambda (x) (+ x b))))

(define add_2 (inc_b 2))



The substitution  model  takes  care  of
this.

With the  environment model  we have  to
preserve the  environment, or  at  least
the part of  it that says  that b is  2,
along with the inner  lambda-expression.
Such a  pairing of  a  lambda-expression
with an environment is called a ________closure.
We  will  represent   closures  by   the
special form

 (closure  _____________<lambda-expr> _____________<environment>),

although it should be understood that in
a   standard    Scheme    implementation
closures  just  appear  to  be  ordinary
functions once created.



According to the rules for interpreting
Scheme, we have to separate the global
frame from the others:

(define (method_lambda args_and_body env)
    (list 'closure
        (cons 'lambda args_and_body)
        (remove_global env))
    )



(define (remove_global env)
   (if (or (null? env) (null? (cdr env))) '()
     (cons (car env) (remove_global (cdr env))))
)


(example '(remove_global
        '(
         ((a . 16) (b . 7))        ; first frame of environment
         ((x . 44) (y . 2))        ; second frame
         ((pi . 3.141593))         ; global frame
         ))
    '(
     ((a . 16) (b . 7))        ; first frame of environment
     ((x . 44) (y . 2))        ; second frame
     )
    )


Abstract Definition of Closures

(define (closure? x)
    (and
        (pair? x)
        (eq? (car x) 'closure))
    )


(define lambda_closure cadr)
(define env_closure    caddr)

------------------------------------------

(define (method_closure args env)
    (cons 'closure args)
    )

Temporarily define   alist_method   to
support test

(define alist_method
    (list
        (cons 'lambda method_lambda)
        )
    )

(example
  '(eval_env!
    '(lambda (x) (+ x a))
    '(
     ((a . 34))
     ()
     ) )
  '(closure
    (lambda (x) (+ x a))
    (((a
        . 34))))
  )



(define (method_if args env)
  (let
    ((bool (eval_env! (car args) env)))
    (cond
      ((eq? bool #t)
       (eval_env! (cadr args) env))
      ((eq?
         bool
         #f)
       (eval_env! (caddr args) env))
      (else (cons 'if args))
      )
    )
  )



(define (method_quote args env)
    (car  args)
    )


 And we can now implement set!

(define (update! var val env)
  (if (null? env)
    (error "set! of undefined variable "
      var )
    (let ((pair (assoc var (car env))))
      (if pair
        (set-cdr! pair val)
        (update! var val (cdr env)))
      )
    )
  )

(define (method_set! args env)
  (update! (car args)
    (eval_env! (cadr args) env) env
    )
  )


We can  dispense with  the  Y-combinator
because the  environment model  supports
recursion directly using set!.

(define alist_method
  (list
    (cons 'lambda method_lambda)
    (cons 'closure     method_closure)
    (cons 'if     method_if)
    (cons 'quote  method_quote)
    (cons 'set!   method_set!)
    )
  )


To test set!, let us set up an environment:

    (define env_test   '(((x . 2)) ()))

    (example '(eval_env! 'x env_test) 2)

    (eval_env! '(set! x 44) env_test)

    (example 'env_test '(((x . 44)) ()))

    (example '(eval_env! 'x env_test) 44)




(example
  '(eval_env!
    ''(3 4 5) env_test)
  '(3 4 5))

[Note: it is possible to avoid using the
mutation    operation    set-cdr!     in
implementing set!. This requires however
that all our functions return a pair

    (<value> <environment>)


A  purely  functional  account  of   the
non-functional  aspects  of  Scheme  can
however be  achieved,  using  this,  and
other, techniques].


3.4 Defining  apply_eager  to  implement
the application of a function.

(define the-global-environment
    (list(list
      (cons '+ +)
      (cons '- -)
      (cons '* *)
      (cons '/ /)
      (cons '>= >=)
      (cons '>  >)
      (cons '<  <)
      (cons '<= =)
      (cons 'null? null?)
      (cons 'car   car)
      (cons 'cdr   cdr)
      (cons 'cons  cons)
      (cons 'list list )
     ))
    )


(define (apply_env! f args env)
    (let ((p (eval_env! f env)))
        (cond
            ((procedure? p)
             (apply p args))
            ((closure? p)
             (apply_closure
                 (lambda_closure p)
                 (env_closure p)
                 args
                 )
             )
            (else (cons f args))
            )
        )
    )




(example
  '(apply_env! '+ '(2 3)
    the-global-environment)
  5)

(example
'(eval_env! '(+ (* 4 5) 3)
the-global-environment)
23)

...  Applying a closure to arguments
------------------------------------

When we come to  apply a closure to  its
arguments  we  have   to  _________construct   __an
___________environment __in  _____which  __to  ________evaluate  ___the
____body __of ___the ______lambda __________expression  _________contained
__in ___the _______closure.


This new environment has 3 parts:

[1] The  _______current global  environment  is
used to create  the last (global)  frame
of the new environment. Changes made  to
the  global  environment  by  set!   and
define statements will be "seen" in  the
body of the lambda-expression.

[2]  The  environment   stored  in   the
closure is used to create frames in  the
new environment specifying the values of
variables   in   the    body   of    the
lambda-expression that are _________non-local and
___non ______global.

[3]  The   first   frame  of   the   new
environment specifies the values of  the
arguments   of   the   lambda-expression
derived by  pairing  them  up  with  the
actual      parameters      of       the
lambda-expression.

Coming closer to our implementation,  we
can rephrase the  above requirements  by
saying that  applying  a  closure  C  to
arguments  v1,v2...vn  requires  us   to
evaluate the body of L = (lambda_closure
C) in an  environment which consists  of
E_c =  (environment_closure C)  modified
as follows:


[1] We append the global environment  to
the  end   of   the   environment   E_c,
obtaining  an  environment  E_cg.   This
allows for  the fact  that in  Scheme, a
redefinition  of   a   global   function
affects previous calls of that function.
For example:


(define (mary x)
   (+ x 45)
)

(define (fred x)
     (mary x)
)

(example '(fred 2) 47)

Now   if   we    redefine   mary    this
redefinition affects fred:

(define (mary x)
    (* x 6)
)

(example '(fred 2) 12)

[Note  that   more   modern   functional
languages like SML  eschew this  special
behaviour of  top-level functions.  This
is less convenient for debugging, but is
almost necessitated  by  the  fact  that
these languages are statically typed, so
that  if  you   redefined  mary   with a
different  type,   fred   would   have a
different type if it "saw" the change in
mary.  This   kind   of   change   could
propagate throughout the program]

[2] We have to extend the environment to
provide bindings for the variables  of L
(that is the  formal parameters) to  the
actual parameters. If L has the form

     (lambda (x1 x2 ... xn) body)

And the arguments  evaluate to (v1  ....
vn) then we make the frame

     ((x1 .  v1) (x1  . v2)  ....  (xn .
vn))

be  the   first   frame   of   our   new
environment.
 
Thus, to sum up, to perform

     (apply_env!  '(closure L E_c) E)

we evaluate the lambda-expression L with
the  environment  E_c  extended  by  the
global environment at the end and by the
frame ((x1 . v1) ....) at the front.


(define (apply_closure  L E_c args)
  (let ((E_cg
       (append
         E_c the-global-environment)))
    (eval_sequence
      (body_lambda L)
      (cons
        (map
          cons
          (vars_lambda
            L) args)
        E_cg)
      )
    ) ; end let
  ) ; end define


(define vars_lambda cadr)
(define body_lambda cddr)

 

(define (eval_sequence seq env)
    (cond
        ((null? seq) (error "cannot evaluate null seqence"))
        ((null? (cdr seq)) (eval_env! (car seq) env))
        (else
            (eval_env! (car seq) env)
            (eval_sequence (cdr seq) env)
            )
        )
    )

(example '(eval_env! '((lambda (x y) (+ x (* 2 y))) 3 4)
            the-global-environment)
         11
         )


(define (method_define args env)
    (if (= (length args) 2)
        (let ((var (car args)) (expr (cadr args)))
            (if (symbol? var)
                (begin
                    (set! the-global-environment
                        (add_variable var
                           the-global-environment))
                    (update!
                        var
                        (eval_env! expr
                            the-global-environment)
                        the-global-environment)
                    )
                (error "var needed in define"
                    (cons 'define args))
                )
            ) ; end let

        (error "wrong form for define"
            (cons 'define args)) ;[8]
        ) ; end if
    )



The function add_variable makes the  new
entry for a  variable in an  environment
if one is required.

(define (add_variable var env)
    (cons
        (cons
            (cons var "undefined")
              (car env))
        (cdr env))
    )

Making it easy to add new special forms
-----------------------------------------

For   convenience,   let   us   define a
mutating procedure  to add  a method  so
that we  can  extend  our  repetoire  of
special forms on the fly.

(define (add_method! name m)
  (set! alist_method (cons (cons name m)
      alist_method))
  )

We  can  now   incorporate  the   define
special form into our interpreter.

(add_method! 'define method_define)


Implementing the begin special form.
-----------------------------------------

We also  need to  provide a  method  for
begin. We  simply use  eval_sequence  to
evaluate  the  sequence  of  expressions
forming the body of a begin expression.

(add_method! 'begin
    (lambda (seq env)
        (eval_sequence  seq env)
        )
    )


Testing out the "banking" example.
---------------------------------------

For   convenience,   let   us   define a
function  evalg   which   evaluates   an
expression in  the  global  environment.
This will  allow  us  to  implement  the
equivalent of  the "read-eval"  loop  of
the   Scheme    system,    whereby    it
continually   reads    an    expression,
evaluates it, and writes out the  value.
Without   learning   more   about    the
input-output  aspects   of  the   Scheme
language we can't  make our  interpreter
behave _______exactly like the built-in system,
but we can make it tolerably  convenient
to use.

(define (evalg expr)
    (writeln "=:> "
      (eval_env! expr
        the-global-environment))
    )

Note that we have only treated the  most
basic kind of  definition -  we have  to
have an explicit lambda if we are  going
to   define   functions.   To   define a
function fred  to  our  interpreter,  we
need to do:

(evalg
    '(define fred (lambda (x) (+ x 2)))
    )

Now,   we   can   check   whether   this
definition has "taken", by looking  fred
up in the global environment.

(example '(lookup
      'fred the-global-environment)
    '(closure (lambda (x) (+ x 2)) ())
    )


 evals allows us to evaluate a  sequence
of    expressions    in    the    global
environment.

(define (evals seq) (for-each evalg seq))



(evals
    '(
     (define make_account
         (lambda (balance)
             (lambda (amount)
                 (if (>= balance amount)
                     (begin (set! balance
                          (- balance amount))
                         (list 'bal balance)
                         )
                     "Insufficient funds"
                     )
                 )
             )
         )
     (define jane (make_account 100))
     jane
     )
    )
 
The jane account is simply the closure [1]:

(example
    '(lookup 'jane the-global-environment)
    '(closure                                        ; [1]
        (lambda (amount)
            (if
                (>= balance amount)
                (begin
                   (set! balance
                      (- balance amount))
                    (list 'bal balance))
                "Insufficient funds"
                )
            ) (((balance . 100))))
    )
  
Now let us make an account for Fred,
and debit Jane's account.

(evals
    '(
     (define fred (make_account 75))
     (jane 34)
     )
    )

(example '(lookup 'jane the-global-environment)
    '(closure
        (lambda (amount)
            (if
                (>= balance amount)
                (begin
                    (set! balance
                        (- balance amount))
                    (list 'balance balance))
                "Insufficient funds"
                )
            ) (((balance . 66))))
    )

Note that when  we make closures,  we do not  copy
the lambda expressions, but share them, so that in
making each  closure, although  it looks  big,  we
only have to  allocate enough memory  to hold  the
association list.



    The substitution model & environment model
               in computer languages

The substitution model serves  as a basis for  the
concept of _____macro _________expansion as found for example in
the   pre-processor    for   the    C    language.
Unfortunately, as we  have seen, the  substitution
model does  not  support the  imperative  paradigm
well. So, while in a purely functional context the
choice  of  the  substitution  model  versus   the
environment model is an  efficiency issue, if  you
"bolt  on"  a  macro-facility  to  an   imperative
language, you  end  up  with  a  system  in  which
behaviour depends on whether you are using a macro
or a regular function definition. For example, you
can write  a  C  macro swap  for  which  the  call
swap(x,y) will swap the values of the  variables x
and y. But you cannot  achieve the same result  if
swap is an ordinary C function - you would have to
write swap(&x,&y).
  
More recent  languages than  C have  attempted  to
preserve transparency as between the  substitution
model and the  environment model  (from which  the
compilation model is derived). For example C++ has
the concept of ______inline functions which the compiler
will  treat  as  macro  definitions  ____only  if  the
meaning of the program is unchanged by so doing.

It should  be  noted  that while  __in  _______general  the
substitution  model  is  an  inefficient  way   to
implement a language, it  can be a very  efficient
way of implementing  small functions. For  example
the swap macro might generate the code:

    {int tmp = x; x = y; y = tmp}

which is  significantly faster  than the  function
call reqired if swap is a function.
 
