(* zip 2 lists together, must be of same length, no list extension *)
exception Length;
fun zip (x :: xs) (y :: ys) = (x, y) :: (zip xs ys)
  |   zip [] [] = []
  |   zip _ _ = raise Length
  ;

(* Zip with list extension: extends last item to length of longest list, just for funnsies *)
fun zip0e (x :: xs) (y :: ys) px py = (x, y) :: (zip0e xs ys x y)
  |   zip0e [] [] px py = []
  |   zip0e [] (y :: ys) px py = (px, y) :: (zip0e [] ys px y)
  |   zip0e (x :: xs) [] px py = (x, py) :: (zip0e xs [] x py)
  ;

fun zipe x y = zip0e x y (hd x) (hd y);


(* each prior helper *)
fun eachprior0 f x (y :: ys) = f(y, x) :: (eachprior0 f y ys)
  | eachprior0 f x [] = [] 
  ;
  
(* adverbs *)
fun /: f = fn l => fn a => map (fn e => f(e, a)) l; (* each first *)
fun /:: f = fn a => fn l =>  map (fn e => f(a, e)) l; (* each second *)
fun :/: f = fn l1 => fn l2 => map f (zip l1 l2); (* each both *)
fun <: f = fn [] => [] | (x :: xs) => x :: (eachprior0 f x xs); (* each prior *)

(* alternative each-both without using zip *)
fun eb0 f (x :: xs) (y :: ys) = f(x,y) :: (eb0 f xs ys)
  | eb0 f [] [] = []
  | eb0 f _ _ = raise Length
  ;

fun eb f = fn l1 => fn l2 => eb0 f l1 l2;


(* drop first i elements from list *)
fun drop(i, ls) = if i = 0 then ls else drop(i - 1, tl ls);

(* index of element in list, returns -1 if not found *)
fun ixOf0 [] x i = ~1
  |   ixOf0 (y :: ys) x i = if x = y then i else ixOf0 ys x (i + 1)
  ;

fun ixOf(ls, x) = ixOf0 ls x 0;

(* remove 1 level of nesting from list *)
fun flatten (x :: xs) = x @ flatten xs
  |   flatten [] = []
  ;

(* last element in a list, exception if empty *)
fun last [x] = x (* singleton list *)
  |   last (x :: xs) = last xs
  |   last [] = raise Length;
  ;

(* wrap an atom in a list *)
fun enlist x = [x];

(* main workhorse for combinations *)
fun combs0 ls l t= 
    if t = 0 then ls (* doneso! *)
    else
        let
            val ds = map (fn x => x + 1) (/:: ixOf l (map last ls)) (* indices to drop from main list for each sublist *)
            val add = /: drop ds l (* list of elements that we can add to each sublist of combinations *)
            val new_ls = :/: (fn (x, y) => /:: (fn (x,y) => x @ [y] ) x y) ls add (* extended combinations *)
        in
            combs0 (flatten new_ls) l (t - 1) (* flatten out and recursive call *)
        end;

(* return combinations of size t from list l *)
fun combs l t = combs0 (map enlist l) l (t - 1);






