

true -> pop_longstrings;

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


lconstant q11 =
    '\nIn figure 1, if V = %p volts and R = %p ohms, what is the
value of the current I?\n\n';


lconstant q12 =
    '\nIn figure 2, if I = %p milliamps, R1 = %p ohms and R3 = %p ohms,
what is the value of the voltage V\n\n';

lconstant q13 =
    '\nIn figure 3 the LED is to be driven at %p milliamps at
which current it has a forward voltage drop of %p volts.
The value of V is %p volts. Calculate the required value
of the resistor R (this does not need to be a preferred
value).\n\n';

lconstant q14 =
    '\nIn figure 4 the value of V is %p volts, the value of
 R1 is %p ohms and the value of R2 is %p ohms.
 The Zener diode conducts with a reverse bias of %p volts.
 What is the value of V2?\n\n';

define exam1(n);
    let i in
        pr('\^L');
        for i from 1 to n do
            pr('\n\n\nCMPSCI 503 Class Test   21SEP99\n\nNAME\n\nSTUDENT ID\n\n');
            printf('Test ID: %p,  ranseed = %p\n\n\n', [%i,ranseed%]);

            pr('Question 1\n');

            printf(q11, [% oneof([5 10 20]), oneof([1000 2000 500])%]);


            pr('Question 2\n\n');

            printf(q12, [% oneof([8 10]),
                            oneof([100 200 500]),
                            oneof([100 200 500]),
                         %]);


            pr('Question 3\n');

            printf(q13, [% oneof([10 20]),
                            oneof([1.2 1.5]),
                            oneof([5 10]),
                         %]);


            pr('Question 4\n');

            let r2 = oneof([1000 2000 3000])
            in
            printf(q14, [% oneof([10 20]),
                           2*r2,r2, oneof([5.2 6.1])
                         %]);

            endlet;


            nl(4);



            pr('\^L');
        endfor
    endlet
enddefine;

true -> pop_longstrings;

exam1(35);
