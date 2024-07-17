
/*
           287 HONORS SECTION

(1) Produce a list of those capabilities missing from this implementation of
    Scheme which are required for classwork to date.
(2) Add set-car! and set-cdr! to this implementation of Scheme.
(3) Add the special form "while" to this implementation of Scheme.

*/






compile_Scheme.p                     Robin Popplestone, March 1995

Generate code for the Scheme language.




         CONTENTS - (Use <ENTER> g to access required sections)

 --  Errata.
 --    Pop-11 compatibility
 --    Lexical analysis
 --      Special forms not done
 --  How the compiler works
 --    Notes on parameter passing
 --    Notes on booleans
 --  Lexical Analysis
 --    tokenise is a slightly better approximation to a Scheme lexical analyser
 --  Schemify(v) converts a POP-11 object to scheme form
 --  read_sexpr is the main parser for Scheme
 --  compile_Scheme compiles a file or character repeater.
 --  Environments specify context for compilation.
 --  A Scheme atom is a POP-11 word with an extra space at the end.
 --  method maps from an atom to a procedure for compiling special forms.
 --  compile_expr(E,Env) compiles ordinary expressions
 --  compile_fun_call generates code for the function part of an expression.
 --  list_from_scm converts a Scheme list to POP-11 form.
 --  listify_count makes a list of arguments for variadic functions.
 --  compile_expr_seq(Seq,Env) plants code to handle a sequence of expressions.
 --  convert_bool converts a scheme object to a Poplog boolean.
 --  compile_bool plants code to compile boolean expressions.
 --  Special forms are treated by compile_... procedures
 --    compile_quote treats quoted expressions.
 --    compile_lambda(E,Env) compiles lambda expressions.
 --      compile_args declares and pops the arguments of a function
 --    compile_define treats the (define ... ) construct
 --    compile_macro handles macro definitions
 --    compile_if(E,Env) compiles the if expression E.
 --    compile_and([and E1..En],Env) treats an "and" expression
 --    compile_case treats case statements
 --    compile_cond treats (cond ( (c1 v1) (c2 v2) ......(else vn))
 --    compile_begin handles the (begin E1...En) construct
 --    compile_let handles let and let* and letrec expressions.
 --     check_Binding checks the syntactic form of a binding  (v,E)
 --    compile_set_! treats the assignment statement in Scheme.
 --    compile_trace supports the tracing of function calls
 --    mishap_scm(Message,Culprits) treats errors.
 --    mishap_wrong_args and mishap_arity are useful utility error functions.
 --  Setting up the standard bindings for built-in functions.
 --    display
 --    pr_scm is the general procedure to print a scheme object
 --    polyadic_from_binary(P,id) makes a scheme polyadic function
 --    The VAR macro allows us to bind Scheme variables to POP functions.

*/


uses lexical_args;

compile_mode:pop11 +defpdr +varsch +constr;


/*
Errata.
---------
Scheme gets stuck in the error:

;;; MISHAP - sysEXECUTE: NOT AT EXECUTE LEVEL
;;; COMPILING:  test~
;;; DOING    :  sysprmishap mishap sysEXECUTE exec_scm compile_Scheme Scheme_c
    ompile ved_lmr veddocommand veddocr wved_apply_action vedprocesschar


  Missing or erroneous scheme functions.
----------------------------------------
apply
The = == correspondence to eq,=,equal needs to be sorted.
check all lists end with nil in member applist etc.
display can take a stream as argument.
nearest-repl/environment - there is a hack in here
reset
polyadic -
polyadic map
vectors

  Pop-11 compatibility
---------------------
- clean up. Use pop11 nil for end of list .


  Lexical analysis
-------------------
upper-to-lower
strings need escape handling.
numbers are POP-11 form
boolean constant   #t


    Special forms not done
---------------------------
begin
do
error
fluid-let   (the dlocal construct)
sequence
cons-stream
the-environment
delay
make-environment
*/


/*
How the compiler works
----------------------
This compiler is based on the use of the Poplog Virtual Machine. Since this is
conceptually a stack machine,  it is quite easy to generate scheme code.
Thus to compile the scheme expression  (f x1 x2) the simplest approach is
to push the values of x1 and x2 on the stack and enter the code for f.
If f, x1 and x2 are scheme atoms, then
   sysPUSH("x1");
   sysPUSH("x2");
   sysCALL("f");
is all that is required.  However this simple approach is complicated a
little by the need to keep scheme and POP-11 distinct, and by the handling
of scheme functions which can take a variable number of arguments as explained
below.

The main function of the compiler is -compile_expr-. Called in the form
compile_expr(Expr,Env) it checks to see whether the expression Expr is:-

    A variable: sysPUSH is called to generate code to push the value on the
        stack.
    A constant: sysPUSHQ is called to generate code to push the literal value.
    A function applied to argument: we use the property	-method- to find a
        procedure to treat the function as a special form. If such a procedure
        exists, it is used to generate the code. If there is none such, we
        call compile_expr recursively to generate code to push the arguments,
        push a count of the arguments, and then call compile_fun_call to
        generate code to call the function.

compile_fun_call(f,Env) will, in the simplest case in which the function f
is an atom, uses sysCALL to generate code to enter the code for f. However
if f is a complex expression, it will call compile_expr to evaluate it, and
call sysAPPLY to plant code to execute the resulting function.

Most of the rest of the compiler serves to treat the special forms like
define, and, or, if, let. Also we have to provide a library of build-in
functions.

*/


/*
  Notes on parameter passing
-----------------------------
Scheme functions can be variadic, that is they take a variable number
of arguments. The actual number of arguments must be known unambiguously
when the function is called, but there is no way of knowing when
such a call is compiled whether or not the function which is called will
in fact be variadic. Thus, for example,  (f x y) may or may not be a call
of a variadic function.

In distinction, POP-11 procedures which take a variable number of arguments
take them off the stack according to conventions which must be obeyed by the
caller. For example, in  consstring(#| `c` `a` `t` |#) the user must know
that a variadic function is being called which expects an argument-count
on the stack and hence must use the #|...|# bracketing of the arguments or
the equivalent.

The convention adopted in this implementation of Scheme is that count of the
number of arguments is always put on the stack before the code for a function
is entered. This is the same as the default case for Poplog Common Lisp.
However, there is very little scope for optimisation in Scheme as it
is normally written, so the call-code is uniform, whereas in Poplog Common
Lisp it is often optimised out.

[Scheme global functions can always be redefined so

	(define (fred x) (+ x (* 3 y)))

cannot be optimised by supposing that + and * are the standard addition and
multiplication operators. We could optimise:

(define fred ( let ((+ +)(* *)) (lambda (x y) (+ x (* 3 y)))))

since the applications of + and * must be the values they had at definition
time, but this is hardly ever written!

  Notes on booleans
-------------------
Most LISPs, including Scheme, identify the -false- truth value with the
empty list. However POPLOG has a built-in -false- object, which is the
target of comparison for the conditional instructions of the Poplog Virtual
Machine. This is NOT the same as the empty list in POP-11.

If we ignore the needs of inter-language working, the logical approach
is to make the empty list be the Poplog false object. This merely
requires that we write the Scheme print functions appropriately.

However if we want to be able to pass Scheme lists to POP-11 functions that
expect properly-formed POP-11 lists, then we have to ensure that they
are terminated by the POP-11 nil object.

This Scheme compiler is written to support either convention.
*/


vars
  Env_init,
  nil_scm = [],
  undef_scm = 'Undefined Value',
  false_scm = false,
  lambda_explicit_?,       ;;; Controls putting definition in pdprops.
  show_macro_expansion_?,  ;;;
;


vars procedure(
    applist_scm,
    assoc_scm,
    check_Binding,
    compile_args,
	compile_expr,
    compile_fun_call,
    compile_qq,
    exec_scm,
    do_Bindings,
	length_scm,
    make_Bindings,
    map_scm,
	mishap_scm,
    mishap_wrong_args,
    pr_scm,
    push_Bindings,
    read_sexpr,
    read_to_close,
    rev_scm,
);

/*
Lexical Analysis
----------------
*/

/*
  A Scheme atom is a POP-11 word with an extra space at the end.
----------------------------------------------------------------
*/

vars Wd_flag_scm = consword('~');

define mk_atom_scm(WS);
  	if isstring(WS) then
  		consword(WS)<>Wd_flag_scm
  	else
   		WS<>Wd_flag_scm
  	endif
enddefine;


example mk_atom_scm;
  mk_atom_scm("fred"),";" =>
** fred  ;
  isword(mk_atom_scm('null?')) =>
** <true>
endexample;





/*
  Schemify(v) converts a POP-11 object to scheme form
------------------------------------------------------
A Scheme function takes one more argument than the corresponding POP-11
procedure in order to support the Scheme convention for passing a variable
number of arguments.
*/

lvars Msg_wrong_args =
  'Calling function %p with wrong number (%p) of arguments, it needs %p';

vars nil_scm = [];

define Schemify(v);
  if isprocedure(v) then                  ;;; if it is a procedure
    lvars m = pdnargs(v);                 ;;; how many arguments does it need?
    lvars Val =
    if m==0 then
    procedure(/*..*/,n)with_nargs 1;      ;;; return a procedure which
      unless n==m then                    ;;; checks that the top of stack
        mishap_scm(Msg_wrong_args,     ;;; is the same as the expected
                      [%v,n,m%]);         ;;; number of arguments.
      endunless;
        v(/*...*/);                       ;;; before calling the original one
    endprocedure;
    elseif m ==1 then
    procedure(/*..*/,n)with_nargs 2;      ;;; return a procedure which
      unless n==m then                    ;;; checks that the top of stack
        mishap_scm(Msg_wrong_args,     ;;; is the same as the expected
                      [%v,n,m%]);         ;;; number of arguments.
      endunless;
        v(/*...*/);                       ;;; before calling the original one
    endprocedure;
    elseif m==2 then
    procedure(/*..*/,n)with_nargs 3;      ;;; return a procedure which
      unless n==m then                    ;;; checks that the top of stack
        mishap_scm(Msg_wrong_args,     ;;; is the same as the expected
                      [%v,n,m%]);         ;;; number of arguments.
      endunless;
        v(/*...*/);                       ;;; before calling the original one
    endprocedure;

    else mishap('too many args of proc being schemified',[^v]);
    endif;

    'Scheme function: ' >< pdprops(v) >< '(' >< m ><')' ->
    pdprops(Val);
    Val
  elseif ispair(v) then
    conspair(Schemify(front(v)),
               Schemify(back(v)))
  elseif isword(v) then mk_atom_scm(v);
  elseif v==[]  then nil_scm
  else v                                  ;;; otherwise use POP-11 value
  endif;
enddefine;


vars procedure(
  make_token,
  skip_comment,
  stack_string,
  tokenise,

);

lvars i;
vars chartype = inits(128);


;;; 0 = whitespace, 1 = identifier, 2 = number, 3 = delimiter, 5=error

for i from 1 to 128 do 1 -> chartype(i); endfor;
for i from 1 to 31 do 5 -> chartype(i);
endfor;

0 -> chartype(`\t`);
0 -> chartype(`\n`);
0 -> chartype(` `);



for i from `0` to `9` do 2 -> chartype(i)
endfor;

2 -> chartype(`.`);  ;;; can appear in a number
2 -> chartype(`+`);
2 -> chartype(`-`);

;;; Delimiters. Certain of these are recognised per se and acted on
;;; accordingly.


3 -> chartype(`(`);
3 -> chartype(`)`);

3 -> chartype(`;`);  ;;; comment
3 -> chartype(`"`);  ;;; String quote
3 -> chartype(`\'`); ;;; S-expression quote
3 -> chartype(`\``);
3 -> chartype(`|`);

3 -> chartype(`{`);
3 -> chartype(`}`);

3 -> chartype(`[`);
3 -> chartype(`]`);

/*
  tokenise handles the lexical analysis.
-----------------------------------------
This is not yet correct. In particular POP-11 conventions for numbers
are used. We assume that a token is a number unless proved otherwise.
This is because a single exception can turn a number into a non-number.
However, our initial filter for numbers is crude, and merely serves
for efficiency. The variable "type" holds the presumed type of the
token.

We begin by scanning past any blank-space (1). The lexical analyser
uses an "overshoot" character c_prev to allow for the necessity of looking
ahead.

Having found the beginning of a token we stack up its characters (2).

;;; 0 = whitespace, 1 = identifier, 2 = number, 3 = delimiter, 5=error
*/

lconstant Msg_wrong_char =
        'Illegal character "%p" in input file %p';

define tokenise(Rep);
  lvars c_prev = false;                   ;;; overshoot character from prev
  procedure()->tok;
    lvars c, tok,type = "number";

    repeat                                ;;; (1) Scan blanks
      if c_prev then                      ;;; use overshoot character?
        c_prev, false -> c_prev
      else
        Rep()
      endif -> c;
      ;;;printf('scanning blanks: c=%p,c_prev = %p\n',[^c^c_prev]);
      if c==termin then return(c->tok);
      endif;
      if c == `;` then
        skip_comment(Rep); `\n`->c;
      endif;
    quitif (chartype(c) /== 0);
    endrepeat;
    make_token(#|                       ;;; (2) read token.
        repeat
          if c==`;` then                ;;; comment ends a token.
            skip_comment(Rep);
            if c_prev then
              `n` -> c_prev;
              quitloop
            else Rep()->c;
            endif;
          endif;
          ;;;printf('making token: c=%p\n',[^c]);
          lvars t = subscrs(c,chartype);
        quitif(t==0);                    ;;; whitespace not incorporated
          if t==5 then mishap_scm(
              Msg_wrong_char,
              [%c,Rep%]);
          endif;
          if c==`"` then
            stack_string(Rep);
            "string" -> type;
            quitloop;
          endif;
          c ;                            ;;; c is part of token.
          if t/==2 then
            "identifier" -> type       ;;; Cannot be a number.
          endif;
          if c==`,` then Rep() -> c;   ;;; ,@ sticks together
            if c = `@` then c
            else c -> c_prev
            endif ;
            quitloop;
          endif;
        quitif(t==3);                    ;;; Delimiter is complete as 1 char


          Rep()-> c;
          c->c_prev;
          ;;;printf('new char = %p\n',[^c]);
        quitif( subscrs(c,chartype) == 3);
        endrepeat |#,type)

      -> tok;
    ;;;      dlocal pop_pr_quotes = true; spr(tok);
  endprocedure
enddefine;

define stack_string(Rep);
  lvars c;
  repeat Rep()->c;
     quitif(c=`"`);
     c;
  endrepeat;
enddefine;


define make_token(/*...*/ type) with_nargs 3;
    if type=="number" then                      ;;; Did it look like a number?
        lvars Str = consstring(/*..*/);
        lvars n   = strnumber(Str);
        if n then return( n)
        else
            deststring(Str)                  ;;; Was not a number, make an atom.
        endif;
    elseif type=="string" then
        return(consstring(/*..*/));
    endif;
    lvars Word = consword(/*...*/);
    if subscrw(1,Word) == `#` and datalength(Word) == 2 then
        if subscrw(2,Word) = `f` then
            nil_scm -> Word
        endif;
    endif;
    Schemify(Word)
enddefine;


define skip_comment(Rep);
  until Rep() == `\n` do
  enduntil;
enddefine;


/*
read_sexpr is the main parser for Scheme
---------------------------------------
*/

lconstant Comma_scm = Schemify(",");
lconstant CommaAt_scm = Schemify(consword(',@'));


lconstant quote = consword('\'');
lconstant quote_scm = Schemify("quote");

lconstant unquote_scm = Schemify("unquote");
lconstant unquote_splicing_scm = Schemify(consword('unquote-splicing'));


lconstant Quote_scm = Schemify(quote);
lconstant quasiquote_scm = Schemify("quasiquote");
lconstant QuasiQuote_scm = Schemify(consword('\`'));
lconstant OpenParen_scm = Schemify("(");
lconstant CloseParen_scm = Schemify(")");
lconstant Period_scm     = Schemify(".");


define read_sexpr();
  lvars item = readitem();
  if item == OpenParen_scm then read_to_close();
  elseif item == Quote_scm then
     conspair(quote_scm,conspair(read_sexpr(),nil_scm))

  elseif item == QuasiQuote_scm then
     conspair(quasiquote_scm,conspair(read_sexpr(),nil_scm))

  elseif item == Comma_scm then
     conspair(unquote_scm,conspair(read_sexpr(),nil_scm))

  elseif item == CommaAt_scm then
     conspair(unquote_splicing_scm,conspair(read_sexpr(),nil_scm))

  else item
  endif;
enddefine;

define read_to_close();
  lvars item = readitem();
  if item == CloseParen_scm then nil_scm
  elseif item == OpenParen_scm then
    conspair(read_to_close(),read_to_close())
  elseif item == Quote_scm then
     conspair(
	     conspair(quote_scm,conspair(read_sexpr(),nil_scm)),
         read_to_close())
  elseif item == QuasiQuote_scm then
     conspair(
	     conspair(quasiquote_scm,conspair(read_sexpr(),nil_scm)),
         read_to_close())

  elseif item == Comma_scm then
     conspair(
	     conspair(unquote_scm,conspair(read_sexpr(),nil_scm)),
         read_to_close())

  elseif item == CommaAt_scm then
     conspair(
	     conspair(unquote_splicing_scm,conspair(read_sexpr(),nil_scm)),
         read_to_close())
  elseif item == Period_scm then
    lvars item = readitem();
    lvars item_end = readitem();
    unless item_end == CloseParen_scm then
       mishap_scm('Improperly formed dotted list %p . %p',[^item^item_end])
    endunless;
    item;
  elseif item == termin then
    mishap_scm('End of input encountered while reading sexpr',[]);
  else conspair(item,read_to_close());
  endif;
enddefine;


/*
compile_Scheme compiles a file or character repeater.
----------------------------------------------------
*/


define compile_Scheme(Rep);
  if isstring(Rep) then discin(Rep) -> Rep
  endif;
  dlocal proglist = Rep.tokenise.pdtolist;
  dlocal pop_longstrings = true;
  while true do
    lvars E = read_sexpr();
    quitif(E=termin);
    compile_expr(E,Env_init);
    lvars Val = exec_scm();
    pr(newline);
    pr_scm(Val); pr(newline);
  endwhile;
enddefine;

define Scheme_compile(/*..*/);       ;;; This name needed for VED
  compile_Scheme(/*..*/);
enddefine;

/*
Environments specify context for compilation.
----------------------------------------------
Given the support provided by the Poplog VM, little is needed in the way
of an environment.  However we do need to remember whether we are in
a local or global context, since scheme top-level variables need to be
treated as Poplog globals.  It is also handy to tag lambda expressions
with a name derived fromthe nearest enclosing function created by (define..)

Also we remember in the environment whether we are generating POP-11 compatible
code.
*/

defclass _Env{
  context_Env,
  is_pop_compat_Env};

;;; make a local version of an environment.

define local_Env(Name,Env)->Env_new;
   copy(Env) -> Env_new;
   Name -> context_Env(Env_new);
enddefine;

vars Env_init = cons_Env(false,true);


/*
method maps from an atom to a procedure for compiling special forms.
--------------------------------------------------------------------
*/

vars procedure (
  args   = back,
  is_var = isword,
  method = newassoc([]),

);

/*
The updater of method takes a POP-11 atom and converts it into
the corresponding scheme atom with which a procedure is associated.
*/

lvars updater_method = updater(method);

define updaterof method(Val,Atom);
  updater_method(Val,mk_atom_scm(Atom));
enddefine;


/*
compile_expr(E,Env) compiles ordinary expressions
-------------------------------------------------
*/

define compile_expr(E,Env);
  if is_var(E) then sysPUSH(E)          ;;; a variable? push its value
  elseif atom(E) then sysPUSHQ(E);      ;;; a constant? push it itself
  else                                  ;;; a function applied to arguments
    lvars
       f         = front(E),               ;;; get the function
       compile_f = method(f);           ;;; is it a special form (e.g. if)?
    if compile_f then                   ;;; use the appropriate method
      compile_f(E,Env)
    else                                ;;; not a special form
      applist_scm(args(E),
               compile_expr(%Env%))->;  ;;; push the arguments on the stack
      sysPUSHQ(length_scm(E)-1);            ;;; push the number of arguments
      compile_fun_call(f,Env);          ;;; call the function.
    endif;
  endif;
enddefine;

/*
compile_fun_call generates code for the function part of an expression.
----------------------------------------------------------------------
??? Do we need the isprocedure check???
*/

define compile_fun_call(f,Env);
  if is_var(f) then                           ;;; A variable?
	sysCALL(f);                           ;;; call indirectly thro' f
  elseif isprocedure(f) then                  ;;; a function?
    sysCALLQ(f);                              ;;; call directly
  elseif atom(f) then
    mishap_scm(
          'cannot apply %p as function',
           [%f%]);
  else                                        ;;; f is a complex expression
    compile_expr(f,Env);                      ;;; evaluate it
    sysCALLS(undef);                          ;;; and apply as a function.
  endif;
enddefine;


/*
list_from_scm converts a Scheme list to POP-11 form.
----------------------------------------------------
*/

define list_from_scm(L);
  [% until atom(L) do front(L); back(L)->L
     enduntil %]
enddefine;

/*
listify_count makes a list of arguments for variadic functions.
---------------------------------------------------------------
*/

define listify_count(/*..*/,n)->List with_nargs 3;
  lvars List = nil_scm;
     repeat n times  /*x_i*/ :: List -> List
     endrepeat;
enddefine;

/*
compile_expr_seq(Seq,Env) plants code to handle a sequence of expressions.
-----------------------------------------------------------------------
Since the value of each expression is pushed on the stack, we must remove
all but the last one.

MIT scheme does not allow an empty expression sequence.

*/


define compile_expr_seq(Seq,Env);
;;;   if Seq=nil_scm then sysPUSH(nil_scm);    ;;; empty expression seq = nil
   if atom(Seq) then
     mishap_scm('wrong form for expression sequence %p',
             [^Seq]);
   else
     while not(atom(Seq)) do
        compile_expr(front(Seq),Env);     ;;; evaluate the expression
        back(Seq) -> Seq;
        unless atom(Seq) then
           sysERASE(false); ;;; pop the stacked value if not last
        endunless;
     endwhile;
   endif;
enddefine;

/*
convert_bool converts a scheme object to a Poplog boolean.
----------------------------------------------------------
*/

define convert_bool(Obj);
  if Obj == nil_scm then false
  else Obj
  endif;
enddefine;

/*
compile_bool plants code to compile boolean expressions.
--------------------------------------------------------
*/
define compile_bool(E,Env);
  compile_expr(E,Env);
  if is_pop_compat_Env(Env) then
    sysCALLQ(convert_bool);
  endif;
enddefine;

/*
Special forms are treated by compile_... procedures
---------------------------------------------------
*/


/*
  compile_quote treats quoted expressions.
------------------------------------------
*/

define compile_quote(E,Env);
   unless length_scm(E)==2 then
     mishap_scm('Wrong form for quoted expression "%p"', [^E]);
   endunless;
   sysPUSHQ(front(back(E)));
enddefine;

compile_quote -> method("quote");



/*
  compile_quasiquote treats quasi-quoted expressions.
------------------------------------------
*/

define compile_quasiquote(E,Env);
   unless length_scm(E)==2 then
     mishap_scm('Wrong form for quoted expression "%p"', [^E]);
   endunless;
   compile_qq(front(back(E)),Env);
enddefine;

compile_quasiquote -> method("quasiquote");


define compile_qq(E,Env);
  if atom(E) then sysPUSHQ(E)

  elseif front(E) == unquote_scm then
    compile_expr(front(back(E)),Env);

  elseif not(atom(front(E))) and                 ;;; ((unquote-splicing f) g)
     front(front(E)) == unquote_splicing_scm
  then
    compile_expr(front(back(front(E))),Env);
    compile_qq(back(E),Env);
    sysCALLQ(nonop <>);
  else compile_qq(front(E),Env); compile_qq(back(E),Env);
       sysCALLQ(cons);
  endif;
enddefine;



/*
  compile_lambda(E,Env) compiles lambda expressions.
----------------------------------------------------
*/

define compile_lambda(E,Env);
  lvars Args = front(back(E));
  lvars Body    = back(back(E));
  if islist(Args) then                   ;;; Fixed number of arguments?
    sysPROCEDURE(context_Env(Env),
                 1+length_scm(Args));
    lvars l_ok_args = sysNEW_LABEL();     ;;; Yes! - check that correct
    sysPUSHQ(length_scm(Args));              ;;; number is passed.
    sysCALLQ(nonop ==);
    sysIFSO(l_ok_args);
    sysCALLQ(mishap_wrong_args);
    sysLABEL(l_ok_args);
    compile_args(Args,Env);              ;;; plant code to unstack args.
  else                                   ;;; Variable number of args
     sysPROCEDURE(context_Env(Env),1);
    sysCALLQ(listify_count);             ;;; make into list.
    compile_args([%Args%],Env)           ;;; and treat as one argument.
  endif;
  compile_expr_seq(Body,Env);
  lvars Code =   sysENDPROCEDURE();
  if lambda_explicit_? and not(context_Env(Env)) then
	  sysPUSHQ(E);
	  sysPUSHQ(Code);
      sysCALLQ(updater(pdprops))
  endif;
  sysPUSHQ(Code);
enddefine;

compile_lambda -> method("lambda");

/*
check_duplicate ensures that variables are unique in argument lists.
*/

define check_duplicate(Args,Atom,Env);
  lvars Args1;
  for Args1 on Args do
    lvars Arg = front(Args1);
    if member(Arg,back(Args1)) then
       mishap_scm(
         '%p expression has repeated argument "%p" in "%p"',
         [%Atom,Arg,Args%]);
    endif;
 endfor;
enddefine;

/*
    compile_args declares and pops the arguments of a function
--------------------------------------------------------------
*/

define compile_args(Args,Env);           ;;;
  lvars Arg;
  check_duplicate(Args,"lambda",Env);
  for Arg in  rev_scm(Args) do            ;;; We pop them in reverse order
    sysLVARS(Arg,0);                       ;;; declare var as lexical local
    sysPOP(Arg);                         ;;; pop it.
  endfor;
enddefine;

/*
  compile_define treats the (define ... ) construct
----------------------------------------------------
There are two cases, exemplified by
  (define var  27)
and
  (define (fred x y) (+ x y))

*/

lconstant
	lambda_scm = Schemify("lambda"),
    else_scm   = Schemify("else");
lconstant msg_need_var =
  'Need variable name or expression instead of "%p" in definition "%p"';


define compile_define(E,Env);
  lvars n = length_scm(E);
  if n < 2 then
     mishap_scm('define statement "%p" defines nothing',[^E]);
  endif;
  lvars Var = front(back(E));
  if is_var(Var) then                         ;;; first case.
    if n/==3 then
      mishap_scm(
        'too many forms in define statement %p',
        [^E]);
    endif;
    if context_Env(Env) then           ;;; Nested variables are lexical
      sysLVARS(Var,0);
    else                               ;;; Top-level variables are non-lexical.
      sysVARS(Var,0)
    endif;
    compile_expr(front(back(back(E))),
                 local_Env(Var,Env));   ;;; Get value of expression.
    sysPOP(Var);                        ;;; and pop it to the variable.
    sysPUSH(Var);
  elseif atom(Var) then
    mishap_scm(msg_need_var,[^Var^E]);

  else                                  ;;;  2nd case - convert to 1st
    lvars Args = back(Var),
          Body = back(back(E)),
          Var1 = front(Var);

    compile_define(
       [define ^Var1 [^lambda_scm ^Args ^^Body]],
       Env)
  endif;
enddefine;

compile_define -> method("define");

/*
  compile_macro handles macro definitions
-----------------------------------------

Macros are handled by using convert_to_method to connvert a scheme function
to a compile-method.

*/

define convert_to_method(F);
    lvars F;
	procedure(E,Env);
      pr('expanding macro: '); pr_scm(F);
      pr('\nfor expression: '); pr_scm(E); pr(newline);
      lvars E1 = F(E,1);
      printf('expands to %p\n',[^E1]);
      compile_expr(E1,Env);
    endprocedure;
enddefine;

define compile_macro(E,Env);
   lvars Binding = back(E);
   check_Binding(Binding,Env);
   compile_expr_seq(back(Binding),Env);
   sysCALLQ(convert_to_method);
   sysPUSHQ(allbutlast(1,front(Binding)));
   sysCALLQ(updater(method));
   sysPUSHQ(undef_scm);
enddefine;

compile_macro -> method("macro");

/*
  compile_if(E,Env) compiles the if expression E.
-------------------------------------------------
*/


define compile_if(Expr,Env);
  lvars n = length_scm(Expr);
  if n==3 then
    Expr<> [^undef_scm] -> Expr;
    4->n;
  endif;
  unless n == 4 then
    mishap_scm('Badly formed "if" expression %p',[%Expr%])
  endunless;
  lvars (_,C,E_ifso,E_ifnot) = explode(Expr);
  compile_bool(C,Env);
  lvars lab_ifnot = sysNEW_LABEL();
  lvars lab_done  = sysNEW_LABEL();
  sysIFNOT(lab_ifnot);
  compile_expr(E_ifso,Env);
  sysGOTO(lab_done);
  sysLABEL(lab_ifnot);
  compile_expr(E_ifnot,Env);
  sysLABEL(lab_done);
enddefine;

compile_if -> method("if");

/*
  compile_and([and E1..En],Env) treats an "and" expression
----------------------------------------------------------
*/

define compile_and(Expr,Env);
  	lvars Arg,Args = back(Expr);
  	if null(Args) then
  	else
    	lvars lab_false = sysNEW_LABEL();
        lvars lab_true  = sysNEW_LABEL();
    	compile_expr(front(Args),Env);
    	for Arg in  list_from_scm(back(Args)) do
      		sysAND(lab_false);
      		compile_expr(Arg,Env);
  		endfor;
  		sysGOTO(lab_true);
  		sysLABEL(lab_false);
  		sysPUSHQ(false_scm);
  		sysLABEL(lab_true);
  	endif;
enddefine;

compile_and -> method("and");


/*
  compile_case treats case statements
-----------------------------------------------------
This is done much like cond.
*/

lvars Msg_wrong_case =
  'Wrong form for key-value pair "%p" in (case ...) expression %p';

define compile_case(Expr,Env);
  lvars CV;
  unless length(Expr) > 2 then
    mishap_scm('case expr "%p" needs actual cases', [^Expr]),
  endunless;
  lvars Target     = front(back(Expr));
  lvars Var        = sysNEW_LVAR();
  lvars List_CV = back(back(Expr));             ;;; get list of case-value pairs
  lvars lab_next = sysNEW_LABEL();       ;;; where to go for the next CV pair
  lvars lab_done = sysNEW_LABEL();       ;;; where to go when evaluation is done
  compile_expr(Target,Env);
  sysPOP(Var);
  for CV in list_from_scm(List_CV) do   ;;;
     if atom(CV) then                   ;;; Check correct form.
          mishap_scm(Msg_wrong_case,
                        [^CV ^Expr]);
     endif;
    lvars C = front(CV);                   ;;; Get the case.
    sysLABEL(lab_next);                 ;;; come here to try new case.
    sysNEW_LABEL() -> lab_next;          ;;; and go here if you fail.
    if C == else_scm then                  ;;; else? do it unconditionally.
      compile_expr_seq(back(CV),Env)
    else                                ;;; otherwise we must do a test.
      sysPUSH(Var);
      sysPUSHQ(C);
      sysCALLQ(member);
      sysIFNOT(lab_next);               ;;; test fails? try next pair
      compile_expr_seq(back(CV),Env);         ;;; succeeds? get the value
      sysGOTO(lab_done);                ;;; and go to the end
    endif;
  endfor;
  sysLABEL(lab_done);                   ;;; whole expression complete.
  sysLABEL(lab_next);
enddefine;

compile_case -> method("case");




/*
  compile_cond treats (cond ( (c1 v1) (c2 v2) ......(else vn))
--------------------------------------------------------------
The code generated for this expression can be explained as follows:

lab_next_1: evaluate c1;  false? goto lab_next_2 ; evaluate v1; goto lab_done
lab_next_2: evaluate c2;  false? goto lab_next_3 ; evaluate v2; goto lab_done

lab_next_n:  evaluate vn;
lab_done:


*/

lvars Msg_wrong_cond =
  'Wrong form for condition-value pair "%p" in (cond ...) expression %p';

define compile_cond(Expr,Env);
  lvars CV;
  lvars List_CV = back(Expr);             ;;; get list of condition-value pairs
  lvars lab_next = sysNEW_LABEL();       ;;; where to go for the next CV pair
  lvars lab_done = sysNEW_LABEL();       ;;; where to go when evaluation is done
  lvars else_?   = false;
  for CV in list_from_scm(List_CV) do   ;;;
     if atom(CV) then                   ;;; Check correct form.
          mishap_scm(Msg_wrong_cond,
                        [^CV ^Expr]);
     endif;
    lvars C = front(CV);                   ;;; Get the condition.
    sysLABEL(lab_next);                 ;;; come here to try new condition.
    sysNEW_LABEL() -> lab_next;          ;;; and go here if you fail.
    if C == else_scm then                  ;;; else? do it unconditionally.
      compile_expr_seq(back(CV),Env);
      true -> else_?;
    else                                ;;; otherwise we must do a test.
      compile_bool(C,Env);
      sysIFNOT(lab_next);               ;;; test fails? try next pair
      compile_expr_seq(back(CV),Env);         ;;; succeeds? get the value
      sysGOTO(lab_done);                ;;; and go to the end
    endif;
  endfor;
  unless else_? then
    sysLABEL(lab_next);
    sysPUSHQ('Undefined from cond');
  endunless;
  sysLABEL(lab_done);                   ;;; whole expression complete.
enddefine;

compile_cond -> method("cond");

/*
  compile_begin handles the (begin E1...En) construct
-----------------------------------------------------
*/

define compile_begin(Expr,Env);
  compile_expr_seq(back(Expr),Env)
enddefine;

compile_begin -> method("begin");

/*
  compile_let handles let and let* and letrec expressions.
-------------------------------------------------------------
??? we have not yet got this right, since we need to have the correct
lexical blocks.
*/

lconstant let_scm = Schemify("let"),
          letrec_scm = Schemify("letrec");

define compile_let(Expr,Env);
  unless length_scm(Expr)>2 then
    mishap_scm('Missing binding or body in let expr %p',[^Expr]);
  endunless;
  lvars Bindings = front(back(Expr)),
        Body     = back(back(Expr));
;;;  sysLBLOCK(false);                        ;;; let introduces new lexical nest.
  lvars f = front(Expr);
  if f==let_scm then                         ;;; For let..
    push_Bindings(Bindings,Env);             ;;; we evaluate ALL expressions
    sysLBLOCK(false);
    make_Bindings(Bindings,Env);             ;;; before binding the variables.
    compile_expr_seq(Body,Env);              ;;; and then call the body.
    sysENDLBLOCK();
  elseif f==letrec_scm then
    sysLBLOCK(false);
    make_Bindings(
       maplist(Bindings,
         procedure(B); conspair(front(B),nil_scm)
         endprocedure),Env );
    push_Bindings(Bindings,Env);             ;;; we evaluate ALL expressions
    make_Bindings(Bindings,Env);             ;;; before binding the variables.
    compile_expr_seq(Body,Env);              ;;; and then call the body.
    sysENDLBLOCK();

  else                                     ;;; whereas for let* ...
    sysLBLOCK(false);
    do_Bindings(Bindings,Env);
    compile_expr_seq(Body,Env);
    sysENDLBLOCK();
  endif;
enddefine;

compile_let -> method("let");
compile_let -> method("letrec");
compile_let -> method('let*');

lvars
  Msg_bad_binding =
    'Badly formed binding %p in bindings %p',
  Msg_need_var =
   'Variable needed instead of "%p" in binding "%b" in bindings "%p"';

/*
   check_Binding checks the syntactic form of a binding  (v,E)
-------------------------------------------------------------
*/

define check_Binding(Binding,Bindings);
    if atom(Binding) then
       mishap_scm(Msg_bad_binding,
                     [%Binding,Bindings%])
    elseunless is_var(front(Binding)) then
       mishap_scm(Msg_need_var,
            [%front(Binding), Binding,Bindings%])
    endif
enddefine;

;;; push_Bindings generates code to push the RHS values of a sequence
;;; of bindings on the stack.

define push_Bindings(Bindings,Env);
  lvars Binding;
  for Binding in list_from_scm(Bindings) do
    check_Binding(Binding,Bindings);
    compile_expr_seq(back(Binding),Env);
  endfor;
enddefine;

;;; make_Bindings generates code to pop the stacked-up bindings into
;;; variables.

define make_Bindings(Bindings,Env);
  lvars Binding;
  lvars Vars = maplist(Bindings,front);
  check_duplicate(Vars,"let",Env);
  for Binding in rev_scm(Bindings) do
     sysLVARS(front(Binding),0);
     sysPOP(front(Binding));
  endfor;
enddefine;

;;; do_Bindings generates code to do bindings se

define do_Bindings(Bindings,Env);
  lvars Binding;
  for Binding in list_from_scm(Bindings) do
      check_Binding(Binding,Bindings);
      compile_expr_seq(back(Binding),Env);
      sysLVARS(front(Binding),0);
      sysPOP(front(Binding));
  endfor;
enddefine;


/*
  compile_set_! treats the assignment statement in Scheme.
-----------------------------------------------------------
The form is (set! Var Expr). We have to check the form for length (1) and
for Var being a variable (2). If all is OK (3), we generate code to evaluate
the Expr and assign it to the Var.
*/

define compile_set_!(E,Env);
  unless length_scm(E) == 3 then                         ;;; (1) right form?
    mishap('Wrong form (  %p  ) for "set!" statement',
            [^E]);
  endunless;
  lvars (_,Var,Val) = explode(E);
  unless is_var(Var) then                                ;;; (2)
    mishap_scm(
         'Non-atom %p cannot be bound by "set!" in %p',
         [%Var,E%]);
  endunless;
  compile_expr(front(back(back(E))),Env);                ;;; (3)
  sysPUSHS(undef);                           ;;; duplicate top of stack.
  sysPOP(Var);
enddefine;

compile_set_! -> method('set!');

/*
  compile_trace supports the tracing of function calls
-------------------------------------------------------
*/

define compile_trace(E,Env);
  lvars Names = back(E);
  popval([trace   ^^Names ;]);
  sysPUSHQ(undef_scm);
enddefine;

compile_trace -> method("trace");


/*
  mishap_scm(Message,Culprits) treats errors.
---------------------------------------------
*/
lvars depth_scm = 1;
;;; sysunprotect("popexecute");

define mishap_scm(String,Culprits);
;;;  true -> popexecute;
  npr('\nError: ');
  printf(String,Culprits);
  dlocal depth_scm = depth_scm+1;
  mishap('Dropping into pop', []);
  /*
  printf('\nRestarting, depth %p\n',[%depth_scm%]);
  compile_Scheme(charin);
  */
enddefine;

;;; sysprotect("popexecute");

/*
  mishap_wrong_args and mishap_arity are useful utility error functions.
------------------------------------------------------------------------
*/


define mishap_wrong_args();
  mishap_scm('function called with wrong number of arguments',[]);
enddefine;


define mishap_arity(Name,m,n);
  mishap_scm('Function "%p" needs %m arguments, was given %p',
     [%Name,m,n%])
enddefine;


/*
Setting up the standard bindings for built-in functions.
-------------------------------------------------------
*/

/*
  display
-------------------
*/

define display_(/*..*/,n);
  lvars L = listify_count(n);
   pr_scm(front(L));
  lvars Rest = back(L);
  if Rest/==nil_scm then
    mishap_scm('channels not implemented',[]);
  endif;
  undef_scm;
enddefine;




define read_(port);
  port();
enddefine;


/*
  pr_scm is the general procedure to print a scheme object
-------------------------------------------------------------
*/
define pr_scm(L);
  	if isprocedure(L) then
		pr('<Compiled function: ');
       	pr_scm(pdprops(L));
    	pr(' >');
  	elseif isword(L) then pr(allbutlast(1,L));
  	elseif isstring(L) then
		dlocal pop_pr_quotes = false;
		pr("""); pr(L); pr(""");
  	elseif atom(L) then pr(L)
  	elseif front(L) = quote_scm and length_scm(L) = 2 then
     	pr('\''); pr_scm(front(back(L)));
  	else pr("(");
    	while not(atom(L)) do
      		pr_scm(front(L));
      		back(L) -> L;
      		unless atom(L) then pr(' ')
      		endunless;
    	endwhile;
    	unless L==nil_scm then pr("."); pr_scm(L)
    	endunless;
    	pr(")");
  	endif;
enddefine;

define exec_scm(/**/);  ;;; Still do not know where missing item goes..
  last([%22,33,44;
  sysEXECUTE()%]);
enddefine;


define Schemify_bool_fun(f,Name)->f_bool;
  lvars m = pdnargs(f);
  procedure(/*..*/,n) ->r with_nargs 2;
    unless n==m then
      mishap_scm(Msg_wrong_args,[%f,n,m%])
    endunless;
    f(/*..*/)->r;
    if r then r else nil_scm
    endif -> r;
  endprocedure -> f_bool;
  unless Name then pdprops(f) -> Name
  endunless;
  'Scheme bool function: ' >< Name >< "(" >< m >< ")"
     -> pdprops(f_bool);
  ;;;m+1 -> pdnargs(f_bool);
enddefine;

/*
  polyadic_from_binary(P,id) makes a scheme polyadic function
--------------------------------------------------------------

Scheme functions like "+" are polyadic. If such a function is commutative
and associative,we can convert the POP-11 procedure -P-  into a Scheme function
as a procedure which calls P n times, where n is the top-of-stack.
*/

define polyadic_from_binary(P,id);
  procedure(/*...*/,n)->val;
    lvars val = id;
    repeat n times P(/*..*/,val) -> val
    endrepeat;
  endprocedure;
enddefine;

/*
  The VAR macro allows us to bind Scheme variables to POP functions.
-------------------------------------------------------------------
*/

define macro VAR;
  lvars V =  mk_atom_scm(itemread());
  "vars",V;
enddefine;

define applist_scm(L,P);
  while not(atom(L)) do
    P(front(L));
    back(L) -> L;
  endwhile;
  undef_scm;
enddefine;

define length_scm(list);
  if atom(list) then 0 else 1+length_scm(back(list))
  endif;
enddefine;

;;; ?? is map in scheme polyadic? yes it is?

define check_null_scm(x);
  unless x == nil_scm then
    mishap_scm('A list is wrongly terminated by %p',[^x]);
  endunless;
enddefine;


define map_scm(f,list);
  if atom(list) then check_null_scm(list); nil_scm;
  else conspair(f(front(list),1),map_scm(f,back(list)))
  endif;
enddefine;

;;; assoc_scm performs the assoc function ??? do we use == or =???

define assoc_scm(val,list,n);
  unless n==1 then
    mishap_arity("assoc",1,n);
  endunless;
  until atom(list) do
    lvars Pair = front(list);
    if front(Pair) == val then return(Pair)
    endif;
    back(list) -> list;
  enduntil;
enddefine;

define get_Env();
  Env_init;
enddefine;

define rev_scm(L)->L1;
  nil_scm->L1;
  while(not(atom(L))) do
    conspair(front(L),L1) -> L1;
    back(L) -> L;
  endwhile;
enddefine;

example rev_scm
rev_scm([1 2 3]) =>
** [3 2 1]
endexample;

define eval_scm(Expr,Env);
  compile_expr(Expr,Env);
  exec_scm();
enddefine;

define newline_scm();
  pr('\n'); undef_scm;
enddefine;

VAR 'atom?'  = Schemify_bool_fun(atom,'atom?');
VAR assoc  = assoc_scm;
VAR 'null?'  = Schemify_bool_fun(null,'null?');
VAR +      = polyadic_from_binary(nonop +,0);
VAR *      = polyadic_from_binary(nonop *,1);
VAR -      = Schemify(nonop -);
VAR /      = Schemify(nonop /);
VAR =      = Schemify_bool_fun(nonop =,false);
VAR >      = Schemify_bool_fun(nonop >,false);
VAR <      = Schemify_bool_fun(nonop <,false);
VAR <=      = Schemify_bool_fun(nonop <=,false);
VAR >=      = Schemify_bool_fun(nonop >=,false);

VAR 'eq?'     = Schemify_bool_fun(nonop ==, 'eq?');
VAR 'equal?' = Schemify_bool_fun(nonop =, 'equal?');
VAR eval   = Schemify(eval_scm);
VAR car    = Schemify(front);
VAR cdr    = Schemify(back);
VAR cons   = Schemify(conspair);
VAR display = display_;
VAR 'eof-object?' = Schemify_bool_fun(nonop ==(%termin%),'eof-object?');
VAR list    = exec_scm(compile_expr( Schemify([lambda x x]), Env_init));
VAR load    = Schemify(compile_Scheme);
VAR cadr    = Schemify(back<>front);
VAR caddr   = Schemify(back<>back<>front);
VAR length  = Schemify(length_scm);
VAR map     = Schemify(map_scm);
VAR 'member?'   = Schemify_bool_fun(member,'member?');
VAR 'nearest-repl/environment' = Schemify(get_Env);
VAR newline = Schemify(newline_scm);
VAR not     = Schemify_bool_fun(not,false);
VAR 'pair?'   = Schemify_bool_fun(ispair,'pair?');
VAR remainder = Schemify(nonop rem);
VAR quotient  = Schemify(nonop div);
VAR zero?     = Schemify_bool_fun(nonop = (%0%),'zero?');


define macro Scheme;
  while true do lvars E = read_sexpr();
    npr(compile_expr(E,Env_init),exec_scm());
  endwhile;
enddefine;



[['.scm' {popcompiler ^Scheme_compile}]
 ['.scm' {vedcompileable true}]
]
    <> vedfiletypes
-> vedfiletypes;


compile_Scheme('~pop/Scheme/initial.scm');
