
fun diff < sin ~e> < ~x> =
        let val de = diff e x
        in
            < cos ~e  * ~de >
        end

 |  diff < ~x> < ~y> = if expEq x y then <1.0> else <0.0> ;


try1 (fn x => diff <sin ~x> < ~x>);



fun test <if ~a then ~b else ~c> = (a,b,c);

test

    <if true  then 3 else 4>;

test
  < ((fn true => 3
    | false => 4 ) true)>   ;


{1 = 45, 2 = 7};
