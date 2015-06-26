(* exercise 2.1: O(n) *)
fun ll [] = [[]]
  | ll x = x :: (ll (tl x))
  ;

(* a simple binary tree for integers *)
datatype btree = E | B of btree * int * btree ;

(* exercise 2.2 O(log n)*)
fun member0 prior E x = x = prior (* reached end of tree, check for equality *)
  | member0 prior (B (l, x, r)) y = 
  if x < y then member0 prior r y else member0 x l y
  ;
  
fun member E x = false
  | member (b as B (l, x, r)) y = member0 x b y
  ;
  
(* exercise 2.3 O(log n) *)
exception AlreadyInTree;
fun insert10 E x = B(E, x, E)
  | insert10 (B(l, x, r)) y = 
    if x < y then B(l, x, insert10 r y)
    else if x > y then B(insert10 l y, x, r)
    else
      raise AlreadyInTree
  ;
  
fun insert1 b x = (insert10 b x) handle AlreadyInTree => b;
  
  
(* exercise 2.4 O(log n) *)
fun insert20 prior E x = if prior = x then raise AlreadyInTree else B(E, x, E)
  | insert20 prior (B (l, x, r)) y = 
  if x < y then B(l, x, insert20 prior r y) else B(insert20 x l y, x, r) 
  ;
  
fun insert2 E x = B(E, x, E)
  | insert2 (b as B(l, x, r)) y = (insert20 x b y) handle AlreadyInTree => b
  ;
  
  
(* exercise 2.5 O(log n) *)
fun complete x 0 = E
  | complete x d = 
    let
      val subtrees = complete x (d - 1)
    in
      B(subtrees, x, subtrees)
    end
  ;

(* exercise 2.6 O(log n) *)
fun balanced x 0 = E 
  | balanced x d = 
    let
      val mid = (d - 1) div 2 
      val left = balanced x mid
      val right = balanced x (d - 1 - mid)
    in
      B(left, x, right)
    end
  ;
  
fun l E = E
  |   l (B(x, _, _)) = x
  ;

fun r E = E
  | r (B(_,_,x)) =x
  ;