fun gh (x, []) = [(x, 1)]
|	gh (x, L as (y, ct) :: xs) = if x = y then ((y, ct + 1) :: xs) else (x, 1) :: L;

fun group x = foldr gh [] x;

fun next x = concat (map (fn (x, y) => (Int.toString y) ^ str(x)) (group (explode x)));

fun ls_h n x= if n = 0 then [] else [x] @ (ls_h (n - 1) (next x));

fun ls n = ls_h n "1";

ls 10;
