

<html><head><title>

ERROR MESSAGES in SCHEME

</title></head>
<body bgcolor="white">



<h1> Error Reporting in UMASS Scheme </h1>

<h2> Warning:</h2> As a result of creating this file, I have discovered a
number of places in which error messages could be improved. I have
made these improvements in the Scheme system source, and will incorporate
them in the public version of Scheme ASAP. Currently (17NOV97) error
messages will be slightly different from those detailed below.

<h2> Where error messages come from </h2>

<p>UMASS Scheme is implemented on top of the Sussex Poplog system. This
means in effect that errors can be detected either in UMASS Scheme or in
Poplog. As a general rule, run-time errors are detected by Poplog, while
compile-time errors are detected by UMASS Scheme.

The following is a typical compile-time error:

<pre>
=> (if 234)
</pre>
<pre>
Error: Badly formed "if" expression (if 234)
In file: /users/users3/fac/pop/poplocal/local/Scheme/output.scm
In or around line 12: (if 234)

Setscheme
=>
</pre>

However  run-time errors occurring in many primitive functions will
appear in a somewhat different form, usually with a short capitalised error
message.
<pre>
(define (test x) (+ x #f)
    )
(test 4)

Error: NUMBER(S) NEEDED
Culprits: #f, 0,
In file: /users/users3/fac/pop/poplocal/local/Scheme/errors.scm
</pre>



<h2> Error Messages Emanating from UMASS Scheme </h2>

The following error messages are produced directly by the UMASS Scheme
System. They may be proceeded by warnings from the Naomi Nag.

Others may be produced by Poplog itself. Single capital letters
are used in places in which a string will be substituted.


<ul>
<li>
Calling function 'F' with wrong number (N) of arguments, it needs M';

<p>Example:
<pre>
    (car '(2 3) '(4 5))

Error: Calling function 'car' with wrong number (2) of arguments, it needs
     1
In file: /users/users3/fac/pop/poplocal/local/Scheme/errors.scm

Value = (4 5)
This error report was prepared for Robin Popplestone
 by Jeremiah Jolt, your compile-time helper.
</pre>




<li> too many args of proc being schemified

<p>
This error is reported by a function which converts a POP-11 function for
use by Scheme. If it appears, it is a system error.


<li> Unterminated string

<p>This error arises when an open string quote is unmatched by a closing
string quote. Consequently it can be quite hard to find. Look in your
"output.scm" file to see which functions the Scheme system has compiled.
The one immediately following probably contains the offending quote.

<p>
Alternatively you can locate it by compiling sub-ranges of your source
file.


<li>Unknown character name N',

<p>This error message is rather unhelpful - I need to improve it. But it
always arises from an illegal combination that begins with #. For example

<pre>
#r
</pre>
gives:
<pre>
Error: Unknown character name #
In file: /users/users3/fac/pop/poplocal/local/Scheme/errors.scm
</pre>

<li> Improperly formed dotted list . X Y
<p> In a "dotted list" only one item is permitted after the dot. So, for
example:

<pre>
'(2 . 3  4)
</pre>
Gives
<pre>
Error: Improperly formed dotted list . 3 4
In file: /users/users3/fac/pop/poplocal/local/Scheme/errors.scm
</pre>

<li>
End of input encountered while reading Scheme expression,
probably a missing close parenthesis';

<p>This message means that Scheme has started reading an expression but has
come to the "end-of-input-stream" marker before the expression is complete.


For example:
<pre>
(+ 2 3
</pre>
gives the error
<pre>
Error: End of input encountered while reading Scheme expression,probably
     a missing close parenthesis
In file: /users/users3/fac/pop/poplocal/local/Scheme/errors.scm
</pre>

<li>cannot apply list L as a function
<p>This error is superceded by the "cannot apply object" message.
</p>


<li>trying to declare expression E as variable
<p>This arises when Scheme finds some kind of expression when it is
expecting a variable.
<pre>
(lambda (3) (x+y))

Error: trying to declare expression '3' as variable
In file: /users/users3/fac/pop/poplocal/local/Scheme/errors.scm
In or around line 167: (lambda (3) (x+y))
</pre>


<pre>
(lambda ((+ x 2)) (x+y))

Error: trying to declare expression '(+ x 2)' as variable
In file: /users/users3/fac/pop/poplocal/local/Scheme/errors.scm
In or around line 176: (lambda ((+ x 2)) (x+y))
</pre>


<li>      Trying to use the reserved symbol 'S as variable
<p> This arises from using a reserved symbol such as 'if' or 'define' as
a variable.

<pre>
(lambda (if) (+ if 2))

Error: Trying to use the reserved symbol 'if  as variable
In file: /users/users3/fac/pop/poplocal/local/Scheme/errors.scm
In or around line 189: (lambda (if) (+ if 2))

</pre>

<pre>
(+ 10 define)

Error: Trying to use the reserved symbol 'define  as variable
In file: /users/users3/fac/pop/poplocal/local/Scheme/output.scm
In or around line 15: (+ y define)
</pre>

<li> Manifest non-function  X  in expression

This means that a a non-functional object X has been used as a function.
For example

<pre>
(2 3)

Error: Manifest non-function  F  in expression<br>
In file: F<br>
In or around line L: E<br>
Are you missing a quotation sign (') ?
</pre>


<p>This means that the compiler has tried to compile an expression E
in which what should be the function F is obviously not a function.


For example

<pre>
(2 34)

Error: Manifest non-function  2  in expression

   (2 34)

Are you missing a quotation sign (') ?

In file: /users/users3/fac/pop/poplocal/local/Scheme/errors.scm
In or around line 225: (2 34)
</pre>



<li>Cannot apply object F as function


<p>This means that Scheme has tried to evaluate an expression with a
non-function in the function position. This happens when it is not obvious
to the compiler that the expression was wrong, and so it was not caught
by the "Manifest non-function" error-check above.

For example, the compiler can't in general tell that the expression (f 5 7)
is erroneous, so you get
<pre>
(define f '(3 4))
(f 5 7)
</pre>
giving
<pre>
Error: Cannot apply object (3 4) as function
In file: /users/users3/fac/pop/poplocal/local/Scheme/errors.scm
</pre>

This often arises from the use of excessive parentheses - for example:
<pre>
(car(x))
</pre>


<li>wrong form for expression sequence S


<p> This means that Scheme has encountered a mal-formed expression
sequence S, usually an empty function-body or <tt>begin</tt>.
For example:

<pre>
(lambda (x))

Error: wrong form for expression sequence ()
In file: /users/users3/fac/pop/poplocal/local/Scheme/errors.scm
In or around line 272: (lambda (x))

(begin)

Error: wrong form for expression sequence ()
In file: /users/users3/fac/pop/poplocal/local/Scheme/errors.scm
In or around line 278: (begin)
</pre>



<li>Wrong form for quoted expression "Q"

<p> This can only occur if you use explicitly the special
form <tt>quote</tt> as in the following

<pre>
(quote 2 3)

Error: Wrong form for quoted expression "(quote 2 3)"
In file: /users/users3/fac/pop/poplocal/local/Scheme/errors.scm
</pre>

<li>Wrong form for quasi-quoted expression "Q"

<p>This arises if the quasi-quote facility is used directly with
<quasiquote>

<pre>
(quasiquote 2 3)

Error: Wrong form for quasi-quoted expression "(quasiquote 2 3)"
In file: /users/users3/fac/pop/poplocal/local/Scheme/errors.scm
</pre>


<li>function "F" called with wrong number of arguments

<p>This means that  the function F has been given the wrong number of
arguments at run time. This will happen with user-defined functions,
and system functions that are written in Scheme. True primitives will
give the "Calling function...wrong number..." message described above

Often this will have been picked up by Naomi Nag,
with a warning message at compile time, but not always (for example
Naomi doesn't know about map_list requiring a function that takes one
argument).

For example
<pre>
(define (fred x) (+ x 3))

(fred 3 4)


Error: function " fred  " called with wrong number of arguments
In file: /users/users3/fac/pop/poplocal/local/Scheme/errors.scm
</pre>


<li> lambda expression has repeated argument "A" in "L"
<li> let expression has repeated argument "A" in "L"
<p>This means that a lambda or let expression has a repeated variable
A in a context L in which  repetition is not allowed.

<pre>
(lambda (x x) (+ x 4))

Error: lambda expression has illegal repeated variable "x " in "(x x)"
In file: /users/users3/fac/pop/poplocal/local/Scheme/errors.scm
Compiling argument list ending at line 336:
    (x x)
In or around line 336: (lambda (x x) (+ x 4))

(let ((x 43) (x 4))(+ x y))

Error: let expression has illegal repeated variable "x " in "(x x)"
In file: /users/users3/fac/pop/poplocal/local/Scheme/errors.scm
Compiling argument list ending at line &lt;false>:
    (x x)
In or around line 351: (let ((x 43) (x 4)) (+ x y))
</pre>


<li>The variable V is being defined as a function, but its type is T
<li>The variable V is given a badly formed function type T
<li>Number of arguments N dont match type T

<p>None of these messages can appear - my type-checking ideas for Scheme
will surface in Lean-and-Mean aka POP2000.
</p>


<li>define statement D is of the form (define EXPR)<br>
     it must have the form (define VARIABLE EXPR) or (define FORM EXPR)

<p>This means that you have omitted part of a <tt>define</tt> statement.
For example

<pre>
(define fred)

Error: define statement "(define fred)" is of the form (define EXPR)
it must have the form (define VARIABLE EXPR) or (define FORM EXPR)
In file: /users/users3/fac/pop/poplocal/local/Scheme/errors.scm
</pre>

<li>
Need variable name instead of "X" in definition "D";
<p> This means that you have something wrongly placed in a <tt> define</tt>
statement.
<tt>
(define 2 fred)
</tt>

<li>
Attempting to redefine special form S

<p> You are not allowed to redefine the meaning of a special form.

<pre>
(define if 45)

Error: Attempting to redefine special form 'if
In file: /users/users3/fac/pop/poplocal/local/Scheme/errors.scm
While defining 'if '

</pre>

<li> too many forms in define statement: D

<p>The define statement D has been given extra components. The allowable
forms are
<pre>
      (define <b>variable expression</b>)
      (define <b>form  expression_sequence</b>)
</pre>
where <tt><b>form</b></tt> is
<tt> (<b>function arg<sub>1</sub>..arg<sub>n</sub></b>)</tt>

<p>An example of such an error is:
<pre>

(define fred 34 joe 67)

Error: too many forms in define statement:
(define fred 34 joe 67)

In file: /users/users3/fac/pop/poplocal/local/Scheme/errors.scm
While defining 'fred '
</pre>



<li>Failed assertion check.<br>

This means that a call of the "assertion checker" special form <tt>:-</tt>
has failed to produce the true object <tt>#t</tt>.
<pre>
(:- (= 3 45))

Error: Failed assertion check (:- (= 3 45))
In file: /users/users3/fac/pop/poplocal/local/Scheme/errors.scm
</pre>


<li>Special form :- should take one argument in S<br>

The <tt>:-</tt>special form which should have just one argument has been
used with more than one.
<pre>
(:- 3 4)

Error: Special form :- should take one argument in (:- 3 4)
In file: /users/users3/fac/pop/poplocal/local/Scheme/errors.scm
</pre>

<li> Badly formed "if" expression E<br>

<p>An <tt>if</tt> expression can have either 2 or 3 arguments.
<pre>
        (if condition expr1 expr2)
        (if condition expr1)
</pre>
Any other form is illegal. For example:
<pre>
(if x)

Error: Badly formed "if" expression (if x)
In file: /courses/cs200/cs287/cs287/public_html/errors.scm
In or around line 433: (if x)
</pre>
Likewise if we have too many arguments for <tt>if</tt>.

<pre>
(if (< x 2) 3 4 5)

Error: Badly formed "if" expression (if (< x 2) 3 4 5)
In file: /courses/cs200/cs287/cs287/public_html/errors.scm
In or around line 439: (if (< x 2) 3 4 5)
</pre>

<li> case expr "C" needs actual cases
<p> The forms of a <tt>case</tt> expression in Scheme are

<pre>
  (case <b>expr case<sub>1</sub>...case<sub>n</sub></b>)

  (case <b>expr case<sub>1</sub>...case<sub>n</sub> </b>(else<b>
expression_sequence</b>))
</pre>
where <b>case<sub>i</sub></b> has the form
<tt>((<b>keys</b>) <b>expression_seq</b>)</tt>,
and <b>keys</b> consists of a sequence of literal values.


An example of correct usage is:
<pre>
(example
    '(case (* 2 3)
       ((2 3 5 7) 'prime)
       ((1 4 6 8 9) 'composite))
   'composite)

(example
    '(case (car '(c d))
       ((a e i o u) 'vowel)
       ((w y) 'semivowel)
       (else 'consonant))
        'consonant)
</pre>
An example of the error message is
<pre>

(case 2)

Error: case expr "(case 2)" needs actual cases
In file: /courses/cs200/cs287/cs287/public_html/errors.scm
In or around line 489: (case 2)
</pre>



<li> Wrong form for key-value pair "C" in (case ...) expression<br>   E<br>
This error message appears when one of the actual cases of a <tt>case</tt>
expression is badly formed.
<pre>
(case x 2 3)

Error: Wrong form for key-value pair "2" in (case ...) expression
(case x 2 3)
In file: /courses/cs200/cs287/cs287/public_html/errors.scm
In or around line 501: (case x 2 3)
</pre>

<li> list of values needed instead of "K" in key-value pair "V" in
     (case..)expression E

<p> There must always be a list of the possible values for a particular
case.
<pre>
(case x (3 4))


Error: list of values needed instead of "3" in key-value pair "(3 4)" in
     (case..)expression
    (case x (3 4))
In file: /courses/cs200/cs287/cs287/public_html/errors.scm
In or around line 508: (case x (3 4))
</pre>





<li>Wrong form for condition-value pair "C" in (cond ...) expression E<br>

<!-- cond --><a href="lecture5.html#cond">
For a specification of cond follow this link. </a><br>

<pre>
(cond 1 2 3 )

Error: Wrong form for condition-value pair "1" in (cond ...) expression
     (cond 1 2 3)
In file: /courses/cs200/cs287/cs287/public_html/errors.scm
Compiling (<test> <value>) clause ending at line <false>:
    1
In or around line 532: (cond 1 2 3)
</pre>


<li> "else" apparently used as a function in E. Badly formed cond or case?<br>
This can happen if you miscount your parentheses in a cond or case statement,
or otherwise:
<tt>
(if (< x 2) 45 (else 34))


Error: "else" apparently used as a function in (else 34). Badly formed
     cond or case?
In file: /courses/cs200/cs287/cs287/public_html/errors.scm
In or around line 555: (if (< x 2) 45 (else 34))
</tt>


<li>Do expression "E" missing a part<br>
<li> Badly formed binding "B" in do expr "E"

We don't use the <tt>do</tt> expression in this course...


<li>Missing binding or body in let expr L<br>

<pre>
(let (+ 2 3))
Error: Missing binding or body in let expr
 (let (+ 2 3))
In file: /courses/cs200/cs287/cs287/public_html/errors.scm
</pre>

<li> Badly formed binding B in bindings L<br>

<pre>
(let  (x 4)  (+ 3 4))

Error: Badly formed binding x  in bindings (x 4)
In file: /courses/cs200/cs287/cs287/public_html/errors.scm
In or around line 583: (let (x 4) (+ 3 4))
</pre>

<li>Variable needed instead of "C" in binding "B" in bindings "L"

<pre>
(let ((3 x) (4 y)) (+ x y))

Error: Variable needed instead of "3" in binding "(3 x)" in bindings "((3
     x) (4 y))"
In file: /courses/cs200/cs287/cs287/public_html/errors.scm
In or around line 594: (let ((3 x) (4 y)) (+ x y))
This error report was prepared for Robin Popplestone


</pre>


<li>Binding "B" is not of form (<b>var expr</b>)<br>
<pre>
(let ((x 3 4) (y 6)) (+ a 2))

Error: Binding "(x 3 4)" is not of form (&lt;var> &lt;expr>)
In file: /courses/cs200/cs287/cs287/public_html/errors.scm
In or around line 608: (let ((x 3 4) (y 6)) (+ a 2))
</pre>

<li> Bindings B should be a list<br>

(let x 3)
Error: Bindings x  should be a list
In file: /courses/cs200/cs287/cs287/public_html/errors.scm
In or around line 604: (let x 3)


<li>Wrong form (  E  ) for "set!" statement

<pre>
(set! x 3 4)

Error: Wrong form "(set! x 3 4)" for "set!" statement
In file: /courses/cs200/cs287/cs287/public_html/errors.scm
Compiling expression ending at line 625:
    (set! x 3 4)

</pre>

<li>Non-atom A cannot be bound by "set!" in E







</ul>



<h2> The "Report POP-11 functions" button </h2>

This is only of significance to system-maintainers. It should be left
in the "inactive" position, that is the "up" or unshaded position.

<p>This button switches the Scheme system into a mode suitable for system
debugging, so it should normally be left inactive. It's effect is to
cause errors to be reported by the POP-11 error reporting function, which
doesn't format the error message by replacing '%p' occurring in an error
message by a value, and which reports all functions on the call-stack, not
just those defined in Scheme. For example, a call of

<pre>
(car 1 2)
</pre>

with the "Report POP-11 functions" button set produces:
<pre>
;;; MISHAP - Calling function '%p' with wrong number (%p) of arguments, it needs %p
;;; INVOLVING:  'car' 2 1
;;; FILE     :  /users/users3/fac/pop/poplocal/local/Scheme/errors.scm   LINE NUMBER:  35
;;; DOING    :  mishap_GDB apply_checking exec_scm compile_Scheme schemecompile scheme_compile
     apply runproc charin read_sexpr compile_Scheme schemecompile scheme_compile pop_setpop_compiler

Type of error = Expression_RT
</pre>

<p>instead of

<pre>
Error: Calling function 'car' with wrong number (2) of arguments, it needs 1
In file: /users/users3/fac/pop/poplocal/local/Scheme/errors.scm

Value = 2
This error report was prepared for Robin Popplestone
 by Jeremiah Jolt, your compile-time helper.
</pre>




<h2> Where the error reporting could be improved.</h2>

The number of arguments that a user-defined function expects should be
reported.

The "value = " is probably not helpful.
