
(* reverse a list *)
fun rev [] = [] (* base case *)
|	rev (x :: xs) = (rev xs) @ [x]; (* induction case *)

rev [1, 2, 3];

(* generate all permutations of a list of unique items *)

fun flatten [] = []
|	flatten (x :: xs)  =  x @ flatten xs
;

fun filter f [] = []
|	filter f (x :: xs) = if (f x) then x :: filter f xs else filter f xs;


fun except e ls = filter (fn x => x <> e) ls;

fun perm [] = [[]]
|	perm x = flatten (map (fn e => map (fn ls => e :: ls) (perm (except e x))) x)
; 


fun len [] = 0
|	len (x :: xs) = 1 + len xs;

fun part0 x [] _ = (x, [])
|	part0 ys (L as x :: xs) n = if n = 0 then (ys, L) else part0 (x :: ys) xs (n - 1)
;

fun part x = part0 [] x (len x div 2);

fun merge x [] = x
|	merge [] y = y
|	merge (x :: xs) (y :: ys) =  if x <= y then x :: merge xs (y :: ys) else y :: merge (x :: xs) ys;

fun mergesort [] = []
|	mergesort [x] = [x]
|	mergesort x = let val (p1, p2) = part x in merge (mergesort p1) (mergesort p2) end;

mergesort [10, 2, 1, 4, 3];
