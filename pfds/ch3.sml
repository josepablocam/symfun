(* exercise 3.1, see blog symfun.wordpress.com *)


(* from PFDS, slightly simplified: restricted type and curried *)
datatype Heap = E | T of int * int * Heap * Heap;


fun rank E = 0
  | rank (T(r, _, _, _)) = r 
  ;

fun makeT x h1 h2 = if rank h1 < rank h2 
  then T(rank h1 + 1, x, h2, h1)
  else T(rank h2 + 1, x, h1, h2)
  ;
  
fun merge h E = h
  | merge E h = h
  | merge (h1 as T(_, x, a1, b1)) (h2 as T(_, y, a2, b2)) =
    if x < y then makeT x a1 (merge b1 h2) else makeT y a2 (merge h1 b2)
  ;
  
fun insert x h = merge (T (1, x, E, E)) h;
fun findMind (T (_, x, _, _)) = x;
fun deleteMin (T (_, x, a, b)) = merge a b;


(* exercise 3.2: insert directly, rather than via merge *)
fun dirInsert x E = T(1, x, E, E)
  | dirInsert x (T (r, y, left0, right0)) =
    let
      val (root, toInsert) = if x < y then (x, y) else (y, x)
      val right = dirInsert toInsert right0
      val rankLeft = rank left0
      val rankRight = rank right
    in
      if rankLeft < rankRight 
          then T(rankLeft + 1, root, right, left0)
      else T(rankRight + 1, root, left0, right)
    end
  ;

(* exercise 3.3: implement function fromList to make list to heap in log n passes 
  We can split the list at most O(log n) times (each time we split it in half).
  Each merge takes O(log n), but note that n is small first and only grows later on,
  so the cost initially is less, and totals O(n) when we account for it
  *)
fun fromList0 (h1 :: h2 :: xs) = fromList0((merge h1 h2) :: fromList0(xs))
  | fromList0 [x] = [x]
  | fromList0 [] = []
  ;
  
fun fromList (l as x :: xs) = hd (fromList0 (map (fn e => T(1, e, E, E)) l))
  | fromList [] = E
  ;
  
